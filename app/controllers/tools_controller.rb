class ToolsController < ApplicationController
  layout 'pages'

  def index

  end

  def get_candidates(fname)
    result = []
    File.open(fname, 'r').each_line do |line|
      arr = line.split(/,\s+/)
      contig1 = arr[0]
      pos1 = arr[1].to_i
      contig2 = arr[2]
      primer_len = arr[3].to_i
      primer_seq = arr[4]
      result << [contig1, pos1, contig2, primer_len, primer_seq]
    end
    return result
  end

  def load_fasta
    home_dir = ENV['HOME']
    data_dir = File.join(home_dir, 'data/sex_primers')
    neisseria = 'Neisseria_FA1090.fa'
    neisseria_fname = File.join(data_dir, neisseria)
    chlamidia = 'Chlamydia_DUW-3CX.fa'
    chlamidia_fname = File.join(data_dir, chlamidia)

    candidate_fname =  File.join(data_dir, 'nei_ch_candidates.txt')
    fasta1_dict = {}
    Bio::FlatFile.foreach( neisseria_fname) do |f|
      fasta1_dict[f.definition.sub(/ .*$/, '')] = f.seq.to_s
    end

    fasta2_dict = {}
    Bio::FlatFile.foreach( chlamidia_fname) do |f|
      fasta2_dict[f.definition.sub(/ .*$/, '')] = f.seq.to_s
    end

    respond_to do |format|
      format.json {
        render :json =>
          {:status => "OK",
          :fasta1_name => neisseria,
          :fasta1 => fasta1_dict,
          :contig1 => 'lcl|AE004969.1_gene_2002',
          :fasta2_name => chlamidia,
          :fasta2 => fasta2_dict,
          :contig2 => 'lcl|NC_000117.1_gene_1',
          :candidates => get_candidates(candidate_fname)
          }.to_json()
      }
    end
  end

end
