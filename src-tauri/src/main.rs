// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

pub mod cmd;
pub mod db;

fn main() {
    tauri::Builder::default()
        .setup(|app| {
            let app_dir = tauri::api::path::app_config_dir(&app.config()).unwrap();
            tauri::async_runtime::block_on(async { db::init(app_dir).await })
        })
        .invoke_handler(tauri::generate_handler![cmd::read_file])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
