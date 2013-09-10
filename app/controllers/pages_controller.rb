class PagesController < ApplicationController

  def tasks
    @analysis_tasks = AnalysisTask.all
    @icon = "genetics.png"
    respond_to do |format|
      format.html
    end
  end

  def servers
    @servers = Server.all
    @icon = "servers.png"
    respond_to do |format|
      format.html
    end
  end

  def fasta
    @icon = "genetics.png"
    redirect_to('tools/index')
  end
end

