use std::fs::create_dir_all;

use crate::{error::Result, APP_DIR};

pub fn init() -> Result<()> {
    // init books dir
    let books_dir = APP_DIR.get().unwrap().join("books");
    create_dir_all(books_dir)?;
    Ok(())
}
