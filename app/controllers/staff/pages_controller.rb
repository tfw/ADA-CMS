require 'ada_archive'
class Staff::PagesController < Inkling::BaseController
  include Inkling::Slugs
  
  inherit_resources                                                                                     
  defaults :resource_class => Page, :instance_name => 'page'
  before_filter :get_archive
  before_filter :get_pages

  respond_to :json, :only => :sluggerize_path
  
  def create
    create! do |format|   
      format.html {redirect_to staff_archives_path(@page.archive)} 
    end
  end

  def update
    update! do |format|   
      format.html { redirect_to staff_archives_path(@page.archive) }
    end
  end

  def update_tree
    new_parent_id = params[:new_parent]
    child_id      = params[:child]
    new_parent    = Page.find(new_parent_id)
    child         = Page.find(child_id)
    
    child.parent_id = new_parent.id
    
    child.save! 
    render :nothing => true
    return
  end

  def sluggerize_path
    parent_page = Page.find(params[:parent]) unless params[:parent].empty?
    slug = sluggerize(params[:title])
    
    if parent_page 
      slug = "#{parent_page.path.slug}/#{slug}" 
    elsif @archive
      slug = "/#{@archive.slug}/#{slug}" 
    end
    
    json_hash = {:success => true, :data => slug}        
    render :json => json_hash
  end
  
  def preview
    @page = Page.new(:params[:staff_page])
    render(:template => '/pages/show', :layout => 'content')
  end
  
  private
  def get_archive
    @archive = Archive.find(params[:archive_id]) if params[:archive_id]
    @archive ||= ADAArchive.new
  end
  
  def get_pages
    @pages = Page.find_all_by_archive_id_and_parent_id( (@archive.nil? ? nil : @archive.id) , nil)
    
    parent_pages = @pages.dup
    for parent_page in @pages
      @pages += parent_page.children
    end
  end
end
