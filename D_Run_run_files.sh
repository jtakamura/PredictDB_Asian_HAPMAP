#!/bin/bash
#PBS -N run_run_files
#PBS -S /bin/bash
#PBS -l walltime=100:00:00
#PBS -l nodes=1:ppn=2
#PBS -l mem=4gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err
cd /home/jennifer/new_PredDB/elastic_net

bash  Run_files.sh

echo "Hi ${USER}, your script ran!" > testjob_output2.txt
echo "Congratulations, you are a superstar!" >> testjob_output2.txt








