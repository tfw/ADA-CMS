#the basic representation of a unit of data - e.g. something imported from Nesstar

class Study < ActiveRecord::Base
  
  has_many :study_entries
  has_many :study_related_materials; alias related_materials study_related_materials
  belongs_to :page
  
  validates :label, :presence => true
  
  def self.store_with_entries(data)
    #first, see if this is a new dataset or we're updating an old one.
    ds = Study.find_by_label(data[:label])
    ds = Study.new if ds.nil?

    ds.label = data[:label]
    ds.about = data[:about]

    local_data = data.dup
    local_data.delete(:label)
    local_data.delete(:about)

    ds.universe = data[:universe]
    data.delete(:universe)
    ds.published = true
    ds.abstract = data[:abstract]
    data.delete(:abstract)
    ds.keywords = data[:keywords]
    data.delete(:keywords)

    ds.save!
    local_data.each {|k,v| create_or_update_entry(ds, k.to_s, v)}

    ds
  end

  def self.create_or_update_entry(dataset, key, value)
    begin
      ds_entry = StudyField.find_by_dataset_id_and_key(dataset.id, key)
    rescue
      raise StandardError, caller
    end

    if ds_entry
      ds_entry.value = value
    else
      ds_entry = DatasStudy.new(:study_id => dataset.id, :key => key, :value => value)
    end

    ds_entry.save!
  end

  def friendly_label
    bits = label.split(/\W/)
    if bits.size > 20
      friendly = bits[0..20].join(" ")
      return "#{friendly} ..."
    else
      return label
    end
  end
  
end