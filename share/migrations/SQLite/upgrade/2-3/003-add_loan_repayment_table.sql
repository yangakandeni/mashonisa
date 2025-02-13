;
BEGIN;

;
CREATE TABLE "loan_repayment" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "loan_id" integer NOT NULL,
  "amount_paid" decimal(9,2) NOT NULL DEFAULT 0,
  "payment_date"  NOT NULL DEFAULT CURRENT_DATE,
  "created_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("loan_id") REFERENCES "loan"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX "loan_repayment_idx_loan_id" ON "loan_repayment" ("loan_id");

;

COMMIT;

