-- Convert schema '/Users/yanga/Desktop/mashonisa-app/share/migrations/_source/deploy/4/001-auto.yml' to '/Users/yanga/Desktop/mashonisa-app/share/migrations/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE client_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  agent_id integer NOT NULL,
  name text NOT NULL,
  created_at  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (agent_id) REFERENCES agent(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO client_temp_alter( id, agent_id, name, created_at) SELECT id, agent_id, name, created_at FROM client;

;
DROP TABLE client;

;
CREATE TABLE client (
  id INTEGER PRIMARY KEY NOT NULL,
  agent_id integer NOT NULL,
  name text NOT NULL,
  created_at  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (agent_id) REFERENCES agent(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX client_idx_agent_id02 ON client (agent_id);

;
CREATE UNIQUE INDEX client_name02 ON client (name);

;
INSERT INTO client SELECT id, agent_id, name, created_at FROM client_temp_alter;

;
DROP TABLE client_temp_alter;

;
CREATE TEMPORARY TABLE interest_rate_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  amount decimal(9,2) NOT NULL DEFAULT 1.4,
  FOREIGN KEY (id) REFERENCES agent(interest_rate_id) ON DELETE CASCADE
);

;
INSERT INTO interest_rate_temp_alter( id, amount) SELECT id, amount FROM interest_rate;

;
DROP TABLE interest_rate;

;
CREATE TABLE interest_rate (
  id INTEGER PRIMARY KEY NOT NULL,
  amount decimal(9,2) NOT NULL DEFAULT 1.4,
  FOREIGN KEY (id) REFERENCES agent(interest_rate_id) ON DELETE CASCADE
);

;
INSERT INTO interest_rate SELECT id, amount FROM interest_rate_temp_alter;

;
DROP TABLE interest_rate_temp_alter;

;

COMMIT;

