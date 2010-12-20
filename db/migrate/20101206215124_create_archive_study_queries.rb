class CreateArchiveStudyQueries < ActiveRecord::Migration
  def self.up
    create_table :archive_study_queries do |t|
      t.integer :id, :null => false
      t.integer :archive_id, :null => false
      t.string :name, :null => false
      t.text :query, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_study_queries
  end
end
