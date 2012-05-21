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
  
  def self.setup
    yield self
  end
  
  def self.user_class
    @@user_class.constantize
  end
end
