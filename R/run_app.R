#' Run the app to find the best surf spots for a given time of the year.
#'
#' @return Called for its side effect.
#' @export
#'
#' @examples
#' if (interactive()) run_app()
run_app <- function() {
  ui <- fluidPage(
    show_supported_countries(),
    show_details_url(),
    DT::DTOutput("best_conditions")
  )

  server <- function(input, output, session) {
    output$best_conditions <- DT::renderDT(surfcast::best_conditions)
  }

  shinyApp(ui, server)
}
