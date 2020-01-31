#' Example yaml file checking Lower Basin reservoir parameters.
#'
#' A yaml file containing rules with logic for checking RiverWare ouput.
#' Structured as a list of lists which are the individual rules.
#'
#' @format A yaml file containing 6 rules
#' \describe{
#'   \item{rules}{List of rules}
#'   \describe{
#'     \item{rule1}{yaml rule}
#'     \describe{
#'       \item{expr}{logical expression}
#'       \item{name}{name of slot used in expression, string}
#'       \item{label}{label of slot, string}
#'       \item{description}{description of logical expression, string}
#'       \item{in_file}{name of file containing slot}
#' }
#' }
#' }
#' @source {data/check_lb_res.yaml}
