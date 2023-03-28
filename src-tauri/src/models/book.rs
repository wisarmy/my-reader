use serde::{Deserialize, Serialize};

use crate::{db::DbPool, error::Result};

/// book model
#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow, sqlx::Type)]
pub struct Book {
    pub id: i64,
    pub title: String,
    pub author: String,
    pub cover: String,
    pub path: String,
    pub created: i64,
    pub updated: i64,
    pub deleted: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow, sqlx::Type)]
pub struct AddBookParams {
    pub title: Option<String>,
    pub author: Option<String>,
    pub cover: Option<String>,
    pub path: Option<String>,
}

pub async fn add(pool: &DbPool, book: AddBookParams) -> Result<Book> {
    let timestamp = chrono::Local::now().timestamp();
    let last_id = sqlx::query("INSERT INTO books (title, author, cover, path, created, updated) VALUES (?, ?, ?, ?, ?, ?)")
        .bind(book.title)
        .bind(book.author)
        .bind(book.cover)
        .bind(book.path)
        .bind(timestamp)
        .bind(timestamp)
        .execute(&pool.0)
        .await?
        .last_insert_rowid();
    get(pool, last_id).await
}

pub async fn get(pool: &DbPool, id: i64) -> Result<Book> {
    let book = sqlx::query_as("SELECT * FROM books WHERE id = ?")
        .bind(id)
        .fetch_one(&pool.0)
        .await?;
    Ok(book)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::db::tests::get_test_pool;

    #[tokio::test]
    async fn test_add_book() {
        let pool = get_test_pool().await;
        let book = AddBookParams {
            title: Some("test_title".to_string()),
            author: Some("test_author".to_string()),
            cover: Some("test_cover".to_string()),
            path: Some("test_path".to_string()),
        };
        let res = add(&pool, book).await.unwrap();
        assert!(res.id > 0);
        assert_eq!(res.title, "test_title".to_string());
    }
}
