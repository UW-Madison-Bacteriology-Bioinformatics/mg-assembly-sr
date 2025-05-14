![Status - In progress](https://img.shields.io/badge/Status-InProgress-2ea44f)

# mg-assembly-sr
Short read metagenomic assembly

# ✨ Overview
This DAGman workflow allows the user to trim short-read (illumina) sequences, and assemble them using SPADES. This can be used in preparation for metagenomic binning, for example using [binning_wf](https://github.com/UW-Madison-Bacteriology-Bioinformatics/binning_wf/tree/after-amr-metagenomics)

# 🖥️  Infrastructure
This workflow uses DAGman technology, which runs each sample automatically through `fastp` and `spades`, and is meant to be run on CHTC.
Each sample has it's own DAG ("sample dag"), meaning that trimming and assembly is performed independently for each sample, and is automatically submitted as a job.
The "main" dag, submits all the sample's DAG at once.

![mg-assembly](https://github.com/user-attachments/assets/e23c4f70-7016-4ca4-94cc-f3021bd19308)


# 🔁 Recreate this workflow; Instructions

# Set up your folders
The workflow expects that you have a staging folder, with Illumina paired-end reads in the following format:

```
/staging/netID/my_project/
--- /staging/netID/my_project/${SAMPLE}_R1_L001.fastq.gz
--- /staging/netID/my_projects/${SAMPLE}_R2_L001.fastq.gz
```

You can also have your files directly in the chtc folder of ResearchDrive, if you lab has that set-up.
```
/researchdrive/ptran5/
--- /researchdrive/ptran5/my_project/${SAMPLE}_R1_L001.fastq.gz
--- /researchdrive/ptran5/my_project/${SAMPLE}_R2_L001.fastq.gz
```


# Run the code

Make a copy of this folder to your chtc account:

```
# login
ssh netid@[chtc.address]
# Download a copy of the code from github
git clone https://github.com/UW-Madison-Bacteriology-Bioinformatics/mg-assembly-sr.git
```

Make the bash script executable:
```
cd mg-assembly-sr/scripts
chmod +x .sh
```

Create a sample list, for example:
```
nano samples.txt
# SampleA
# SampleB
# SampleC
# Make sure there is a line return after your last sample
#exit
```

> [!NOTE]
> Want to use the ResearchDrive/chtc folder to transfer and export your files directly to research drive?
> Navigate to the scripts folder, and comment out the section surrounded by "####" in the 2 `.sh` files, and replace the netID with that of your PI.


Create a custom dag for each sample:
```
[ptran5@ap2002 mg-assembly-sr]$ bash create_sample_dag.sh 
Usage: create_sample_dag.sh <samples_list> <path_to_reads>
```

```
bash create_sample_dag.sh samples.txt /staging/ptran5/my_project/
```

Create a custom dag with everything:
```
[ptran5@ap2002 mg-assembly-sr]$ bash create_main_dag.sh 
Usage: create_main_dag.sh <list of samples> <output_file>
```

```
bash create_main_dag.sh samples.txt main_assembly.dag
```

Run the dag:
```
condor_submit_dag main_assembly.dag
```

# Troubleshooting and common issues

If one of your DAG fails because of a memory issue please follow these steps:

1. Type condor_q to check the job ID of the job that fails, and take note of that (note: not the JOB ID of all the samples in your DAG).
2. Type “ls -lht” to check the timestamps of the latest rescue files for that sample’s dag (named something like: assembly_SAMPLE.dag.rescue001).
3. Stop the job that fails (e.g. condor_rm JobID). This initiates the creation of a new rescue file
Important: Wait for the job to be removed from condor_q: type condor_q and check that the job is removed, it takes a few seconds/minutes. Type condor_q a few times to refresh and really make sure it’s removed.
4. Once you don’t see it in the queue anymore, type “ls -lht” to check if a new rescue file has been created, it might be named the same thing but with a new rescue number, e.g. rescue002.
View the file (e.g. less assembly_SAMPLE.dag.rescue002)
It should say something like DONE Step, but not “DONE” for the step that failed.
5. Modify your submit file to update the resource requested (in request_cpus, request_memory or request_disk) as appropriate.
You can submit specifically that sample’s condor_submit_dag  assembly_SAMPLE.dag to run that one only. 
6. If you type condor_q you should be able to see the DAG in the queue, idle, and then running, but with some steps labeled as “done” already.
