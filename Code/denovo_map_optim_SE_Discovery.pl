#!/bin/bash
## G.Smith-Vidaurre
## 12 July 2020
## Updated 16 August 2020

## Purpose: Optimize Stacks parameters for the SE libraries using a subset of individuals chosen over a range of read numbers and geographic areas. The reads used in the denovo_map.pl run were filtered for rare and abundant kmers using kmer_filter. Here, keeping m constant at 3, and varying M and n from 1 to 8, while setting these parameters to be equal (e.g. M = n = 1 for first run). Note that since the population map only has a subset of individuals, these are the ones that will be used by the pipeline

#SBATCH --job-name SE_pop8
#SBATCH --partition normal ## default
#SBATCH --nodes 1 ## default
#SBATCH --ntasks 1 ## default
#SBATCH --cpus-per-task 16 ## number of threads, default is 1, changes ntasks, I still find that confusing
#SBATCH --time 1-01:00:00 ## Must be specified, the default for this partition is 7 days 1 hour max walltime (7-01:00:00)
#SBATCH --mail-user gsmithvi@nmsu.edu
#SBATCH --mail-type BEGIN ## will get an email when job starts
#SBATCH --mail-type END ## will get an email when job ends
#SBATCH --mail-type FAIL ## will get email when job fails
#SBATCH --get-user-env ## pass on environmental settings

module load stacks

map_path=/scratch/gsmithvi/info
in_path=/scratch/gsmithvi/cleaned/kmer_filter/single_end
# out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn1
# out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn2
# out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn3
# out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn4
# out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn5
# out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn6
# out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn7
out_path=/scratch/gsmithvi/tests_denovo/single_end/stacks_m3_Mn8

popmap=$map_path/popmap_SE_optim.txt
log_file=$out_path/denovo_map.oe

# Run denovo_map.pl with m = 3, M = n = 1 to start, also execute the populations unit to keep only loci shared by 80% of the samples (-r 80)
# -T is the number of cores, -X are options for specific pipeline components

# M=1 # 12 July 2020
# M=2 # 12 July 2020
# M=3 # 13 July 2020
# M=4 # 13 July 2020
# M=5 # 13 July 2020
# M=6 # 13 July 2020
# M=7 # 13 July 2020
# M=8 # 13 July 2020

# Moved -m 3 for ustacks to a customized pipeline component call, otherwise the run fails, since -m is not an accepted denovo_map.pl flag
# Added -X "ustacks:-m 3", and fixed "-min_maf" to "--min_maf"
# denovo_map.pl --samples $in_path --popmap $popmap -o $out_path -M $M -n $M -T 4 -X "ustacks:-m 3" -X "populations:-r 0.80" -X "populations:--min_maf 0.05" &> $log_file

# Rerun just populations
# Using out_path as the in path because this is where the catalog files are
pop_log_file=$out_path/populations.oe
populations --in_path $out_path --out_path $out_path --popmap $popmap -t 4 -r 0.80 --min_maf 0.05 &> $pop_log_file
