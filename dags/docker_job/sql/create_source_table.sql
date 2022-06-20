CREATE SCHEMA IF NOT EXISTS analytics_object;

CREATE TABLE IF NOT EXISTS analytics_object.users (
    id serial,
    name TEXT NOT NULL UNIQUE,
    visitor_ind bigint,
    created_at TIMESTAMP,
    user_segment TEXT,
    event_type TEXT,
    event_time TIMESTAMP,
    export_date TIMESTAMP,
    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS analytics_object.walls (
    id serial,
    name VARCHAR (255) NOT NULL,
    owner VARCHAR (255) NOT NULL,
    created_at TIMESTAMP,
    event_type TEXT,
    event_time TIMESTAMP,
    export_date TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_users_walls
          FOREIGN KEY(owner)
          REFERENCES analytics_object.users(name)
);

CREATE TABLE IF NOT EXISTS analytics_object.posts (
    id serial,
    name VARCHAR (255) NOT NULL,
    content TEXT,
    wall bigint,
    author TEXT,
    created_at TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_walls_posts
         FOREIGN KEY(wall)
         REFERENCES analytics_object.walls(id),
    CONSTRAINT fk_users_posts
         FOREIGN KEY(author)
         REFERENCES analytics_object.users(name)
);

CREATE TABLE IF NOT EXISTS analytics_object.comments (
    id serial,
    text TEXT,
    post bigint,
    author TEXT,
    created_at TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_posts_comments
         FOREIGN KEY(post)
         REFERENCES analytics_object.posts(id),
    CONSTRAINT fk_users_comments
         FOREIGN KEY(author)
         REFERENCES analytics_object.users(name)
);


CREATE TABLE IF NOT EXISTS analytics_object.likes (
    id serial,
    like_notlike_ind bigint,
    post bigint,
    comment bigint,
    author TEXT,
    created_at TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_posts_likes
         FOREIGN KEY(post)
         REFERENCES analytics_object.posts(id),
    CONSTRAINT fk_users_likes
         FOREIGN KEY(author)
         REFERENCES analytics_object.users(name),
    CONSTRAINT fk_comments_likes
         FOREIGN KEY(comment)
         REFERENCES analytics_object.comments(id)
);