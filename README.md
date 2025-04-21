# mg-assembly-sr
Short read metagenomic assembly

# Instructions

# Set up your folders
This expects that you have a staging folder, with Illumina paired-end reads in the following format:

```
/staging/netID
--- /staging/netID/${SAMPLE}.R1.fastq.gz
--- /staging/netID/${SAMPLE}.R2.fastq.gz
```

# Run the code

Make a copy of this folder to your chtc account:

```
git clone https://github.com/UW-Madison-Bacteriology-Bioinformatics/mg-assembly-sr.git
```

Make the bash script executable:
```
cd md-assembly-sr
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

Create a custom dag for each sample:
```
[ptran5@ap2002 mg-assembly-sr]$ bash create_sample_dag.sh 
Usage: create_sample_dag.sh <samples_list> <netid>
```

```
bash create_sample_dag.sh samples.txt ptran5
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