
-- AGENTS
INSERT INTO agent (name) VALUES ('DJ Luu');
INSERT INTO agent (name) VALUES ('Sister');
INSERT INTO agent (name) VALUES ('Nwabisa');

-- CLIENTS
INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%DJ%'), 'Somlotha');
INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%DJ%'), 'Magidi');
INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%DJ%'), 'DJ Luu');
INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%DJ%'), 'Saki');

INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%Sister%'), 'Mandlakazi');
INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%Sister%'), 'Zikhona');
INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%Sister%'), 'Andile');

INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%Nwabisa%'), 'Nwabisa');
INSERT INTO client (agent_id, name) VALUES (( SELECT id FROM agent WHERE name LIKE '%Nwabisa%'), 'Brother');

-- LOANS
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Somlotha'), 1000, 0.4);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Somlotha'), 1000, 0.4);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Magidi'), 100, 0.4);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'DJ Luu'), 1000, 0);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'DJ Luu'), 500, 0);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Mandlakazi'), 5000, 0);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Zikhona'), 1000, 0.3);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Andile'), 100, 0.3);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Nwabisa'), 5000, 0);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Nwabisa'), 200, 0);
INSERT INTO loan (client_id, amount_borrowed, interest_rate) VALUES ((SELECT id FROM client WHERE name = 'Brother'), 300, 0.3);

-- REPAYMENTS
INSERT INTO loan_repayment (client_id, amount_paid) VALUES ((SELECT id FROM client WHERE name = 'Somlotha'), 200);
INSERT INTO loan_repayment (client_id, amount_paid) VALUES ((SELECT id FROM client WHERE name = 'Somlotha'), 500); -- paid less than balance
INSERT INTO loan_repayment (client_id, amount_paid) VALUES ((SELECT id FROM client WHERE name = 'Magidi'), 1500); -- paid more than balance
INSERT INTO loan_repayment (client_id, amount_paid) VALUES ((SELECT id FROM client WHERE name = 'DJ Luu'), 1500); -- paid exact balance i.e. settled loan
INSERT INTO loan_repayment (client_id, amount_paid) VALUES ((SELECT id FROM client WHERE name = 'Brother'), 500);
INSERT INTO loan_repayment (client_id, amount_paid) VALUES ((SELECT id FROM client WHERE name = 'Somlotha'), 1500);
