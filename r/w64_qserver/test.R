# example of using Q server

source("c:/r/qserver.r")
c <- open_connection()

execute(c, "\\l sp.q")
show(execute(c, "select from s"))
show(execute(c, ".z.p"))
show(execute(c, ".z.P-.z.p"))
show(execute(c, "2?0Ng"))

# close_connection(c)
