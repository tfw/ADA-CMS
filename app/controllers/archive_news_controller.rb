class ArchiveNewsController < ContentController
  respond_to :html

  def show
    @archive_news = ArchiveNews.find_by_id(params[:id])
    @news = @archive_news.news
    @current_archive = @archive_news.archive
    @assigned_archives = @news.archives
    @title = @news.title
    respond_with(@news)
  end
end

