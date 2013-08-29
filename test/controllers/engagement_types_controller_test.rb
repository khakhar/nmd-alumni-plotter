require 'test_helper'

class EngagementTypesControllerTest < ActionController::TestCase
  setup do
    @engagement_type = engagement_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:engagement_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create engagement_type" do
    assert_difference('EngagementType.count') do
      post :create, engagement_type: { name: @engagement_type.name }
    end

    assert_redirected_to engagement_type_path(assigns(:engagement_type))
  end

  test "should show engagement_type" do
    get :show, id: @engagement_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @engagement_type
    assert_response :success
  end

  test "should update engagement_type" do
    patch :update, id: @engagement_type, engagement_type: { name: @engagement_type.name }
    assert_redirected_to engagement_type_path(assigns(:engagement_type))
  end

  test "should destroy engagement_type" do
    assert_difference('EngagementType.count', -1) do
      delete :destroy, id: @engagement_type
    end

    assert_redirected_to engagement_types_path
  end
end
