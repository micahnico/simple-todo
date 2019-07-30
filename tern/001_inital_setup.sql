-- comment out the extension part for heroku deploy
-- then to create extension run below command then paste the create extension into the db prompt

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

create table users (
  id uuid DEFAULT public.gen_random_uuid() primary key,
  email character varying DEFAULT ''::character varying not null,
  password_digest character varying DEFAULT ''::character varying not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);

create table login_sessions (
  id uuid primary key default public.gen_random_uuid(),
  user_id uuid references users (id) on delete cascade,
  login_time timestamptz not null,
  login_ip inet not null,
  last_access_time timestamptz not null,
  last_ip inet not null,
  request_count int not null default 0,
  logout_time timestamptz
);
create index on login_sessions (user_id);

create table projects (
  id uuid DEFAULT public.gen_random_uuid() primary key,
  name varchar not null,
  description text
);

create table lists (
  id uuid DEFAULT public.gen_random_uuid() primary key,
  name varchar not null,
  project_id uuid references projects not null
);

create table todos (
  id uuid DEFAULT public.gen_random_uuid() primary key,
  description text,
  due_date date,
  completed_at timestamp with time zone,
  list_id uuid references lists not null
);

grant select, insert, update, delete on projects to {{.app_user}};
grant select, insert, update, delete on lists to {{.app_user}};
grant select, insert, update, delete on todos to {{.app_user}};
grant select, insert, update, delete on users to {{.app_user}};
grant select, insert, update, delete on login_sessions to {{.app_user}};

---- create above / drop below ----

drop table todos;
drop table lists;
drop table projects;
drop table login_sessions;
drop table users;


