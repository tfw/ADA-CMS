class Staff::DDIMappingsController < Staff::BaseController

  before_filter :get_mappings, :except => [:create, :update]
  before_filter :get_missing_mappings, :except => [:create, :update]

  def index
    @mapping = DDIMapping.new
  end

  def show
    @mapping = DDIMapping.find(params[:id])
    render :action => :index
  end

  def create
    @mapping = DDIMapping.find(params[:mapping_id])
    @mapping.update_attributes(params[:mapping])

    get_missing_mappings
    get_mappings
    render :action => :index
  end

  def update
    @mapping = DDIMapping.find(params[:mapping][:id])
    @mapping.update_attributes(params[:mapping])

    get_missing_mappings
    get_mappings
    render :action => :index
  end

  def edit
    @mapping = DDIMapping.find(params[:id])
    render :action => :index
  end

  def destroy
    @mapping = DDIMapping.find(params[:id])
    @mapping.delete
    render :action => :index
  end

  def csv
    render :layout => false
  end


  private
  def get_mappings
    @mappings = DDIMapping.find(:all, :conditions => "human_readable is not null")
  end

  def get_missing_mappings
    @missing_mappings = DDIMapping.find_all_by_human_readable(nil, :order => :ddi)
  end
end
