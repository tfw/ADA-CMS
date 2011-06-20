class Users::SearchesController < ContentController
  inherit_resources
  defaults :resource_class => Search, :instance_name => 'search'
  
  def index
    order_by = params[:sort] if Search.column_names.include?(params[:sort])
    order = params[:order]
    
    if params[:order] == "up"
      order = "ASC" 
    elsif params[:order] == "down"
      order =  "DESC"
    end
    
    @current_archive = Archive.ada
    @searches = current_user.searches.order("#{order_by} #{order}")
  end
  
  def destroy
    @search = Search.find(params[:id])
    
    if @search.user != current_user
      flash[:error] = "You cannot delete another user's search."
    end
    
    delete!
  end
end
