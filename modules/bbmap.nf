process bbmap {

    tag { sample_id }

    publishDir "${params.outdir}/", mode:'copy'

    input:
    tuple val(sample_id), path(reads_1), path(reads_2), path(adapters)

    output:
    tuple val(sample_id), path("${sample_id}_R1.trim.fastq.gz"), path("${sample_id}_R2.trim.fastq.gz"), emit: normalized_reads
    //tuple val(sample_id), path("${sample_id}_fastp_provenance.yml"), emit: provenance

    script:
    """
    //printf -- "- process_name: fastp\\n" > ${sample_id}_fastp_provenance.yml
    //printf -- "  tool_name: fastp\\n  tool_version: \$(fastp --version 2>&1 | cut -d ' ' -f 2)\\n" >> ${sample_id}_fastp_provenance.yml
    bbnorm.sh \
      in=${sample_id}_R1.trim.fastq.gz \
      in2=${sample_id}_R2.trim.fastq.gz \
      out=${sample_id}_R1.fullNorm_1.fq.gz \
      out2=${sample_id}_R2.fullNorm_2.fq.gz \
      target=${params.target_depth}
      mindepth=${params.min_depth}
    """
}