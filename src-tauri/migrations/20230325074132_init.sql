-- Add migration script here
-- sqlite: create table books of epub, pdf, mobi, azw3, txt, etc.
create table books (
  id integer primary key autoincrement,
  title text not null,
  author text not null,
  path text not null,
  cover text not null,
  created_at integer not null,
  updated_at integer not null,
  deleted_at integer not null
);