// Goal: To do `moving window volatility' of returns.
// http://www.mayin.org/ajayshah/KB/R/html/p4.html
//\l rtest.q
// check if lib installed 
if[0i=first Rget"is.element(\"zoo\",installed.packages()[,1])";Rcmd"install.packages(\"zoo\",repos=\"https://cloud.r-project.org\")"]
Rcmd"library(zoo)";

// Some data to play with (Nifty on all fridays for calendar 2004) --
pr:1946.05 1971.9 1900.65 1847.55 1809.75 1833.65 1913.6 1852.65 1800.3 1867.7 1812.2 1725.1 1747.5 1841.1 1853.55 1868.95 1892.45 1796.1 1804.45 1582.4 1560.2 1508.75 1521.1 1508.45 1491.2 1488.5 1537.5 1553.2 1558.8 1601.6 1632.3 1633.4 1607.2 1590.35 1609 1634.1 1668.75 1733.65 1722.5 1775.15 1820.2 1795 1779.75 1786.9 1852.3 1872.95 1872.35 1901.05 1996.2 1969 2012.1 2062.7 2080.5
d: 2004.01.02 2004.01.09 2004.01.16 2004.01.23 2004.01.30 2004.02.06 2004.02.13 2004.02.20 2004.02.27 2004.03.05 2004.03.12 2004.03.19 2004.03.26 2004.04.02 2004.04.09 2004.04.16 2004.04.23 2004.04.30 2004.05.07 2004.05.14 2004.05.21 2004.05.28 2004.06.04 2004.06.11 2004.06.18 2004.06.25 2004.07.02 2004.07.09 2004.07.16 2004.07.23 2004.07.30 2004.08.06 2004.08.13 2004.08.20 2004.08.27 2004.09.03 2004.09.10 2004.09.17 2004.09.24 2004.10.01 2004.10.08 2004.10.15 2004.10.22 2004.10.29 2004.11.05 2004.11.12 2004.11.19 2004.11.26 2004.12.03 2004.12.10 2004.12.17 2004.12.24 2004.12.31
Rset[`d;d]
Rset[`pr;pr]
Rcmd"p <- structure(pr, index = d, frequency = 0.142857142857143, class = c(\"zooreg", "zoo\"))";

// Shift to returns --
Rcmd"r <- 100*diff(log(p))";
Rget"head(r)"
Rget"summary(r)"
Rget"sd(r)"

// Compute the moving window vol --
Rcmd"vol <- sqrt(250) * rollapply(r, 20, sd, align = \"right\")";

// A pretty plot --
Rcmd"png('pretty_plot_test.png')";
Rcmd"plot(vol, type=\"l\", ylim=c(0,max(vol,na.rm=TRUE)),lwd=2, col=\"purple\", xlab=\"2004\",ylab=paste(\"Annualised sigma, 20-week window\"))";
Rcmd"grid()";
Rget"legend(x=\"bottomleft\", col=c(\"purple\", \"darkgreen\"),lwd=c(2,2), bty=\"n\", cex=0.8,legend=c(\"Annualised 20-week vol (left scale)\", \"Nifty (right scale)\"))"
Rcmd"par(new=TRUE)";
Rcmd"plot(p, type=\"l\", lwd=2, col=\"darkgreen\", xaxt=\"n\", yaxt=\"n\", xlab=\"\", ylab=\"\")";
Rcmd"axis(4)";
Roff[]
hcount `:pretty_plot_test.png
//hdel `:pretty_plot_test.png
