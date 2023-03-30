use serde::{Deserialize, Serialize};
use sqlx::{QueryBuilder, Sqlite};

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

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ListParams {
    pub limit: Option<(i64, i64)>,
    pub kw: Option<String>,
}
/// list book with filters
pub async fn lists(pool: &DbPool, filter: ListParams) -> Result<Vec<Book>> {
    let mut query: QueryBuilder<Sqlite> =
        QueryBuilder::new("select * from books where deleted = 0");

    if let Some(kw) = filter.kw {
        query.push(format!(
            " and (title LIKE '%{}%' or author LIKE '%{}%')",
            kw, kw
        ));
    }
    query.push(" order by created DESC");
    if let Some(limit) = filter.limit {
        query.push(format!(" limit {},{}", limit.0, limit.1));
    }
    let books = query.build_query_as().fetch_all(&pool.0).await?;
    Ok(books)
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
    #[tokio::test]
    async fn test_lists() {
        let pool = get_test_pool().await;
        let mut book = AddBookParams {
            path: "test_path".to_string(),
            title: "test_title".to_string(),
            author: "".to_string(),
            cover: "".to_string(),
        };
        let _add_res = add(&pool, book.clone()).await.unwrap();
        book.path = "test_path_2".to_string();
        book.title = "test_title_2".to_string();
        let _add_res = add(&pool, book.clone()).await.unwrap();
        book.path = "test_path_3".to_string();
        book.title = "test_title_3".to_string();
        let _add_res = add(&pool, book.clone()).await.unwrap();
        let filter = ListParams {
            limit: Some((0, 10)),
            kw: Some("test_title".to_string()),
        };

        let books = lists(&pool, filter).await.unwrap();
        assert_eq!(books.len(), 3);
    }
}
