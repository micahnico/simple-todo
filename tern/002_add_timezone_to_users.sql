ALTER TABLE users
ADD COLUMN time_zone character varying not null default 'Eastern Time (US & Canada)';

---- create above / drop below ----

ALTER TABLE users 
DROP COLUMN time_zone;
