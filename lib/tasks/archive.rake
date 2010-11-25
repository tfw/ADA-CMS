task :archive do
  include FileUtils::Verbose

  now = Time.now.strftime("%m/%d/%Y-%I:%M%p")
  mkdir "/home/deploy/backups/#{now}"

  #1 dump the db
  `pg_dump -U postgres -Ft -b ada_production > /home/deploy/backups/#{now}/db/ada.tar`
end
