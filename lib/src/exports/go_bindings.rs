extern crate libc;

use crate::core::greet::greet as rust_greet;
use crate::core::fibonacci::fibonacci as rust_fibonacci;
use std::ffi::{CStr, CString};

#[no_mangle]
pub extern "C" fn go_greet(name: *const libc::c_char) -> *mut libc::c_char {
    let c_str = unsafe { CStr::from_ptr(name) };
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

#[no_mangle]
pub extern "C" fn go_fibonacci(n: *const libc::c_char) -> *mut libc::c_char {
    let c_str = unsafe { CStr::from_ptr(n) };
    let n_str = c_str.to_string_lossy().into_owned();
    let n_u32: u32 = n_str.parse().unwrap();

    let result = rust_fibonacci(n_u32);
    let result_str = result.to_string();

    let c_result = CString::new(result_str).unwrap();
    c_result.into_raw()
}

#[no_mangle]
pub extern "C" fn free_result(result: *mut libc::c_char) {
    if !result.is_null() {
        unsafe {
            let _ = CString::from_raw(result);
        }
    }
}
