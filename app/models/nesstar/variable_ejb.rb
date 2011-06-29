class Nesstar::VariableEJB < ActiveRecord::Base
  set_table_name 'VariableEJB'
  establish_connection "nesstar"
#  set_table_name "variableejb"
end