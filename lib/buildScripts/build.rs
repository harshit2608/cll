use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let project_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    let config_path = PathBuf::from(&project_dir).join("cbindgen.toml");

    let out_dir = PathBuf::from(&project_dir).join("build").join("cll.h");

    let status = Command::new("cbindgen")
        .arg("--config")
        .arg(config_path)
        .arg("--crate")
        .arg("cll")
        .arg("--output")
        .arg(out_dir)
        .status()
        .expect("Failed to run cbindgen");

    if !status.success() {
        panic!("cbindgen failed to generate the header file");
    }
}
