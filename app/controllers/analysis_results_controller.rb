class AnalysisResultsController < ApplicationController
  # GET /analysis_results
  # GET /analysis_results.json
  def index
    @analysis_results = AnalysisResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @analysis_results }
    end
  end

  # GET /analysis_results/1
  # GET /analysis_results/1.json
  def show
    @analysis_result = AnalysisResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @analysis_result }
    end
  end

  # GET /analysis_results/new
  # GET /analysis_results/new.json
  def new
    @analysis_result = AnalysisResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @analysis_result }
    end
  end

  # GET /analysis_results/1/edit
  def edit
    @analysis_result = AnalysisResult.find(params[:id])
  end

  # POST /analysis_results
  # POST /analysis_results.json
  def create
    print "create called"
    print params[:analysis_result]
    @analysis_result = AnalysisResult.new
    @analysis_result.task_id = params[:analysis_result]["task_id"]
    @analysis_result.duration = params[:analysis_result]["duration"]
    @analysis_result.status = params[:analysis_result]["status"]

    respond_to do |format|
      if @analysis_result.save
        format.html { redirect_to @analysis_result, notice: 'Analysis result was successfully created.' }
        format.json { render json: @analysis_result, status: :created, location: @analysis_result }
      else
        format.html { render action: "new" }
        format.json { render json: @analysis_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /analysis_results/1
  # PUT /analysis_results/1.json
  def update
    @analysis_result = AnalysisResult.find(params[:id])

    respond_to do |format|
      if @analysis_result.update_attributes(params[:analysis_result])
        format.html { redirect_to @analysis_result, notice: 'Analysis result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @analysis_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /analysis_results/1
  # DELETE /analysis_results/1.json
  def destroy
    @analysis_result = AnalysisResult.find(params[:id])
    @analysis_result.destroy

    respond_to do |format|
      format.html { redirect_to analysis_results_url }
      format.json { head :no_content }
    end
  end
end
