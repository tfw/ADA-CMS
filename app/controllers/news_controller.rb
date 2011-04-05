class NewsController < ContentController
  respond_to :html

  def show
    @news_archive = NewsArchive.find_by_id(params[:id])
    @news = @news_archive.news
    @current_archive = @news_archive.archive
    @assigned_archives = @news.archives
    @title = @news.title
    respond_with(@news)
  end

end
