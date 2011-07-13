class Staff::Archives::MenuItemsController < Staff::Archives::BaseController
  inherit_resources
  defaults :resource_class => MenuItem, :instance_name => 'menu_item'
  before_filter :get_archive
  before_filter :get_menu_items, :except => :destroy  
  
  
  def create
    create! do |format|
      format.html {
        redirect_to staff_archive_path(@menu_item.archive)
        }
    end
  end

  def update
    update! do |format|
      format.html {
        redirect_to staff_archive_path(@menu_item.archive)
      }
    end
  end

  def destroy
    archive = MenuItem.find(params[:id]).archive
    destroy! do |format|
      format.html {
        redirect_to staff_archive_path(archive)
        }
    end
  end 
   
  def get_menu_items
    @menu_items = MenuItem.archive_root_menu_items(@archive)

    parent_menu_items = @menu_items.dup
    for parent_menu_item in @menu_items
      @menu_items += parent_menu_item.children
    end

    if params[:id]
      @menu_items.delete(MenuItem.find(params[:id]))
    end
  end
    
end
