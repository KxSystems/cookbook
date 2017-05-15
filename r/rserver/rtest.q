/ test R server for Q
\l rinit.q

Ropen 0

Rcmd "a=array(1:24,c(2,3,4))"
Rget "dim(a)"
Rget "a"

if[3<=.z.K;Rset["a";2?0Ng]]
Rget "a"

Rcmd "b= 2 == array(1:24,c(2,3,4))"
Rget "dim(b)"
Rget "b"

Rget "1.1*array(1:24,c(2,3,4))"

Rset["xyz";1 2 3i]
Rget "xyz"

Rget "pi"
Rget "2+3";
Rget "11:11"
Rget "11:15"
a:Rget "matrix(1:6,2,3)"
a[1]
Rcmd "m=array(1:24,c(2,3,4))"
Rget "m"
Rget "length(m)"
Rget "dim(m)"
Rget "c(1,2,Inf,-Inf,NaN,NA)"

Rcmd "pdf(tempfile(\"t1\",fileext=\".pdf\"))"
Rcmd "plot(c(2,3,5,7,11))"
Rcmd "dev.off()"

Rcmd "x=factor(c('one','two','three','four'))"
Rget "x"
Rget "mode(x)"
Rget "typeof(x)"
Rget "c(TRUE,FALSE,NA,TRUE,TRUE,FALSE)"
Rcmd "foo <- function(x,y) {x + 2 * y}"
Rget "foo"
Rget "typeof(foo)"
Rget "foo (5,3)"

Rget "wilcox.test(c(1,2,3),c(4,5,6))"
Rcmd "data(OrchardSprays)"
a:Rget "OrchardSprays"
a

// to install package in non-interactive way
// install.packages("zoo", repos="http://cran.r-project.org")
Rget"install.packages"
//'Broken R object.
Rget".GlobalEnv"
//"environment"
Rget"emptyenv()"
//"environment"
Rget".Internal"
//"special"
@[Rcmd;"typeof(";like[;"incomplete: *"]]
@[Rcmd;"typeof()";like[;"eval error*"]]
Rget each ("cos";".C";"floor";"Im";"cumsum";"nargs";"proc.time";"dim";"length";"names";".External")
Rget "getGeneric('+')"
Rget"as.raw(10)"
Rget"as.logical(c(1,FALSE,NA))"
Rget"1:10"
// data.frame
Rget"data.frame(a=1:3, b=c('a','b','c'))"
Rget"data.frame(a=1:3, b=c('a','b','c'),stringsAsFactors=FALSE)"
Rget"data.frame(a=1:3)"
Rget"data.frame()"
// dates
Rget"as.Date('2005-12-31')"
Rget"as.Date(NA)"
Rget"rep(as.Date('2005-12-31'),2)"



//lang
Rget "as.pairlist(1:10)"
Rget "as.pairlist(TRUE)"
Rget "as.pairlist(as.raw(1))"
Rget "pairlist('rnorm', 10L, 0.0, 2.0 )"
Rget "list(x ~ y + z)"
Rget "list( c(1, 5), c(2, 6), c(3, 7) )"
Rget "matrix( 1:16+.5, nc = 4 )"
Rget "Instrument <- setRefClass(Class='Instrument',fields=list('id'='character', 'description'='character'))"
Rget "Instrument$accessors(c('id', 'description'))"
Rget "Instrument$new(id='AAPL', description='Apple')"
Rget "(1+1i)"
Rget "(0:9)^2"
Rget"expression(rnorm, rnorm(10), mean(1:10))"
Rget"list( rep(NA_real_, 20L), rep(NA_real_, 6L) )"
Rget"c(1, 2, 1, 1, NA, NaN, -Inf, Inf)"

// long vectors
Rcmd"x<-c(as.raw(1))"
//Rcmd"x[2147483648L]<-as.raw(1)"
count Rget`x

.[Rset;("x[0]";1);"nyi"~]
Rget["c()"]~Rget"NULL"
()~Rget"c()"
{@[Rget;x;"type"~]}each (.z.p;0b;1;1f;{};([1 2 3]1 2 3))
Rset[`x;1]
Rget each ("x";enlist "x";`x;`x`x)  // ("x";"x")?
Rcmd"rm(x)"

// run gc
Rget"gc()"

Rset["a";`sym?`a`b`c]
`:x set string 10?`4
Rset["a";get `:x]
hdel `:x;

Rinstall`data.table
Rcmd"library(data.table)"
Rcmd"a<-data.frame(a=c(1,2))"
Rget`a
Rcmd "b<-data.table(a=c(1,2))"
Rget`b
Rcmd"inspect <- function(x, ...) .Internal(inspect(x,...))"
Rget`inspect
Rget"substitute(log(1))"
