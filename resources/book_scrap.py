# imports
from bs4 import BeautifulSoup as bs
import requests
import polars as pl
import re
import time

# set the base URL
base_url = "https://books.toscrape.com/"

# User agent to mimic a browser visit
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36"
}


# Scrapping Function
def scrape_books(url, start, end, headers=headers):
    full_links = []
    for pg in range(start, end):
        new_url = f"{url}catalogue/page-{pg}.html"
        r = requests.get(new_url, headers=headers)
        soup = bs(r.content, "lxml")
        books = soup.find_all("article", class_="product_pod")
        for book in books:
            link = book.find("a", href=True)["href"]
            full_links.append(base_url + "catalogue/" + link)
        time.sleep(2)

    book_data = []
    for link in full_links:
        soup2 = bs(requests.get(link).content, "lxml")
        if soup2.find("p", class_="price_color") is not None:
            price = soup2.find("p", class_="price_color").text.strip()
        else:
            price = "NA"
        if soup2.find("p", class_="instock availability") is not None:
            stock = soup2.find("p", class_="instock availability").text.strip()
        else:
            stock = "NA"
        my_dict = {
            "name": soup2.find("h1").text.strip(),
            "price": price,
        }
        if "available" in stock:
            my_dict["stock"] = "available"
            my_dict["available_number"] = int(
                re.search(
                    r"\d+",
                    soup2.find("p", class_="instock availability").text.strip().lower(),
                ).group()
            )
        else:
            my_dict["stock"] = "not available"
            my_dict["available_number"] = "Not Applicable"
        book_data.append(my_dict)
        time.sleep(1)
    df = pl.DataFrame(book_data)
    df = df.with_columns(
        [
            # extract numeric part
            pl.col("price").str.extract(r"(\d+\.?\d*)", 1).cast(pl.Float64),
            # extract currency symbol
            pl.col("price").str.extract(r"([£$€])", 1).alias("currency"),
        ]
    ).sort("price", descending=True)
    return df


def main():
    df = scrape_books(base_url, 1, 5)
    print(df)


if __name__ == "__main__":
    main()
else:
    None
