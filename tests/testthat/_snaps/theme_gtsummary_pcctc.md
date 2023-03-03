# theme_gtsummary_pcctc() works

    Code
      gtsummary::trial %>% gtsummary::tbl_summary(by = trt, include = age) %>%
        gtsummary::add_p() %>% gtsummary::as_tibble()
    Output
      # A tibble: 2 x 4
        `**Characteristic**` `**Drug A**, N = 98` `**Drug B**, N = 102` `**p-value**`
        <chr>                <chr>                <chr>                 <chr>        
      1 Age                  46 (37, 59)          48 (39, 56)           0.7          
      2 Unknown              7                    4                     <NA>         

