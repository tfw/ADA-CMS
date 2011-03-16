class RefactorStudiesForFacets < ActiveRecord::Migration
  def self.up
    add_column :studies, :data_kind, :string
    add_column :studies, :sampling_abbr, :string
    add_column :studies, :collection_mode_abbr, :string   
    add_column :studies, :contact_affiliation, :string   
    
    #not a facet - want this on the study tho
    add_column :studies, :comment, :text
  end

  def self.down
    drop_column :studies, :data_kind
    drop_column :studies, :sampling_abbr
    drop_column :studies, :collection_mode_abbr
    drop_column :studies, :contact_affiliation
    drop_column :studies, :comment
  end
end
