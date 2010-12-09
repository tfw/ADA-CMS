class AddExtraStudyFieldsAndPageState < ActiveRecord::Migration
  def self.up
    add_column :studies, :universe, :text
    add_column :studies, :abstract, :text
    add_column :studies, :collection_date, :string
    add_column :studies, :id_number, :string
    add_column :studies, :series_name, :text
    add_column :studies, :topics, :text
    add_column :studies, :keywords, :text
    add_column :studies, :country, :string
    add_column :studies, :geo_coverage, :text
    add_column :studies, :investigator, :text
    add_column :studies, :language, :string

    remove_column :studies, :abstract
    remove_column :studies, :keywords
    add_column :studies, :abstract, :text
    add_column :studies, :keywords, :text
    add_column :studies, :page_id, :integer

    add_column :pages, :state, :string    
  end

  def self.down
    remove_column :studies, :universe
    remove_column :studies, :abstract
    remove_column :studies, :collection_date
    remove_column :studies, :id_number
    remove_column :studies, :series_name
    remove_column :studies, :topics
    remove_column :studies, :keywords
    remove_column :studies, :country
    remove_column :studies, :geo_coverage
    remove_column :studies, :investigator
    remove_column :studies, :language
    remove_column :studies, :page_id

    remove_column :pages, :state
  end
end
