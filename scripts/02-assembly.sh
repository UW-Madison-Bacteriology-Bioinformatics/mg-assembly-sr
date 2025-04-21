#!/bin/bash
# this scripts run assembly on the trimmed, host-removed reads.
SAMPLE="$1"
CPU="$2"

ls -lh

spades.py -1 ${SAMPLE}_R.non.host.R1.fastq.gz \
	-2 ${SAMPLE}_R.non.host.R2.fastq.gz \
	-o ${SAMPLE}_spades_output \
	--meta \
	--only-assembler \
	-t ${CPU} \
	-m 600

ls -lh

tar czvf ${SAMPLE}_spades_output.tar.gz ${SAMPLE}_spades_output
