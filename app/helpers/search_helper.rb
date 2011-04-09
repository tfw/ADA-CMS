module SearchHelper 
  
  def highlight_excerpt(highlight)
    return if highlight.nil?
    
    highlights = "#{highlight.field_name}: "
    highlights << highlight.format { |word| "<span class=\"highlight\">#{word}</span>".html_safe}	
    highlights << "..."
    highlights.html_safe	
  end
  
  
  def conceal?(format_name, format = "title")
    return if format.nil? and format_name == "title"
    "class = 'concealed'" unless format_name == format
  end
  
  #the below is just bizarre.
  def selected(format_name, format = "title")
    # puts "\n\n\n format: #{format} / format_name #{format_name} \n\n\n"
    "class = 'selected-menu-item'" if format_name == format  
    # "class = 'selected-menu-item'" if format.nil? and format_name == "title"  
  end
end