# Our three deployment environments are devs, staff and public
deploy: &deploy
  adapter: postgresql
  port: 5432
  host:     <%= Secrets::DATABASE_HOST %>
  username: <%= Secrets::DATABASE_USERNAME %>
  password: <%= Secrets::DATABASE_PASSWORD %>
  pool: 20

devs:
  <<: *deploy
  database: adacms_devs

staff:
  <<: *deploy
  database: adacms_staff

public:
  <<: *deploy
  database: adacms_public
