class SearchController < ContentController
  
  respond_to :html
    
  def sphinx   
    @term = params[:term]
    @current_archive = Archive.find(params[:archive_id])  
    @sphinx = ThinkingSphinx.search(@term, :page => params[:page], :conditions => {:archive_id => @current_archive.id})

    @archive_facets = {Archive.social_science => (Study.facets @term, :conditions => {:archive_id => Archive.social_science.id}),
      Archive.historical => (Study.facets @term, :conditions => {:archive_id => Archive.historical.id}),
      Archive.indigenous => (Study.facets @term, :conditions => {:archive_id => Archive.indigenous.id}),
      Archive.longitudinal => (Study.facets @term, :conditions => {:archive_id => Archive.longitudinal.id}),
      Archive.qualitative => (Study.facets @term, :conditions => {:archive_id => Archive.qualitative.id}),
      Archive.international => (Study.facets @term, :conditions => {:archive_id => Archive.international.id})            
      }
      
    render :results
  end
  
  def facets
    @current_archive = Archive.find(params[:archive_id])
    @facet = params[:facet]
    @sphinx = ThinkingSphinx.facets(params[:facet], :page => params[:page], :conditions => {:archive_id => @current_archive.id})
  
    @archive_facets = {Archive.social_science => (Study.facets @facet, :conditions => {:archive_id => Archive.social_science.id}),
      Archive.historical => (Study.facets @facet, :conditions => {:archive_id => Archive.historical.id}),
      Archive.indigenous => (Study.facets @facet, :conditions => {:archive_id => Archive.indigenous.id}),
      Archive.longitudinal => (Study.facets @facet, :conditions => {:archive_id => Archive.longitudinal.id}),
      Archive.qualitative => (Study.facets @facet, :conditions => {:archive_id => Archive.qualitative.id}),
      Archive.international => (Study.facets @facet, :conditions => {:archive_id => Archive.international.id})            
      }
    
    render :facets
  end
end
