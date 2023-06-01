# croquet (development version)

* When applying a column label with `set_derived_variable_labels()`, the function will report on any columns whose names end in `.x` or `.y`, as these are likely the result of a merge error.

* When applying a column label with `set_derived_variable_labels()`, the function now reports which columns are being dropped. The report is by the case of the variables, e.g. all lowercase variables are reported together. 

# croquet 0.4.0

### Breaking Change

* The labels file in `set_derived_variable_labels()` must now be a CSV with columns `"df_name"`, `"df_label"`, `"var_name"`, and `"var_label"`.

# croquet 0.3.1

* Updated the PCCTC gtsummary theme to place levels and cohort size on separate lines in the headers of `gtsummary::tbl_summary(by=)`. The cohort sizes presented in the header are also now formatted with `gtsummary::style_number()`. (#23)

# croquet 0.3.0

* Migrated `here_data()` and all project template functions and data objects to an internal package.

* Updated project template to work with data saved in SharePoint.

# croquet 0.2.1

* Fix to derived variables label Excel file path in setup template file.

# croquet 0.2.0

* Added a draft of the project template, including new functions `create_pcctc_project()`, `add_project_directory()`, `use_pcctc_file()`, `use_pcctc_analysis()`, `use_pcctc_setup()`, `use_pcctc_report()`, `use_pcctc_gitignore()`.

* Added functions to select all upper case (`all_uppercase()`), lower case (`all_lowercase()`), and columns with label attributes (`all_labelled()`).

* Re-exporting the `dplyr::select()` function.

* Re-exporting the `here::here()` function.

# croquet 0.1.0

* Initial release.
