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
end
