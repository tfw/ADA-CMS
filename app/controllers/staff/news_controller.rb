class Staff::NewsController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => News, :instance_name => 'news'
  respond_to :json, :only => [:preview]

  before_filter :get_archives

  def index
    get_recent_news
  end

  def show
    show! do 
      @assigned_archives = @news.archives
    end
  end

  def preview
    news = params[:news]
    archives = news.delete(:archives)
    @news = News.new(news)
    @assigned_archives = archives.map do |archive_id|
      Archive.find(archive_id)
    end
    render(:partial => "news/show", :object => @news)
  end

  private
  def get_recent_news
    @recent_news = News.find(:all, :order => "created_at DESC")
  end

  def get_archives
    @archives = Archive.all(:order => "name asc")
  end
end
