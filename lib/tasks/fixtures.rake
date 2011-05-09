namespace :db do
  desc 'Create YAML test fixtures from data in an existing database.  
  Defaults to development database. Set RAILS_ENV to override.'

  task :fixtures => :environment do
    include FileUtils
    
    sql = "SELECT * FROM %s"
    skip_tables = ["schema_migrations", "sessions"]
    ActiveRecord::Base.establish_connection
    tables = ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : ActiveRecord::Base.connection.tables - skip_tables
    puts "\n\n #{tables} \n\n"
    
    tables.each do |table_name|
      i = "000"
      system("mkdir tmp/fixtures")
      File.open("#{RAILS_ROOT}/tmp/fixtures/#{table_name}.yml", 'w') do |file|
        data = ActiveRecord::Base.connection.select_all(sql % table_name)
        file.write data.inject({}) { |hash, record|
          hash["#{table_name}_#{i.succ!}"] = record
          hash
        }.to_yaml
      end
    end
  end
end
