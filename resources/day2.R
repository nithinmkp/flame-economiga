library(tsibble)

table <- table <- tibble::tibble(
  date = seq(as.Date("2020-01-01"), by = "month", length.out = 12),
  value = sample(3000:5000, 12)
)

ts(table,start = as.Date("2020-01-01"),
   end = as.Date("2020-12-01"))

table |> 
  as_tsibble(index=date)


library(readr)
gh_data <- read_csv("resources/gh_data.csv")
View(gh_data)


library(tidyr)
library(dplyr)
library(janitor)
gh_data |> 
  clean_names() |> 
  select(-3) |> 
  pivot_longer(-c(1:2),
               names_to = "year") |> 
  mutate(year=parse_number(year)) |> 
  filter(indicator_name=="Population_total") |> 
  as_tsibble(index = year) |> 
  scan_gaps()


sales <- read_csv("resources/sales.csv")  

sales |> 
  mutate(date=lubridate::ym(Date)) |> 
  as_tsibble(index=date) |> 
  scan_gaps()


sales |> 
  mutate(date=lubridate::ym(Date))
