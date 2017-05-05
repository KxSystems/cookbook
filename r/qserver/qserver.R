
kdbarch <- as.character(as.factor(c("x86_64"="64","i386"="32"))[R.version$arch])
kdbplatform <- as.character(as.factor(c("Darwin"="m","Linux"="l","Windows"="w"))[Sys.info()['sysname']])
dyn.load(file.path(paste0(kdbplatform,kdbarch), paste0("qserver",.Platform$dynlib.ext)))

open_connection <- function(host="localhost", port=5000, user=NULL) {
         parameters <- list(host, as.integer(port), user)
      h <- .Call("kx_r_open_connection", parameters)
    assign(".k.h", h, envir = .GlobalEnv)
    h
}

close_connection <- function(connection) {
	.Call("kx_r_close_connection", as.integer(connection))
}

execute <- function(connection, query) {
	.Call("kx_r_execute", as.integer(connection), query)
}

k <- function(query) {
    h <- get(".k.h", envir = .GlobalEnv)
    execute(h, query)
}
