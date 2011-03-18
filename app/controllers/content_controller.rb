class ContentController < ApplicationController 
  # 
  # respond_to :json, :only => 
  
  layout 'content' #this file is created by Inking::Theme (see Inkling admin), and written out to tmp/inkling/themes/layouts  
  before_filter :get_archives
  before_filter :get_ada_pages

  protected    
  def get_ada_pages
    @ada_parent_pages = Page.archive_root_pages(Archive.ada)
  end

  def get_archives
    @archives = Archive.all
  end
end
