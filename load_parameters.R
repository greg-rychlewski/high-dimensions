##### Simulation Parameters #####
numRuns <- 500
numObs <- 50 
dims <- c(2, 3, 5, 10, 20, 30, 40, 50) 
norms <- c("L0.5"=0.5, "L1"=1, "L2"=2, "L3"=3) 
selectedNorms <- c("L0.5"=0.5, "L1"=1, "L2"=2, "L3"=3) 
avgRatio <- lapply(norms, function(norm) numeric()) 
avgDiff <- lapply(norms, function(norm) numeric()) 

##### Layout Parameters #####
legendPos <- "bottom" 
legendSize <- 12
axisLabelSize <- 12 
axisTitleSize <- 14
plotTitleSize <- 14
lineSize <- 1 
legendBoxSize <- 2 
plotWidth <- "80%" 