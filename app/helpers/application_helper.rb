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
  
  def user_text_markdown(text, truncate_to = nil)
    if truncate_to == nil
      sanitize RDiscount.new(text, :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html
    else
      sanitize(RDiscount.new(truncate(text, :length => truncate_to), :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html)
    end
  end
end
