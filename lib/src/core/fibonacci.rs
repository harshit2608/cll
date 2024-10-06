pub fn fibonacci(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}

#[cfg(test)]
mod tests {
    use crate::exports;

    use super::*;
    use std::ffi::{CStr, CString};

    #[test]
    fn test_direct_fibonacci() {
        assert_eq!(fibonacci(0), 0);
        assert_eq!(fibonacci(1), 1);
        assert_eq!(fibonacci(2), 1);
        assert_eq!(fibonacci(3), 2);
        assert_eq!(fibonacci(4), 3);
        assert_eq!(fibonacci(5), 5);
        assert_eq!(fibonacci(6), 8);
    }

    #[test]
    fn test_fibonacci() {
        let n: u32 = 5;
        let c_n = CString::new(n.to_string()).unwrap();

        let result_ptr = unsafe { exports::fibonacci(c_n.as_ptr()) };

        let result = unsafe { CStr::from_ptr(result_ptr).to_string_lossy().parse::<u32>().unwrap() };
        assert_eq!(result, 5);
        unsafe { exports::free_result(result_ptr) };
    }
}
