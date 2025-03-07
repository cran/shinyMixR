#------------------------------------------ get_proj ------------------------------------------
#' Read in and update model results in project object
#'
#' This function creates or updates a project object with models and/or results emerged from nlmixr2 runs.
#' A check is performed to see if newer results are present and only updates these.
#'
#' @param projloc character with the base location of the shinyMixR project
#' @param geteval logical indicating if the model functions should be evaluated
#'
#' @export
#' @return A named list with information for each model in the 'projloc'
#' @examples
#'
#' \dontrun{
#'   proj <- get_proj()
#' }
get_proj <- function(projloc=".",geteval=TRUE){
  
  # Read in models and place in result objects
  dir.create(paste0(projloc,"/shinyMixR"),showWarnings = FALSE,recursive = TRUE)
  mdln    <- normalizePath(list.files(paste0(projloc,"/models"),pattern="run[[:digit:]]*\\.[r|R]",full.names = TRUE))
  mdlnb   <- sub("\\.[r|R]","",basename(mdln))
  sumres  <- normalizePath(list.files(paste0(projloc,"/shinyMixR"),pattern="run[[:digit:]]*\\.ressum\\.rds",full.names = TRUE))
  sumresi <- file.info(sumres)
  summdli <- file.info(mdln)
  
  # read in data folder (only in case objects are not yet present)
  datf  <- list.files(paste0(projloc,"/data"))
  grepd <- " |^[[:digit:]]|\\!|\\#|\\$|\\%|\\&|\\'|\\(|\\)|\\-|\\;|\\=|\\@|\\[|\\]|\\^\\`\\{\\|\\}"
  if(any(grepl(grepd,datf))) warning("Data files with special characters found, take into acount that models that use these can crash")

  # Read in models and results
  if(!file.exists(paste0(projloc,"/shinyMixR/project.rds"))){
    mdls <- lapply(mdln,list)
    names(mdls) <- sub("\\.[r|R]","",basename(mdln))
    if(length(mdln)==0){
      warning("No models present")
    }else{
      for(i in 1:length(mdln)){
        names(mdls[[i]]) <- "model"
        mdls[[i]]$modeleval <- list()
        if(geteval) mdls[[i]]$modeleval$meta <- try(get_meta(mdln[i]))
      }
    }
    for(i in sumres) mdls[[sub("\\.ressum\\.rds","",basename(i))]]$results <- readRDS(i)
    mdls$meta <- list(lastrefresh=Sys.time())
  }else{
    mdls   <- readRDS(paste0(projloc,"/shinyMixR/project.rds"))
    # for the list with models, check if new models are available or old models are deleted
    # and if models are updated after last refresh:
    inproj <- names(mdls)[names(mdls)!="meta"]
    todel  <- setdiff(tolower(inproj),tolower(mdlnb))
    toadd  <- setdiff(tolower(mdlnb),tolower(inproj))
    if(length(todel)!=0){
      mdls <- mdls[c(sort(inproj[!inproj%in%todel]),"meta")]
    }
    if(length(toadd)!=0){
      mdls2 <- lapply(mdln[which(mdlnb%in%toadd)],list)
      names(mdls2) <- toadd
      for(i in 1:length(mdls2)){
        names(mdls2[[i]]) <- "model"
        if(geteval) mdls2[[i]]$modeleval$meta <- try(get_meta(mdln[which(mdlnb%in%toadd)][i]))
      }
      mdls <- c(mdls,mdls2)
    }
    # For model results and meta data, check if there are newer results than time of last save
    if(geteval){
      for(i in mdln){
        if(summdli$mtime[row.names(summdli)==i] > mdls$meta$lastrefresh)
          mdls[[sub("\\.[r|R]","",basename(i))]]$modeleval$meta <- try(get_meta(i))
      }
    }
    for(i in sumres){
      if(sumresi$mtime[row.names(sumresi)==i] > mdls$meta$lastrefresh)
        mdls[[sub("\\.ressum\\.rds","",basename(i))]]$results <- try(readRDS(i))
    }
    mdls$meta$lastrefresh <- Sys.time()
  }
  # Additional check to see if model is not saved after the last results
  chk       <- data.frame(mdl=sub("\\.[r|R]","",basename(mdln)),mdlsv=summdli$mtime,stringsAsFactors = FALSE)
  chk$ressv <- sumresi$mtime[match(chk$mdl,sub("\\.ressum\\.rds","",basename(sumres)))]
  chk       <- chk[which(chk$mdlsv>chk$ressv),]

  saveRDS(mdls,file=paste0(projloc,"/shinyMixR/project.rds"))
  return(mdls)
}
