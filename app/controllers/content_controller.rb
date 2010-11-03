class ContentController < Inkling::ContentController  
  before_filter :get_archives

  protected  
  def current_archive
    nil
  end

  private
  def get_archives
    @archives = Archive.all
  end
end
