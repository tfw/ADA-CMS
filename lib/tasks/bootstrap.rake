
namespace :db do
  
  task :bootstrap => :environment do
    desc "Load initial database fixtures (in db/bootstrap/development*.yml) into the current environment's database.  
    Load specific fixtures using FIXTURES=x,y"

    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    
    (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db/bootstrap',
        "#{RAILS_ENV}", '*.{yml,csv}'))).each do |fixture_file|
      puts "loading #{fixture_file} ... "
      Fixtures.create_fixtures("db/bootstrap/#{RAILS_ENV}", File.basename(fixture_file, '.*'))
    end
        
    puts "Finished bootstrapping #{RAILS_ENV}"  
  end

  
end
