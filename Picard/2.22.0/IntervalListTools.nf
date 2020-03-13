process IntervalListTools {
    tag {"PICARD IntervalListTools ${sample_id}"}
    label 'PICARD_2_22_0'
    label 'PICARD_2_22_0_IntervalListTools'
    container = 'quay.io/biocontainers/picard:2.22.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple file(interval_list)

    output:
    file("temp_*/scattered.interval_list")

    script:

    """
    picard -Xmx${task.memory.toGiga()-4}G IntervalListTools \
    TMP_DIR=\$TMPDIR \
    INPUT=${interval_list} \
    SUBDIVISION_MODE=BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW \
    SCATTER_COUNT=$params.scatter_count \
    UNIQUE=true \
    OUTPUT=.
    """
}
