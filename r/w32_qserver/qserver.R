dyn.load("c:/r/qserver.dll")

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
