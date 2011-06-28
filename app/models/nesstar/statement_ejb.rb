class Nesstar::StatementEJB < ActiveRecord::Base
  set_table_name "StatementEJB"
  establish_connection "nesstar"
  
  has_one :integration
end