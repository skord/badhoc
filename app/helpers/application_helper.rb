module ApplicationHelper
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
  
  def tripcode_auth_tags(tripcode_status, name)
    if tripcode_status
      "<strong class='authenticated'>#{name}</strong>"
    else
      "<strong>#{name}</strong>"
    end
  end
  
  # needs refactor
  def user_text_markdown(text)
    if controller.action_name == 'index'
      sanitize RDiscount.new(truncate(text, :length => 500), :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html
    else
      sanitize RDiscount.new(text, :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html
    end
  end
end
