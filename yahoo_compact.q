yahoo: {[offset;stocks]
    tbl:();i:0;zs:(ze:`date$.z.z)-offset;
    parms:"&d=",(string -1+`mm$ze),"&e=",(string`dd$ze),"&f=",(string`year$ze),"&g=d&a=",(string -1+`mm$zs),"&b=",(string`dd$zs),"&c=",(string`year$zs),"&ignore=.csv";
    do[count stocks:distinct stocks,();
        txt:`:http://ichart.finance.yahoo.com "GET /table.csv?s=",(string stock:stocks[i]),parms," http/1.1\r\nhost:ichart.finance.yahoo.com\r\n\r\n";
        tbl,:update Sym:stock from select from ("*EEEEI ";enlist",")0:(txt ss"Date,Open")_ txt;            i+:1];
    (lower cols tbl)xcol`Date`Sym xasc update Date:{"D"$(-2_x),"20",-2#x:-9#"0",x} each Date from select from tbl where not null Volume}  
