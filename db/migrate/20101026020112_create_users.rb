class CreateUsers < ActiveRecord::Migration
  
  create_table :users do |t|
    # t.database_authenticatable #use openid instead
    # t.confirmable
    # t.recoverable
    t.rememberable
    t.trackable
    # t.encryptable      
    t.string :identity_url
    t.string :email
    t.timestamps
    t.string :firstname
    t.string :surname
  end
  
  def self.down
    drop_table :users
  end
end