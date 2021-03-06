class User < ActiveRecord::Base
  devise :openid_authenticatable
  acts_as_inkling_user
  
  validates_uniqueness_of :identity_url
  
  has_many :pages, :foreign_key => "author_id"
  has_many :news, :foreign_key => "user_id"
  has_many :archive_study_integrations, :foreign_key => "user_id"
  has_many :searches
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
      # if value.is_a? Array
      #   value = value.first
      # end

      case key.to_s
      when 'email', 'http://users.ada.edu.au/email'
        value = use_first_value(value)
        self.email = value
      when 'http://users.ada.edu.au/role'
        User.register_in_role(self, value.last)
       # self.roles << Inkling::Role.find_or_create_by_name(value) #refactor this! Shouldn't automatically create roles
      when 'http://axschema.org/namePerson/first'
        value = use_first_value(value)
        self.firstname = value
      when 'http://axschema.org/namePerson/last'
        value = use_first_value(value)
        self.surname = value        
      else
        logger.error "Unknown OpenID field: #{key}"
      end
    end

    save! if self.changed? 
    UserObserver.re_enters(self)
  end
  
  def to_s
    str = "#{firstname} #{surname}"
    str ||= email
  end

  def is_staff?
    (roles & [Inkling::Role.find_by_name("administrator"),
      Inkling::Role.find_by_name("manager"),
      Inkling::Role.find_by_name("publisher"),
      Inkling::Role.find_by_name("approver"),
      Inkling::Role.find_by_name("archivist")]).any?
  end

  def can_approve?
    (roles & [Inkling::Role.find_by_name("administrator"),
      Inkling::Role.find_by_name("manager"),
      Inkling::Role.find_by_name("publisher"),
      Inkling::Role.find_by_name("approver")]).any?
  end

  private
  def self.register_in_role(user, name)
    role = Inkling::Role.find_by_name(name)
    role ||= Inkling::Role.create(:name => name)

    user.role_memberships.each{|rm| rm.delete}
    role << user
  end

  def use_first_value(value)
    if value.is_a? Array
      value.first
    else
      value
    end
  end
end
