// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::path::PathBuf;

use once_cell::sync::OnceCell;
use tauri::Manager;
use tracing_subscriber::{prelude::__tracing_subscriber_SubscriberExt, util::SubscriberInitExt};

pub mod cmd;
mod db;
pub mod error;
mod file_manager;
mod models;
mod services;

static APP_DIR: OnceCell<PathBuf> = OnceCell::new();

fn main() {
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(|_| "info".into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    tauri::Builder::default()
        .setup(|app| {
            // set global app dir
            let app_dir = tauri::api::path::app_config_dir(&app.config()).unwrap();
            APP_DIR.set(app_dir.clone()).unwrap();
            // init file manager
            file_manager::init().unwrap();
            // init db
            tauri::async_runtime::block_on(async { db::init(app_dir).await.unwrap() });
            // set state db pool
            app.manage(tauri::async_runtime::block_on(async {
                db::get_pool().await.unwrap()
            }));
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            cmd::read_file,
            cmd::add_book,
            cmd::list_books
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
