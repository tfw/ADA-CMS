class User < ActiveRecord::Base

  devise :openid_authenticatable
  
  #abstract into inkling helper START
  has_many :role_memberships, :class_name => "Inkling::RoleMembership"#, :foreign_key => "user.id"
  has_many :roles, :class_name => "Inkling::Role", :through => :role_memberships
  has_many :logs
  
  def has_role?(role)
    role = role.to_s
    self.roles.find_by_name(role)
  end  
  #abstract into inkling helper END
  
  validates_uniqueness_of :identity_url
  
  has_many :pages, :foreign_key => "author_id"
  has_many :news, :foreign_key => "user_id"
  has_many :archive_study_integrations, :foreign_key => "user_id"

  attr_accessible :identity_url

  def self.build_from_identity_url(identity_url)
    #first, try to locate existing user
    openid_user = User.find_by_identity_url(identity_url)
    openid_user ||= new({:identity_url => identity_url})
  end

  def self.openid_optional_fields
    ['email', 'http://users.ada.edu.au/email', 'http://users.ada.edu.au/role', 'http://axschema.org/namePerson/first', 'http://axschema.org/namePerson/last']
  end

  def openid_fields=(fields)
    fields.each do |key, value|
      # Some AX providers can return multiple values per key
      if value.is_a? Array
        value = value.first
      end

      case key.to_s
      when 'email', 'http://users.ada.edu.au/email'
        self.email = value
      when 'http://users.ada.edu.au/role'
        self.roles << Inkling::Role.find_or_create_by_name(value) #refactor this! Shouldn't automatically create roles
      when 'http://axschema.org/namePerson/first'
        self.firstname = value
      when 'http://axschema.org/namePerson/last'
        self.surname = value        
      else
        logger.error "Unknown OpenID field: #{key}"
      end
    end

    save! if self.changed? 
    UserObserver.re_enters(self)
  end
  
  def to_s
    "#{firstname} #{surname}"
  end
end
