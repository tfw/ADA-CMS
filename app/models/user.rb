class User < Inkling::User
  set_table_name 'inkling_users'
  
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
