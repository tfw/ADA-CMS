class CreateVariables < ActiveRecord::Migration
  def self.up
    create_table :variables do |t|
      t.integer :id
      t.string  :label
      t.integer :study_id
      t.string  :name
      t.text    :question_text
      t.integer :num_cats
      t.decimal :val_range_max
      t.decimal :val_range_min
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
