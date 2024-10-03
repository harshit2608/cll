extern crate jni;

use crate::greet::greet as rust_greet;
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
pub extern "system" fn Java_cll_App_freeGreeting(_env: JNIEnv, _class: JClass, _greeting: jstring) {
    // No manual freeing required in Java
}
