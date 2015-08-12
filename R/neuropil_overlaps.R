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
#' @seealso The \code{\link{neuropils}} data.frame contains details of the
#'   different neuropil regions.
neuropil_overlaps<-function(nps, raw=FALSE){
  # empirically there is some shift required here
  if(is.numeric(nps)) nps=nps+249L
  baseurl="http://brainbase.imp.ac.at/bbweb/infovisdata?nsst=0&st=as&ast=imgStain&nst="

  x=GET(paste0(baseurl, paste(nps, collapse = ",")))
  stop_for_status(x)
  cx=content(x)
  if(raw) return(cx)
  df=bb_json_df(cx)
  # replace standard column names with short neuropil names
  np_names=sapply(attr(df,'units'),'[[','name')
  colnames(df)[match(names(np_names), colnames(df))]=np_names

  # imgIds may as well be integer
  df$imgId=as.integer(df$imgId)
  df
}

# Convert a Brainbase JSON query result into a dataframe
bb_json_df<-function(x,varnames=NULL,stringsAsFactors=FALSE){
  num_vars=length(x[['data']][[1]])
  lc=as.data.frame(lapply(seq_len(num_vars),
                          function(c) sapply(x[['data']],'[[',c)),
                   stringsAsFactors=stringsAsFactors)
  names(lc) = if(is.null(varnames)) names(x[['data']][[1]]) else varnames
  attr(lc,'units')=x[['units']]
  lc
}
