;
BEGIN;

;

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

;
CREATE INDEX "loan_idx_client_id" ON "loan" ("client_id");

;

COMMIT;

