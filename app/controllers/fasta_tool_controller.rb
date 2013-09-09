class FastaToolController < ApplicationController
  layout 'pages'

  def index

  end

  def load_fasta
    respond_to do |format|
      format.json {
        render :json =>
          [:status => "OK"].to_json()
      }
    end
  end
end
