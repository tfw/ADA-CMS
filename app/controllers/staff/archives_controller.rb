class Staff::ArchivesController < Inkling::BaseController
  inherit_resources                                                                                     
  defaults :resource_class => Archive, :instance_name => 'archive'

  before_filter :get_archive
  # before_filter :get_pages

  private
  def get_archive
    @archive = Archive.find_by_slug(params[:slug]) if params[:slug]
    @archive ||= nil
  end
  
  # def get_pages
  #   @pages = Page.find_all_by_archive_id_and_parent_id( (@archive.nil? ? nil : @archive.id) , nil)
  #   
  #   parent_pages = @pages.dup
  #   for parent_page in @pages
  #     @pages += parent_page.children
  #   end
  # end
end
