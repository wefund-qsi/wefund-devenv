-- Seed script : modele unifie (Projet 1 = source de verite)
-- Remplit : projects, campagnes, news, user, auth, role, contributions, transactions
-- Les dates sont dynamiques : aujourd'hui ou demain (aleatoire) selon les lignes
-- Usage :
--   docker exec -i we-fund-db psql -U postgres -d wefund_db < metabase/seed_unified_only_proj1.sql

BEGIN;

TRUNCATE TABLE
  news,
  campagnes,
  projects,
  contributions,
  transactions,
  "auth",
  "role",
  "user"
RESTART IDENTITY CASCADE;

-- =========================
-- Projet 1 (source de verite)
-- =========================

INSERT INTO projects (id, titre, description, photo, "porteurId", "createdAt", "updatedAt")
SELECT
  v.id,
  v.titre,
  v.description,
  v.photo,
  v.porteur_id,
  date_trunc('day', CURRENT_TIMESTAMP) - (v.day_offset || ' days')::interval + (8 + v.row_no) * interval '1 hour',
  date_trunc('day', CURRENT_TIMESTAMP) - (v.day_offset || ' days')::interval + (8 + v.row_no) * interval '1 hour' + interval '30 minutes'
FROM (
  VALUES
    ('11111111-1111-1111-1111-111111111001'::uuid, 'Projet Eau Solidaire', 'Acces a l eau potable', 'p1.jpg', 'porteur_p1', 10, 1),
    ('11111111-1111-1111-1111-111111111002'::uuid, 'Projet Ecole Connectee', 'Materiel numerique pour ecoles', 'p2.jpg', 'porteur_p2', 8, 2),
    ('11111111-1111-1111-1111-111111111003'::uuid, 'Projet Sante Mobile', 'Clinique mobile rurale', 'p3.jpg', 'porteur_p3', 6, 3),
    ('11111111-1111-1111-1111-111111111004'::uuid, 'Projet Reboisement', 'Planter 10 000 arbres', 'p4.jpg', 'porteur_p4', 4, 4),
    ('11111111-1111-1111-1111-111111111005'::uuid, 'Projet Formation Pro', 'Ateliers de formation', 'p5.jpg', 'porteur_p5', 2, 5)
) AS v(id, titre, description, photo, porteur_id, day_offset, row_no);

INSERT INTO campagnes (id, titre, description, objectif, "montantCollecte", "dateFin", statut, "porteurId", "projetId", "createdAt", "updatedAt")
SELECT
  v.id,
  v.titre,
  v.description,
  v.objectif,
  v.montant_collecte,
  CASE
    WHEN v.statut = 'ACTIVE' THEN
      (CASE WHEN random() < 0.5 THEN CURRENT_DATE ELSE CURRENT_DATE + interval '1 day' END)::timestamp
      + (17 + v.row_no) * interval '1 hour'
    WHEN v.statut IN ('REUSSIE', 'ECHOUEE') THEN
      date_trunc('day', CURRENT_TIMESTAMP) - (v.row_no || ' days')::interval + interval '18 hours'
    ELSE
      date_trunc('day', CURRENT_TIMESTAMP) + interval '2 day' + interval '19 hours'
  END,
  v.statut::campagnes_statut_enum,
  v.porteur_id,
  v.projet_id,
  date_trunc('day', CURRENT_TIMESTAMP) - (10 - v.row_no || ' days')::interval + interval '9 hours',
  CURRENT_TIMESTAMP
