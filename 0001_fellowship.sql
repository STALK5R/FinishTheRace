CREATE TABLE members (
 id TEXT PRIMARY KEY,
 email TEXT NOT NULL UNIQUE,
 name TEXT NOT NULL,
 display_name TEXT NOT NULL,
 address1 TEXT NOT NULL,
 address2 TEXT NOT NULL DEFAULT '',
 city TEXT NOT NULL,
 region TEXT NOT NULL,
 postal TEXT NOT NULL,
 country TEXT NOT NULL DEFAULT 'US',
 password_hash TEXT NOT NULL,
 password_salt TEXT NOT NULL,
 verified INTEGER NOT NULL DEFAULT 0,
 created TEXT NOT NULL
);
CREATE TABLE member_sessions (
 token_hash TEXT PRIMARY KEY,
 member_id TEXT NOT NULL REFERENCES members(id) ON DELETE CASCADE,
 expires INTEGER NOT NULL
);
CREATE INDEX member_sessions_member ON member_sessions(member_id);
CREATE TABLE auth_tokens (
 token_hash TEXT PRIMARY KEY,
 member_id TEXT NOT NULL REFERENCES members(id) ON DELETE CASCADE,
 purpose TEXT NOT NULL CHECK(purpose IN ('verify','reset')),
 expires INTEGER NOT NULL
);
CREATE INDEX auth_tokens_member ON auth_tokens(member_id);
CREATE TABLE fellowship_posts (
 id TEXT PRIMARY KEY,
 type TEXT NOT NULL CHECK(type IN ('message','testimony','prayer')),
 member_id TEXT REFERENCES members(id) ON DELETE SET NULL,
 author TEXT NOT NULL,
 email TEXT NOT NULL DEFAULT '',
 title TEXT NOT NULL,
 body TEXT NOT NULL,
 image TEXT NOT NULL DEFAULT '',
 video TEXT NOT NULL DEFAULT '',
 audio TEXT NOT NULL DEFAULT '',
 link TEXT NOT NULL DEFAULT '',
 visibility TEXT NOT NULL CHECK(visibility IN ('public','private')),
 consent_public INTEGER NOT NULL DEFAULT 0,
 status TEXT NOT NULL CHECK(status IN ('draft','pending','published','rejected','reviewed')),
 moderation_note TEXT NOT NULL DEFAULT '',
 created TEXT NOT NULL,
 updated TEXT NOT NULL
);
CREATE INDEX fellowship_posts_feed ON fellowship_posts(type,status,visibility,created,id);
CREATE INDEX fellowship_posts_member ON fellowship_posts(member_id,created);
CREATE TABLE moderation_log (
 id TEXT PRIMARY KEY,
 post_id TEXT NOT NULL,
 action TEXT NOT NULL,
 created TEXT NOT NULL
);
