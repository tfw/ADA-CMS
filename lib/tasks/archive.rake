task :archive do
  include FileUtils::Verbose

  rm_rf('data') if File.exists?('data')

  mkdir "/home/deploy/backups/#{now}"
  now = Time.now.strftime("%m/%d/%Y-%I:%M%p")

  #1 dump the db
  `pg_dump -U postgres -Ft -b ada_production > /home/deploy/backups/#{now}/db/ada.tar`
end
