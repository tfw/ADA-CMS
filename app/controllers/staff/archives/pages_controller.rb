
class Staff::Archives::PagesController < Staff::ArchivesController
  include Inkling::Util::Slugs
  
  inherit_resources                                                                                     
  defaults :resource_class => Page, :instance_name => 'page'
  # before_filter :get_archive
  before_filter :get_archives, :except => [:destroy, :update_tree]
  before_filter :get_pages, :except => [:sluggerize_path, :preview]

  respond_to :json, :only => [:sluggerize_path, :preview]
  
  def create
    create! do |format| 
      format.html {
        if @page.archive
          redirect_to staff_archive_path(@page.archive) 
        end        
        } 
    end
  end

  def update
    update! do |format|   
      format.html {
        if @page.archive
          redirect_to staff_archive_path(@page.archive) 
        end
      } 
    end
  end
  
  def destroy
    archive = Page.find(params[:id]).archive
    destroy! do |format|   
      format.html { 
        redirect_to staff_archive_path(archive) 
        }
    end
  end

  #methods for remote call via ajax

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
    @page = Page.new(params[:page])
    @page.archive = @archive
  	html = render(:partial => @page.partial, :object => @page)
  	html
  end
  
  private
  # def get_archive
  #   @archive = Archive.find(params[:archive_id]) unless params[:archive_id].blank? 
  # end

  def get_archives
    @archives = Archive.all(:order => "name asc")
  end
  
  def get_pages
    # debugger
    @pages = Page.archive_root_pages(@archive)
    
    parent_pages = @pages.dup
    for parent_page in @pages
      @pages += parent_page.children
    end
    
    if params[:id]
      @pages.delete(Page.find(params[:id]))
    end
  end
end
