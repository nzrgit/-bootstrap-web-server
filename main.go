package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

func main() {

	fmt.Println("init")

	router := mux.NewRouter()
	srv := &http.Server{
		Handler:      router,
		Addr:         ":8443",
		WriteTimeout: 10 * time.Second,
		ReadTimeout:  10 * time.Second,
	}

	if err := srv.ListenAndServeTLS("server.crt", "server.key"); err != nil {
		fmt.Println(err)
	}

}
