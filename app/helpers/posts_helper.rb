module PostsHelper
  # needs refactor
  def post_text_markdown(text)
    if controller.action_name == 'index'
      sanitize RDiscount.new(truncate(text, :length => 500), :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html
    else
      sanitize RDiscount.new(text, :filter_html, :filter_styles, :safelink, :no_pseudo_protocols, :smart).to_html
    end
  end
end
