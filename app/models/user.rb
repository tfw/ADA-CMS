class User < ActiveRecord::Base
  
  #abstract into inkling helper START
  has_many :role_memberships
  has_many :roles, :through => :role_memberships
  has_many :logs
  
  def has_role?(role)
    role = role.to_s
    self.roles.find_by_name(role)
  end  
  #abstract into inkling helper END

  devise :openid_authenticatable

  attr_accessible :identity_url

  def self.build_from_identity_url(identity_url)
    new({:identity_url => identity_url,
          #TODO these are dummies to satisfy devise
          :password => 'password',
          :password_confirmation => 'password'})
  end

  def self.openid_optional_fields
    ["email"]
  end

  def openid_fields=(fields)
    fields.each do |key, value|
      # Some AX providers can return multiple values per key
      if value.is_a? Array
        value = value.first
      end

      case key.to_s
      when "email"
        self.email = value
      else
        logger.error "Unknown OpenID field: #{key}"
      end
    end
  end
end
