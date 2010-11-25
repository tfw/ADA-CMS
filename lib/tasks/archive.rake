task :archive do
  include FileUtils::Verbose

  rm_rf('data') if File.exists?('data')

  mkdir 'data'
  mkdir 'data/db'
  mkdir 'data/files'

  `touch data/log`
  `echo #{Time.now.strftime("%m-%d-%y at %I %M")} >> data/log`
  #1 dump the db
  `pg_dump -U postgres -Ft -b ada_production > data/db/ada.tar`
end
