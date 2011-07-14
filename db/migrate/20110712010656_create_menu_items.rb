class CreateMenuItems < ActiveRecord::Migration
    extend Inkling::Util::MigrationHelpers
      
  def self.up
    create_table :menu_items do |t|
      t.string :title
      t.string :link
      t.integer :archive_id
      t.references :content, :polymorphic => true
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string  :state      
      t.timestamps
    end
  end

  def self.down
    drop_table :menu_items
  end
end
