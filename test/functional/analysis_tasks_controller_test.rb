require 'test_helper'

class AnalysisTasksControllerTest < ActionController::TestCase
  setup do
    @analysis_task = analysis_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:analysis_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create analysis_task" do
    assert_difference('AnalysisTask.count') do
      post :create, analysis_task: { description: @analysis_task.description, duration: @analysis_task.duration, project_name: @analysis_task.project_name, run_id: @analysis_task.run_id, script_params: @analysis_task.script_params, script_template: @analysis_task.script_template, server_id: @analysis_task.server_id, status: @analysis_task.status }
    end

    assert_redirected_to analysis_task_path(assigns(:analysis_task))
  end

  test "should show analysis_task" do
    get :show, id: @analysis_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @analysis_task
    assert_response :success
  end

  test "should update analysis_task" do
    put :update, id: @analysis_task, analysis_task: { description: @analysis_task.description, duration: @analysis_task.duration, project_name: @analysis_task.project_name, run_id: @analysis_task.run_id, script_params: @analysis_task.script_params, script_template: @analysis_task.script_template, server_id: @analysis_task.server_id, status: @analysis_task.status }
    assert_redirected_to analysis_task_path(assigns(:analysis_task))
  end

  test "should destroy analysis_task" do
    assert_difference('AnalysisTask.count', -1) do
      delete :destroy, id: @analysis_task
    end

    assert_redirected_to analysis_tasks_path
  end
end
