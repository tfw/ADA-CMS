class CreateDatasetRelatedMaterials < ActiveRecord::Migration
  def self.up
    create_table :dataset_related_materials do |t|
      t.integer :id
      t.integer :dataset_id
      t.string :uri
      t.string :label      
      t.timestamps
    end
  end

  def self.down
      drop_table :dataset_related_materials
  end
end
