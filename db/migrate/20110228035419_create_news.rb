class CreateNews < ActiveRecord::Migration
  extend Inkling::Util::MigrationHelpers

  def self.up
    create_table :news do |t|
      t.integer :user_id, :null => :false
      t.string :title, :null => false
      t.text :body, :null => false
      t.string :state, :null => false, :default => 'draft'
      t.string :keywords, :limit => 1024
      t.datetime :publish_at
      t.timestamps
    end
    add_foreign_key(:news, :user_id, :users)
    add_index(:news, :user_id)

    create_table :archive_news do |t|
      t.integer :news_id, :null => :false
      t.integer :archive_id, :null => :false
      t.timestamps
    end

    add_foreign_key(:archive_news, :archive_id, :archives)
    add_foreign_key(:archive_news, :news_id, :news)
    add_index(:archive_news, [:news_id, :archive_id])
    add_index(:archive_news, [:archive_id, :news_id])
  end

  def self.down
    drop_table :archive_news
    drop_table :news
  end
end
