class ContentController < Inkling::ContentController  
  before_filter :get_archives

  private
  
  def get_archives
    @archives = Archive.all
  end
end
