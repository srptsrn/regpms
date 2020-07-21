#encoding: utf-8

require 'net/ldap'
require 'open-uri'
require 'base64'

class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  skip_authorization_check

  include ERB::Util 

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    puts "LOGIN START ===================="
    
    # ldap_authenticate(params[:user][:login], params[:user][:password])
    if ldap_authenticatex(params[:user][:login], params[:user][:password])
      user = User.where(["username = ?", params[:user][:login]]).first
      if user
        sign_in user, :bypass => true 
        flash[:alert] = nil
        redirect_to root_url
        return false
      else
        self.resource = User.new
        flash[:alert] = "'#{html_escape(params[:user][:login].to_s)}' don't have permission. <br/>Please contact IRIS's administrator.".html_safe
        render :template => "/devise/sessions/new"
        return false
      end
    else
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end

  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def ldap_test
    
    host = "202.12.97.29"
    port = 389
    base_student = "ou=Student,ou=Khonkaen,o=KKU"
    base_staff = "ou=Staff,ou=Khonkaen,o=KKU"
    username = params[:username]
    
    # xxx
    xxx = ""
    
    # dn
    dn = ""
    base = base_student
    
    ldap_con_anonymous = Net::LDAP.new({:host => host, :port => port, :auth => {:method => :anonymous}})
    filter = Net::LDAP::Filter.eq("uid", username)
    ldap_con_anonymous.search(:base => base, :filter => filter, :return_result => false) {|entry| entry.each {|attr, values| values.each {|value| xxx += "#{attr} :: #{value} <br/>"}}}

    render :text => xxx
  end

  protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
  
  def ldap_authenticate2(username, password)
    ua = Base64.encode64(request.env['HTTP_USER_AGENT']).gsub(' ', '').gsub(/\n/, '')
    secretKey = 'jZp30ECmzpNLVrl27hfL0DmnzupKWtQdqfexf301fd948510e054ca9389096aaa6f8e0ea40982ROTqdGa78v6eKkZUVjhvNFdH92Twh847VWv7ADaH9f57974fb0962e0aa877a3c66193b68600316d69ffTTxQLt03WWH8CN9vjnCk'
    username = username.to_s.gsub(' ', '').gsub(/\n/, '')
    password = Base64.encode64(Digest::MD5.hexdigest(password.to_s)).gsub(' ', '').gsub(/\n/, '')
    returnType = 'json' # json, html
    url = "https://api.kku.ac.th/Auth/Server/#{ua}/#{secretKey}/#{password}/#{username}/#{returnType}"
    
    resultx = ""
    begin
      open(url)do |f|
        f.each_line {|line| resultx += line}
      end
    rescue Exception => exc
      resultx = %{{"success":false, "message": "#{exc.message}"}}
    end
    result = JSON.parse(resultx)
    
    return result["success"]
  end
  
  def ldap_authenticate(username, password)
    
    puts "LDAP ------------------------------"
    
    host, port, base_student, base_staff = ldap_configuration
    user = User.where(["username = ?", username]).first
    attributes = []
    
    if user && !user.ldap_dn.blank? && !user.ldap_base.blank?
      dn = user.ldap_dn
      base = user.ldap_base
    else
      dn, base = ldap_dn_base(username, password)
    end
    
    # Authenticate
    begin
      ldap_con = Net::LDAP.new({:host => host, :port => port, :auth => {:method => :simple, :username => dn, :password => password}})
      ldap_con_bind = ldap_con.bind

      if ldap_con_bind
        
        entries = nil
        email = ""
        firstname = ""
        lastname = ""
        department = ""
        pid = ""
        
        filter = Net::LDAP::Filter.eq("uid", username)
        ldap_con.search(:base => base, :filter => filter, :attributes => attributes, :return_result => false) {|entry| entries = entry}
        entries.each do |attr, values| 
          values.each do |value| 
            email = value if attr.to_s == "mail"
            firstname = value if attr.to_s == "givenname"
            lastname = value if attr.to_s == "sn"
          end
        end
        
        # Auto create User
        unless user
          # user = User.new
          # user.login = username
          # user.firstname = firstname
          # user.lastname = lastname
          # user.nickname = firstname
          # user.email = !email.blank? ? email : username + "@kku.ac.th"
          # user.password = password
          # user.password_confirmation = password
          # user.ldap_dn = dn
          # user.ldap_base = base
          # user.workflow_state = "enabled"
          # if user.save
            # @login_message ||= ""
            # @login_message += "Create User success<br/>"
          # else
            # @login_message ||= ""
            # @login_message += "Create User failed<br/>"
            # user.errors.each {|er| @login_message += "#{er.inspect}<br/>" }
          # end
        else
          # user.password = password
          # user.password_confirmation = password
          user.ldap_dn = dn
          user.ldap_base = base
          if user.save
            @login_message ||= ""
            @login_message += "Update User<br/>"
          else
            @login_message ||= ""
            @login_message += "Update User ERROR<br/>"
          end
        end
      end
    rescue Exception => exc
      ldap_con_bind = nil
      @login_message ||= ""
      @login_message += "#{exc.message}<br/>"
    end
    
    puts "= LDAP BIND ==========================================================="
    puts "----- username : #{username}"
    puts "----- dn : #{dn}"
    puts "----- base : #{base}"
    puts "----- error : #{@login_message}"

    return ldap_con_bind
  end
  
  def ldap_configuration
    host = "202.12.97.29"
    port = 389
    base_student = "ou=Student,ou=Khonkaen,o=KKU"
    base_staff = "ou=Staff,ou=Khonkaen,o=KKU"
    return host, port, base_student, base_staff
  end
  
  def ldap_dn_base(username, password)
    host, port, base_student, base_staff = ldap_configuration
    # dn
    dn = ""
    base = base_student
    
    # Authenticate
    begin
      ldap_con_anonymous = Net::LDAP.new({:host => host, :port => port, :auth => {:method => :anonymous}})
      filter = Net::LDAP::Filter.eq("uid", username)
      ldap_con_anonymous.search(:base => base, :filter => filter, :return_result => false) {|entry| entry.each {|attr, values| values.each {|value| dn = value if attr.to_s == "dn"}}}
      if dn.blank?
        base = base_staff
        ldap_con_anonymous.search(:base => base, :filter => filter, :return_result => false) {|entry| entry.each {|attr, values| values.each {|value| dn = value if attr.to_s == "dn"}}}
      end
    rescue Exception => exc
      dn = ""
      base = base_student
    end
    
    puts "= LDAP CHECK ==========================================================="
    puts "----- username : #{username}"
    puts "----- dn : #{dn}"
    puts "----- base : #{base}"
    
    return dn, base
  end
  
  def ldap_authenticatex(username, password)
    
    key = "regpms"
    usernamex = username
    passwordx = Base64.encode64(password.to_s).gsub("\n", "")

    # url = "http://ldap.ibatt.in.th/ldap/#{key}/#{passwordx}/#{usernamex}"
    url = "http://ldap2.ibatt.in.th/ldap/#{key}/#{passwordx}/#{usernamex}"
    
    resultx = ""
    begin
      open(url)do |f|
        f.each_line {|line| resultx += line}
      end
    rescue Exception => exc
      resultx = %{{"passed":false}}
    end

    result = JSON.parse(resultx)
    
    return result["passed"]
  end
  
end
