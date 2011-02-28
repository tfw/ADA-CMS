class Staff::NewsController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => News, :instance_name => 'news'

  def index
    get_recent_news
  end
  
  def get_recent_news
    @recent_news = News.find(:all, :limit => 10, :order => "created_at DESC")
  end
end
