class RefactorStudiesForFacets < ActiveRecord::Migration
  def self.up
    add_column :studies, :data_kind, :string
    add_column :studies, :sampling_procedure, :string
    add_column :studies, :collection_method, :string   
  end

  def self.down
    drop_column :studies, :data_kind
    drop_column :studies, :sampling_procedure
    drop_column :studies, :collection_method
  end
end
