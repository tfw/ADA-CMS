class SearchController < ContentController
  
  respond_to :html
    
  def search   
    @term = params[:term]    
    @current_archive = Archive.find(params[:archive_id])  
    
    @archive_searches = {Archive.ada => archive_search(Archive.ada.id, @term),
       Archive.social_science => archive_search(Archive.social_science.id, @term),
       Archive.historical => archive_search(Archive.historical.id, @term),
       Archive.indigenous => archive_search(Archive.indigenous.id, @term),
       Archive.longitudinal => archive_search(Archive.longitudinal.id, @term),
       Archive.qualitative => archive_search(Archive.qualitative.id, @term),
       Archive.international => archive_search(Archive.international.id, @term)}

    @search = @archive_searches[@current_archive]  
    
    @title = "Search: #{@term}"
      
    render :results
  end
  
  private
  
  def archive_search(archive_id, term)
    Study.search do ;
      keywords term do 
        highlight :label, :abstract, :comment
      end
      
      with(:archive_ids).any_of [archive_id];
      
      facet :data_kind
      facet :sampling_abbr
      facet :collection_mode_abbr
      facet :contact_affiliation
      facet :collection_mode_abbr
      facet :geographical_cover
      facet :geographical_unit
      facet :analytic_unit
      facet :creation_date
      facet :series_name
      facet :study_auth_entity
    end    
  end
  
  
  # def facets
  #   @current_archive = Archive.find(params[:archive_id])
  #   @term = params[:facet]
  #   @sphinx = ThinkingSphinx.search(params[:term], :page => params[:page], :conditions => {:archive_id => @current_archive.id})
  # 
  #   @archive_facets = {Archive.social_science => (Study.facets @facet, :conditions => {:archive_id => Archive.social_science.id}),
  #     Archive.historical => (Study.facets @facet, :conditions => {:archive_id => Archive.historical.id}),
  #     Archive.indigenous => (Study.facets @facet, :conditions => {:archive_id => Archive.indigenous.id}),
  #     Archive.longitudinal => (Study.facets @facet, :conditions => {:archive_id => Archive.longitudinal.id}),
  #     Archive.qualitative => (Study.facets @facet, :conditions => {:archive_id => Archive.qualitative.id}),
  #     Archive.international => (Study.facets @facet, :conditions => {:archive_id => Archive.international.id})            
  #     }
  #   
  #   debugger
  #   
  #   render :facets
  # end
end
