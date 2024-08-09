package main

import (
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

func main() {

	fmt.Println("init")

	router := mux.NewRouter()

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		io.WriteString(w, "These aren't the droids you're looking for...\n")
	})

	router.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		io.WriteString(w, "ok\n")
	})

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
