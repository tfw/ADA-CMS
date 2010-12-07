# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Ada::Application.load_tasks

namespace :ada do
  task :rebuild => ["db:migrate:reset", "inkling:init", "db:seed"]
end

task :nesstar => :environment do
  Nesstar::AtsidaIntegration.run
end

task :fetch_rdf do
  include FileUtils::Verbose
  nesstar_url = "http://bonus.anu.edu.au/obj/fStudyHome/StudyHome?http%3A%2F%2Fwww.nesstar.org%2Frdf%2Fmethod=http%3A%2F%2Fwww.nesstar.org%2Frdf%2FDatasetHome%2FEJBQuery&http%3A%2F%2Fwww.nesstar.org%2Frdf%2FDatasetHome%2FEJBQuery%23query=SELECT+OBJECT(o)+FROM+Study+o+WHERE+o.abstractText+like+%27%25aborigin%25%27"

  rm_rf("tmp/nesstar")
  mkdir("tmp/nesstar")
  begin
    `curl -o tmp/nesstar/payload.xml --compressed "#{nesstar_url}"`
    `echo #{Time.now.strftime("%Y-%m-%d %I:%M")} > tmp/nesstar/payload_success.txt`
  rescue StandardError => boom
    `echo #{Time.now.strftime("%Y-%m-%d %I:%M")} > tmp/nesstar/payload_failure.txt`
    `echo "\n\n Exception: #{boom.to_s}" >> tmp/nesstar/payload_failure.txt`
  end
end