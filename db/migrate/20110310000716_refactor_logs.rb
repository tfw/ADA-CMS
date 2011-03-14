class CreateInklingFeedsAndRefactorLogs < ActiveRecord::Migration
  def self.up
    add_column :inkling_logs, :category, :string, :null => false
  end

  def self.down
    remove_column :inkling_logs, :category
  end
end
