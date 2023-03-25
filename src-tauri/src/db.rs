use sqlx::{sqlite::SqliteConnectOptions, SqlitePool};
use std::{error::Error, path::PathBuf};

pub async fn init(app_dir: PathBuf) -> Result<(), Box<dyn Error>> {
    let db_path = app_dir.join("main.sqlite");

    let connect_options = SqliteConnectOptions::new()
        .create_if_missing(true)
        .filename(db_path.to_str().unwrap());

    let pool = SqlitePool::connect_with(connect_options).await?;
    sqlx::migrate!("./migrations").run(&pool).await?;
    Ok(())
}
