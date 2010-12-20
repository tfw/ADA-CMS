class CreateDdiMappings < ActiveRecord::Migration
  def self.up
    create_table :ddi_mappings do |t|
      t.string :ddi
      t.string :human_readable
      t.text  :description
      t.boolean :xml_element
      t.timestamps
    end
  end

  def self.down
    drop_table :mappings
  end
end
