--
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Mar  1 16:16:01 2025
--

;
BEGIN TRANSACTION;
--
-- Table: "agent"
--
CREATE TABLE "agent" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "interest_rate_id" integer NOT NULL,
  FOREIGN KEY ("interest_rate_id") REFERENCES "interest_rate"("id")
);
CREATE INDEX "agent_idx_interest_rate_id" ON "agent" ("interest_rate_id");
CREATE UNIQUE INDEX "agent_name" ON "agent" ("name");
--
-- Table: "interest_rate"
--
CREATE TABLE "interest_rate" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "amount" decimal(1,2) NOT NULL DEFAULT 0.4,
  FOREIGN KEY ("id") REFERENCES "agent"("interest_rate_id") ON DELETE CASCADE
);
--
-- Table: "client"
--
CREATE TABLE "client" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "agent_id" integer NOT NULL,
  "name" text NOT NULL,
  "interest_rate" decimal(1,2),
  "created_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("agent_id") REFERENCES "agent"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "client_idx_agent_id" ON "client" ("agent_id");
CREATE UNIQUE INDEX "client_name" ON "client" ("name");
--
-- Table: "loan"
--
CREATE TABLE "loan" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "client_id" integer NOT NULL,
  "amount_borrowed" decimal(9,2) NOT NULL DEFAULT 0,
  "loan_status" text NOT NULL DEFAULT 'active',
  "date_borrowed"  NOT NULL DEFAULT CURRENT_DATE,
  "created_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("client_id") REFERENCES "client"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "loan_idx_client_id" ON "loan" ("client_id");
--
-- Table: "loan_repayment"
--
CREATE TABLE "loan_repayment" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "loan_id" integer NOT NULL,
  "amount_paid" decimal(9,2) NOT NULL DEFAULT 0,
  "payment_date"  NOT NULL DEFAULT CURRENT_DATE,
  "created_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("loan_id") REFERENCES "loan"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "loan_repayment_idx_loan_id" ON "loan_repayment" ("loan_id");
COMMIT;
