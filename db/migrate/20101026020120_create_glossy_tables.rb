class CreateGlossyTables < ActiveRecord::Migration
  def self.up
    create_table :glossy_pages do |t|
      t.string :name, :null => false
      t.integer :author_id, :null => false
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
