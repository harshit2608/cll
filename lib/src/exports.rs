use crate::greet; // Ensure this matches your greet function's location

#[no_mangle]
pub extern "C" fn greet(name: *const libc::c_char) -> *mut libc::c_char {
    let c_str = unsafe { std::ffi::CStr::from_ptr(name) };
    let name_str = c_str.to_string_lossy().into_owned();
    let greeting = greet::greet(&name_str); // Assuming you have a `greet` function defined
    let c_greeting = std::ffi::CString::new(greeting).unwrap();
    c_greeting.into_raw()
}

#[no_mangle]
pub extern "C" fn free_greeting(greeting: *mut libc::c_char) {
    if greeting.is_null() { return; }
    unsafe {
        let _ = std::ffi::CString::from_raw(greeting);
    }
}
