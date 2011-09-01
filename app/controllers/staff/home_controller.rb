class Staff::HomeController < Staff::BaseController
  
  def dashboard
  	@draft_news = News.where("state ='draft'").order("updated_at asc").limit(20);
  	@draft_news_count = News.where("state ='draft'").order("updated_at asc").count;
  	@draft_pages = Page.where("state ='draft'").order("updated_at asc").limit(20);
  	@draft_pages_count = Page.where("state ='draft'").order("updated_at asc").count;
  end
end