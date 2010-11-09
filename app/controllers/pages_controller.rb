class PagesController < ContentController
  
  respond_to :html
  
  def show
    @page = Page.find_by_id(params[:id])
    # @archive = @page.archive
    # @archive ||= ADAArchive.new #see lib/ada_archive.rb
    # 
    # @parent_pages = Page.find_all_by_archive_id_and_parent_id(@page.archive.id, nil)
    # # @children_pages = Page.find_all_by_archive_id_and_parent_id(@page.archive.id, )
    # respond_with()
  end
end
