module ArchiveStudiesHelper
  
  def study_field_table_row(key, study, fields, css_class)
    if fields.has_key?(key) and not fields[key].blank?
      row = "<tr class='#{css_class}'>\n<td valign='top'>"
      row +=  (human_readable_check(key) || key)
      row +=  "</td><td valign='top'>"
      row += fields[key]
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
  # 
  def conceal_unless(format_names, format = "study")
    css_class = nil
    "class = 'concealed'" unless format_names.include?(format) or (format.nil? and format_names.include?("study")) 
    css_class 
  end
  
  def variable_href(variable, archive)       
    archive_study = ArchiveStudy.find_by_archive_id_and_study_id(archive.id, variable.study.id)
           "#{NESSTAR}/webview/index.jsp?object=http://bonus.anu.edu.au:81/obj/fVariable/au.edu.anu.ada.ddi.#{variable.study.ddi_id}_#{variable.field('varID')}&archive=#{archive_css(archive)}&cms_url=#{archive_study.path.slug}"  
  end
  
  def up_arrow_anchor(position)
    "var-#{position - 1}"
  end
  
  def down_arrow_anchor(position)
    "var-#{position + 1}"
  end
end