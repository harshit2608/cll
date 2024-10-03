#[no_mangle]
pub extern "C" fn node_greet(name: *const i8) {
    let c_str = unsafe { std::ffi::CStr::from_ptr(name) };
    let str_slice = c_str.to_str().unwrap();
    println!("Hello, {}!", str_slice);
}
