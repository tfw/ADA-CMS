class RefactorStudiesForFacets < ActiveRecord::Migration
  def self.up
    add_column :studies, :data_kind_facet, :string
    add_column :studies, :sampling_facet, :string
    add_column :studies, :collection_mode_facet, :string   
    add_column :studies, :comment, :text
  end

  def self.down
    drop_column :studies, :data_kind_facet
    drop_column :studies, :sampling_facet
    drop_column :studies, :collection_mode_facet
    drop_column :studies, :comment
  end
end
