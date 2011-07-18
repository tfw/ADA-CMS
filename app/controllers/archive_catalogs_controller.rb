class ArchiveCatalogsController < ContentController
    
  respond_to :html
  clear_helpers
  helper :application
  
  before_filter :get_root_catalogs
  
  def show
    @catalog = params[:id] ? ArchiveCatalog.find_by_id(params[:id]) : nil
    @current_archive = @catalog ? @catalog.archive : Archive.ada
    @title = @catalog ? @catalog.title : "Browse ADA Catalogs"
    @archive_catalog_studies = @catalog ? @catalog.archive_catalog_studies : []

    respond_with(@catalog)
  end  
  
  def browse
    catalog_urn = params[:archive_catalog_urn]
    path = Inkling::Path.find_by_slug(catalog_urn)
    @catalog = path.content
    
    @archive_catalog_study = ArchiveCatalogStudy.find(params[:archive_catalog_study_id]) if params[:archive_catalog_study_id]

    if @archive_catalog_study
      @archive_catalog_studies = [@archive_catalog_study] 
      remaining_studies = @catalog.archive_catalog_studies.dup
      remaining_studies.delete(@archive_catalog_study)
      @archive_catalog_studies += remaining_studies
    else
      @archive_catalog_studies = @catalog.archive_catalog_studies
    end
    
    @current_archive = @catalog.archive
    render :layout => false
  end
  
  protected
  def get_root_catalogs
    @ada_catalogs = {Archive.social_science => ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.social_science.id, nil),
    Archive.historical => ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.historical.id, nil),
    Archive.indigenous => ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.indigenous.id, nil),
    Archive.longitudinal => ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.longitudinal.id, nil),
    Archive.qualitative => ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.qualitative.id, nil),
    Archive.international => ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.international.id, nil),
    Archive.crime => ArchiveCatalog.find_by_archive_id_and_parent_id(Archive.crime.id, nil)}
  end  
end