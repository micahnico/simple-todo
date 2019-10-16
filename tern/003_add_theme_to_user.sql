ALTER TABLE users
ADD COLUMN dark_theme boolean not null default false;

---- create above / drop below ----

ALTER TABLE users 
DROP COLUMN dark_theme;
