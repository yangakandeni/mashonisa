-- Convert schema '/Users/yanga/Desktop/mashonisa-app/share/migrations/_source/deploy/3/001-auto.yml' to '/Users/yanga/Desktop/mashonisa-app/share/migrations/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE client ADD COLUMN interest_rate decimal(1,2);

;
CREATE TEMPORARY TABLE interest_rate_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  amount decimal(1,2) NOT NULL DEFAULT 0.4,
  FOREIGN KEY (id) REFERENCES agent(interest_rate_id) ON DELETE CASCADE
);

;
INSERT INTO interest_rate_temp_alter( id, amount) SELECT id, amount FROM interest_rate;

;
DROP TABLE interest_rate;

;
CREATE TABLE interest_rate (
  id INTEGER PRIMARY KEY NOT NULL,
  amount decimal(1,2) NOT NULL DEFAULT 0.4,
  FOREIGN KEY (id) REFERENCES agent(interest_rate_id) ON DELETE CASCADE
);

;
INSERT INTO interest_rate SELECT id, amount FROM interest_rate_temp_alter;

;
DROP TABLE interest_rate_temp_alter;

;

COMMIT;

