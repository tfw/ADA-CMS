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
  
  def create
    create! do |format|
      format.html {
        redirect_to staff_news_path
        }
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

  def publish
    @news = News.find(params[:id]) 

    if current_user.can_approve?
      @news.publish!(current_user)
      flash[:notice] = "News published."
      Inkling::Log.create!(:text => 
        "#{@news.author} published news <a href='#{edit_staff_news_path(@news)}'>#{@news.title}</a>.", :category => "workflowable", :user => @news.author)
    else
      flash[:alert] = "I'm sorry, you don't have permission to publish News."
    end

    redirect_to edit_staff_news_path(@news) 
  end


  private
  def get_recent_news
    @recent_news = News.find(:all, :order => "created_at DESC")
  end

  def get_archives
    @archives = Archive.all(:order => "name asc")
  end
end
