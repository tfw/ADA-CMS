
class Staff::Archives::PagesController < Staff::Archives::BaseController
  include Inkling::Util::Slugs, Staff::WorkflowableHelper

  inherit_resources
  defaults :resource_class => Page, :instance_name => 'page'
  before_filter :get_archive
  before_filter :get_archives, :except => [:destroy, :update_tree]
  before_filter :get_pages, :except => [:sluggerize_path, :preview]

  respond_to :json, :only => [:sluggerize_path, :preview]

  def new
    new! do
    @page.partial = "/pages/default_page"
    end
  end

  def create
    create! do |format|
      format.html {
        redirect_to staff_archive_path(@page.archive)
        }
    end
  end

  def browse      # browse_staff_documents_path
    # Render a browser for CKEditor
    @documents = Document.all
    @pages = @archive.pages
    @archive_studies = @archive.archive_studies
    render :layout => "browser"
  end

  def update
    update! do |format|
      format.html {
        redirect_to staff_archive_path(@page.archive)
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
      slug = "#{parent_page.urn}/#{slug}"
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

  def publish
    @page = Page.find(params[:id]) 

    if current_user.can_approve?
      @page.publish!(current_user)
      flash[:notice] = "Page published."
      Inkling::Log.create!(:text => "#{@page.author} published page <a href='#{edit_staff_archive_page_path(@page.archive, @page)}'>#{@page.title}</a> in <a href='/staff/archives/#{@page.archive.slug}'>#{@page.archive.name}</a>.", :category => "workflowable", :user => @page.author)
    else
      flash[:alert] = "I'm sorry, you don't have permission to publish pages."
    end

    redirect_to edit_staff_archive_page_path(@page.archive, @page) 
  end

  private
  def get_archives
    @archives = Archive.all(:order => "name asc")
  end

  def get_pages
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
