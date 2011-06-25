# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110623073254) do

  create_table "archive_catalog_integrations", :force => true do |t|
    t.integer  "archive_catalog_id"
    t.integer  "archive_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_catalog_studies", :force => true do |t|
    t.integer  "archive_catalog_id"
    t.integer  "archive_study_id"
    t.integer  "catalog_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_catalogs", :force => true do |t|
    t.string   "title",            :null => false
    t.integer  "archive_id",       :null => false
    t.integer  "catalog_position"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_news", :force => true do |t|
    t.integer  "news_id"
    t.integer  "archive_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archive_news", ["archive_id", "news_id"], :name => "index_archive_news_on_archive_id_and_news_id"
  add_index "archive_news", ["news_id", "archive_id"], :name => "index_archive_news_on_news_id_and_archive_id"

  create_table "archive_studies", :force => true do |t|
    t.integer  "study_id"
    t.integer  "archive_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_study_blocks", :force => true do |t|
    t.integer  "study_query_id"
    t.string   "ddi_id",         :null => false
    t.integer  "archive_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_study_integrations", :force => true do |t|
    t.integer  "study_id"
    t.integer  "archive_study_id"
    t.integer  "archive_study_query_id"
    t.integer  "archive_catalog_integration_id"
    t.string   "ddi_id",                         :null => false
    t.integer  "archive_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_study_queries", :force => true do |t|
    t.integer  "archive_id", :null => false
    t.string   "name",       :null => false
    t.text     "query",      :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archives", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "slug",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ddi_mappings", :force => true do |t|
    t.string   "ddi"
    t.string   "human_readable"
    t.text     "description"
    t.boolean  "xml_element"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "documents", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                 :null => false
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.integer  "archive_id"
    t.integer  "integer"
    t.datetime "resource_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["title"], :name => "index_documents_on_title", :unique => true
  add_index "documents", ["user_id"], :name => "index_documents_on_user_id"

  create_table "images", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                 :null => false
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.integer  "archive_id"
    t.integer  "integer"
    t.datetime "resource_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["title"], :name => "index_images_on_title", :unique => true
  add_index "images", ["user_id"], :name => "index_images_on_user_id"

  create_table "inkling_can_can_actions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_feed_roles", :force => true do |t|
    t.datetime "created_at", :null => false
    t.string   "title",      :null => false
    t.integer  "feed_id",    :null => false
    t.integer  "role_id",    :null => false
  end

  create_table "inkling_feeds", :force => true do |t|
    t.datetime "created_at", :null => false
    t.string   "authors"
    t.string   "title",      :null => false
    t.string   "format",     :null => false
    t.string   "source",     :null => false
    t.string   "criteria"
  end

  create_table "inkling_logs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.text     "text",       :null => false
    t.string   "category",   :null => false
    t.integer  "user_id"
  end

  create_table "inkling_paths", :force => true do |t|
    t.string   "slug",         :null => false
    t.integer  "content_id"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_permissions", :force => true do |t|
    t.integer  "type_id"
    t.integer  "role_id",           :null => false
    t.integer  "can_can_action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_role_memberships", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  create_table "inkling_roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_themes", :force => true do |t|
    t.string   "name",                                :null => false
    t.text     "body"
    t.string   "extension",  :default => ".html.erb", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_types", :force => true do |t|
    t.string   "klass_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integrations", :force => true do |t|
    t.integer  "ada_object_id"
    t.string   "ada_object_type"
    t.integer  "nesstar_object_id"
    t.string   "nesstar_object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                                           :null => false
    t.text     "body",                                            :null => false
    t.string   "state",                      :default => "draft", :null => false
    t.string   "keywords",   :limit => 1024
    t.datetime "publish_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["user_id"], :name => "index_news_on_user_id"

  create_table "pages", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "link_title",   :null => false
    t.text     "description"
    t.integer  "author_id",    :null => false
    t.text     "body"
    t.text     "breakout_box"
    t.integer  "parent_id"
    t.integer  "archive_id"
    t.string   "partial"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "related_materials", :force => true do |t|
    t.integer  "study_id"
    t.string   "uri"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "archive_id"
    t.string   "filters"
    t.string   "terms"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studies", :force => true do |t|
    t.text     "abstract_text"
    t.text     "access_conditions"
    t.text     "access_place"
    t.text     "analytic_unit"
    t.text     "availability"
    t.text     "coll_mode"
    t.date     "collection_end"
    t.date     "collection_start"
    t.text     "comment"
    t.datetime "creation_date"
    t.text     "data_collector"
    t.text     "data_kind"
    t.date     "distribution_date"
    t.text     "distributor"
    t.text     "doc_alt_titl"
    t.text     "doc_auth_entity"
    t.text     "doc_bibl_cit"
    t.text     "doc_bibl_cit_format"
    t.text     "doc_copyright"
    t.date     "doc_dist_date"
    t.text     "doc_distributor"
    t.text     "doc_eng_title"
    t.string   "doc_lang"
    t.date     "doc_prod_date"
    t.text     "doc_producer"
    t.text     "doc_sub_titl"
    t.text     "doc_title"
    t.text     "eng_abstract"
    t.text     "eng_weight"
    t.text     "external_id"
    t.text     "geographical_cover"
    t.text     "geographical_unit"
    t.text     "keywords"
    t.text     "label"
    t.text     "language"
    t.text     "limitations"
    t.text     "method_notes"
    t.text     "nation"
    t.text     "pdf_file"
    t.date     "period_end"
    t.date     "period_start"
    t.text     "research_instr"
    t.text     "response"
    t.text     "sampling"
    t.text     "schedule_catalog_id"
    t.datetime "schedule_date"
    t.text     "schedule_email_text"
    t.string   "series_id"
    t.text     "series_name"
    t.text     "site"
    t.text     "source"
    t.text     "stdy_alt_titl"
    t.text     "stdy_auth_entity"
    t.text     "stdy_bibl_cit"
    t.text     "stdy_class"
    t.text     "stdy_contact"
    t.text     "stdy_contact_affiliation"
    t.text     "stdy_contact_email"
    t.text     "stdy_contributor"
    t.text     "stdy_copyright"
    t.text     "stdy_data_appraisal"
    t.text     "stdy_data_coll_freq"
    t.text     "stdy_dep_date"
    t.text     "stdy_depositor"
    t.text     "stdy_eng_title"
    t.string   "stdy_id"
    t.string   "stdy_lang"
    t.text     "stdy_par_titl"
    t.text     "stdy_prod_agency"
    t.text     "stdy_prod_date"
    t.text     "stdy_producer"
    t.text     "stdy_producer_abbr"
    t.text     "stdy_status"
    t.text     "stdy_sub_titl"
    t.text     "stdy_version"
    t.date     "stdy_version_date"
    t.text     "stdy_version_notes"
    t.text     "stdy_version_responsibility"
    t.text     "stdy_version_type"
    t.boolean  "sub_study"
    t.text     "subcat"
    t.text     "time_meth"
    t.date     "time_period"
    t.text     "title"
    t.text     "universe"
    t.text     "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "identity_url"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname"
    t.string   "surname"
  end

  create_table "variable_fields", :force => true do |t|
    t.integer  "variable_id"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variables", :force => true do |t|
    t.string   "label"
    t.integer  "study_id"
    t.string   "name"
    t.text     "question_text"
    t.integer  "num_cats"
    t.decimal  "val_range_max"
    t.decimal  "val_range_min"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
