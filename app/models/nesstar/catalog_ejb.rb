class Nesstar::CatalogEJB < ActiveRecord::Base
  set_table_name 'CatalogEJB'
  establish_connection "nesstar"
end