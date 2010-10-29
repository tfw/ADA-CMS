class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name, :null => false
      t.integer :author_id, :null => false
      t.text :body
      t.text :breakout_box
      t.integer :parent_id
      t.boolean :home_page
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
