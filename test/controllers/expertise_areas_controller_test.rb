require 'test_helper'

class ExpertiseAreasControllerTest < ActionController::TestCase
  setup do
    @expertise_area = expertise_areas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expertise_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expertise_area" do
    assert_difference('ExpertiseArea.count') do
      post :create, expertise_area: { name: @expertise_area.name }
    end

    assert_redirected_to expertise_area_path(assigns(:expertise_area))
  end

  test "should show expertise_area" do
    get :show, id: @expertise_area
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expertise_area
    assert_response :success
  end

  test "should update expertise_area" do
    patch :update, id: @expertise_area, expertise_area: { name: @expertise_area.name }
    assert_redirected_to expertise_area_path(assigns(:expertise_area))
  end

  test "should destroy expertise_area" do
    assert_difference('ExpertiseArea.count', -1) do
      delete :destroy, id: @expertise_area
    end

    assert_redirected_to expertise_areas_path
  end
end
