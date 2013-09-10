fasta1UI = []
fasta2UI = []
loadFasta= () ->
  console.log 'called: loadFasta...'
  $.ajax
    url: '/tools/load_fasta',
    data: '',
    type: 'POST',
    dataType: 'json',
    success: (param) ->
      if(param.status=="OK")
        fasta1UI = new UIPanel('fasta_a_panel', param.fasta1_name, param.contig1, param.fasta1)
        fasta2UI = new UIPanel('fasta_b_panel', param.fasta2_name, param.contig2, param.fasta2)

      else
        console.log "status= "+param.status

class UIPanel
  constructor: (@panelname, @fastaname, @contigname, @dict) ->
    @colsize = 55
    @emptyrow = "<span>&nbsp;</span>"
    console.log "panel "+@panelname+" created: "+@fastaname
    [result, nrow] = @create_markup()
    $("\##{@panelname}").html(result)
    $("\##{@panelname}_contigname").html(@fastaname)

  create_markup: () ->
    @seq = @dict[@contigname]
    console.log @seq
    nrow = 0
    nuc_in_row = 0
    result = "<div id=\"panel_#{@panelname}_row_0\">"

    for ch, index in @seq.split ""
      result = result + "<span id=\"panel_#{@panelname}_nuc_#{index}\">#{ch}</span>"
      nuc_in_row += 1

      if (nuc_in_row % @colsize is 0)
        nrow += 1
        result = result + "</div><div id=\"panel_#{@panelname}_row_#{nrow}\">"
        nuc_in_row = 0
    result += "</div>"
    [result, nrow+1]

$(document).ready ->
  loadFasta()
