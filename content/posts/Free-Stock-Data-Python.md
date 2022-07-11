
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