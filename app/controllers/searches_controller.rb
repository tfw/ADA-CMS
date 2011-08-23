class SearchesController < ContentController
  inherit_resources
  defaults :resource_class => Search, :instance_name => 'search'
  
  respond_to :html
  clear_helpers
  helper :application
  helper :search

  ORDERS = {'study-asc' => [:label, :asc],
            'study-desc' => [:label, :desc],
            'primary-investigator-asc' => [:stdy_auth_entity, :asc],
            'primary-investigator-desc' => [:stdy_auth_entity, :desc],
            'time-period-asc' => [:period_start, :asc],
            'time-period-desc' => [:period_start, :desc],
            'ada-id-asc' => [:ddi_id, :asc],            
            'ada-id-desc' => [:ddi_id, :desc]}
                          
  def transient
    if params[:filters] and params[:filters].is_a? String
      params[:filters] = YAML.load(params[:filters])
    end
    search(params[:term], Archive.find(params[:archive_id]), params[:filters] || [], nil, params[:order], params[:page])
  end
  
  def show
    if params[:clear]
      session[:recent_saved_search_id] = nil
      params.delete(:clear)
    end

    show! do |format|
      format.html {
        search(@search.terms, @search.archive, @search.filters, @search.id, params[:order], params[:page])
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
  def search(term, current_archive, study_filters, search_id = nil, order_by = nil, page = 1)
    
    @term = term
    @current_archive = current_archive
    @search = Search.new

    @study_searches = 
      if @current_archive == Archive.ada
        search_studies_globally(study_filters, order_by, page)
      else
        {current_archive => study_search(current_archive, term, study_filters, order_by, page)}
      end

    @ada_search = study_search(Archive.ada, term, study_filters, page) unless @current_archive == Archive.ada
    
    @studies_search = @study_searches[current_archive]
    @variables_search = variable_search(term, [], page)

    @title = "Search: #{@term}"
    params[:filters] ||= []
    render :results
  end
  
  
  #the logic below was moved into Study (fat model), but a performance hit occurred - strangely -
  #so, for now, the fatter controller is acceptable.
  #these searches are conducted to build facets for each archive
  def search_studies_globally(filters = {}, order_by, page)
    {Archive.ada => study_search(Archive.ada, @term, filters, order_by, page),
     Archive.social_science => study_search(Archive.social_science, @term, filters, order_by, page),
     Archive.historical => study_search(Archive.historical, @term, filters, order_by, page),
     Archive.indigenous => study_search(Archive.indigenous, @term, filters, order_by, page),
     Archive.longitudinal => study_search(Archive.longitudinal, @term, filters, order_by, page),
     Archive.qualitative => study_search(Archive.qualitative, @term, filters, order_by, page),
     Archive.international => study_search(Archive.international, @term, filters, order_by, page),
     Archive.crime => study_search(Archive.crime, @term, filters, order_by, page)}
  end

  def study_search(archive, term, filters = {}, order, page)
    Sunspot.search(Study) do ;
      keywords term do 
        highlight :label, :fragment_size => -1
        highlight :abstract_text
      end

      with(:archive_ids).any_of [archive.id];
      
    #  debugger 

      filters.each do |facet|
        facet.each do |name, value|
          with(name.to_sym, value)
        end
      end
    
      order_by(ORDERS[order][0], ORDERS[order][1]) if order

      paginate(:page => page)

      facet :data_kind, :sort => :count, :limit => 7, :minimum_count => 2
      facet :sampling, :sort => :count, :limit => 7, :minimum_count => 2
      facet :coll_mode, :sort => :count, :limit => 7, :minimum_count => 2#
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
