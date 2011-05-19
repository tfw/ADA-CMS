class CreateArchiveCategories < ActiveRecord::Migration
  def self.up
    create_table :archive_catalogues do |t|
      t.string  :title, :null => false
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalogues
  end
end
