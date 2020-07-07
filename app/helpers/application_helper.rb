module ApplicationHelper
  
  def get_signature(username, pid)

    key = "4514c087309096378b40e463b06dd756eb8274a8f03cf08e8e63753b3cc5eb9aeb416a261d45aa8ab9c4f476633586aff2a0502dd2506f4fc6a93a1ccc091872"
    sid = "pms"
    url = "http://localhost:3210/api/signature/#{username}/#{pid}?key=#{key}&sid=#{sid}"
    url = "#{$ELEAVE_SITE}/api/signature/#{username}/#{pid}?key=#{key}&sid=#{sid}" # if Rails.env.production?
      
    resultx = ""
    begin
      open(url)do |f|
        f.each_line {|line| resultx += line}
      end
    rescue Exception => exc
      resultx = %{{"success":false, "message": "#{exc.message}"}}
    end
    
    result = JSON.parse(resultx)
    
    return result["url"].blank? ? "/files/missing/signature_blank.png" : result["url"]
    
  end
  
  # Nav ===================================================================================================
  def nav_show?(nav_item)
    can_read = can?(:read, nav_item[:resource])
    nav_item[:items].each do |child|
      can_read ||= nav_show?(child)
    end unless nav_item[:items].blank?
    can_read
  end
  
  def nav_url(nav_item)
    url = "#"
    if can?(:read, nav_item[:resource])
      if nav_item[:url]
        url = nav_item[:url]
      elsif !nav_item[:controller].blank? && !nav_item[:action].blank?
        url = url_for(:controller => nav_item[:controller], :action => nav_item[:action])
      end
    end
    url
  end
  
  def nav_active?(nav_item)
    nav_controller = nav_item[:controller]
    nav_action = nav_item[:action]
    if nav_item[:url]
      path = Rails.application.routes.recognize_path(nav_item[:url])
      nav_controller = path[:controller]
      nav_action = path[:action]
    end
    
    (controller_path == nav_controller) && ((nav_action == action_name) || (nav_action == "index"))
  end
  
  def nav_child_active?(nav_item)
    active_state = false
    nav_item[:items].each do |child|
      active_state ||= (nav_active?(child) || nav_child_active?(child))
    end unless nav_item[:items].blank?
    active_state
  end
  
  # Will Paginate + Bootstrap
  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => BootstrapPagination::Rails
    end
    super *[collection_or_options, options].compact
  end
  
end
