module ArchiveStudiesHelper
  def study_field_table_row(key, study, fields, css_class)
    if fields.has_key?(key) and not fields[key].blank?
      row = "<tr class='#{css_class}'>\n<td valign='top'>"
      row +=  (human_readable_check(key, study, current_user) || key)
      row +=  "</td><td valign='top'>"
      row += fields[key]
      row += "</td>\n</tr>"
      FFS
     fields.delete(key)
     row.html_safe
   end
  end
end