FROM (
  VALUES
    ('22222222-2222-2222-2222-222222222001'::uuid, 'Campagne Eau', 'Collecte mensuelle eau', 5000.00::numeric, 2400.00::numeric, 'ACTIVE', 'porteur_p1', '11111111-1111-1111-1111-111111111001'::uuid, 1),
    ('22222222-2222-2222-2222-222222222002'::uuid, 'Campagne Ecole', 'Tablettes et routeurs', 12000.00::numeric, 12000.00::numeric, 'REUSSIE', 'porteur_p2', '11111111-1111-1111-1111-111111111002'::uuid, 2),
    ('22222222-2222-2222-2222-222222222003'::uuid, 'Campagne Sante', 'Medicaments essentiels', 8000.00::numeric, 3500.00::numeric, 'ACTIVE', 'porteur_p3', '11111111-1111-1111-1111-111111111003'::uuid, 3),
    ('22222222-2222-2222-2222-222222222004'::uuid, 'Campagne Reboisement', 'Pepiniere et logistique', 7000.00::numeric, 1200.00::numeric, 'ECHOUEE', 'porteur_p4', '11111111-1111-1111-1111-111111111004'::uuid, 4),
    ('22222222-2222-2222-2222-222222222005'::uuid, 'Campagne Formation', 'Formateurs et kits', 6000.00::numeric, 0.00::numeric, 'EN_ATTENTE', 'porteur_p5', '11111111-1111-1111-1111-111111111005'::uuid, 5)
) AS v(id, titre, description, objectif, montant_collecte, statut, porteur_id, projet_id, row_no);

INSERT INTO news (id, titre, contenu, "campagneId", "createdAt")
SELECT
  v.id,
  v.titre,
  v.contenu,
  v.campagne_id,
  (CASE WHEN random() < 0.5 THEN CURRENT_DATE ELSE CURRENT_DATE + interval '1 day' END)::timestamp
  + (8 + v.row_no) * interval '1 hour'
FROM (
  VALUES
    ('33333333-3333-3333-3333-333333333001'::uuid, 'Point semaine 1', 'Lancement officiel de la campagne.', '22222222-2222-2222-2222-222222222001'::uuid, 1),
    ('33333333-3333-3333-3333-333333333002'::uuid, 'Objectif atteint', 'Merci a tous les contributeurs.', '22222222-2222-2222-2222-222222222002'::uuid, 2),
    ('33333333-3333-3333-3333-333333333003'::uuid, 'Nouveau partenaire', 'Un partenaire local rejoint le projet.', '22222222-2222-2222-2222-222222222003'::uuid, 3),
    ('33333333-3333-3333-3333-333333333004'::uuid, 'Mise a jour budget', 'Reallocation des ressources terrain.', '22222222-2222-2222-2222-222222222004'::uuid, 4),
    ('33333333-3333-3333-3333-333333333005'::uuid, 'Preparation lancement', 'Calendrier et objectifs publies.', '22222222-2222-2222-2222-222222222005'::uuid, 5)
) AS v(id, titre, contenu, campagne_id, row_no);

-- =========================
-- Utilisateurs et contributions (lies a Projet 1)
-- =========================

INSERT INTO "user" (id, nom, prenom, username) VALUES
  ('44444444-4444-4444-4444-444444444001', 'Dupont', 'Alice', 'alice.dupont'),
  ('44444444-4444-4444-4444-444444444002', 'Martin', 'Benoit', 'benoit.martin'),
  ('44444444-4444-4444-4444-444444444003', 'Nguyen', 'Camille', 'camille.nguyen'),
  ('44444444-4444-4444-4444-444444444004', 'Diallo', 'David', 'david.diallo'),
  ('44444444-4444-4444-4444-444444444005', 'Lopez', 'Emma', 'emma.lopez');

INSERT INTO "auth" (id, password, "userId") VALUES
  (1, 'hash_pwd_1', '44444444-4444-4444-4444-444444444001'),
  (2, 'hash_pwd_2', '44444444-4444-4444-4444-444444444002'),
  (3, 'hash_pwd_3', '44444444-4444-4444-4444-444444444003'),
  (4, 'hash_pwd_4', '44444444-4444-4444-4444-444444444004'),
  (5, 'hash_pwd_5', '44444444-4444-4444-4444-444444444005');

INSERT INTO "role" (id, role, "userId") VALUES
  (1, 'ADMINISTRATEUR', '44444444-4444-4444-4444-444444444001'),
  (2, 'USER', '44444444-4444-4444-4444-444444444002'),
  (3, 'USER', '44444444-4444-4444-4444-444444444003'),
  (4, 'USER', '44444444-4444-4444-4444-444444444004'),
  (5, 'USER', '44444444-4444-4444-4444-444444444005');

-- Contributions uniquement sur campagnes ACTIVE
-- Campagne Eau   (ACTIVE) : 22222222-...-001
-- Campagne Sante (ACTIVE) : 22222222-...-003

