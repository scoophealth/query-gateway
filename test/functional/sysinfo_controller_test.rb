require 'test_helper'

class SysinfoControllerTest < ActionController::TestCase
  test "should get currentload" do
    get :load
    assert_response :success
  end

  test "should get currentusers" do
    get :users
    assert_response :success
  end

  test "should get diskspace" do
    get :diskspace
    assert_response :success
  end

  test "should get mongo" do
    get :mongo
    assert_response :success
  end

  test "should get totalprocesses" do
    get :processes
    assert_response :success
  end

  test "should get swap" do
    get :swap
    assert_response :success
  end

  test "should get import" do
    get :import
    assert_response :success
  end

  test "should get tomcat" do
    get :import
    assert_response :success
  end

  test "should get delayed_job" do
    get :delayed_job
    assert_response :success
  end

end
