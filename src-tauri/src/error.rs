use thiserror::Error;

pub type Result<T> = std::result::Result<T, AppError>;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("invalid header (expected {expected:?}, found {found:?})")]
    InvalidHeader { expected: String, found: String },
    #[error("unknown error")]
    Unknown,
    #[error("{0}")]
    Error(String),
    #[error("sqlx: {0}")]
    Sqlx(#[from] sqlx::error::Error),
    #[error("sqlx migrate: {0}")]
    SqlxMigrate(#[from] sqlx::migrate::MigrateError),
}

#[macro_export]
macro_rules! app_error {
    ($($arg:tt)*) => {{
        $crate::error::AppError::Error(format!($($arg)*))
    }}
}
