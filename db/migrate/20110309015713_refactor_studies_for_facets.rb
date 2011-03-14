class RefactorStudiesForFacets < ActiveRecord::Migration
  def self.up
    add_column :studies, :data_kind, :string
    add_column :studies, :sampling, :string
    add_column :studies, :collection_mode, :string   
  end

  def self.down
    drop_column :studies, :data_kind
    drop_column :studies, :sampling
    drop_column :studies, :collection_mode
  end
end
