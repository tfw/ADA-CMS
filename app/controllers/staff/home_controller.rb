class Staff::HomeController < Staff::BaseController
  
  def dashboard
  	@draft_news = News.where("state ='draft'").order("updated_at desc");
  	@draft_pages = Page.where("state ='draft'").order("updated_at desc");
  end
end