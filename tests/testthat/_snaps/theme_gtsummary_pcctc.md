# theme_gtsummary_pcctc() works

    Code
      gtsummary::trial %>% gtsummary::tbl_summary(by = trt, include = age) %>%
        gtsummary::as_tibble()
    Output
      # A tibble: 2 x 3
        `**Characteristic**` `**Drug A**  \nN = 98` `**Drug B**  \nN = 102`
        <chr>                <chr>                  <chr>                  
      1 Age                  46 (37, 60)            48 (39, 56)            
      2 Unknown              7                      4                      

