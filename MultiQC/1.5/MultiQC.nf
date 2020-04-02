
process MultiQC {
    tag {"MULTIQC ${id}"}
    label 'MULTIQC_1_5'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:multiqc-1.5'

    input:

    file(qc_files: "*")
    out_dir

    output:
    file "multiqc_report.html"
    file "multiqc_data"


    script:
    """

    multiqc ${params.optional} $out_dir
    """
}
