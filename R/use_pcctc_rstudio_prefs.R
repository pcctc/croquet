#' Use Data Science RStudio Preferences
#'
#' @description
#' The function wraps `rstudio.prefs::use_rstudio_prefs()` and sets the following
#' preferences in RStudio.
#'
#' ```{r, echo = FALSE}
#' data_science_prefs %>%
#'   purrr::map(as.character) %>%
#'   unlist() %>%
#'   tibble::enframe() %>%
#'   rlang::set_names(c("**Preference**", "**Value**")) %>%
#'   knitr::kable()
#' ```
#' @param profile Used to set additional preferences saved under specified profile.
#' Default is your current system username. If no profile exists, it is ignored.
#'
#' @export
#'
#' @examplesIf FALSE
#' use_pcctc_rstudio_prefs()

use_pcctc_rstudio_prefs <- function(profile = tolower(Sys.info()[["user"]])) {
  # adding user-specific preferences -------------------------------------------
  if (profile %in% names(profile_prefs)) {
    cli::cli_alert_info("Adding {.val {profile}} preferences...")
    data_science_prefs <-
      data_science_prefs %>%
      utils::modifyList(val = profile_prefs[[profile]])
  }

  # apply preferences ----------------------------------------------------------
  rstudio.prefs::use_rstudio_prefs(!!!data_science_prefs)
}


# save preferences in list -----------------------------------------------------
# default list for all users
data_science_prefs <-
  list(
    always_save_history = FALSE,
    graphics_backend = "ragg",
    load_workspace = FALSE,
    show_hidden_files = TRUE,
    show_line_numbers = TRUE,
    margin_column = 80L,
    save_workspace = "never",
    rainbow_parentheses = TRUE
  )

# personalized preferences. These are ADDED to the defaults
profile_prefs <-
  list(
    "sjobergd" = list(highlight_selected_line = TRUE,
                      show_indent_guides = TRUE,
                      show_terminal_tab = TRUE,
                      use_tinytex = TRUE,
                      auto_save_on_blur = TRUE,
                      code_completion_delay = 150L,
                      document_author = "Daniel D. Sjoberg",
                      insert_native_pipe_operator = TRUE,
                      show_invisibles = FALSE,
                      restore_last_project = FALSE,
                      rmd_chunk_output_inline = FALSE,
                      show_last_dot_value = TRUE,
                      show_margin = TRUE,
                      show_invisibles = TRUE)
  )
