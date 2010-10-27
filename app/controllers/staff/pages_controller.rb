class Staff::PagesController < Inkling::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Page, :instance_name => 'page'
end
