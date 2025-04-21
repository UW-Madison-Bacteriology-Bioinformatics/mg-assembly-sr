#!/bin/bash

SAMPLE="$1"

fastp -i ${SAMPLE}.R1.fastq.gz -I ${SAMPLE}.R2.fastq.gz -o ${SAMPLE}_out.R1.fastq.gz -O ${SAMPLE}_out.R2.fastq.gz
