class CreateDatasets < ActiveRecord::Migration
  def self.up
    create_table :datasets do |t|
      t.integer :id
      t.string :label
      t.string :resource
      t.string :study3
      t.string :about
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :datasets
  end
end
