##### Simulation Parameters #####
numRuns <- 500 # Number of simulations
numObs <- 50 # Number of observations per simulation
dims <- c(2, 3, 5, 10, 20, 30, 40, 50) # Dimension of sample space
norms <- c("L0.5"=0.5, "L1"=1, "L2"=2, "L3"=3) # Type of norm used to calculate distances
avgRatio <- lapply(norms, function(norm) numeric()) # Average ratio of max distance to min distance from origin over all simulations
avgDiff <- lapply(norms, function(norm) numeric()) # Average difference between max distance and min distance from origin over all simulations

##### Layout Parameters #####
legendPos <- "bottom" 
legendSize <- 12
axisLabelSize <- 12 
axisTitleSize <- 14
lineSize <- 1 
legendBoxSize <- 2 
plotWidth <- "80%" 