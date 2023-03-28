use std::{fs::File, io::Read};

use base64::Engine;

use crate::{
    db::DbPool,
    models::book::{self, Book},
};

/// tauri read iamge file
#[tauri::command]
pub fn read_file(file: String) -> Result<String, String> {
    let mut file = File::open(file).map_err(|e| format!("unable to open file: {}", e))?;
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer)
        .map_err(|e| format!("unable to read file: {}", e))?;
    let base64 = base64::engine::general_purpose::STANDARD_NO_PAD.encode(buffer);
    // TODO: use mime crate to get mime type
    Ok(format!("data:image/png;base64,{}", base64))
}

/// add book
#[tauri::command]
pub async fn add_book(
    pool: tauri::State<'_, DbPool>,
    book: book::AddBookParams,
) -> Result<Book, String> {
    let result = book::add(&pool, book).await.map_err(|e| format!("{}", e))?;
    Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_file_metadata() {
        let file = File::open("Cargo.toml".to_string()).unwrap();
        println!("{:#?}", file.metadata());
    }
}
