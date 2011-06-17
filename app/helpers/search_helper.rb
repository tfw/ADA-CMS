module SearchHelper 
  
  def highlight_excerpt(highlight)
    return if highlight.nil?
    
    highlights = "#{highlight.field_name}: "
    highlights << highlight.format { |word| "<span class=\"highlight\">#{word}</span>".html_safe}	
    highlights << "..."
    highlights.html_safe	
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
  
  def conceal_unless(format_names, format = "title")
    #this if shouldn't be necessary, appears to be a bug in helpers using default values in method args
    if format.nil?
      format = "title"
    end
    
    "class = 'concealed'" unless format_names.include?(format)
  end
  
  def search_abbr(params, remove_filters = false)
    abbr = "#{params[:term]}"

    if params[:filters].any?
      abbr += ": "
      filter_list(abbr, params, remove_filters)
    end
  	
  	abbr.downcase
  end
  
  def filter_list(str, params, remove_filters = false)
    if params[:filters].any?
  		params[:filters].each do |facet|
  		  facet.each do |name, value|		    
    			str += "#{Study::FACETS[name.to_sym]} = #{value}" 

    			if remove_filters
    			  copy = params.dup
    			  copy[:filters].first.delete(name)
    			  str += "(#{link_to '-', copy})"
  			  end
			  
    			unless name == facet.keys.last 
    			  str += ", " 
    			end
  		  end 
  	  end 
	  end
	  str
  end
end