module ApplicationHelper

  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
  
  def user_text_markdown(text, truncate_to = nil)
    if truncate_to == nil
      sanitize RDiscount.new(text, :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html
    else
      sanitize(RDiscount.new(truncate(text, :length => truncate_to), :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html)
    end
  end
  
  # So named so I can freaking find it later. 
  def form_name_app_helper
    if session[:my_name].nil?
      return 'Anonymous'
    else
      return session[:my_name]
    end
  end
  
end
