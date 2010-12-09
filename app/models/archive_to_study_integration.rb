#an integration point between Nesstar, an archive, and a study.

class ArchiveToStudyIntegration < ArchiveToStudyBlock
  
  belongs_to :study
  # validate :unique_study_and_query
  
end
