df <- tibble::tribble(
         ~Country, ~`GDP.(USD.Trillions)`, ~`Population.(Millions)`, ~`GDP.per.Capita.(USD)`,
          "India",                   3.75,                    1400L,                   2679L,
  "United States",                  27.36,                     338L,                  80944L,
          "China",                  17.92,                    1412L,                  12679L,
          "Japan",                   4.21,                     125L,                  33733L,
        "Germany",                   4.31,                      84L,                  51285L
  )


df2 <- tibble::tribble(
         ~Country, ~`GDP.(USD.Trillions)`, ~`Population.(Millions)`, ~`GDP.per.Capita.(USD)`,
          "India",                   3.75,                    1400L,                   2679L,
  "United States",                  27.36,                     338L,                  80944L,
          "China",                  17.92,                    1412L,                  12679L,
          "Japan",                   4.21,                     125L,                  33733L,
        "Germany",                   4.31,                      84L,                  51285L
  )



library(rvest)
# From local file
soup <- read_html("resources/demo_page.html")
# Print
print(soup)
# Select all section divs
sections <- html_elements(soup, "div section")
# Extract exercises from each section
exercies <- sections |> 
  html_elements("h2") |>
  html_text2() |>
  stringr::str_subset("^Exercise")
print(exercies)