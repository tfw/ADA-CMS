class CreatePages < ActiveRecord::Migration
      extend Inkling::Util::MigrationHelpers
      
  def self.up
    create_table :pages do |t|
      t.string  :title, :null => false
      t.string  :link_title, :null => false
      t.text    :description
      t.integer :author_id, :null => false
      t.text    :body
      t.text    :breakout_box
      t.integer :parent_id
      t.integer :archive_id
      t.string  :partial
      t.integer :lft
      t.integer :rgt
      t.string  :state
      t.timestamps
    end
    
    add_foreign_key(:pages, :archive_id, :archives)
    add_foreign_key(:pages, :author_id, :users)
  end

  def self.down
    drop_table :pages
  end
end
