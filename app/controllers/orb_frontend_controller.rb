class OrbFrontendController < ApplicationController
  
  # devise
  before_filter :authenticate_user!
  # authorize_resource :class => false
  skip_before_filter :authenticate_user!, :only => [:template]
  skip_authorization_check :only => [:template]
  
  before_filter :load_menu

  private  
  def default_layout
    "orb_frontend"
  end

  # cancan
  def current_ability
    # @current_ability ||= UserAbility.new(current_user)
    current_user.ability
  end
  check_authorization :unless => :devise_controller?

  private
  def load_menu
    @nav_shortcuts = []
    @nav_items = []
    
    @nav_items << {:title => t(:home), :icon_class => "entypo-briefcase", :url => root_url, :resource => :dashboard}
    
    @nav_items << {:title => t(:news), :icon_class => "entypo-briefcase", :url => news_frontend_url, :resource => :dashboard}
    
    # @nav_items << {:title => Message.model_name.human, :icon_class => "fa fa-envelope", :url => messages_path, :resource => Message}
    
    # @nav_items << {:title => Ticket.model_name.human, :icon_class => "fa fa-ticket", :url => tickets_path, :resource => Ticket}
    
    # sub_navs = []
    # sub_navs << {:title => User.model_name.human, :icon_class => "fa fa-user", :url => admin_users_path, :resource => User}
    # sub_navs << {:title => UserGroup.model_name.human, :icon_class => "fa fa-users", :url => admin_user_groups_path, :resource => UserGroup}
    # @nav_items << {:title => t(:administrator), :sub_id => "administrator", :icon_class => "fa fa-cogs", :items => sub_navs}
    
    # sub_navs = []
    # sub_navs << {:title => t(:orb_template), :icon_class => "fa fa-magic", :url => orb_frontend_template_url, :resource => :template, :target => "_blank"}
    # @nav_items << {:title => t(:system), :sub_id => "system", :icon_class => "fa fa-terminal", :items => sub_navs}
    
  end
  
  public
  def template
    redirect_to "/orb/frontend/index.html"
    return false
  end
  
end
