#!/bin/bash
# 10 June 2020 
# G.Smith-Vidaurre

# Purpose: Optimize Stacks parameters for the SE libraries using a subset of individuals chosen over a range of read numbers and geographic areas. The reads used in the denovo_map.pl run were filtered for rare and abundant kmers using kmer_filter. Here, keeping m constant at 3, and varying M and n from 1 to 8, while setting these parameters to be equal (e.g. M = n = 1 for first run). Note that since the population map only has a subset of individuals, these are the ones that will be used by the pipeline

map_path=/media/owner/MYIOPSITTA/R/Origins_Selection/info
in_path=/media/owner/MYIOPSITTA/R/Origins_Selection/kmer_output/single_end_2015
out_path=/media/owner/MYIOPSITTA/R/Origins_Selection/tests_denovo/stacks_m3_Mn1/single_end_2015

popmap=$map_path/popmap_SE_optim.txt
log_file=$out_path/denovo_map.oe

# Run denovo_map.pl with m = 3, M = n = 1 to start, also execute the populations unit to keep only loci shared by 80% of the samples (-r 80)
# -T is the number of cores, -X are options for specific pipeline components

M=1

# -X "populations:-r 0.80" -X "populations:-min_maf 0.05"
denovo_map.pl --samples $in_path --popmap $popmap -o $out_path -m 3 -M $M -n $M -T 4 -X "populations:-r 0.80" -X "populations:-min_maf 0.05" &> $log_file
