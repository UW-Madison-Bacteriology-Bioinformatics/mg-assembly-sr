#!/bin/bash

SAMPLE="$1"
CPU="$2"
MEMORY="$3"
echo $MEMORY
MEMORY="${MEMORY%GB*}"
echo $MEMORY

ls -lh

spades.py -1 ${SAMPLE}_out.R1.fastq.gz \
	-2 ${SAMPLE}_out.R2.fastq.gz \
	-o ${SAMPLE}_spades_output \
	--meta \
	--only-assembler \
	-t ${CPU} \
	-m ${MEMORY}

ls -lh

tar czvf ${SAMPLE}_spades_output.tar.gz ${SAMPLE}_spades_output
