cssStyles <- function(){
	tags$style(HTML("
		/* Generic Elements */
		html{
			height: 100%;
			background-color: #000;
		}

		body{
			margin: 10px;
			background-color: #000;
		}

		a, a:hover, a:focus, a:active{
			font-style: italic;
			color: #fff;
		}

		.waiting{
    		cursor: wait;
		}

		/* Main Containers */
		#sideBar, #mainBar{
			display: none;
		}

		#sideBar{
			background-color: #303030;
			color: #fff;
			border: 1px solid #f0f0f0;
		}

		.plotInfo{
			text-align: left;
			font-size: 12px;
		}

		/* User Input */
		#intro{
			background-color: #303030;
			border: 1px solid #f0f0f0;
			color: #fff;
			border-radius: 3px;
			width: 70%;
			padding-bottom: 25px;
			padding-top: 15px;
			padding-left: 45px;
			padding-right: 45px;
		}

		#newNormGroup > .form-group, #addNorm, #normVal{
			display: inline-block;
		}

		#addNorm{
			width: 125px;
			vertical-align: baseline;
		}

		#normVal{
			width: 100px;
		}

		.normErrorInput{
			border: 1.5px solid red;
		}

		#addNorm:hover, #startButton:hover, #addNorm:focus, #startButton:focus, #addNorm:active, #startButton:active, #addNorm:visited, #startButton:visited{
			background-color: #303030;
			color: #fff;
		}

		#filterLabel{
			margin-bottom: -20px;
			margin-top: 15px;
		}

		/* Plots */
		#ratioPlot > img, #diffFacet > img{
			padding: 15px;
			background-color: #444;
			border-radius: 3px;
		}

		#ratioPlot > img:hover, #diffFacet > img:hover{
			background-color: #777;
		}

		/* Progress Bar */
		.shiny-notification{
			background-color: #303030;
			color: #fff;
		}

		.shiny-notification-close{
			color: #fff;
		}"
	)
)}