class RenameDatasetTablesToStudy < ActiveRecord::Migration
  def self.up
    rename_table :datasets, :studies
    rename_table :dataset_entries, :study_fields
    rename_table :dataset_related_materials, :study_related_materials
  end

  def self.down
    rename_table :studies, :datasets
    rename_table :study_fields, :dataset_entries
    rename_table :study_related_materials, :dataset_related_materials
  end
end
