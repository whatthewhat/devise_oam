require 'test_helper'
include TestHelpers

class DeviseOamTest < ActiveSupport::TestCase
  test "correctly parses ldap roles" do
    ldap_roles = 'role-1,Role-2'
    roles = ["role-1", "role-2"]

    authenticatable = DeviseOam::AuthenticatableEntity.new("login", ldap_roles)

    assert_equal authenticatable.ldap_roles, roles
  end
  
  test "login is case sensitive" do
    auth1 = DeviseOam::AuthenticatableEntity.new("Login")
    auth2 = DeviseOam::AuthenticatableEntity.new("loGin")
    
    assert_equal auth1.login, "Login"
    assert_equal auth2.login, "loGin"
  end

  test "#" do
  end
end
