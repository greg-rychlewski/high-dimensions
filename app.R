#####################################################################################################
#                                                                                                   #
#                              Recreate Certain Results from                                        #
#                        'On the Surprising Behavior of Distance Metrics'                           #
#                             by Aggarwal, Hinneburg and Keim                                       #           
#                                                                                                   #
#####################################################################################################

##### Preliminaries #####
source("load_dependencies.R")
source("load_parameters.R")
source("load_functions.R")
source("load_css.R")

##### User Interface #####
ui <- tagList(
	useShinyjs(),
	cssStyles(),
	fluidPage(
		withMathJax(),
		div(
			h4("Surprising Behaviour of Distance Metrics in High Dimensions", align="center"),
			br(),
			br(),
			p("The standard way of measuring distance between two \\(d\\)-dimensional points, \\((x_1, x_2, ..., x_d)\\) and \\((y_1, y_2, ..., y_d)\\), is \\[\\sqrt{\\sum\\limits_{i=i}^d (x_i - y_i)^2}\\]"),
			p("This is called the Euclidean, or \\(L^2\\), norm. In general, distance may be measured by any \\(L^p\\) norm (where \\(p \\ge 1 \\)): \\[\\left(\\sum\\limits_{i=i}^d |x_i - y_i|^p\\right)^{\\frac{1}{p}}\\]"),
			p("This application investigates the behaviour of different \\(L^p\\) norms in high dimensions. More specifically, we show that the notion of closeness disappears as the number of dimensions, \\(d\\), increases. This is done by generating points uniformly distributed over the unit hypercube \\((0, 1)^d\\) and comparing the distance of the point closest to the origin to the point farthest from the origin. In doing so, we are implicity examining the behaviour of the closest and farthest neighbors from any fixed point."),
			p("Two different values of interest will be calculated: 1) the ratio of the maximum distance to the minimum distance and 2) the difference between the maximum distance and the minimum distance. As will be seen, the behaviour of these two values is not the same across all \\(L^p\\) norms. In particular, if we take \\(0 < p < 1\\), which is not a valid norm because it doesn't satisfy the triangle inequality, we see very interesting results."),
			br(),
			p("Note: These are independent reproductions of the results from", a("On the Surprising Behavior of Distance Metrics in High Dimensional Space by Charu C. Aggarwal, Alexander Hinneburg, and Daniel A. Keim.", href="https://link.springer.com/chapter/10.1007/3-540-44503-X_27", target="_blank")),
			br(),
			br(),
			div(actionButton(inputId="startButton", label="Start"), id="startButtonContainer"),
			id="intro"
		),
		sidebarLayout(
			sidebarPanel(
				div(
					div(
						numericInput(inputId="normVal", label="", value=1, min=0.1, max=99.9, step=0.1),
						actionButton(inputId="addNorm", label="Add New Metric"),
						id="newNormGroup"
					),
					div(
						id="normError"
					),
					div(
						"Filter Metrics",
						id="filterLabel"
					),
					checkboxGroupInput(inputId="currNorms", label="", choices=norms, selected=norms, inline=TRUE),
					br(),
					h5("Ratio Plot"),
					HTML(
						"<ul class='plotInfo'>
							<li>All ratios decrease to 1</li>
							<li>Norms with higher values of p decrease at a faster rate</li>
						</ul>"
					),
					h5("Difference Plot"),
					HTML(
						"<ul class='plotInfo'>
							<li>Norms with \\(p \\le 0.6\\) increase in an exponential manner</li>
							<li>Norms with \\(0.6 < p < 2\\) increase in a logarithmic manner</li>
							<li>Norms with \\(p\\) close to 2 increase quickly and then level off</li>
							<li>Norms with \\(p > 2\\) decrease </li>
						</ul>"
					)
				),
				width=3,
				id="sideBar"
			),
			mainPanel(
				div(
					plotOutput(outputId="ratioPlot", width=plotWidth),
					br(),
					br(),
					plotOutput(outputId="diffFacet", width=plotWidth)
				),
				width=9,
				id="mainBar"
			)
		),
		align="center"
	)
)

##### Server Functionality #####
server <- function(input, output, session){
	rValues <- reactiveValues(simDone=FALSE)

	observeEvent(input$startButton, {
		# Update norm checkbox group
		updateCheckboxGroupInput(session, inputId="currNorms", label="", choices=norms, selected=selectedNorms, inline=TRUE)

		# Disable start button and run simulations
		shinyjs::addClass(selector="html", class="waiting")
		shinyjs::disable("startButton")
		runSimulations()

		# Change user display
		shinyjs::removeClass(selector="html", class="waiting")
		shinyjs::hide("intro")	
		shinyjs::show("mainBar")
		shinyjs::show("sideBar")
		
		rValues$simDone <- TRUE
	})

	output$ratioPlot <- renderPlot({
		if (!rValues$simDone || length(selectedNorms) == 0){
			return(NULL)
		}

		plotRatios()
	})

	output$diffFacet <- renderPlot({
		if (!rValues$simDone || length(selectedNorms) == 0){
			return(NULL)
		}

		plotDifferences()
	})

	observeEvent(input$addNorm, {
		# Remove old error message
		shinyjs::hide("normError")
		shinyjs::removeClass("normVal", "normErrorInput")

		# Disable user input
		shinyjs::addClass(selector="html", class="waiting")
		shinyjs::disable("addNorm")
		shinyjs::disable("currNorms")

		# Validate input
		validNorm <- validateNorm(input)

		if (validNorm$valid){
			updateNorms(input, add=TRUE)
			runSimulations()
			updateCheckboxGroupInput(session, inputId="currNorms", label="", choices=norms, selected=selectedNorms, inline=TRUE)
		}else{
			shinyjs::addClass("normVal", "normErrorInput")
			shinyjs::html("normError", validNorm$msg)
			shinyjs::show("normError")
		}

		# Reenable user input
		shinyjs::removeClass(selector="html", class="waiting")
		shinyjs::enable("addNorm")
		shinyjs::enable("currNorms")
	})

	observeEvent(input$currNorms, {
		rValues$simDone <- FALSE
		
		updateNorms(input)
		
		rValues$simDone <- TRUE
	}, ignoreInit=TRUE, ignoreNULL=FALSE)
}

##### Run Application #####
shinyApp(ui=ui, server=server)