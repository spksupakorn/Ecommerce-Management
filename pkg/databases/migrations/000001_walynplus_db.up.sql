BEGIN;

--Set timezone
SET TIME ZONE 'Asia/Bangkok';

--Install uuid extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--users_id -> U000001
--products_id -> U000001
--orders_id -> U000001
--Create sequence
CREATE SEQUENCE users_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE products_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE orders_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE customers_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE agents_id_seq START WITH 1 INCREMENT BY 1;

--Auto update
CREATE OR REPLACE FUNCTION set_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;   
END;
$$ language 'plpgsql';

--Create enum
CREATE TYPE "order_status" AS ENUM (
    'waiting',
    'shipping',
    'completed',
    'canceled'
);

CREATE TABLE "users" (
    "id" VARCHAR(10) PRIMARY KEY DEFAULT CONCAT('WPU', LPAD(NEXTVAL('users_id_seq')::TEXT, 6, '0')),
    "username" VARCHAR UNIQUE NOT NULL,
    "password" VARCHAR NOT NULL,
    "firstname" VARCHAR NOT NULL,
    "lastname" VARCHAR NOT NULL,
    "email" VARCHAR UNIQUE NOT NULL,
    "role_id" INT NOT NULL,
    "point" FLOAT NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "oauth" (
    "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    "user_id" VARCHAR NOT NULL,
    "access_token" VARCHAR NOT NULL,
    "refresh_token" VARCHAR NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "roles" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR NOT NULL UNIQUE
);

CREATE TABLE "products" (
    "id" VARCHAR(10) PRIMARY KEY DEFAULT CONCAT('WPP', LPAD(NEXTVAL('products_id_seq')::TEXT, 6, '0')),
    "title"  VARCHAR NOT NULL,
    "description" VARCHAR NOT NULL DEFAULT '',
    "price" FLOAT NOT NULL DEFAULT 0,
    "point" FLOAT NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "images" (
    "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    "filename" VARCHAR NOT NULL,
    "url" VARCHAR NOT NULL,
    "product_id" VARCHAR NOT NULL DEFAULT '',
    "created_at" TIMESTAMP NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "products_categories" (
    "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    "product_id" VARCHAR NOT NULL,
    "category_id" INT NOT NULL
);

CREATE TABLE "categories" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "orders" (
    "id" VARCHAR(10) PRIMARY KEY DEFAULT CONCAT('WPO', LPAD(NEXTVAL('orders_id_seq')::TEXT, 6, '0')),
    "user_id" VARCHAR NOT NULL,
    "order_type_id" INT NOT NULL,
    "contact" VARCHAR NOT NULL,
    "address" VARCHAR NOT NULL,
    "transfer_slip" jsonb,
    "status" order_status NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "products_orders" (
    "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    "order_id" VARCHAR NOT NULL,
    "qty" INT NOT NULL DEFAULT 1,
    "price" FLOAT NOT NULL DEFAULT 0,
    "point" FLOAT NOT NULL DEFAULT 0,
    "product" jsonb
);

CREATE TABLE "customers" (
    "id" VARCHAR(10) PRIMARY KEY DEFAULT CONCAT('WPC', LPAD(NEXTVAL('users_id_seq')::TEXT, 6, '0')),
    "user_id" VARCHAR NOT NULL,
    "firstname" VARCHAR NOT NULL,
    "lastname" VARCHAR NOT NULL,
    "email" VARCHAR UNIQUE NOT NULL,
    "address" VARCHAR NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "agents" (
    "id" VARCHAR(10) PRIMARY KEY DEFAULT CONCAT('WPA', LPAD(NEXTVAL('users_id_seq')::TEXT, 6, '0')),
    "user_id" VARCHAR NOT NULL,
    "agent_type_id" INT NOT NULL,
    "agent_level_id" INT NOT NULL,
    "firstname" VARCHAR NOT NULL,
    "lastname" VARCHAR NOT NULL,
    "email" VARCHAR UNIQUE NOT NULL,
    "address" VARCHAR NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "order_type" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "agent_type" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "agent_level" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR UNIQUE NOT NULL
);

ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id");
ALTER TABLE "oauth" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "images" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");
ALTER TABLE "products_categories" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");
ALTER TABLE "products_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("order_type_id") REFERENCES "order_type" ("id");
ALTER TABLE "products_orders" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id");
ALTER TABLE "customers" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "agents" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "agents" ADD FOREIGN KEY ("agent_type_id") REFERENCES "agent_type" ("id");
ALTER TABLE "agents" ADD FOREIGN KEY ("agent_level_id") REFERENCES "agent_level" ("id");

CREATE TRIGGER set_updated_at_timestamp_users_table BEFORE UPDATE ON "users" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_oauth_table BEFORE UPDATE ON "oauth" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_products_table BEFORE UPDATE ON "products" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_images_table BEFORE UPDATE ON "images" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_orders_table BEFORE UPDATE ON "orders" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_customers_table BEFORE UPDATE ON "customers" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_agents_table BEFORE UPDATE ON "agents" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

COMMIT;