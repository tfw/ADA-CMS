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
end