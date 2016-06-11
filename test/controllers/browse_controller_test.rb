require 'test_helper'

class BrowseControllerTest < ActionController::TestCase
  test "should get category" do
    get :category
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
