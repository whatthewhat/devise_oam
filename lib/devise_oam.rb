require "devise"
require "devise_oam/strategies/header_authenticatable"
require "devise_oam/authenticatable_entity"

module DeviseOam
  # Settings
  mattr_accessor :oam_header
  mattr_accessor :user_class
  mattr_accessor :user_login_field
  mattr_accessor :create_user_if_not_found
  mattr_accessor :create_user_method
  mattr_accessor :ldap_header
  mattr_accessor :roles_setter
  mattr_accessor :attr_headers
  mattr_writer :update_user_method

  @@update_user_method = nil
  
  def self.setup
    yield self
  end
  
  def self.user_class
    @@user_class.constantize
  end

  def self.update_user_method
    @@update_user_method || @@roles_setter
  end
end
