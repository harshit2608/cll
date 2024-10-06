extern crate jni;

use crate::{greet::greet as rust_greet, core::fibonacci::fibonacci as rust_fibonacci};
use jni::objects::{JClass, JString};
use jni::sys::jstring;
use jni::JNIEnv;

#[no_mangle]
pub extern "system" fn Java_cll_App_greet(env: JNIEnv, _class: JClass, name: JString) -> jstring {
    let input: String = env.get_string(name).expect("Couldn't get Java string!").into();
    let greeting = rust_greet(&input);
    env.new_string(greeting).expect("Couldn't create Java string").into_raw()
}

#[no_mangle]
pub extern "system" fn Java_cll_App_fibonacci(env: JNIEnv, _class: JClass, n: JString) -> jstring {
    let input: String = env.get_string(n).expect("Couldn't get Java string!").into();
    let n_u32: u32 = input.parse().expect("Couldn't parse string to u32!");

    let result = rust_fibonacci(n_u32);
    let result_str = result.to_string();

    env.new_string(result_str).expect("Couldn't create Java string").into_raw()
}

#[no_mangle]
pub extern "system" fn Java_cll_App_freeResult(_env: JNIEnv, _class: JClass, _result: jstring) {
    // No manual freeing required in Java, handled by JVM garbage collector
}
