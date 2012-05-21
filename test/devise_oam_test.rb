require 'test_helper'
include TestHelpers

class DeviseOamTest < ActiveSupport::TestCase
  def setup
    set_default_settings
    
    @strategy = DeviseOam::Devise::Strategies::HeaderAuthenticatable.new(env_with_params("/", {}, { "HTTP_#{DeviseOam.oam_header}" => "foo" }))
  end
  
  test "truth" do
    assert_kind_of Module, DeviseOam
  end
  
  test "setup block yields self" do
    DeviseOam.setup do |config|
      assert_equal DeviseOam, config
    end
  end
  
  test "strategy is valid when specified header is in the request" do
    assert @strategy.valid?, "Expected strategy to be valid since oam_header is in the request"
  end
  
  test "strategy is not valid when specified header is not in the request" do
    DeviseOam.oam_header = "some_header_that_is_not_in_the_request"
    invalid_strategy = DeviseOam::Devise::Strategies::HeaderAuthenticatable.new(env_with_params)
    
    assert !invalid_strategy.valid?, "Expected strategy not to be valid since oam_header is not in the request"
  end
  
  test "authentication fails when oam_header is blank" do
    strategy = DeviseOam::Devise::Strategies::HeaderAuthenticatable.new(env_with_params("/", {}, { "HTTP_#{DeviseOam.oam_header}" => "" }))
    strategy._run!
    
    assert_equal strategy.result, :failure
    assert_equal strategy.user, nil
  end
  
  test "authentication succeeds when oam_header is present and not blank" do
    user = DeviseOam.user_class.new(DeviseOam.user_login_field => "foo")
    user.save(validate: false)
    @strategy._run!
    
    assert_equal @strategy.result, :success
    assert_not_nil @strategy.user
  end
  
  test "creates new user when create_user_if_not_found is true" do
    DeviseOam.create_user_if_not_found = true
    @strategy._run!
    
    assert_equal @strategy.result, :success
    assert_not_nil @strategy.user
  end
  
  test "correctly parses ldap roles" do
    ldap_roles = 'role-1,Role-2'
    roles = ["role-1", "role-2"]
    
    authenticatable = DeviseOam::AuthenticatableEntity.new("login", ldap_roles)
    
    assert_equal authenticatable.ldap_roles, roles
  end
  
  test "sets user roles on creation" do
    roles = ["role-1", "role-2"]
    DeviseOam.create_user_if_not_found = true
    
    strategy = DeviseOam::Devise::Strategies::HeaderAuthenticatable.new(
      env_with_params("/", {}, { "HTTP_#{DeviseOam.oam_header}" => "foo", "HTTP_#{DeviseOam.ldap_header}" => roles.join(",") })
    )
    strategy._run!
    
    user = DeviseOam.user_class.where(DeviseOam.user_login_field => "foo").first
    
    assert_equal strategy.result, :success
    assert_equal strategy.authenticatable.ldap_roles, roles
    assert_equal user.roles, roles
  end
  
  test "updates excisting user roles" do
    roles = ["role-2", "role-3"]
    user = DeviseOam.user_class.new(DeviseOam.user_login_field => "foo", :roles => ["role-1", "role-2"])
    user.save(validate: false)
    
    strategy = DeviseOam::Devise::Strategies::HeaderAuthenticatable.new(
      env_with_params("/", {}, { "HTTP_#{DeviseOam.oam_header}" => "foo", "HTTP_#{DeviseOam.ldap_header}" => roles.join(",") })
    )
    strategy._run!
    
    assert_equal strategy.result, :success
    assert_equal strategy.authenticatable.ldap_roles, roles
    assert_equal user.reload.roles, roles
  end
end
