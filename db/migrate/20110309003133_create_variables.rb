class CreateVariables < ActiveRecord::Migration
  def self.up
    create_table :variables do |t|
      # t.integer :id
      # t.string  :label
      # t.integer :study_id
      # t.string  :name
      # t.text    :question_text
      # t.integer :num_cats
      # t.decimal :val_range_max
      # t.decimal :val_range_min
      
      t.text      :additivity
      t.text      :comment
      t.text      :concept
      t.text      :creation_date
      t.text      :data_file_id
      t.text      :decimal_places
      t.text      :end_pos
      t.text      :expression
      t.text      :ext_notes_role
      t.text      :ext_notes_title
      t.text      :ext_notes_uri
      t.text      :format
      t.text      :format_schema
      t.text      :geogr
      t.text      :instructions
      t.text      :interviewer_instr
      t.text      :intervl
      t.text      :is_key
      t.text      :is_weight
      t.text      :label
      t.text      :max_value
      t.text      :mean_value
      t.text      :median_value
      t.text      :min_value
      t.text      :missing_values
      t.text      :mode_value
      t.text      :name
      t.text      :nature
      t.text      :no_invalid_responses
      t.text      :no_responses
      t.text      :no_valid_responses
      t.text      :notes
      t.text      :origin
      t.text      :position
      t.text      :post_question_text
      t.text      :pre_question_text
      t.text      :question_text
      t.text      :scale
      t.text      :source
      t.text      :start_pos
      t.text      :std_value
      t.text      :study_id
      t.text      :syntax
      t.text      :universe
      t.text      :val_range_max
      t.text      :val_range_min
      t.text      :var_id
      t.text      :weighted_mean_value
      t.text      :weighted_median_value
      t.text      :weighted_mode_value
      t.text      :weighted_no_invalid_responses
      t.text      :weighted_std_value
      t.text      :width
      t.timestamps
    end
    
    create_table :variable_fields do |t|
      t.integer :id
      t.integer :variable_id
      t.string :key
      t.text :value 
      t.timestamps
    end
  end

  def self.down
    drop_table :variables
    drop_table :variable_entries    
  end
end
