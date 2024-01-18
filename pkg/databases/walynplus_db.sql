CREATE TABLE "users" (
  "id" varchar PRIMARY KEY,
  "username" varchar UNIQUE,
  "password" varchar,
  "firstname" varchar,
  "lastname" varchar,
  "email" varchar UNIQUE,
  "role_id" int,
  "point" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "oauth" (
  "id" varchar PRIMARY KEY,
  "user_id" varchar,
  "access_token" varchar,
  "refresh_token" varchar,
  "created_at" timesstamp,
  "updated_at" timesstamp
);

CREATE TABLE "roles" (
  "id" int PRIMARY KEY,
  "title" varchar
);

CREATE TABLE "products" (
  "id" varchar PRIMARY KEY,
  "product_num" varchar UNIQUE,
  "title" varchar,
  "description" varchar,
  "price" float,
  "point" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "images" (
  "id" varchar PRIMARY KEY,
  "filename" varchar,
  "url" varchar,
  "product_id" varchar,
  "created_at" timesstamp,
  "updated_at" timesstamp
);

CREATE TABLE "products_categories" (
  "id" varchar PRIMARY KEY,
  "product_id" varchar,
  "category_id" int
);

CREATE TABLE "categories" (
  "id" int PRIMARY KEY,
  "title" varchar UNIQUE
);

CREATE TABLE "orders" (
  "id" varchar PRIMARY KEY,
  "user_id" varchar,
  "order_type" varchar,
  "contact" varchar,
  "address" varchar,
  "tranfer_slip" jsonb,
  "status" varchar,
  "created_at" timesstamp,
  "updated_at" timesstamp
);

CREATE TABLE "products_orders" (
  "id" varchar PRIMARY KEY,
  "order_id" varchar,
  "qty" int,
  "price" float,
  "point" float,
  "product" jsonb
);

CREATE TABLE "customers" (
  "id" varchar PRIMARY KEY,
  "user_id" varchar,
  "customer_code" [unique],
  "firstname" varchar,
  "lastname" varchar,
  "email" varchar UNIQUE,
  "address" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "agents" (
  "id" varchar PRIMARY KEY,
  "user_id" varchar,
  "agent_type" varchar,
  "agent_code" [unique],
  "firstname" varchar,
  "lastname" varchar,
  "email" varchar UNIQUE,
  "address" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "order_type" (
  "id" varchar PRIMARY KEY,
  "title" varchar UNIQUE
);

CREATE TABLE "agent_type" (
  "id" varchar PRIMARY KEY,
  "title" varchar UNIQUE
);

ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id");

ALTER TABLE "oauth" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "images" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "products_categories" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "products_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id");

ALTER TABLE "orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "orders" ADD FOREIGN KEY ("order_type") REFERENCES "order_type" ("id");

ALTER TABLE "products_orders" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id");

ALTER TABLE "customers" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "agents" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "agents" ADD FOREIGN KEY ("agent_type") REFERENCES "agent_type" ("id");
