library("devtools")

res <- revdep_check()
revdep_check_save_summary()
revdep_check_print_problems()
revdep_email(date = "Jan 26", only_problems = FALSE, draft = TRUE)
