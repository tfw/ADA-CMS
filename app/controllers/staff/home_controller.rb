class Staff::HomeController < Staff::BaseController
  
  def dashboard
  	pages_limit = params[:all_pages] ? nil : 20;
  	news_limit = params[:all_news] ? nil : 20; 
  	@draft_news = News.where("state ='draft'").order("updated_at asc").limit(news_limit);
  	@draft_news_count = News.where("state ='draft'").order("updated_at asc").count;
  	@draft_pages = Page.where("state ='draft'").order("updated_at asc").limit(pages_limit);
  	@draft_pages_count = Page.where("state ='draft'").order("updated_at asc").count;
  end
end