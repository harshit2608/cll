pub fn greet(name: &str) -> String {
    format!("Hello, {}!\n", name)
}

#[cfg(test)]
mod tests {
    use crate::exports;

    use super::*; // Bring the parent module's items into scope
    use std::ffi::{CStr, CString};

    #[test]
    fn test_direct_greet() {
      let result = greet("Alice");
      assert_eq!(result, "Hello, Alice!\n");
    }

    #[test] // Mark this function as a test case
    fn test_greet() {
        let name = "Alice";

        // Convert name to C-compatible string
        let c_name = CString::new(name).unwrap();

        // Call the exported greet function
        let greeting_ptr = unsafe { exports::greet(c_name.as_ptr()) };

        // Convert the returned C string back to a Rust string
        let greeting = unsafe { CStr::from_ptr(greeting_ptr).to_string_lossy().into_owned() };

        // Check the expected output
        let expected_greeting = format!("Hello, {}!\n", name);
        assert_eq!(greeting, expected_greeting);

        // Free the memory allocated by the Rust library
        unsafe { exports::free_greeting(greeting_ptr) };
    }
}
