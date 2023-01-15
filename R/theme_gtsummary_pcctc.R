#' Set PCCTC gtsummary theme
#'
#' Visit the [gtsummary themes vignette](https://www.danieldsjoberg.com/gtsummary/articles/themes.html#writing-themes-1)
#' for a full list of preferences that can be set.
#'
#' @inheritParams gtsummary::theme_gtsummary_compact
#'
#' @family gtsummary-related functions
#' @export
#' @examples
#' theme_gtsummary_pcctc()

theme_gtsummary_pcctc <- function(font_size = NULL) {

  lst_theme_pcctc <-
    gtsummary::theme_gtsummary_compact(set_theme = FALSE, font_size = font_size) %>%
    utils::modifyList(
      val = list("pkgwide-str:theme_name" = "PCCTC"))

  # modify the default font
  lst_theme_pcctc$`as_flex_table-lst:addl_cmds`$valign <-
    c(lst_theme_pcctc$`as_flex_table-lst:addl_cmds`$valign,
      list(rlang::expr(flextable::font(fontname = "Open Sans", part = "all"))))

  lst_theme_pcctc$`as_gt-lst:addl_cmds`$cols_hide <-
    c(lst_theme_pcctc$`as_gt-lst:addl_cmds`$cols_hide,
      list(rlang::expr(gt::tab_options(table.font.names = "Open Sans"))))

  # setting theme
  gtsummary::set_gtsummary_theme(lst_theme_pcctc)
}


