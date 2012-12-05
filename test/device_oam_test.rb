require 'test_helper'
include TestHelpers

class DeviseOamTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, DeviseOam
  end

  test "setup block yields self" do
    DeviseOam.setup do |config|
      assert_equal DeviseOam, config
    end
  end

  test "update_user_method is set to roles_setter by default" do
    DeviseOam.update_user_method = nil
    DeviseOam.roles_setter = :roles_setter
    assert_equal DeviseOam.update_user_method, :roles_setter
  end
end
