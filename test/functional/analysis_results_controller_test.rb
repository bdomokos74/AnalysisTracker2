require 'test_helper'

class AnalysisResultsControllerTest < ActionController::TestCase
  setup do
    @analysis_result = analysis_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:analysis_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create analysis_result" do
    assert_difference('AnalysisResult.count') do
      post :create, analysis_result: { duration: @analysis_result.duration, status: @analysis_result.status, task_id: @analysis_result.task_id }
    end

    assert_redirected_to analysis_result_path(assigns(:analysis_result))
  end

  test "should show analysis_result" do
    get :show, id: @analysis_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @analysis_result
    assert_response :success
  end

  test "should update analysis_result" do
    put :update, id: @analysis_result, analysis_result: { duration: @analysis_result.duration, status: @analysis_result.status, task_id: @analysis_result.task_id }
    assert_redirected_to analysis_result_path(assigns(:analysis_result))
  end

  test "should destroy analysis_result" do
    assert_difference('AnalysisResult.count', -1) do
      delete :destroy, id: @analysis_result
    end

    assert_redirected_to analysis_results_path
  end
end
