class Staff::ArchivesController < Staff::BaseController

  respond_to :html
  respond_to :json, :only => :update_page_order
  before_filter :get_archive, :except => :update_page_order
  before_filter :get_parent_pages, :only => :show  
  before_filter :get_parent_menu_items, :only => :show  

  def show
    @pages = Page.find_all_by_archive_id(@archive)
    respond_with @archive
  end


  def update_menu_order
    #1 find the moved page
    moved_menu_id = params[:moved].gsub("menu-options-", "")
    moved_menu = MenuItem.find(moved_menu_id)
    menu_ids = params[:menu_order].split(",")
    menu_ids.collect! {|i| i.gsub("menu-options-", "").to_i}

    #2 find the pages left and right of the moved page
    idx = menu_ids.index(moved_menu_id.to_i)
    left_idx  = idx != menu_ids.first ? menu_ids[idx - 1] : nil
    right_idx = idx != menu_ids.last ? menu_ids[idx + 1] : nil
puts "l #{left_idx} : r #{right_idx}"
    debugger
    left_menu =  MenuItem.find(left_idx)
    right_menu =  MenuItem.find(right_idx)

    moved_menu.move_to_right_of left_menu
    left_menu.move_to_left_of moved_menu

    moved_page.move_to_left_of right_menu
    right_menu.move_to_right_of moved_menu
    render :nothing => true
  end


  private
  def get_archive
    @archive ||= Archive.find_by_slug(params[:id]) if params[:id]
  end
  
  def get_parent_pages
    @parent_pages = Page.archive_root_pages(@archive)
  end
  
  def get_parent_menu_items
    @parent_menu_items = MenuItem.archive_root_menu_items(@archive)
  end  
end
