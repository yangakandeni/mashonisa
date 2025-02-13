
;
BEGIN;

;

ALTER TABLE agent ADD COLUMN interest_rate_id integer NOT NULL;

;
CREATE INDEX agent_idx_interest_rate_id ON agent (interest_rate_id);

;

;

COMMIT;

