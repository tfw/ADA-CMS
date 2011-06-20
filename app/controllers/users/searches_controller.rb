class Users::SearchesController < ContentController
  inherit_resources
  defaults :resource_class => Search, :instance_name => 'search'
  
  def index
    @current_archive = Archive.ada
    @searches = current_user.searches
  end
  
  def destroy
    @search = Search.find(params[:id])
    
    if @search.user != current_user
      flash[:error] = "You cannot delete another user's search."
    end
    
    delete!
  end
end
