class ContentController < ApplicationController 
  
  layout 'content' #this file is created by Inking::Theme (rake install_theme), and written out to tmp/inkling/themes/layouts  
  before_filter :get_archives
  before_filter :get_ada_pages

  helper_method :get_atom_feed
  
  protected    
  def get_ada_pages
    @ada_parent_pages = Page.archive_root_pages(Archive.ada)
  end

  def get_archives
    @archives = Archive.all
  end
  
  def get_atom_feed(archive)
    feed = Inkling::Feed.find_by_title("#{archive.name} Atom Feed")
    feed ||=  Inkling::Feed.create!(:title => "#{archive.name} Atom Feed", :format => "Inkling::Feeds::Atom", :source => "NewsArchiveFeedsSource", :authors => archive.name, :criteria => {:archive_id => archive.id})    
  end
end
