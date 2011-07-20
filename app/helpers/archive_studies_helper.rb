module ArchiveStudiesHelper
  
  def study_field_table_row(key, study, fields)
    if fields.has_key?(key) and not fields[key].blank?
      row = "<tr class='#{cycle('standard', 'alt')}'>\n<td valign='top'>"
      row +=  (human_readable_check(key) || key)
      row +=  "</td><td valign='top'>"
      row += fields[key].to_s
      row += "</td>\n</tr>"
      
     fields.delete(key)
     row.html_safe
   end
  end
  
  def variable_field(field)
    unless field[1].blank?
      key = (human_readable_check(field[0]) || field[0])
      "#{key}: #{field[1]}"
    end
  end

  def selected_tab_if(format_names, format = "study")
    css_class = nil
    css_class = "class='selected-tab'" if format_names.include?(format) or (format.nil? and format_names.include?("study")) 
    css_class
  end
    
  def conceal_unless(format_names, format = "title")
    #this if shouldn't be necessary, appears to be a bug in helpers using default values in method args
    if format.nil?
      format = "study"
    end
    
    "class = 'concealed'" unless format_names.include?(format)
  end
  
  
  def variable_href(variable, archive_study)          
    "#{NESSTAR_SERVER}/webview/index.jsp?object=#{NESSTAR_SERVER}:80/obj/fVariable/#{variable.stdy_id}_#{variable.var_id}&cms_url=#{archive_study.urn}"
  end
  
  def up_arrow_anchor(position)
    "var-#{position - 1}"
  end
  
  def down_arrow_anchor(position)
    "var-#{position + 1}"
  end
  
  def related_material_url(related_material)
    if related_material.uri =~ /http/
      related_material.uri
    else
      uri = related_material.uri.gsub("..", "")
      "#{NESSTAR_SERVER}#{uri}"
    end
  end
  
  def related_material_comment_then_file_name(related_material)
    link_text = nil

    unless related_material.comment.blank?
      link_text = related_material.comment
    else
      link_text = related_material.uri.split(/\//).last
    end
    link_text
  end
end
