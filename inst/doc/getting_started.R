## ----echo=FALSE, results='hide'-----------------------------------------------
knitr::opts_chunk$set(fig.width=7, fig.height=4) 

## ----eval=FALSE---------------------------------------------------------------
#  # For development versions
#  devtools::install_github("richardhooijmaijers/shinyMixR")
#  # Or for CRAN release
#  install.packages("shinyMixR")
#  # It is advised to use the CRAN releas of nlmixr2
#  install.packages("nlmixr2")
#  # It is advised to use xpose.nlmixr2 for easy diagnostics
#  install.packages("xpose.nlmixr2")

## ----eval=FALSE---------------------------------------------------------------
#  library(shinyMixR,quietly = TRUE)
#  create_proj()

## ----eval=FALSE---------------------------------------------------------------
#  run_shinymixr(launch.browser = TRUE)

## ----echo=FALSE,out.width="700px"---------------------------------------------
#knitr::include_graphics("screen1.png")
knitr::include_graphics(file.path("..","man", "figures", "screen1.png"))

## ----echo=FALSE,out.width="300px"---------------------------------------------
#knitr::include_graphics("screen2.png")
knitr::include_graphics(file.path("..","man", "figures", "screen2.png"))

## ----echo=FALSE,out.width="300px"---------------------------------------------
#knitr::include_graphics("screen3.png")
knitr::include_graphics(file.path("..","man", "figures", "screen3.png"))

## ----echo=FALSE,out.width="300px"---------------------------------------------
#knitr::include_graphics("screen4.png")
knitr::include_graphics(file.path("..","man", "figures", "screen4.png"))

## ----echo=FALSE,out.width="300px"---------------------------------------------
#knitr::include_graphics("screen5.png")
knitr::include_graphics(file.path("..","man", "figures", "screen5.png"))

## ----echo=FALSE,out.width="300px"---------------------------------------------
#knitr::include_graphics("screen6.png")
knitr::include_graphics(file.path("..","man", "figures", "screen6.png"))

## ----echo=FALSE,out.width="300px"---------------------------------------------
#knitr::include_graphics("screen7.png")
knitr::include_graphics(file.path("..","man", "figures", "screen7.png"))

## ----results='hide', eval=FALSE-----------------------------------------------
#  proj_obj <- get_proj()

## ----eval=FALSE---------------------------------------------------------------
#  overview()
#  tree_overview()

## ----eval=FALSE---------------------------------------------------------------
#  run_nmx("run1")
#  # progress of a run is written to external text file
#  # this can be read-in for intermediate assessment
#  readLines("shinyMixR/temp/run1.prog.txt")

## ----eval=FALSE---------------------------------------------------------------
#  # Default data frame
#  par_table(proj_obj,c("run1","run2"))
#  # output to tex file (compiled to pdf)
#  par_table(proj_obj, models="run1", outnm="par.tex")

## ----eval=TRUE, echo=FALSE, message=FALSE, warning=FALSE----------------------
library(shinyMixR)
res  <- readRDS(system.file("other/run1.res.rds", package = "shinyMixR"))

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  res  <- readRDS("./shinyMixR/run1.res.rds")

## ----message=FALSE, warning=FALSE---------------------------------------------
gof_plot(res, type="user")
# gof_plot(res, mdlnm="run1", outnm="gof.tex")

## ----message=FALSE, warning=FALSE---------------------------------------------
res$TRT <- ifelse(as.numeric(res$ID)<6,1,2)
fit_plot(res, by="TRT", PRED="CPRED", type="user",logy=FALSE)
# fit_plot(res, mdlnm="run1", outnm="fit.html")

