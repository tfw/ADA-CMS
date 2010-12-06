class CreateStudyIntegrationBlocks < ActiveRecord::Migration
  def self.up
    create_table :study_integration_blocks do |t|
      t.integer :id
      t.string :ddi_id
      t.integer :archive_id, :null => :false
      t.timestamps
    end
  end

  def self.down
    drop_table :study_integration_blocks
  end
end
