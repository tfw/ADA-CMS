#a dummy model to allow us to reuse archive pages in the context of all archives
class ADAArchive
  
  def name
    "ADA"
  end
  
  def id
    nil
  end
  
  def pages
    Page.find_all_by_archive_id(nil)
  end
end