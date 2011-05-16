class NewsArchiveFeedsSource
  
  def self.list(criteria = nil)
    NewsArchive.where({:archive_id => criteria[:archive_id]}).all
  end
end