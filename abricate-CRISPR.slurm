#!/bin/bash
# Partition for the job:
#SBATCH --partition=cloud,physical

# Multithreaded (SMP) job: must run on one node and the cloud partition
#SBATCH --nodes=1

# The name of the job:
#SBATCH --job-name="abricate"
#SBATCH --array=1-6

# The project ID which this job should run under:
#SBATCH --account="punim0599"

# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12

# Use this email address:
#SBATCH --mail-user=jmmans@student.unimelb.edu.au

# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=0-4:00:00

# check that the script is launched with sbatch
if [ "x$SLURM_JOB_ID" == "x" ]; then
   echo "You need to submit your job to the queuing system with sbatch"
   exit 1
fi

# dependencies
module load Miniconda3
source activate abricate

# drives
mkdir /data/cephfs/punim0599/Jesse/emm75/abricate/phage

cd /data/cephfs/punim0599/Jesse/emm75/contigs
ls | while read line; do

# work
[[ -f "/data/cephfs/punim0599/Jesse/emm75/abricate/phage/${line}.tab" ]] || abricate /data/cephfs/punim0599/Jesse/emm75/contigs/${line} --db CRISPR --minid 95 --mincov 95 > /data/cephfs/punim0599/Jesse/emm75/abricate/CRISPR/${line}.tab

# collate into one file
abricate --summary /data/cephfs/punim0599/Jesse/emm75/abricate/CRISPR/* > /data/cephfs/punim0599/Jesse/emm75/abricate/CRISPR_summary.tab
done
