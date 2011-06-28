class Nesstar::EGMSResourceEJB < ActiveRecord::Base
  set_table_name 'EGMSResourceEJB'
  establish_connection "nesstar"
end