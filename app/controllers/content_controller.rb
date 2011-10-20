class ContentController < ApplicationController 
  
  layout 'content' #this file is created by Inking::Theme (rake install_theme), and written out to tmp/inkling/themes/layouts  
  before_filter :get_archives
  before_filter :get_ada_menu_items
  
  protected    
  def get_ada_menu_items
    @ada_menu_items = MenuItem.archive_root_menu_items(Archive.ada, Workflowable::PUBLISH)
  end

  def get_archives
    @archives = Archive.all
  end
end
