#From Laurn S. Mogil##
#!/bin/bash
#PBS -N Run_run_files
#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=2
#PBS -l mem=8gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err
cd /home/jennifer/Files_for_PredictDB

bash  run_files.sh

echo "Hi ${USER}, your script ran!" > testjob_output2.txt
echo "Congratulations, you are a superstar!" >> testjob_output2.txt
 
#bash command in order to run all files
#call on run_files.sh to run it
#use bash Run_run_files.sh to run it from the terminal
