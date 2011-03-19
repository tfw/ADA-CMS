module ArchiveStudiesHelper

  def human_readable_check(ddi, dataset, current_user)
    mapping = DdiMapping.find_by_ddi(ddi)

    if mapping.nil?
      ddi
    else
     mapping.human_readable
    end
  end
    
  def study_field_table_row(key, study, fields, css_class)
    if fields.has_key?(key) and not fields[key].blank?
      row = "<tr class='#{css_class}'>\n<td valign='top'>"
      row +=  (human_readable_check(key, study, current_user) || key)
      row +=  "</td><td valign='top'>"
      row += fields[key]
      row += "</td>\n</tr>"
      
     fields.delete(key)
     row.html_safe
   end
  end
end