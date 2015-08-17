#' Fetch fractional overlap for each neuropil for all images in BrainBase
#'
#' @param nps The neuropils to fetch, specified either as integer ids or as the
#'   character vector abbreviated neuropil name (see \code{\link{neuropils} in
#'   both cases}. The special values of "brain" and "vnc" imply all brain or vnc
#'   neuropils, respectively.
#' @param raw Whether to return the raw httr result
#' @param normalised_by How to normalise the results. This denominator can
#'   either be the total number of voxels in each \bold{neuropil} region or the
#'   total amount of \code{staining} in the whole expression pattern.
#'
#' @return processed \code{data.frame} with columns \itemize{
#'
#'   \item imgId Integer image id
#'
#'   \item name Image name
#'
#'   \item ... additional columns expressing the fraction of each neuropil
#'   domain occupied by foreground voxels and titled with the abbreviated
#'   neuropil names.}
#' @export
#' @importFrom httr GET stop_for_status content
#' @seealso The \code{\link{neuropils}} data.frame contains details of the
#'   different neuropil regions.
#' @examples
#' x=neuropil_overlaps(1152)
#'
#' \dontrun{
#' r=neuropil_overlaps(1152, raw=TRUE)
#' json_content=content(r)
#'
#' all_brain=neuropil_overlaps('brain')
#' all_vnc=neuropil_overlaps('vnc')
#' }
neuropil_overlaps<-function(nps, raw=FALSE, normalised_by=c("neuropil","staining")){
  normalised_by=match.arg(normalised_by)
  if(is.character(nps)) {
    nps <- if(length(nps)==1 && nps %in%c("brain", "vnc"))
      brainbaser::neuropils$id[brainbaser::neuropils$tissue==nps]
    else brainbaser::neuropils$id[match(nps, brainbaser::neuropils$abbrev)]
  }

  if(is.numeric(nps)) {
    # empirically there is some shift required here
    nps=nps+249L
  } else stop("invalid neuropil specification!")
  baseurl=paste0("http://brainbase.imp.ac.at/bbweb/infovisdata?nsst=",
                 ifelse(normalised_by=='neuropil',0,1),
                 "&st=as&ast=imgStain&nst=")

  x=GET(paste0(baseurl, paste(nps, collapse = ",")))
  stop_for_status(x)
  if(raw) return(x)
  df=bb_json_df(x)
  # replace standard column names with short neuropil names
  np_names=sapply(attr(df,'units'),'[[','name')
  colnames(df)[match(names(np_names), colnames(df))]=np_names

  # imgIds may as well be integer
  df$imgId=as.integer(df$imgId)
  df
}

# Convert a Brainbase JSON query result into a dataframe
bb_json_df<-function(x,varnames=NULL,stringsAsFactors=FALSE){
  x=content(x)
  num_vars=length(x[['data']][[1]])
  lc=as.data.frame(lapply(seq_len(num_vars),
                          function(c) sapply(x[['data']],'[[',c)),
                   stringsAsFactors=stringsAsFactors)
  names(lc) = if(is.null(varnames)) names(x[['data']][[1]]) else varnames
  attr(lc,'units')=x[['units']]
  lc
}
