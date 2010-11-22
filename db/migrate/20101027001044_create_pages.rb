class CreatePages < ActiveRecord::Migration
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
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
