require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get New" do
    get signip_path
    assert_response :success
  end

end
