yahoo: {[offset;stocks]
	tbl:();i:0;zs:(ze:.z.d)-offset;
    parms:"&d=",(string -1+`mm$ze),"&e=",(string`dd$ze),"&f=",(string`year$ze),"&g=d&a=",(string -1+`mm$zs),"&b=",(string`dd$zs),"&c=",(string`year$zs),"&ignore=.csv";
    do[count stocks:distinct stocks,();
        txt:`:http://ichart.finance.yahoo.com "GET /table.csv?s=",(string stock:stocks[i]),parms," http/1.0\r\nhost:ichart.finance.yahoo.com\r\n\r\n";
		tbl,:update Sym:stock from select from ("DEEEEI ";enlist",")0:(txt ss"Date,Open")_ txt;i+:1];
    (lower cols tbl)xcol`Date`Sym xasc select from tbl where not null Volume}  
