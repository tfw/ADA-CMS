class SearchesController < ContentController
  inherit_resources
  defaults :resource_class => Search, :instance_name => 'search'
  
  respond_to :html
  clear_helpers
  helper :application
  helper :search
    
  def transient
    search(params[:term], Archive.find(params[:archive_id]), params[:filters] || [], params[:page])
  end
  
  def show
    if params[:clear]
      session[:recent_saved_search_id] = nil
      params.delete(:clear)
    end

    show! do |format|
      format.html {
        search(@search.terms, @search.archive, @search.filters, @search.id, params[:page])
      }
    end
  end
      
  def create
    create! do |format|
      format.js {
        if @search.valid?
          session[:recent_saved_search_id] = @search.id
          @search_path = search_path(@search)
          @saved_searches_path = user_searches_path(current_user)
        end
      }
    end
  end

  private
  def search(term, current_archive, study_filters, search_id = nil, page)
    @term = term
    @current_archive = current_archive
    @search = Search.new

    @study_searches = 
      if @current_archive == Archive.ada
        search_studies_globally(study_filters, page)
      else
        {current_archive => study_search(current_archive, term, study_filters, page)}
      end
    
    @studies_search = @study_searches[current_archive]
    @variables_search = variable_search(term, [], page)

    @title = "Search: #{@term}"
    params[:filters] ||= []
    render :results
  end
  
  
  #the logic below was moved into Study (fat model), but a performance hit occurred - strangely -
  #so, for now, the fatter controller is acceptable.
  #these searches are conducted to build facets for each archive
  def search_studies_globally(filters = {}, page = 1)
    {Archive.ada => study_search(Archive.ada, @term, filters, page),
     Archive.social_science => study_search(Archive.social_science, @term, filters, page),
     Archive.historical => study_search(Archive.historical, @term, filters, page),
     Archive.indigenous => study_search(Archive.indigenous, @term, filters, page),
     Archive.longitudinal => study_search(Archive.longitudinal, @term, filters, page),
     Archive.qualitative => study_search(Archive.qualitative, @term, filters, page),
     Archive.international => study_search(Archive.international, @term, filters, page),
     Archive.crime => study_search(Archive.crime, @term, filters, page)}
  end

  def study_search(archive, term, filters = {}, page = 1)
    Sunspot.search(Study) do ;
      keywords term do 
        highlight :label, :abstract_text, :comment
      end

      with(:archive_ids).any_of [archive.id];
      
      filters.each do |facet|
        facet.each do |name, value|
          with(name.to_sym, value)
        end
      end
      
      paginate(:page => page)

      facet :data_kind, :sort => :count, :limit => 7, :minimum_count => 2
      facet :sampling, :sort => :count, :limit => 7, :minimum_count => 2
      facet :coll_mode, :sort => :count, :limit => 7, :minimum_count => 2
      facet :stdy_contact_affiliation, :sort => :count, :limit => 7, :minimum_count => 2
      facet :geographical_cover, :sort => :count, :limit => 7, :minimum_count => 2
      facet :geographical_unit, :sort => :count, :limit => 7, :minimum_count => 2
      facet :analytic_unit, :sort => :count, :limit => 7, :minimum_count => 2
      facet :creation_date, :sort => :count, :limit => 7, :minimum_count => 2
      facet :series_name, :sort => :count, :limit => 7, :minimum_count => 2
      facet :stdy_auth_entity, :sort => :count, :limit => 7, :minimum_count => 2
    end    
  end

  def variable_search(term, filters = {}, page)
    Sunspot.search(Variable) do ;
      keywords term do 
        highlight :label, :question_text
      end
      
      paginate(:page => page)
            
      filters.each do |facet|
        facet.each do |name, value|
          with(name.to_sym, value)
        end
      end
    end    
  end
end
