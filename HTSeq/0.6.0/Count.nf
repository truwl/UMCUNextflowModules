process Count {
    tag {"htseq-count ${sample_id}"}
    label 'HTSeq_0_6_0'
    label 'HTSeq_0_6_0_count'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.htseq_mem}" : ""
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/HTSeq/htseq_0.6.0-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai)
    file(genome_gtf)   
  
    output:
    tuple sample_id, file("${sample_id}_*_raw_counts.txt") 

    shell:
    def s_val = params.strandness
    if (!params.singleEnd) {
       if (params.strandness == 'reverse') { s_val = 'yes' }
       if (params.strandness == 'yes') { s_val = 'reverse' }
    }
    def count_val = ''
    if (params.htseq_mode == 'gene') { count_val = 'gene_id' }
    if (params.htseq_mode == 'transcript') { count_val = 'transcript_id' }
    if (params.htseq_mode == 'exon') { count_val = 'exon_id' }
     
    """
    htseq-count -m union -r pos -s $s_val -i $count_val -f bam $bam_file $genome_gtf  > ${sample_id}_${count_val}_raw_counts.txt
    """
}
