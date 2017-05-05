
source("qserver.R")
h=open_connection()   # default is localhost:5000

execute (h,"sp:([]s:10?`3;p:10?`1;qty:100*10?10)")
s=execute(h,"select[5] from sp")
execute (h,"a:.z.d")
execute (h,"b:a+100 * til 5")
execute (h,"c:.z.z")
execute (h,"d:c+1.23 * til 5")

show(s)
show(execute(h,"b"))
show(execute(h,"d"))

close_connection(h)
