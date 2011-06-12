#to rebuild the bootstrap files run "rake db:extract_fixtures" and look in tmp/fixtures
namespace :db do
  
  task :bootstrap => :environment do
    desc "Load initial database fixtures (in db/bootstrap/development*.yml) into the current environment's database.  
    Load specific fixtures using FIXTURES=x,y"

    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    
    fixture_dir = File.join "db", "bootstrap", Rails.env

    if ENV['FIXTURES']
      fixtures = ENV['FIXTURES'].split(/,/)
    else
      order_file = File.join Rails.root, fixture_dir, 'order.txt'
      if File.exist? order_file
        fixtures = File.read(order_file).split(/\n/).map(&:strip).
          select { |s| not s.starts_with? '#' }
      else
        fixtures = Dir.glob(File.join(Rails.root, fixture_dir, '*.{yml,csv}'))
      end
    end

    fixtures.each do |fixture_file|
      puts "loading #{fixture_file} ... "
      Fixtures.create_fixtures(fixture_dir, File.basename(fixture_file, '.*'))
    end
        
    puts "Finished bootstrapping #{RAILS_ENV}"  
  end

end
