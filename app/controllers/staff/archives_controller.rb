class Staff::ArchivesController < Inkling::BaseController

  respond_to :html
  respond_to :json, :only => :update_page_order
  before_filter :get_archive, :only => :show
  before_filter :get_parent_pages, :only => :show  
  
  def show
    @pages = Page.find_all_by_archive_id(@archive)
    respond_with @archive
  end

  def update_page_order
    #1 find the moved page
    moved_page = Page.find(params[:moved])
    
    page_ids = params[:page_order].split(",")
    page_ids.collect! {|i| i.to_i}
    #2 find the pages left and right of the moved page
    idx = page_ids.index(moved_page.id)
    left_idx  = idx != page_ids.first ? page_ids[idx - 1] : nil
    right_idx = idx != page_ids.last ? page_ids[idx + 1] : nil
    left_page =  Page.find(left_idx)
    right_page =  Page.find(right_idx)
    
    moved_page.move_to_right_of left_page
    left_page.move_to_left_of moved_page

    moved_page.move_to_left_of right_page
    right_page.move_to_right_of moved_page
    render :nothing => true
  end

  private
  def get_archive
    @archive = Archive.find_by_slug(params[:slug]) if params[:slug]
  end
  
  def get_parent_pages
    @parent_pages = Page.archive_roots(@archive)
  end  
end
