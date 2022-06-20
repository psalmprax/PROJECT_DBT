CREATE SCHEMA IF NOT EXISTS analytics_dim;
CREATE SCHEMA IF NOT EXISTS analytics_objects;
CREATE SCHEMA IF NOT EXISTS analytics_stage;
CREATE SCHEMA IF NOT EXISTS analytics_facts;

CREATE TABLE IF NOT EXISTS analytics_dim.dim_users (
    wall_owner_sk serial,
    user_id numeric,
    name TEXT,
    visitor_ind bigint,
    created_at TEXT,
    user_segment TEXT,
    del_ind bigint,
    PRIMARY KEY (wall_owner_sk)
);

CREATE TABLE IF NOT EXISTS analytics_stage.users_cdc (
    id serial,
    name TEXT,
    visitor_ind bigint,
    created_at TEXT,
    user_segment TEXT,
    event_type TEXT,
    event_time TEXT,
    export_date TEXT
);

CREATE TABLE IF NOT EXISTS analytics_dim.dim_walls (
    wall_sk serial,
    wall_id TEXT,
    wall_name TEXT,
    PRIMARY KEY (wall_sk)
);

CREATE TABLE IF NOT EXISTS analytics_stage.walls_cdc (
    id serial,
    name TEXT,
    owner TEXT,
    created_at TEXT,
    event_type TEXT,
    event_time TEXT,
    export_date TEXT
);


 CREATE TABLE IF NOT EXISTS analytics_dim.dim_user_wall (
     user_wall_sk serial,
     wall_id TEXT,
     owner TEXT,
     created_at TEXT
 );