class ArchiveFeedsSource
  
  def self.list(criteria = nil)
    feed = ArchiveNews.where({:archive_id => criteria[:archive_id]}).order("created_at DESC").limit(10)
    feed += ArchiveStudy.where({:archive_id => criteria[:archive_id]}).order("created_at DESC").limit(10)
  end
end