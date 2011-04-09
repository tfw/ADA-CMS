module SearchHelper 
  
  def highlight_excerpt(highlight)
    return if highlight.nil?
    
    highlights = "#{highlight.field_name}: "
    highlights << highlight.format { |word| "<span class=\"highlight\">#{word}</span>".html_safe}	
    highlights << "..."
    highlights.html_safe	
  end
    
  def conceal_unless(format_names, format = "title")
    return if format.nil? and format_names.include?("title")
    "class = 'concealed'" unless format_names.include?(format)
  end

  def selected_tab_if(format_names, format = "title")
    css_class = nil
    css_class = "class='selected-tab'" if format_names.include?(format) or (format.nil? and format_names.include?("title")) 
    css_class
  end
  
  def selected_menu_if(format_names, format = "title")
    css_class = nil
    css_class = "class = 'selected-menu-item'" if format_names.include?(format) or (format.nil? and format_names.include?("title")) 
    css_class
  end
end