# Calculate ratios and differences across dimensions for each norm
runSimulations <- function(){
	withProgress(message="Running Simulations", value=0, {
		for (d in dims){
			# Store ratios and differences for each simulation run within each norm
			ratio <- lapply(norms, function(norm) numeric())
			diff <- lapply(norms, function(norm) numeric())	
			originDiff <- lapply(norms, function(norm) numeric())	

			for (i in 1:numRuns){
				# Generate uniform random data in (0,1)^d
				data <- matrix(runif(numObs*d), ncol=d, byrow=T)

				for (k in norms){
					norm <- names(norms)[norms == k]

					max <- max(rowSums(data^k)^(1/k))
					min <- min(rowSums(data^k)^(1/k))

					ratio[[norm]][i] <- max / min
					diff[[norm]][i] <- max - min
				}

				incProgress(1 / (length(dims) * numRuns))
			}
					
			# Store average ratios and differences for current dimension
			dimLabel <- ifelse(d==1, paste0(d, " dimension"), paste0(d, " dimensions"))

			for (norm in names(norms)){
				avgRatio[[norm]][dimLabel] <<- mean(ratio[[norm]])
				avgDiff[[norm]][dimLabel] <<- mean(diff[[norm]])
			}
		}
	})
}

# Get dataframe for plots
getData <- function(results){
	allData <- data.frame()

	for (norm in names(selectedNorms)){
		tempData <- data.frame(result=results[[norm]], dimension=dims, norm=norm, row.names=NULL)
		allData <- rbind(allData, tempData)
	}

	return(allData)
}

# Plot ratio of maximum to minimum distance across dimensions
plotRatios <- function(){
	ratioData <<- getData(avgRatio)

	ratioPlot <- ggplot(data=ratioData, aes(x=dimension))
	ratioPlot <- ratioPlot + geom_line(aes(y=result, group=norm, color=norm), size=lineSize)
	ratioPlot <- ratioPlot + geom_hline(aes(yintercept=1, linetype="Ratio = 1"), size=lineSize, linetype="dotted")
	ratioPlot <- ratioPlot + xlab("Dimension") + ylab("Farthest Point / Closest Point") 
	ratioPlot <- ratioPlot + scale_y_continuous(breaks=c(0, 1, seq(from=5, to=max(ratioData$result), by=5)))
	ratioPlot <- ratioPlot + ggtitle("Ratio of Distances")
	ratioPlot <- ratioPlot + theme(plot.title=element_text(hjust=0.5, size=plotTitleSize))
	ratioPlot <- ratioPlot + theme(axis.text=element_text(size=axisLabelSize), axis.title=element_text(size=axisTitleSize))
	ratioPlot <- ratioPlot + theme(legend.title=element_blank(), legend.position=legendPos, legend.text=element_text(size=legendSize))

	return(ratioPlot)	
}

# Plot differencce between maximum and minimum distance across dimensions (facet)
plotDifferences <- function(){
	diffData <- getData(avgDiff)

	diffPlot <- ggplot(data=diffData, aes(x=dimension, y=result, color=norm))
	diffPlot <- diffPlot + geom_line(size=lineSize)
	diffPlot <- diffPlot + facet_grid(norm ~ ., scales="free_y")
	diffPlot <- diffPlot + theme(strip.text.y = element_text(size=12, face="bold"))
	diffPlot <- diffPlot + xlab("Dimension") + ylab("Farthest Point - Closest Point") 
	diffPlot <- diffPlot + ggtitle("Difference between Distances")
	diffPlot <- diffPlot + theme(plot.title=element_text(hjust=0.5, size=plotTitleSize))
	diffPlot <- diffPlot + theme(axis.text=element_text(size=axisLabelSize), axis.title=element_text(size=axisTitleSize))
	diffPlot <- diffPlot + theme(legend.title=element_blank(), legend.position=legendPos, legend.text=element_text(size=legendSize))
	diffPlot <- diffPlot + guides(color=FALSE)

	return(diffPlot)
}

# Update norms based on user input
updateNorms <- function(input, add=FALSE){
	if (add){
		newLabel <- paste0("L", isolate(input$normVal))

		norms <<- c(norms, isolate(as.numeric(input$normVal)))
		names(norms)[length(norms)] <<- newLabel
		norms <<- sort(norms)

		selectedNorms <<- c(selectedNorms, isolate(as.numeric(input$normVal)))
		names(selectedNorms)[length(selectedNorms)] <<- newLabel
		selectedNorms <<- sort(selectedNorms)
	}else{
		if (!is.null(isolate(input$currNorms))){
			labels <- paste0("L", isolate(input$currNorms))
			selectedNorms <<- as.numeric(isolate(input$currNorms))
			names(selectedNorms) <<- labels
			selectedNorms <<- sort(selectedNorms)
		}else{
			selectedNorms <<- NULL
		}
	}
}

# Validate new norm being added by user
validateNorm <- function(input){
	result <- list()
	newNorm <- as.numeric(input$normVal)

	if (is.na(newNorm)){
		result$valid <- FALSE
		result$msg <- "Metric value must be numeric."
	}else if(newNorm %in% norms){
		result$valid <- FALSE
		result$msg <- "Metric value is already present."
	}else if(newNorm <= 0){
		result$valid <- FALSE
		result$msg <- "Metric value must be positive."
	}else{
		result$valid <- TRUE
	}

	return(result)
}