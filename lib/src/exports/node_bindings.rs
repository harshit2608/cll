use crate::core::greet::greet as rust_greet;
use crate::core::fibonacci::fibonacci as rust_fibonacci;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn node_greet(name: *const c_char) -> *mut c_char {
    let c_str = unsafe { CStr::from_ptr(name) };
    let name_str = c_str.to_string_lossy().into_owned();

    let greeting = rust_greet(&name_str);
    let c_greeting = CString::new(greeting).unwrap();
    c_greeting.into_raw()
}

#[no_mangle]
pub extern "C" fn node_fibonacci(n: *const c_char) -> *mut c_char {
    let c_str = unsafe { CStr::from_ptr(n) };
    let n_str = c_str.to_string_lossy().into_owned();
    let n_u32: u32 = n_str.parse().unwrap();

    let result = rust_fibonacci(n_u32);
    let result_str = result.to_string();

    let c_result = CString::new(result_str).unwrap();
    c_result.into_raw()
}

#[no_mangle]
pub extern "C" fn free_result(result: *mut c_char) {
    if !result.is_null() {
        unsafe {
            let _ = CString::from_raw(result);
        }
    }
}
