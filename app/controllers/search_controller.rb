class SearchController < ContentController
  
  respond_to :html
    
  def search   
    @term = params[:term]    
    @current_archive = Archive.find(params[:archive_id])  
    @study_filters = (params[:filters] || [])
    variable_filters = (params[:var_filters] || [])

    @study_searches = 
      if @current_archive == Archive.ada
        search_studies_globally(@study_filters)
      else
        {@current_archive => study_search(@current_archive, @term, @study_filters)}
      end
    
    @studies_search = @study_searches[@current_archive]  
    @variables_search = variable_search(@term, variable_filters)      
    
    @title = "Search: #{@term}"
    params[:filters] ||= []
    params[:var_filters] ||= []
    render :results
  end
  
  private  #the logic below was moved into Study (fat model), but a performance hit occurred - strangely -
          #so, for now, the fatter controller is acceptable
  def search_studies_globally(filters = {})
    {Archive.ada => study_search(Archive.ada, @term, filters),
     Archive.social_science => study_search(Archive.social_science, @term, filters),
     Archive.historical => study_search(Archive.historical, @term, filters),
     Archive.indigenous => study_search(Archive.indigenous, @term, filters),
     Archive.longitudinal => study_search(Archive.longitudinal, @term, filters),
     Archive.qualitative => study_search(Archive.qualitative, @term, filters),
     Archive.international => study_search(Archive.international, @term, filters)}
  end

  def study_search(archive, term, filters = {})
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

  def variable_search(term, filters = {})
    Sunspot.search(Variable) do ;
      keywords term do 
        highlight :label, :question_text
      end
            
      filters.each do |facet|
        facet.each do |name, value|
          with(name.to_sym, value)
        end
      end
      
      facet :name
    end    
  end
end
