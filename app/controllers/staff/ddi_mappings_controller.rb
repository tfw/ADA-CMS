class Staff::DdiMappingsController < Staff::BaseController

  before_filter :get_mappings, :except => [:create, :update]
  before_filter :get_missing_mappings, :except => [:create, :update]

  def index
    @ddi_mapping = DdiMapping.new
  end

  def show
    @ddi_mapping = DdiMapping.find(params[:id])
    render :action => :index
  end

  def create
    @ddi_mapping = DdiMapping.find(params[:ddi_mapping][:id])
    @ddi_mapping.update_attributes(params[:ddi_mapping])

    get_missing_mappings
    get_mappings
    render :action => :index
  end

  def update
    @ddi_mapping = DdiMapping.find(params[:ddi_mapping][:id])
    @ddi_mapping.update_attributes(params[:ddi_mapping])

    get_missing_mappings
    get_mappings
    render :action => :index
  end

  def edit
    @ddi_mapping = DdiMapping.find(params[:id])
    render :action => :index
  end

  def destroy
    @ddi_mapping = DdiMapping.find(params[:id])
    @ddi_mapping.delete
    render :action => :index
  end

  def csv
    render :layout => false
  end


  private
  def get_mappings
    @ddi_mappings = DdiMapping.find(:all, :conditions => "human_readable is not null")
  end

  def get_missing_mappings
    @ddi_missing_mappings = DdiMapping.find_all_by_human_readable(nil, :order => :ddi)
  end
end
