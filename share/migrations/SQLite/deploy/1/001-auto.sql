--
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Feb  9 23:13:02 2025
--

;
BEGIN TRANSACTION;
--
-- Table: "agent"
--
CREATE TABLE "agent" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" text NOT NULL
);
CREATE UNIQUE INDEX "agent_name" ON "agent" ("name");
COMMIT;
