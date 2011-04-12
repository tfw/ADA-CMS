class User < Inkling::User
  set_table_name 'inkling_users'
  
  devise :openid_authenticatable

  def self.create_from_identity_url(identity_url)
    User.create(:identity_url => identity_url)
  end

  def self.openid_optional_fields
    ["email", "fullname"]
  end

  def openid_fields=(fields)
    fields.each do |key, value|
      # Some AX providers can return multiple values per key
      if value.is_a? Array
        value = value.first
      end

      case key.to_s
      when "fullname"
        self.name = value
      when "email"
        self.email = value
      else
        logger.error "Unknown OpenID field: #{key}"
      end
    end
  end
end
