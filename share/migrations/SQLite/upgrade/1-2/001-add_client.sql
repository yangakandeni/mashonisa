;
BEGIN;

;
CREATE TABLE "client" (
  "id" INTEGER PRIMARY KEY NOT NULL,
  "agent_id" integer NOT NULL,
  "name" text NOT NULL,
  "created_at"  NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY ("agent_id") REFERENCES "agent"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX "client_idx_agent_id" ON "client" ("agent_id");

;
CREATE UNIQUE INDEX "client_name" ON "client" ("name");

;

COMMIT;