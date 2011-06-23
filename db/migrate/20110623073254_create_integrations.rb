class CreateIntegrations < ActiveRecord::Migration
  def self.up
    create_table :integrations do |t|
      t.references :ada_object, :polymorphic => true
      t.references :nesstar_object, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :integrations
  end
end
