
process SnpSiftDbnsfp {
    tag {"SNPEFF_Snpsiftsbnsfp ${run_id}"}
    label 'SNPEFF_4_3t'
    label 'SNPEFF_4_3t_Snpsiftsbnsfp'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:snpeff-4.3t'

    input:
      tuple run_id, file(vcf), file(vcfidx)

    output:
      tuple run_id, file("${vcf.baseName}_dbnsfp.vcf"), file("${vcf.baseName}_dbnsfp.vcf.idx")

    script:

    """
    set -o pipefail

    java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/SnpSift.jar dbnsfp -v \
    ${params.optional} \
    -db ${params.genome_dbnsfp} $vcf > ${vcf.baseName}_dbnsfp.vcf

    java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/igvtools.jar index ${vcf.baseName}_dbnsfp.vcf

    """
}
