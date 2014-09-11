require 'test_helper'

class PostAttatchmentsControllerTest < ActionController::TestCase
  setup do
    @post_attatchment = post_attatchments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:post_attatchments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post_attatchment" do
    assert_difference('PostAttatchment.count') do
      post :create, post_attatchment: { attatchment: @post_attatchment.attatchment, post_id: @post_attatchment.post_id }
    end

    assert_redirected_to post_attatchment_path(assigns(:post_attatchment))
  end

  test "should show post_attatchment" do
    get :show, id: @post_attatchment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post_attatchment
    assert_response :success
  end

  test "should update post_attatchment" do
    patch :update, id: @post_attatchment, post_attatchment: { attatchment: @post_attatchment.attatchment, post_id: @post_attatchment.post_id }
    assert_redirected_to post_attatchment_path(assigns(:post_attatchment))
  end

  test "should destroy post_attatchment" do
    assert_difference('PostAttatchment.count', -1) do
      delete :destroy, id: @post_attatchment
    end

    assert_redirected_to post_attatchments_path
  end
end
