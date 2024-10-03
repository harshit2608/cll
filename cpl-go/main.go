package main

/*
#cgo LDFLAGS: -L./cpl_lib -lcpl
#include <stdlib.h>

// Declaration of the Rust functions
char* go_greet(const char* name);
void free_greeting(char* greeting);
*/
import "C"
import (
	"fmt"
	"unsafe"
)

// Greet is a wrapper function to call the Rust `greet` function.
func Greet(name string) string {
	// Convert Go string to C string
	cName := C.CString(name)
	defer C.free(unsafe.Pointer(cName)) // Free the C string after use

	// Call the Rust function
	greetingPtr := C.go_greet(cName)

	// Convert the returned C string back to Go string
	greeting := C.GoString(greetingPtr)

	// Free the memory allocated by the Rust library
	C.free_greeting(greetingPtr)

	return greeting
}

func main() {
	name := "World"
	greeting := Greet(name)
	fmt.Println(greeting) // Output: Hello, World!
}
