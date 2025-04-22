#!/bin/bash

SAMPLE="$1"

fastp -i ${SAMPLE}_R1_001.fastq.gz \
	 -I ${SAMPLE}_R2_001.fastq.gz \
 -o ${SAMPLE}_out.R1.fastq.gz -O ${SAMPLE}_out.R2.fastq.gz
