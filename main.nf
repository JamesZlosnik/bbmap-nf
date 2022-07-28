#!/usr/bin/env nextflow

/*
 *   A nextflow wrapper for running bbmap.sh
 *   -----------------------------------------

 == V1  ==
This pipeline will run bbmap.sh on a set of fastq files in a baseDir and produce a set of normalized fq.gz files for analysis

 */

 import java.time.LocalDateTime

 nextflow.enable.dsl = 2

 include { bbmap } from './modules/bbmap.nf'

// prints to the screen and to the log
        log.info """

                 FluViewer Pipeline
                 ===================================
                 projectDir    : ${projectDir}
                 launchDir     : ${launchDir}
                 fastqInputDir : ${params.fastq_input}
                 outdir        : ${params.outdir}
                 target_depth = ${params.target_depth}
                 min_depth = ${params.min_depth}
                 """
                 .stripIndent()


workflow {
     ch_start_time = Channel.of(LocalDateTime.now())
     ch_pipeline_name = Channel.of(workflow.manifest.name)
     ch_pipeline_version = Channel.of(workflow.manifest.version)

     //ch_pipeline_provenance = pipeline_provenance(ch_pipeline_name.combine(ch_pipeline_version).combine(ch_start_time))

     ch_fastq_input = Channel.fromFilePairs( params.fastq_search_path, flat: true ).map{ it -> [it[0].split('_')[0], it[1], it[2]] }.unique{ it -> it[0] }
     
     main:
       //hash_files_fastq(ch_fastq_input.map{it -> [it[0], [it[1], it[2]]] }.combine(Channel.of("fastq_input")))
       bbmap( ch_fastq_input.combine(ch_adapters))
       

       //ch_provenance = fastp.out.provenance
       //ch_provenance = ch_provenance.join(ch_fastq_input.map{ it -> it[0] }.combine(ch_pipeline_provenance)).map{ it -> [it[0], it[1] << it[2]] }
       //ch_provenance = ch_provenance.join(hash_files_fastq.out.provenance).map{ it -> [it[0], it[1] << it[2]] }
     
       collect_provenance(ch_provenance)



}
