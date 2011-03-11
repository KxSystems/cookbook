# example of using Q server

source("c:/r/qserver.r")
c <- open_connection()
t <- execute(c, "select from t")
# close_connection(c)
