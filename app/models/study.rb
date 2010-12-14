#the basic representation of a unit of data - e.g. something imported from Nesstar

class Study < ActiveRecord::Base
  
  has_many :study_fields; alias fields study_fields
  has_many :study_related_materials
  has_many :archive_to_study_integrations
  has_many :pages, :through => :archive_to_study_integrations
  
  validates :label, :presence => true
  
  def self.store_with_entries(data)
    #first, see if this is a new dataset or we're updating an old one.
    study = Study.find_by_label(data[:label])
    study = Study.new if study.nil?

    study.label = data[:label]
    study.about = data[:about]

    local_data = data.dup
    local_data.delete(:label)
    local_data.delete(:about)

    study.universe = data[:universe]
    data.delete(:universe)
    study.published = true
    study.abstract = data[:abstract]
    data.delete(:abstract)
    study.keywords = data[:keywords]
    data.delete(:keywords)

    study.save!
    local_data.each {|k,v| create_or_update_entry(study, k.to_s, v)}

    study
  end

  def self.create_or_update_entry(study, key, value)
    begin
      study_field = StudyField.find_by_study_id_and_key(study.id, key)
    rescue
      raise StandardError, caller
    end

    if study_field
      study_field.value = value
    else
      study_field = StudyField.new(:study_id => study.id, :key => key, :value => value)
    end

    study_field.save!
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
  
  def related_materials_attribute
    fields.find_by_key("relatedMaterials_attribute_resource")
  end
  
  def field(key)
    field = study_fields.find_by_key(key)
    field.value if field
  end
end