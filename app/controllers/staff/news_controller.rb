class Staff::NewsController < Staff::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => News, :instance_name => 'news'
  respond_to :json, :only => [:preview]

  before_filter :get_archives

  def index
    get_recent_news
  end
  
  def create
    create! do |format|
      format.html {
        redirect_to staff_news_index_path
        }
    end
  end

  def update
    update! do |format|
      format.html {
        redirect_to staff_news_index_path
        }
    end
  end

  def preview
    @news = params[:news]
    archives = @news.delete(:archives)
    @news = News.new(@news)

    if @news.keywords.nil?
      @news.keywords = ""
    end
    @news.updated_at = Time.now

    @archive_news = ArchiveNews.new(:news => @news, :archive => Archive.ada)
    @archive_news.path = Inkling::Path.new(:slug => "previewing")
    @current_archive = @archives.first
    @current_archive ||= Archive.ada

    render(:template => "/archive_news/show", :object => @news, :layout => false)
  end

  def publish
    @news = News.find(params[:id]) 

    if current_user.can_approve?
      @news.publish!(current_user)
      flash[:notice] = "News published."
      Inkling::Log.create!(:text => 
        "#{@news.user} published news <a href='#{edit_staff_news_path(@news)}'>#{@news.title}</a>.", 
          :category => "workflowable", :user => @news.user)
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
