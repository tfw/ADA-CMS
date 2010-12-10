class CreateArchiveToStudyIntegrations < ActiveRecord::Migration
  def self.up
    create_table :archive_to_study_integrations do |t|
      t.integer :id
      # t.string :ddi_id
      t.integer :study_query_id
      t.string :url, :null => false
      t.string :test, :null => false
      t.integer :study_id
      t.integer :archive_id, :null => :false
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_to_study_integrations
  end
end
