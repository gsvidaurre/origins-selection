#!/usr/bin/env Rscript

# Smith-Vidaurre
# 08 October 2020

# Purpose: Testing abcrf model training with BARC fsc26 simulations on Discovery.

out_path <- "/scratch/gsmithvi/ABC/ABC_BARC"

# Build full prior when delimitR installed, 
# delimitR::makeprior

# Reduce full prior
# Code from delimitR::Prior_reduced


Models <- as.factor(FullPrior[, "Model"])
    summary(Models)
    FullPriorRed <- FullPrior
    FullPriorRed["Model"] <- NULL
    Prior_Reduced <- FullPriorRed[sapply(FullPriorRed, function(x) length(levels(factor(x))) > 
        1)]
    Prior_Reduced <- as.data.frame(Prior_Reduced)

# Save both priors

# Read priors back in to continue workflow

FullPrior <- readRDS(file.path(out_path, "FullPrior.RDS"))
ReducedPrior <- readRDS(file.path(out_path, "ReducedPrior.RDS"))

# Code from RF_build_abcrf
Models <- as.factor(FullPrior[, "Model"])

Trainingdata <- data.frame(Models, ReducedPrior)
RF <- abcrf::abcrf(Models ~ ., data = Trainingdata, ntree = 500, 
        paral = TRUE)

saveRDS(RF, file.path(out_path, "trained_reduced_Prior.RDS"))
