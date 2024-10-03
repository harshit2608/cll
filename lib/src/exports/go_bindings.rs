extern crate libc;

use crate::greet::greet as rust_greet;
use std::ffi::{CStr, CString};

#[no_mangle]
pub extern "C" fn go_greet(name: *const libc::c_char) -> *mut libc::c_char {
    let c_str = unsafe { CStr::from_ptr(name) };   // Convert C string to Rust string
    let name_str = c_str.to_string_lossy().into_owned();

    let greeting = rust_greet(&name_str);  // Call the Rust greet function

    let c_greeting = CString::new(greeting).unwrap(); // Convert the Rust string to CString
    c_greeting.into_raw()  // Return raw pointer
}

#[no_mangle]
pub extern "C" fn free_greeting(greeting: *mut libc::c_char) {
    if !greeting.is_null() {
        unsafe {
            let _ = CString::from_raw(greeting); // Free the memory
        }
    }
}
