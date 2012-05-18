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
    DeviseOam.create_user_method = "create_oam_user"
    @strategy._run!
    
    assert_equal @strategy.result, :success
    assert_not_nil @strategy.user
  end
end
