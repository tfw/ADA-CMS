class ArchiveResources < ActiveRecord::Migration
  extend Inkling::Util::MigrationHelpers

  def self.up
    add_column :documents, :archive_id, :integer
    add_foreign_key :documents, :archive_id, :archives
    add_column :images, :archive_id, :integer
    add_foreign_key :images, :archive_id, :archives
  end

  def self.down
    remove_column :images, :archive_id
    remove_column :documents, :archive_id
  end
end
