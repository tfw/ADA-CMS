class Staff::NewsController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => News, :instance_name => 'news'

  before_filter :get_archives

  def index
    get_recent_news
  end

  def update
    update! do |format| 
      format.html {
        redirect_to edit_staff_news_path(@news)
      } 
    end
  end

  private
  def get_recent_news
    @recent_news = News.find(:all, :limit => 10, :order => "created_at DESC")
  end

  def get_archives
    @archives = Archive.all(:order => "name asc")
  end
end
