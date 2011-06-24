class CreateRelatedMaterials < ActiveRecord::Migration
      extend Inkling::Util::MigrationHelpers
      
  def self.up
    create_table :related_materials do |t|
      t.integer :id
      t.integer :study_id
      t.string :uri
      t.string :label      
      
      # add_column :study_related_materials, :comment, :text
      # add_column :study_related_materials, :creation_date, :text
      # add_column :study_related_materials, :complete, :boolean
      # add_column :study_related_materials, :resource, :text
      # remove_column :study_related_materials, :label
      
      t.timestamps
    end
    
    add_foreign_key(:related_materials, :study_id, :studies)
    
  end

  def self.down
      drop_table :related_materials
  end
end
