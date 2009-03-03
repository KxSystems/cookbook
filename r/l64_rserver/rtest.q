/ test R server for Q

\l rinit.q

Ropen 0
Rcmd "a=array(1:24,c(2,3,4))"
Rget "dim(a)"
Rget "a"
Rget "dim(a)"
a:Rget "a"

Rcmd "b= 2 == array(1:24,c(2,3,4))"
Rget "dim(b)"
Rget "b"
Rget "dim(b)"
Rget "b"

Rget "1.1*array(1:24,c(2,3,4))"
Rset["xyz";1 2 3]
Rget "xyz"

Rget "pi"
Rget "2+2";

Rget "11:11"
Rget "11:15"
a:Rget "matrix(1:6,2,3)"
a[1]
a:Rget "array(1:24,c(2,3,4))"
b:a[1]
b

Rcmd "pdf(\"/home/chris/temp/t1.pdf\")"
Rcmd "plot(c(2,3,5,7,11))"
Rcmd "dev.off()"

Rcmd "a=c(2,3,5)"
Rget "a"
Rcmd "a=2:5"
Rget "a"
Rget "2+3"
Rget "pi"
Rcmd "x=factor(c(\"one\",\"two\",\"three\",\"four\"))"
Rget "x"
Rget "mode(x)"
Rget "typeof(x)"
Rcmd "m=array(1:24,c(2,3,4))"
Rget "m"
Rget "length(m)"
Rget "dim(m)"
Rget "c(TRUE,FALSE,NA,TRUE,TRUE,FALSE)"
Rcmd "foo <- function(x,y) {x + 2 * y}"
Rget "foo"
Rget "typeof(foo)"
Rget "foo (5,3)"
Rget "c(1,2,Inf,-Inf,NaN,NA)"

Rget "wilcox.test(c(1,2,3),c(4,5,6))"

Rcmd "data(OrchardSprays)"
a:Rget "OrchardSprays"
a
