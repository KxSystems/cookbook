
source("qserver.R")
h=open_connection()

execute (h,"\\l sp.q")
s=execute(h,"select[5] from sp")
execute (h,"a;.z.d")
execute (h,"b:a+100 * til 5")
execute (h,"c:.z.z")
execute (h,"d:c+1.23 * til 5")

show(s)
show(execute(h,"d"))

# close_connection(h)
