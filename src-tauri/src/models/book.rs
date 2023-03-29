use serde::{Deserialize, Serialize};

use crate::{app_error, db::DbPool, error::Result};

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

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AddBookParams {
    pub title: String,
    pub author: String,
    pub cover: String,
    pub path: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UpdateBookParams {
    pub id: i64,
    pub title: Option<String>,
    pub author: Option<String>,
    pub cover: Option<String>,
    pub path: Option<String>,
}
/// add book
pub async fn add(pool: &DbPool, book: AddBookParams) -> Result<Book> {
    // check if book exists
    if exists(pool, &book.path).await? {
        return Err(app_error!("book already exists"));
    }
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
/// exists book
pub async fn exists(pool: &DbPool, path: &str) -> Result<bool> {
    let query_res = sqlx::query("SELECT * FROM books WHERE path = ?")
        .bind(path)
        .fetch_one(&pool.0)
        .await;
    match query_res {
        Ok(_) => Ok(true),
        Err(sqlx::Error::RowNotFound) => Ok(false),
        Err(err) => Err(err)?,
    }
}
/// get book
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
            title: "test_title".to_string(),
            author: "test_author".to_string(),
            cover: "test_cover".to_string(),
            path: "test_path".to_string(),
        };
        let res = add(&pool, book).await.unwrap();
        assert!(res.id > 0);
        assert_eq!(res.title, "test_title".to_string());
    }
    #[tokio::test]
    async fn test_exists_book() {
        let pool = get_test_pool().await;
        let book = AddBookParams {
            path: "test_path".to_string(),
            title: "".to_string(),
            author: "".to_string(),
            cover: "".to_string(),
        };
        let _add_res = add(&pool, book.clone()).await.unwrap();
        let exists_res = exists(&pool, "test_path").await.unwrap();
        assert!(exists_res);
        let exists_res = exists(&pool, "test_path_x").await.unwrap();
        assert!(!exists_res);
    }
}
