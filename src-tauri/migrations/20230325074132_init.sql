-- Add migration script here
-- sqlite: create table books of epub, pdf, mobi, azw3, txt, etc.
create table books (
  id integer primary key autoincrement,
  title text not null,
  author text not null,
  path text not null,
  cover text not null,
  created integer not null default 0,
  updated integer not null default 0,
  deleted integer not null default 0
);