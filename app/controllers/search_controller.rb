class SearchController < ContentController
  
  respond_to :html
    
  def search   
    @term = params[:term]    
    @current_archive = Archive.find(params[:archive_id])  
    @archive_searches = params[:filters] ? 
    {@current_archive => archive_search(@current_archive, @term, params[:filters])} : search_globally
    
    @search = @archive_searches[@current_archive]  
    
    @title = "Search: #{@term}"
    params[:filters] ||= []
    render :results
  end
  
  private  
  def search_globally
    {Archive.ada => archive_search(Archive.ada, @term),
     Archive.social_science => archive_search(Archive.social_science, @term),
     Archive.historical => archive_search(Archive.historical, @term),
     Archive.indigenous => archive_search(Archive.indigenous, @term),
     Archive.longitudinal => archive_search(Archive.longitudinal, @term),
     Archive.qualitative => archive_search(Archive.qualitative, @term),
     Archive.international => archive_search(Archive.international, @term)}
  end

  def archive_search(archive, term, filters = {})
    Sunspot.search(Study) do ;
      keywords term do 
        highlight :label, :abstract, :comment
      end
      
      with(:archive_ids).any_of [archive.id];
      
      filters.each do |facet|
        facet.each do |name, value|
          with(name.to_sym, value)
        end
      end
      
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