INSERT INTO contributions (id, montant, "campagneId", "contributeurId", "createdAt")
SELECT
  v.id,
  v.montant,
  v.campagne_id,
  v.user_id,
  (CASE WHEN random() < 0.5 THEN CURRENT_DATE ELSE CURRENT_DATE + interval '1 day' END)::timestamp
  + (9 + v.row_no) * interval '1 hour'
  + (v.row_no * 7) * interval '1 minute'
FROM (
  VALUES
    -- Campagne Eau (ACTIVE)
    ('66666666-6666-6666-6666-666666666001'::uuid, 40::numeric,  '22222222-2222-2222-2222-222222222001'::uuid, '44444444-4444-4444-4444-444444444001'::uuid, 1),
    ('66666666-6666-6666-6666-666666666002'::uuid, 25::numeric,  '22222222-2222-2222-2222-222222222001'::uuid, '44444444-4444-4444-4444-444444444002'::uuid, 2),
    -- Campagne Sante (ACTIVE)
    ('66666666-6666-6666-6666-666666666003'::uuid, 60::numeric,  '22222222-2222-2222-2222-222222222003'::uuid, '44444444-4444-4444-4444-444444444003'::uuid, 3),
    ('66666666-6666-6666-6666-666666666004'::uuid, 80::numeric,  '22222222-2222-2222-2222-222222222003'::uuid, '44444444-4444-4444-4444-444444444004'::uuid, 4),
    ('66666666-6666-6666-6666-666666666005'::uuid, 35::numeric,  '22222222-2222-2222-2222-222222222001'::uuid, '44444444-4444-4444-4444-444444444005'::uuid, 5)
) AS v(id, montant, campagne_id, user_id, row_no);

-- Transactions toutes captured (coherentes avec les contributions)
INSERT INTO transactions (id, "paymentIntentId", montant, statut, "contributionId", "contributeurId", "createdAt", "updatedAt")
SELECT
  v.id,
  CONCAT('pi_demo_', to_char(CURRENT_TIMESTAMP, 'YYYYMMDDHH24MISS'), '_', v.row_no),
  v.montant,
  v.statut::transactions_statut_enum,
  v.contribution_id,
  v.user_id,
  ts.created_at,
  ts.created_at + interval '2 minutes'
FROM (
  VALUES
    ('55555555-5555-5555-5555-555555555001'::uuid, 40::numeric, 'captured', '66666666-6666-6666-6666-666666666001'::uuid, '44444444-4444-4444-4444-444444444001'::uuid, 1),
    ('55555555-5555-5555-5555-555555555002'::uuid, 25::numeric, 'captured', '66666666-6666-6666-6666-666666666002'::uuid, '44444444-4444-4444-4444-444444444002'::uuid, 2),
    ('55555555-5555-5555-5555-555555555003'::uuid, 60::numeric, 'captured', '66666666-6666-6666-6666-666666666003'::uuid, '44444444-4444-4444-4444-444444444003'::uuid, 3),
    ('55555555-5555-5555-5555-555555555004'::uuid, 80::numeric, 'captured', '66666666-6666-6666-6666-666666666004'::uuid, '44444444-4444-4444-4444-444444444004'::uuid, 4),
    ('55555555-5555-5555-5555-555555555005'::uuid, 35::numeric, 'captured', '66666666-6666-6666-6666-666666666005'::uuid, '44444444-4444-4444-4444-444444444005'::uuid, 5)
) AS v(id, montant, statut, contribution_id, user_id, row_no)
CROSS JOIN LATERAL (
  SELECT
    (CASE WHEN random() < 0.5 THEN CURRENT_DATE ELSE CURRENT_DATE + interval '1 day' END)::timestamp
    + (11 + v.row_no) * interval '1 hour'
    + (v.row_no * 5) * interval '1 minute' AS created_at
) AS ts;

-- Keep sequences aligned after explicit IDs
SELECT setval(pg_get_serial_sequence('"auth"', 'id'), COALESCE((SELECT MAX(id) FROM "auth"), 1), true);
SELECT setval(pg_get_serial_sequence('"role"', 'id'), COALESCE((SELECT MAX(id) FROM "role"), 1), true);

COMMIT;
