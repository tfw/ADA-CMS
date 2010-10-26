class CreateDatasetEntries < ActiveRecord::Migration
  def self.up
    create_table :dataset_entries do |t|
      t.integer :id
      t.integer :dataset_id
      t.string :key
      t.text :value 
      t.timestamps
    end
  end

  def self.down
    drop_table :dataset_entries
  end
end
