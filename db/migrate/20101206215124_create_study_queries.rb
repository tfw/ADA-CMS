class CreateStudyQueries < ActiveRecord::Migration
  def self.up
    create_table :study_queries do |t|
      t.integer :id
      t.integer :archive_id
      t.string :name
      t.text :query
      t.timestamps
    end
  end

  def self.down
    drop_table :study_queries
  end
end
