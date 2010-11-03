class CreateArchives < ActiveRecord::Migration
  def self.up
    create_table :archives do |t|
      t.string :name, :null => false
      t.string :slug, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :archives
  end
end
