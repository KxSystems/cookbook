/ the API wants dates as yyyy-mm-dd
iso: ssr[;".";"-"] string@;
/ prices arrive as strings such as "$266.93" and volumes as "51,523,180"
clean: except[;"$,"];

// @desc Queries historical daily prices from the Nasdaq API
// and returns a table of trading info for
// a list of stocks over the last few days. No API key is needed.
// Requires HTTPS support in q (OpenSSL libraries and a CA certificate file).
// Yahoo's replacement API rejects requests without a User-Agent header, which .Q.hg
// does not send, so it cannot be used here.
// @param ndays  {short|int|long}  Number of calendar days to look back from today.
// @param stocks {symbol|symbol[]} Ticker symbols; duplicates are removed.
// @return       {table}           Columns Date, Sym, Open, High, Low, Close and Volume.
//                                 Non-trading days are absent.
//                                 Signals 'no data for <sym> if a symbol is unknown.
// @example
// yahoo[10;`GOOG`AMZN]
// /=> Date       Sym  Open    High     Low      Close  Volume
// /=> ---------------------------------------------------------
// /=> 2026.11.02 AMZN 243.01  253.81   242.28   245.63 58347980
// /=> 2026.11.02 GOOG 280.575 285.2099 277.78   278.04 29231780
// /=> ..
yahoo:{[ndays;stocks]
 / ensure that stocks is a list (it might be a single symbol) and then get rid of duplicates, if any
 stocks: distinct stocks,();
 enddate: .z.d; / .z.d gives current date
 startdate: enddate-ndays;
 :raze {[startdate:`d; enddate:`d; stock:`s]
     url: "https://api.nasdaq.com/api/quote/",(string stock),"/historical?assetclass=stocks&limit=9999&fromdate=",(iso startdate),"&todate=",iso enddate;
     / .Q.hg sends the HTTP GET request and returns the response body as a string; .j.k parses the JSON
     resp: .j.k .Q.hg `$":",url;
     / an unknown symbol comes back with data:null
     if[not 99h=type resp`data; :()];
     rows: resp[`data][`tradesTable][`rows]; / list of dictionaries, one per day
     if[count rows;
       stocktable: select Date:"D"$date, Sym:stock, Open:"F"$clean each open, High:"F"$clean each high, Low:"F"$clean each low, Close:"F"$clean each close, Volume:"J"$clean each volume from rows;
       :stocktable];
      :();
  }[startdate; enddate] each stocks;
  }
