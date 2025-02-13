;
BEGIN;

;
CREATE TABLE "interest_rate" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "amount" decimal(9,2) NOT NULL DEFAULT 1.4,
  FOREIGN KEY ("id") REFERENCES "agent"("interest_rate_id") ON DELETE CASCADE
);

;

;

COMMIT;

