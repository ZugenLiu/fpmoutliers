#' LFPOF
#'
#' W. Zhang, J. Wu and J. Yu, "An Improved Method of Outlier Detection Based on Frequent Pattern," Information Engineering (ICIE), 2010 WASE International Conference on, Beidaihe, Hebei, 2010, pp. 3-6.
#'
#' @param data \code{data.frame} or \code{transactions} from \code{arules} with input data
#' @param minSupport minimum support for FPM
#' @param mlen maximum length of frequent itemsets
#' @return vector with outlier scores
#' @import arules foreach doParallel parallel
#' @export
LFPOF <- function(data, minSupport=0.3, mlen=0){
  no_cores <- detectCores() - 1
  registerDoParallel(no_cores)

  if(is(data,"data.frame")){
    data <- sapply(data,as.factor)
    data <- data.frame(data, check.names=F)
    txns <- as(data, "transactions")
  } else {
    txns <- data
  }
  if(mlen<=0){
    variables <- unname(sapply(txns@itemInfo$labels,function(x) strsplit(x,"=")[[1]][1]))
    mlen <- length(unique(variables))
  }
  fitemsets <- apriori(txns, parameter = list(support=minSupport, maxlen=mlen, target="frequent itemsets"))

  fiList <- LIST(items(fitemsets))
  qualities <- fitemsets@quality[,"support"]

  scores <- c()
  tx <- NULL
  scores <- foreach(tx = as(txns,"list"), .combine = list, .multicombine = TRUE)  %dopar%  {
    transaction = unlist(tx,"list")
    metric <- c()
    for(item in seq(1,length(fitemsets))){
      itemset <- fiList[[item]]
      if(all(itemset %in% transaction)){
        metric <- c(metric, length(itemset))
      }
    }
    max(metric)/length(transaction)
  }
  scores <- unlist(scores)
  stopImplicitCluster()

  output <- list()
  output$minSupport <- minSupport
  output$maxlen <- mlen
  output$model <- fitemsets
  output$scores <- scores
  output
}
