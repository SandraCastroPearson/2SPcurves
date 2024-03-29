% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/2SSPmodifier.R
\name{TwoSSPmodifier}
\alias{TwoSSPmodifier}
\title{ROC when survival goes to 0 for either group}
\usage{
TwoSSPmodifier(
  time,
  event,
  group,
  modifier,
  area = FALSE,
  mlabels,
  xlab,
  ylab,
  main,
  cex.axis = 1.5,
  cex.lab = 1.5,
  legend.inset = 0.02,
  legend.cex = 1.5,
  lty = c(1, 6),
  lwd = 1.5
)
}
\arguments{
\item{time}{Time to event or censoring.}

\item{event}{An indicator vector with values of 1 for individuals who had the event occurred or 0 if the participant was censored.}

\item{group}{An indicator vector with values of 1 if the the participant was in the treatment arm and 0 otherwise.}

\item{modifier}{An indicator vector with values of 1 for a certain level of the modifier and 0 otherwise. Example: 0 for male and 1 for female.}

\item{area}{Logical argument to indicate if user wants an estimate for area under the curve. Default is TRUE.}

\item{mlabels}{A vector with two strings to label the levels of the modifier.}

\item{xlab}{String argument for the horizontal axis label of the ROC curve.}

\item{ylab}{String argument for the vertical axis label of the ROC curve.}

\item{main}{String argument for the title of the ROC curve.}

\item{cex.axis}{Optional graphical parameter for magnification of axis annotation. See \link[graphics]{par} for more details.}

\item{cex.lab}{Optional graphical parameter for magnification of x and y labels. See \link[graphics]{par} for more details.}

\item{legend.inset}{Optional graphical parameter controling the inset of the legend.}

\item{legend.cex}{Optional graphical parameter for magnification of the legend's text.}

\item{lty}{Optional graphical parameter to set the type of line to use. Can be a number or a vector. See \link[graphics]{par} for more details.}

\item{lwd}{Optional graphical parameter for line width relative to the default. See \link[graphics]{par} for more details.}
}
\value{
A plot of the ROC curve and an ROCsurv object containing:
\itemize{
 \item A list with two survfit objects for the treatment and control groups when the modifier=0.
 \item A list with two survfit objects for the treatment and control groups when the modifier=1.
 \item If area = TRUE, the areas under the curve for the two ROCs in the given plot.
}
}
\description{
ROC when survival goes to 0 for either group
}
