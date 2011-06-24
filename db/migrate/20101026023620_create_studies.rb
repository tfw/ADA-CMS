class CreateStudies < ActiveRecord::Migration
      extend Inkling::Util::MigrationHelpers
      
  def self.up
    create_table :studies do |t|
      t.text    :abstract_text
      t.text    :access_conditions
      t.text    :access_place
      t.text    :analytic_unit
      t.text    :availability
      t.text    :coll_mode
      t.date    :collection_end
      t.date    :collection_start
      t.text    :comment
      t.datetime    :creation_date
      t.text    :data_collector
      t.text    :data_kind
      t.date    :distribution_date
      t.text    :distributor
      t.text    :doc_alt_titl
      t.text    :doc_auth_entity
      t.text    :doc_bibl_cit
      t.text    :doc_bibl_cit_format
      t.text    :doc_copyright
      t.date    :doc_dist_date
      t.text    :doc_distributor
      t.text    :doc_eng_title
      t.string    :doc_lang
      t.date    :doc_prod_date
      t.text    :doc_producer
      t.text    :doc_sub_titl
      t.text    :doc_title
      t.text    :eng_abstract
      t.text    :eng_weight
      t.text    :external_id
      t.text    :geographical_cover
      t.text    :geographical_unit
      t.text    :keywords
      t.text    :label
      t.text    :language
      t.text    :limitations
      t.text    :method_notes
      t.text    :nation
      t.text    :pdf_file
      t.date    :period_end
      t.date    :period_start
      t.text    :research_instr
      t.text    :response
      t.text    :sampling
      t.text    :schedule_catalog_id
      t.datetime    :schedule_date
      t.text    :schedule_email_text
      t.string  :series_id
      t.text    :series_name
      t.text    :site
      t.text    :source
      t.text    :stdy_alt_titl
      t.text    :stdy_auth_entity
      t.text    :stdy_bibl_cit
      t.text    :stdy_class
      t.text    :stdy_contact
      t.text    :stdy_contact_affiliation
      t.text    :stdy_contact_email
      t.text    :stdy_contributor
      t.text    :stdy_copyright
      t.text    :stdy_data_appraisal
      t.text    :stdy_data_coll_freq    
      t.text    :stdy_dep_date
      t.text    :stdy_depositor
      t.text    :stdy_eng_title
      t.string    :stdy_id
      t.string    :stdy_lang
      t.text    :stdy_par_til
      t.text    :stdy_prod_agency
      t.text    :stdy_prod_date
      t.text    :stdy_producer
      t.text    :stdy_producer_abbr
      t.text    :stdy_status
      t.text    :stdy_sub_til
      t.text    :stdy_version
      t.date    :stdy_version_date
      t.text    :stdy_version_notes
      t.text    :stdy_version_responsibility
      t.text    :stdy_version_type
      t.boolean    :sub_study
      t.text    :sub_cat
      t.text    :time_meth
      t.date    :time_period
      t.text    :title
      t.text    :universe
      t.text    :weight

      t.timestamps
    end
    
  end

  def self.down
    drop_table :studies
  end
end
