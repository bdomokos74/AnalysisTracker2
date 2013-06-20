class AnalysisTasksController < ApplicationController
  # GET /analysis_tasks
  # GET /analysis_tasks.json
  def index
    @analysis_tasks = AnalysisTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @analysis_tasks }
    end
  end

  # GET /analysis_tasks/1
  # GET /analysis_tasks/1.json
  def show
    @analysis_task = AnalysisTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @analysis_task }
    end
  end

  # GET /analysis_tasks/new
  # GET /analysis_tasks/new.json
  def new
    @analysis_task = AnalysisTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @analysis_task }
    end
  end

  # GET /analysis_tasks/1/edit
  def edit
    @analysis_task = AnalysisTask.find(params[:id])
  end

  # POST /analysis_tasks
  # POST /analysis_tasks.json
  def create
    @analysis_task = AnalysisTask.new(params[:analysis_task])

    respond_to do |format|
      if @analysis_task.save
        format.html { redirect_to @analysis_task, notice: 'Analysis task was successfully created.' }
        format.json { render json: @analysis_task, status: :created, location: @analysis_task }
      else
        format.html { render action: "new" }
        format.json { render json: @analysis_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /analysis_tasks/1
  # PUT /analysis_tasks/1.json
  def update
    @analysis_task = AnalysisTask.find(params[:id])

    respond_to do |format|
      if @analysis_task.update_attributes(params[:analysis_task])
        format.html { redirect_to @analysis_task, notice: 'Analysis task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @analysis_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /analysis_tasks/1
  # DELETE /analysis_tasks/1.json
  def destroy
    @analysis_task = AnalysisTask.find(params[:id])
    @analysis_task.destroy

    respond_to do |format|
      format.html { redirect_to analysis_tasks_url }
      format.json { head :no_content }
    end
  end
end
