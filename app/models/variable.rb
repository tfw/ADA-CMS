class Variable < ActiveRecord::Base
  belongs_to :study
  has_many :variable_fields; alias fields variable_fields
  has_many :statistics
  
  # validates_presence_of :study_id #it seems that not all variables are related to a study
  
  #solr config
  searchable do
    text :label, :stored => true
    text :name, :stored => true
    text :question_text, :stored => true
    integer :study_id
  end  
  
  def self.store_with_fields(data)
    variable = Variable.find_by_label(data[:label])
    variable = Variable.new if variable.nil?

    variable.label = data[:label]
    variable.study = Study.find_by_about(data[:study_attribute_resource])

    local_data = data.dup
    local_data.delete(:label)

    variable.name = data[:name]
    data.delete(:name)

    if data[:questionText] #this value doesnt appear in all variables
      variable.question_text = data[:questionText] 
      data.delete(:questionText)
    end
    
    variable.num_cats = data[:numCats]
    data.delete(:numCats)
    variable.val_range_max = data[:valRangeMax]
    data.delete(:valRangeMax)
    variable.val_range_min = data[:valRangeMin]
    data.delete(:valRangeMin)
  
    variable.save!
    local_data.each {|k,v| create_or_update_field(variable, k.to_s, v)}
    variable
  end
  
  def self.create_or_update_field(variable, key, value)
    begin
      variable_field = VariableField.find_by_variable_id_and_key(variable.id, key)
    rescue
      raise StandardError, caller
    end

    if variable_field
      variable_field.value = value
    else
      variable_field = VariableField.new(:variable_id => variable.id, :key => key, :value => value)
    end

    variable_field.save!
  end
end  
