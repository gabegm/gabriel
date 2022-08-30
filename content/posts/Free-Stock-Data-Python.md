---
layout: post
draft: true
unlisted: false
title: How To Get Free Historical Stock Data in Python
author: Gabriel Gauci Maistre
description: 
summary: 
images:
- /images/stonks.jpeg
image: /images/stonks.jpeg
audio: []
series: []
videos: []
tags:
- python
- stocks
date: 2022-07-08 10:00:00 +0000
---

![alt text](/images/stonks.jpeg "I have no idea what I'm doing")

It's recently become apparent to me that collecting somewhat good quality end-of-day stock price data has turned into a real pain, with [today's listed alternatives](https://fxgears.com/index.php?threads/how-to-acquire-free-historical-tick-and-bar-data-for-algo-trading-and-backtesting-in-2020-stocks-forex-and-crypto-currency.1229/#post-19298) alternatives being somewhat lacking compared to what I had used a few years ago for my bachelor thesis project on algorithmic trading.

Which is why I decided to write a script to do this for fun ~~and profit~~.

The first thing that pops up when you search for AAPL on [DuckDuckGo](https://duckduckgo.com/?q=aapl&t=newext&atb=v315-1&ia=stock) is [Yahoo Finance](https://duckduckgo.com/?q=aapl&t=newext&atb=v315-1&ia=stock). Yahoo has been providing stock date for quite a long time now, and used to provide an easy way to retrieve end-of-day data in the past, however since the last few years this has no longer been the case.

Glacing at the network tab in my browser's developer tools, I can see that my browser has made a `GET` request to Yahoo Finance for `AAPL` ticker with a few other options.

![alt text](/images/yahoo-finance.png "Yahoo Finance GET request")

Diving deeper into this GET request, I can see that Yahoo Finance returned some data in its response.

![alt text](/images/yahoo-finance-response.png "Yahoo Finance response")

And opening the particular request in a new tab allows me to view the full response and save it to a JSON file should I wish to do so.

This would of course be quite tedious to do for each symbol we're interested in, for each day. What if we could automate this process and transform the data into a structured format such as a DataFrame for further wrangling?

Navigating to the "Historical Data" tab, the page provides us with a download button. The URL behind this button is as follows:

* https://query1.finance.yahoo.com/v7/finance/download/ -> base URL
* AAPL -> symbol
* ?period1=1630328849 -> period start
* &period2=1661864849 -> period end
* &interval=1 -> frequecncy of data
* d&events=history -> type of Yahoo Finance event
* &includeAdjustedClose=true -> whether to include adjusted close figures

At first glance this API looks quite straight forward, we just have a few questions.

* Can I pass multiple symbols in the same API GET request?
* When kind of date range is `1630328849:1661864849`?
* Can I get a list of symbols?

The date ranges are in [Unix time](https://en.wikipedia.org/wiki/Unix_time), which is a system in computing for describing a point in time. Since we're not computers, this means that we'll need a way to convert dates to Unix time.

The Yahoo Fiance API doesn't seem to care if there's is now data for a particular date and will simply return data for a date range which it has. This works great for us, which is why I used `01/01/1970` as a default start date.

Lucky for us, Python provides a module to convert such a date.

```py
from datetime import datetime, timezone

dt_start = int(datetime(1970, 1, 1, 0, 0, 0, 0, tzinfo=timezone.utc).timestamp())
dt_end = int(datetime.now().timestamp())
```

## Full source code

```py
import urllib.request
import pandas as pd
from datetime import datetime, timezone
import logging
import time
import random
import csv

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

class ticker:
    def __init__(self, symbol: str, start: int, end: int, interval: str, events: str, adjust_close: bool) -> None:
        self.base = "https://query1.finance.yahoo.com/v7/finance/download/"
        self.symbol = symbol
        self.start = start
        self.end = end
        self.interval = interval
        self.events = events
        self.adjust_close = adjust_close
        self.url = self._url_builder()

    def _url_builder(self):
        return (
            self.base +
            self.symbol + '?' +
            f"period1={self.start}" + '&' +
            f"period2={self.end}" + '&' +
            f"interval={self.interval}" + '&' +
            f"events={self.events}" + '&' +
            f"includeAdjustedClose={self.adjust_close}"
        )

    def save(self) -> tuple:
        self.file, self.headers = urllib.request.urlretrieve(self.url, f"data/raw/{self.symbol}.csv")

        return self

    def read(self) -> pd.DataFrame:
        df = pd.read_csv(self.file, parse_dates=["Date"])
        df.columns = [s.lower().replace(' ', '_') for s in df.columns]
        df["symbol"] = self.symbol

        return df

def get_tickers():
    url = "https://github.com/rreichel3/US-Stock-Symbols/raw/main/all/all_tickers.txt"

    tickers = urllib.request.urlopen(url).read().decode("utf-8").split("\n")

    with open("data/processed/tickers.csv", 'w', newline='') as f:
        wr = csv.writer(f)
        wr.writerow(tickers)

    return tickers

dt_start = int(datetime(1970, 1, 1, 0, 0, 0, 0, tzinfo=timezone.utc).timestamp())
dt_end = int(datetime.now().timestamp())

df_tickers = pd.DataFrame({})
tickers = get_tickers()

for symbol in tickers:
    try:
        logging.info(symbol)

        df = ticker(
                symbol = symbol,
                start = dt_start,
                end = dt_end,
                interval = "1d",
                events = "history",
                adjust_close = True
            ).save().read()

        logging.info(f"{len(df)} rows")

        df_tickers = pd.concat([df_tickers, df], ignore_index=True)
    except Exception as e:
        logging.error(f"Unable to retrieve {symbol}")

    time.sleep(random.uniform(1, 3))

df_tickers.to_csv(f"data/processed/tickers-{dt_end}.csv", index=False)
```