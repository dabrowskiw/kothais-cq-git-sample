nextflow.enable.dsl=2

params.out = "$launchDir/output"

process downloadFile {
	publishDir params.out, mode: "copy", overwrite: true
	output:
	path "batch1.fasta"
	"""
	wget http://tinyurl.com/cqbatch1 -O batch1.fasta
	"""

}

process countSequences {
  publishDir params.out, mode: "copy", overwrite: true
  input:
    path infile 
  output:
    path "numseq*"
  """
  grep "^>" $infile | wc -l > numseqs.txt
  """
}

process splitSequences {
    publishDir params.out, mode: "copy", overwrite: true

    input: 
        path infile

    output:
        path "numseq_*"  

    script:
        """
        split -l 2 $infile numseq_  
        """
}


workflow {
	downloadFile | countSequences
}