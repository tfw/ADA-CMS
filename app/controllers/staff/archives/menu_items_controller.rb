class Staff::Archives::MenuItemsController < Staff::Archives::BaseController
  inherit_resources
  defaults :resource_class => MenuItem, :instance_name => 'menu_item'
  before_filter :get_archive
    
end
