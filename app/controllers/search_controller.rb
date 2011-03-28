class SearchController < ContentController
  
  respond_to :html
    
  def search   
    @term = params[:term]    
    @current_archive = Archive.find(params[:archive_id])  
    @filters = params[:filters]

    @archive_searches = 
      if @filters.empty?
         search_globally
      elsif @current_archive == Archive.ada
        search_globally(@filters)
      else
        {@current_archive => archive_search(@current_archive, @term, @filters)}
      end
          

    @search = @archive_searches[@current_archive]  
    
    @title = "Search: #{@term}"
    params[:filters] ||= []
    render :results
  end
  
  private  #the logic below was moved into Study (fat model), but a performance hit occurred - strangely -
          #so, for now, the fatter controller is acceptable
  def search_globally(filters = {})
    {Archive.ada => archive_search(Archive.ada, @term, filters),
     Archive.social_science => archive_search(Archive.social_science, @term, filters),
     Archive.historical => archive_search(Archive.historical, @term, filters),
     Archive.indigenous => archive_search(Archive.indigenous, @term, filters),
     Archive.longitudinal => archive_search(Archive.longitudinal, @term, filters),
     Archive.qualitative => archive_search(Archive.qualitative, @term, filters),
     Archive.international => archive_search(Archive.international, @term, filters)}
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
end
