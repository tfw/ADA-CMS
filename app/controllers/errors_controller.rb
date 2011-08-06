class ErrorsController < ContentController

  #this will suit a 404 condition. 500s can be handled with a static error page from public/
  def routing
    @title = "#{params[:miss]} 404"
    @current_archive = Archive.ada
    render :template => "errors/404", :status => 404, :layout => 'content' 
  end
end

