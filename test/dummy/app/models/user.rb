class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles
  # attr_accessible :title, :body
  
  ROLES = %w(admin role-1 role-2 role-3)
  
  def self.create_oam_user(attributes)
    user = User.new
    user.email = attributes[:email]
    user.roles = attributes[:roles] if attributes[:roles]
    
    user.save validate:false
  end
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
  
  def update_roles(roles)
    self.roles = roles
    self.save validate:false
  end
end
