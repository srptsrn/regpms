require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class ApplicationController < ActionController::Base
  
  include Userstamp
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # cancan work around for rails 4
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  # cancan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  before_filter :create_user_access_log
  before_action :set_locale
  around_filter :set_timezone, :if => :current_user
  before_filter :allow_enable_user_only, :if => :current_user
  
  before_action :get_current_evaluation
  after_filter :store_prev_location
  
  layout :load_layout

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:username, :email]
  end

  def set_locale
    I18n.locale = params[:locale] || (current_user ? current_user.locale : nil) || session[:locale]
    I18n.locale = I18n.default_locale unless I18n.locale.present?
    session[:locale] = I18n.locale
  end
  
  def set_timezone
    old_time_zone = Time.zone
    Time.zone = current_user.timezone unless current_user.timezone.blank?
    yield
  ensure
    Time.zone = old_time_zone
  end
  
  def allow_enable_user_only
    unless current_user.current_state.to_sym == :enabled
      sign_out
      redirect_to root_url
      return false
    end
  end

  def load_layout
    login_layout = "orb_frontend"
    login_layout = "orb_login"
    (is_a?(Devise::SessionsController) || is_a?(Devise::RegistrationsController) || is_a?(Devise::PasswordsController) || is_a?(Devise::ConfirmationsController)) ? login_layout : default_layout
  end
  
  def default_layout
    $DEFAULT_LAYOUT
  end
  
  def create_user_access_log
    UserAccessLog.create(
      :user_id => current_user ? current_user.id : nil,
      :username => current_user ? current_user.username : nil,
      :ip => request.remote_ip, 
      :controller_name => params[:controller],
      :action_name => params[:action],
      :params => params.inspect,
      :params_id => params[:id],
      :log_time => Time.now 
    )
  end
  
  def get_current_evaluation
    if current_user
      
      tmp_evaluation_ids = EvaluationUser.where(["user_id = ?", current_user.id]).collect {|eu| eu.evaluation_id}.uniq
      
      joins = "JOIN evaluation_employee_types ON evaluations.id = evaluation_employee_types.evaluation_id"
      where = ["evaluation_employee_types.employee_type_id = ?", current_user.employee_type_id]
      where = ["evaluation_employee_types.employee_type_id = ? OR evaluations.id IN (?)", current_user.employee_type_id, tmp_evaluation_ids] if tmp_evaluation_ids.size > 0
      @active_evaluations = Evaluation.joins(joins).where(where).uniq
      
      if session[:current_evaluation_id] && Evaluation.exists?(session[:current_evaluation_id])
        @current_evaluation = Evaluation.find(session[:current_evaluation_id])
      else
        @current_evaluation = Evaluation.all_enabled.select {|ev| ev.evaluation_employee_types.collect {|evet| evet.employee_type_id}.include?(current_user.employee_type_id)}.first
        @current_evaluation = @active_evaluations.sort_by {|ev| ev.to_s}.reverse.first if @current_evaluation.nil?
        session[:current_evaluation_id] = @current_evaluation ? @current_evaluation.id : nil
      end
    end
  end
  
  def has_current_evaluation?
    if @current_evaluation.nil?
      redirect_to root_url
      return false
    end
  end
  
  def store_prev_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_location_url] = request.fullpath 
    end
  end
  
  private
  def get_leaves(year, pid, from_date=nil, to_date=nil)
    
    from = from_date.blank? ? "" : (from_date.class == Date ? from_date.strftime("%d/%m/%Y") : from_date.to_s)
    to = to_date.blank? ? "" : (to_date.class == Date ? to_date.strftime("%d/%m/%Y") : to_date.to_s)

    key = "4514c087309096378b40e463b06dd756eb8274a8f03cf08e8e63753b3cc5eb9aeb416a261d45aa8ab9c4f476633586aff2a0502dd2506f4fc6a93a1ccc091872"
    sid = "pms"
    url = "http://localhost:3210/api/user?year=#{year}&from=#{from}&to=#{to}&pid=#{pid}&key=#{key}&sid=#{sid}"
    url = "#{$ELEAVE_SITE}/api/user?year=#{year}&from=#{from}&to=#{to}&pid=#{pid}&key=#{key}&sid=#{sid}" # if Rails.env.production?
    
    resultx = ""
    begin
      open(url)do |f|
        f.each_line {|line| resultx += line}
      end
    rescue Exception => exc
      resultx = %{{"success":false, "message": "#{exc.message}"}}
    end
    
    result = JSON.parse(resultx)
    
    return result
    
  end
  
  def get_checkinouts(year, pid, from_date=nil, to_date=nil)
    
    from = from_date.blank? ? "" : (from_date.class == Date ? from_date.strftime("%d/%m/%Y") : from_date.to_s)
    to = to_date.blank? ? "" : (to_date.class == Date ? to_date.strftime("%d/%m/%Y") : to_date.to_s)
    
    key = "4514c087309096378b40e463b06dd756eb8274a8f03cf08e8e63753b3cc5eb9aeb416a261d45aa8ab9c4f476633586aff2a0502dd2506f4fc6a93a1ccc091872"
    sid = "pms"
    url = "http://localhost:3333/api/checkinouts?year=#{year}&from=#{from}&to=#{to}&pid=#{pid}&key=#{key}&sid=#{sid}"
    url = "http://member.library.kku.ac.th/api/checkinouts?year=#{year}&from=#{from}&to=#{to}&pid=#{pid}&key=#{key}&sid=#{sid}" if Rails.env.production?
    
    resultx = ""
    begin
      open(url)do |f|
        f.each_line {|line| resultx += line}
      end
    rescue Exception => exc
      resultx = %{{"success":false, "message": "#{exc.message}"}}
    end
    
    result = JSON.parse(resultx)
    
    return result
    
  end
  
  def get_holidays(year, from_date=nil, to_date=nil)
    
    from = from_date.blank? ? "" : (from_date.class == Date ? from_date.strftime("%d/%m/%Y") : from_date.to_s)
    to = to_date.blank? ? "" : (to_date.class == Date ? to_date.strftime("%d/%m/%Y") : to_date.to_s)
    
    key = "4514c087309096378b40e463b06dd756eb8274a8f03cf08e8e63753b3cc5eb9aeb416a261d45aa8ab9c4f476633586aff2a0502dd2506f4fc6a93a1ccc091872"
    sid = "pms"
    puts url = "http://localhost:3210/api/holiday?year=#{year}&from=#{from}&to=#{to}&key=#{key}&sid=#{sid}"
    url = "#{$ELEAVE_SITE}/api/holiday?year=#{year}&from=#{from}&to=#{to}&key=#{key}&sid=#{sid}" if Rails.env.production?
    
    resultx = ""
    begin
      open(url)do |f|
        f.each_line {|line| resultx += line}
      end
    rescue Exception => exc
      resultx = %{{"success":false, "message": "#{exc.message}"}}
    end
    
    result = JSON.parse(resultx)
    
    return result
    
  end
  
end
