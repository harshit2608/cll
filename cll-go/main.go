package main

/*
#cgo LDFLAGS: -L./cll_lib -lcll
#include <stdlib.h>

// Declaration of the Rust functions
char* go_greet(const char* name);
void free_greeting(char* greeting);
char* go_fibonacci(const char* n);
void free_result(char* result);
*/
import "C"
import (
	"fmt"
	"strconv"
	"unsafe"
)

func Greet(name string) string {
	cName := C.CString(name)
	defer C.free(unsafe.Pointer(cName))

	greetingPtr := C.go_greet(cName)
	greeting := C.GoString(greetingPtr)
	C.free_greeting(greetingPtr)

	return greeting
}

func Fibonacci(n int) string {
	nStr := strconv.Itoa(n)
	cN := C.CString(nStr)

	defer C.free(unsafe.Pointer(cN))

	resultPtr := C.go_fibonacci(cN)
	result := C.GoString(resultPtr)
	C.free_result(resultPtr)

	return result
}

func main() {
	name := "From Golang Lib!!"
	greeting := Greet(name)
	fmt.Println(greeting)

	n := 12
	fibResult := Fibonacci(n)
	fmt.Printf("Fibonacci of %d: %s\n", n, fibResult)
}
