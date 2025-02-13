-- Convert schema '/Users/yanga/Desktop/mashonisa-app/share/migrations/_source/deploy/3/001-auto.yml' to '/Users/yanga/Desktop/mashonisa-app/share/migrations/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE agent_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);

;
INSERT INTO agent_temp_alter( id, name) SELECT id, name FROM agent;

;
DROP TABLE agent;

;
CREATE TABLE agent (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);

;
CREATE UNIQUE INDEX agent_name02 ON agent (name);

;
INSERT INTO agent SELECT id, name FROM agent_temp_alter;

;
DROP TABLE agent_temp_alter;

;
DROP TABLE interest_rate;

;
DROP TABLE loan;

;
DROP TABLE loan_repayment;

;

COMMIT;

