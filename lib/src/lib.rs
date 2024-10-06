#[cfg(feature = "go")]
pub mod exports {
    pub mod go_bindings;
}

#[cfg(feature = "java")]
pub mod exports {
    pub mod java_bindings;
}

#[cfg(feature = "node")]
pub mod exports {
    pub mod node_bindings;
}

pub mod core;
pub use core::{fibonacci, greet};
