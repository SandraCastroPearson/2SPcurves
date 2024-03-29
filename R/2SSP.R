getAUC <- function(KMests, silent, xlab, ylab, main, cex.axis = cex.axis,
         cex.lab = cex.lab, lty = lty, label.inset = label.inset,
         label.cex = label.cex, lwd = lwd){
  result <- completeROC(KMests[[1]], silent, xlab, ylab, main,cex.axis = cex.axis,
                          cex.lab = cex.lab, lty = lty, label.inset = label.inset,
                          label.cex = label.cex, lwd = lwd) #time, event, group
  if (is.null(result)) {temp <- list(control_km=KMests[[3]], drug_km = KMests[[4]])
  } else {temp <- list(AUC = result[[1]], R_u = result[[2]],
                       control_km=KMests[[3]], drug_km = KMests[[4]])}

  return(temp)
}

#' Create a two-sample survival probability curve for data from randomized controlled trials.
#'
#' @description
#' This function creates a two-samle survival probability curve for data from randomized controlled trials and has options to estimate the AUC, diagnose the proportional hazard assumptions and more.
#'
#' @param time Time to event or censoring.
#' @param event An indicator vector with values of 1 for individuals who had the event occur or 0 if the participant was censored.
#' @param group An indicator vector with values of 1 if the the participant was in the treatment arm and 0 otherwise.
#' @param checkPH Logical argument to indicate if user wants to compare the nonparametric curve with the curve based on the proportional hazards model (default is FALSE).
#' @param compare Logical argument to indicate if user wants want to compare the nonparametric curve with curves based on a proportional hazards model, proportional odds model, and various AFT models (default is FALSE).
#' @param area Logical argument to indicate if user wants an estimate for area under the curve (default is TRUE).
#' @param abtwc Logical argument to indicate if area between curves is needed as part of model comparisons (checkPHM or compare must be TRUE).
#' @param silent Logical argument, FALSE indicates the user wants plots and TRUE indicates no plots only AUC calculations (default is FALSE).
#' @param xlab String argument for the horizontal axis label of the ROC curve.
#' @param ylab String argument for the vertical axis label of the ROC curve.
#' @param main String argument for the title of the ROC curve.
#' @param CI Logical argument indicating if user wants bootstrap errors and confidence intervals to be calculated for the curve and AUC. Default is FALSE.
#' @param level Numerical argument indicating condifence level for the confidence interval. Default is 0.95. It's ignored if CI=FALSE.
#' @param B Number of bootstrap samples to use for confidence interval and error calculations. Default is 1000. It's ignored if CI=FALSE.
#' @param cex.axis Optional graphical parameter for magnification of axis annotation. See \link[graphics]{par} for more details.
#' @param cex.lab Optional graphical parameter for magnification of x and y labels. See \link[graphics]{par} for more details.
#' @param legend.inset Optional graphical parameter controling the inset of the legend.
#' @param legend.cex Optional graphical parameter for magnification of the legend's text.
#' @param lty Optional graphical parameter to set the type of line to use. Can be a number or a vector. See \link[graphics]{par} for more details.
#' @param lwd Optional graphical parameter for line width relative to the default. See \link[graphics]{par} for more details.
#'
#' @return A plot of the ROC curve (if \code{silent=FALSE}) and an ROCsurv object containing:
#' \itemize{
#'  \item A survfit object containing the survival curve for the treatment group.
#'  \item A survfit object containing the survival curve for the control group.
#'  \item The area under the curve (AUC).
#'  \item A matrix representation of the two-sample survival probability curve \code{R_u}.
#' }
#'
#'
#' @export
#'

###### # @param level The confidence level for the confidence interval of the area under the curve.
###### # Must be between 0.50 and 0.99. Default is 0.95. See details.

TwoSSP <- function(time, event, group, area=TRUE, silent=FALSE,
                    CI = FALSE, level = 0.95, B=1000, checkPH = FALSE, compare=FALSE, abtwc=FALSE,
                    xlab=NULL, ylab=NULL, main=NULL, cex.axis = 1.5, cex.lab = 1.5,
                    legend.inset=0.02, legend.cex=1.5, lty = c(2,1,3), lwd = 1.5){

  #### basic checks for missing parameters
  all_lengths = c(length(time), length(event), length(group))
  if (length(unique(all_lengths)) != 1) stop("One or more input vectors (time, event, group) differs in length from the rest.")
  #if (is.null(level)) {level = 0.95}
  if (is.null(xlab)) {xlab <- "Control Group Survival Probability"}
  if (is.null(ylab)) {ylab <- "Treatment Group Survival Probability"}
  if (is.null(main)) {main <- ""}
  #if (missing(method)) {method <- ""}
  label.inset=legend.inset; label.cex=legend.cex

  mat <- cbind(time, event, group)
  mat <- na.omit(mat)
  time = mat[,1]; event = mat[,2]; group = mat[,3];

  ###########################################

  if(checkPH == TRUE) { #CHECK IF PROPORTIONAL HAZARDS
    if (missing(abtwc)) {abtwc=TRUE}
    res <- PHM(time, event, group, silent, abtwc, xlab, ylab, main, cex.axis = cex.axis,
                        cex.lab = cex.lab, lty = lty, label.inset = label.inset,
                        label.cex = label.cex, lwd = lwd)
    #############################################
  }

  if (compare == TRUE) { #COMPARE TO LOGLOGISTIC AND LOGNORMAL
      res <- list(compare(time, event, group, silent, abtwc, xlab, ylab, main, cex.axis = cex.axis,
                           cex.lab = cex.lab, lty = lty, label.inset = label.inset,
                           label.cex = label.cex, lwd = lwd),
                  control_km=KMests[[3]], drug_km = KMests[[4]])
    }
    #############################################
  if (checkPH == FALSE & compare == FALSE){

    KMests <- getKMtab(time, event, group)

        if (area==FALSE & CI == FALSE) {#plot
          temp <- onlyROC(skm = KMests[[1]], xlab, ylab, main, cex.axis,
                          cex.lab, lty, label.inset, label.cex, lwd)
          res <- list(R_u=temp, control_km=KMests[[3]], drug_km = KMests[[4]])
          }

            #############################################
        if (area == TRUE & CI == FALSE) {
          res <- getAUC(KMests, silent, xlab, ylab, main,cex.axis = cex.axis,
                             cex.lab = cex.lab, lty = lty, label.inset = label.inset,
                             label.cex = label.cex, lwd = lwd)
          }
            #############################################
        if (CI == TRUE){
            res <- getAUC(KMests, silent=TRUE, xlab, ylab, main,cex.axis = cex.axis,
                        cex.lab = cex.lab, lty = lty, label.inset = label.inset,
                        label.cex = label.cex, lwd = lwd)
            maindat <- mat
            temp <- btsp(res, maindat, B, level, xlab, ylab, main, cex.axis = cex.axis,
                             cex.lab = cex.lab, lty = lty, lwd = lwd)
            res <- list(temp, control_km=KMests[[3]], drug_km = KMests[[4]])
          }

      }


  return(res)
}

#@param method Method to be used to obtain a complete curve.
