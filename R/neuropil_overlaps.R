#' Fetch fractional overlap for each neuropil for all images in BrainBase
#'
#' @param nps The neuropils to fetch as integer ids. A non-finite value implies
#'   all neuropils.
#' @param raw Whether to return raw JSON result
#'
#' @return processed data.frame
#' @export
#'
#' @examples
#' x=neuropil_overlaps(1152)
#' @importFrom httr GET stop_for_status content
neuropil_overlaps<-function(nps, raw=FALSE){
  # empirically there is some shift required here
  if(is.numeric(nps)) nps=nps+249L
  baseurl="http://brainbase.imp.ac.at/bbweb/infovisdata?nsst=0&st=as&ast=imgStain&nst="

  x=GET(paste0(baseurl, paste(nps, collapse = ",")))
  stop_for_status(x)
  cx=content(x)
  if(raw) return(cx)
  bb_json_df(cx)
}

# Convert a Brainbase JSON query result into a dataframe
bb_json_df<-function(x,varnames=NULL,stringsAsFactors=FALSE){
  num_neuropils=length(x[[1]])
  lc=as.data.frame(lapply(seq_len(2L+num_neuropils),
                          function(c) sapply(x[['data']],'[[',c)),
                   stringsAsFactors=stringsAsFactors)
  names(lc) = if(is.null(varnames)) names(x[['data']][[1]]) else varnames
  attr(lc,'units')=x[['units']]
  lc
}
