use sqlx::{sqlite::SqliteConnectOptions, SqlitePool};
use std::path::PathBuf;
use tracing::debug;

use crate::{error::Result, APP_DIR};

pub async fn init(app_dir: PathBuf) -> Result<()> {
    let db_path = app_dir.join("main.sqlite");
    debug!("init db: {}", db_path.display());

    let connect_options = SqliteConnectOptions::new()
        .create_if_missing(true)
        .filename(db_path.to_str().unwrap());

    let pool = SqlitePool::connect_with(connect_options).await?;
    sqlx::migrate!("./migrations").run(&pool).await?;
    Ok(())
}

// get sqlite pool
pub async fn get_pool() -> Result<SqlitePool> {
    let app_dir = APP_DIR.get().unwrap();
    let db_path = app_dir.join("main.sqlite");
    debug!("get pool: {}", db_path.display());

    let connect_options = SqliteConnectOptions::new()
        .create_if_missing(true)
        .filename(db_path.to_str().unwrap());

    let pool = SqlitePool::connect_with(connect_options).await?;
    Ok(pool)
}
