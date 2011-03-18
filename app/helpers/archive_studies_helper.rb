module ArchiveStudiesHelper

  def human_readable_check(ddi, dataset, current_user)
    mapping = DdiMapping.find_by_ddi(ddi)

    if mapping.nil?
      ddi
    else
     mapping.human_readable
    end
  end
    
  def study_field_table_row(key, fields)
    if fields.has_key?(key)
      row = <<TABLE_ROW
      <tr>
   	   <td valign='top'><%= human_readable_check(key, study, current_user)%> </td><td valign='top'> <%= study.field(key) %>/td>
   	 </tr>
TABLE_ROW
     
     fields.delete(key)
     row
   end
  end
end