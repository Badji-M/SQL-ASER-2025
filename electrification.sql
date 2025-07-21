-- -----------------------------------------------------
-- Base de données 2 : Electrification Rurale - ASER
-- Auteur : Pape Mamadou BADJI et Ndeye Aïssatou CISSE (ENSAE / AS2)
-- Date : JUILLET 2025
-- -----------------------------------------------------

CREATE DATABASE IF NOT EXISTS electrification;
USE electrification;

-- Présentation des tables de la base de données
-- ------------------------------------------------------------
-- | Nom de la table        | Attributs principaux                        | Description                                                                 |
-- |------------------------|---------------------------------------------|-----------------------------------------------------------------------------|
-- | region                 | id_region, nom_region                       | Liste des régions administratives.                                          |
-- | departement            | id_departement, nom_departement, id_region  | Contient les départements liés à une région.                                |
-- | commune                | id_commune, nom_commune, id_departement     | Contient les communes liées à un département.                               |
-- | village                | code_village, nom_village, id_commune,      | Table centrale : contient les villages, leur localisation, population,      |
-- |                        | population, latitude, longitude, statut,    | statut d’électrification et la date d’électrification.                      |
-- |                        | date_electrification                        |                                                                             |
-- | priorite               | id_priorite, code_village, niveau_priorite, | Liste les villages jugés prioritaires selon des critères donnés.            |
-- |                        | motif, date_classement                      |                                                                             |
-- | electrification        | id_electrification, code_village,           | Détaille les installations électriques : type d'énergie, puissance, coût.   |
-- |                        | type_source, puissance, date, durée, coût   |                                                                             |
-- | consommation           | id_consommation, code_village, annee,       | Historique de la consommation annuelle en kWh par village.                  |
-- |                        | consommation_kwh                            |                                                                             |
-- | appareil               | id_appareil, nom_appareil, puissance_kw,    | Liste des types d'appareils utilisés et leur puissance.                     |
-- |                        | duree_vie_annees                            |                                                                             |
-- | utilisation_appareil   | id_utilisation, code_village, id_appareil,  | Donne le nombre d'appareils présents dans chaque village.                   |
-- |                        | nombre                                      |                                                                             |
-- | maintenance            | id_maintenance, id_electrification,         | Suivi des opérations de maintenance sur les installations.                  |
-- |                        | date, type_operation, cout_fcfa             |                                                                             |
-- | distance_village       | id_distance, village_source, village_cible, | Donne les distances inter-villages pour calculs de proximité.               |
-- |                        | distance_km                                 |                                                                             |
-- ------------------------------------------------------------

-- 1. Table des régions
CREATE TABLE region (
  id_region INT PRIMARY KEY AUTO_INCREMENT,
  nom_region VARCHAR(100) NOT NULL
);

-- 2. Table des départements
CREATE TABLE departement (
  id_departement INT PRIMARY KEY AUTO_INCREMENT,
  nom_departement VARCHAR(100) NOT NULL,
  id_region INT NOT NULL,
  FOREIGN KEY (id_region) REFERENCES region(id_region)
);

-- 3. Table des communes
CREATE TABLE commune (
  id_commune INT PRIMARY KEY AUTO_INCREMENT,
  nom_commune VARCHAR(100) NOT NULL,
  id_departement INT NOT NULL,
  FOREIGN KEY (id_departement) REFERENCES departement(id_departement)
);

-- 4. Table des villages
CREATE TABLE village (
  code_village VARCHAR(10) PRIMARY KEY,
  nom_village VARCHAR(100),
  id_commune INT,
  population INT,
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  statut_electrification ENUM('electrifié','non électrifié') DEFAULT 'non électrifié',
  date_electrification DATE,
  FOREIGN KEY (id_commune) REFERENCES commune(id_commune)
);

-- 5. Table des priorités
CREATE TABLE priorite (
  id_priorite INT PRIMARY KEY AUTO_INCREMENT,
  code_village VARCHAR(10),
  niveau_priorite ENUM('faible','moyenne','élevée') DEFAULT 'faible',
  motif TEXT,
  date_classement DATE,
  FOREIGN KEY (code_village) REFERENCES village(code_village)
);

-- 6. Table des installations d’électrification
CREATE TABLE electrification (
  id_electrification INT PRIMARY KEY AUTO_INCREMENT,
  code_village VARCHAR(10),
  type_source VARCHAR(50), -- réseau national , solaire, etc.
  puissance_installee_kw DECIMAL(10,2),
  date_installation DATE,
  duree_de_vie_annees INT,
  cout_initial_fcfa DECIMAL(12,0),
  FOREIGN KEY (code_village) REFERENCES village(code_village)
);

-- 7. Table des consommations électriques annuelles
CREATE TABLE consommation (
  id_consommation INT PRIMARY KEY AUTO_INCREMENT,
  code_village VARCHAR(10),
  annee INT,
  consommation_kwh DECIMAL(12,2),
  FOREIGN KEY (code_village) REFERENCES village(code_village)
);

-- 8. Table des types d’appareils utilisés
CREATE TABLE appareil (
  id_appareil INT PRIMARY KEY AUTO_INCREMENT,
  nom_appareil VARCHAR(100),
  puissance_kw DECIMAL(5,2),
  duree_vie_annees INT
);

-- 9. Table d’utilisation des appareils par village
CREATE TABLE utilisation_appareil (
  id_utilisation INT PRIMARY KEY AUTO_INCREMENT,
  code_village VARCHAR(10),
  id_appareil INT,
  nombre INT,
  FOREIGN KEY (code_village) REFERENCES village(code_village),
  FOREIGN KEY (id_appareil) REFERENCES appareil(id_appareil)
);

-- 10. Table des maintenances effectuées
CREATE TABLE maintenance (
  id_maintenance INT PRIMARY KEY AUTO_INCREMENT,
  id_electrification INT,
  date_maintenance DATE,
  type_operation VARCHAR(100),
  cout_fcfa DECIMAL(12,0),
  FOREIGN KEY (id_electrification) REFERENCES electrification(id_electrification)
);

-- 11. Table des distances entre villages (pour calculs de proximité)
CREATE TABLE distance_village (
  id_distance INT PRIMARY KEY AUTO_INCREMENT,
  village_source VARCHAR(10),
  village_cible VARCHAR(10),
  distance_km DECIMAL(6,2),
  FOREIGN KEY (village_source) REFERENCES village(code_village),
  FOREIGN KEY (village_cible) REFERENCES village(code_village)
);



INSERT INTO region (nom_region) VALUES
('Dakar'),
('Diourbel'),
('Fatick'),
('Kaffrine'),
('Kaolack'),
('Kédougou'),
('Kolda'),
('Louga'),
('Matam'),
('Saint-Louis'),
('Sédhiou'),
('Tambacounda'),
('Thiès'),
('Ziguinchor');


INSERT INTO departement (nom_departement, id_region) VALUES
('Bignona', 14),    -- Ziguinchor
('Oussouye', 14),
('Ziguinchor', 14),

('Dakar', 1),      -- Dakar
('Guédiawaye', 1),
('Pikine', 1),
('Rufisque', 1),

('Diourbel', 2),   -- Diourbel
('Mbacké', 2),
('Bambey', 2),

('Fatick', 3),     -- Fatick
('Foundiougne', 3),
('Gossas', 3),

('Kaffrine', 4),   -- Kaffrine
('Birkilane', 4),
('Koungheul', 4),
('Malem Hodar', 4),

('Kaolack', 5),    -- Kaolack
('Guinguinéo', 5),
('Nioro du Rip', 5),

('Kédougou', 6),   -- Kédougou
('Salémata', 6),
('Saraya', 6),

('Kolda', 7),      -- Kolda
('Médina Yoro Foulah', 7),
('Vélingara', 7),

('Louga', 8),      -- Louga
('Kébémer', 8),
('Linguère', 8),

('Matam', 9),      -- Matam
('Kanel', 9),
('Ranérou Ferlo', 9),

('Saint-Louis', 10),  -- Saint-Louis
('Dagana', 10),
('Podor', 10),

('Sédhiou', 11),   -- Sédhiou
('Bounkiling', 11),
('Goudomp', 11),

('Tambacounda', 12), -- Tambacounda
('Bakel', 12),
('Goudiry', 12),
('Koumpentoum', 12),

('Thiès', 13),     -- Thiès
('Mbour', 13),
('Tivaouane', 13);




INSERT INTO commune (id_commune, nom_commune, id_departement) VALUES
(1, 'Dakar', 1),
(2, 'Hann Bel-Air', 1),
(3, 'Pikine', 2),
(4, 'Malika', 2),
(5, 'Guédiawaye', 3),
(6, 'Camberène', 3),
(7, 'Rufisque', 4),
(8, 'Bargny', 4),
(9, 'Mbour', 5),
(10, 'Joal-Fadiouth', 5),
(11, 'Thiès', 6),
(12, 'Tivaouane', 6),
(13, 'Tivaouane', 7),
(14, 'Meckhe', 7),
(15, 'Fatick', 8),
(16, 'Foundiougne', 8),
(17, 'Foundiougne', 9),
(18, 'Karang', 9),
(19, 'Kaolack', 10),
(20, 'Ndoffane', 10),
(21, 'Guinguinéo', 11),
(22, 'Fass', 11),
(23, 'Kaffrine', 12),
(24, 'Birkelane', 12),
(25, 'Koungheul', 13),
(26, 'Keur Massar', 13),
(27, 'Malem Hodar', 14),
(28, 'Diourbel', 14),
(29, 'Kédougou', 15),
(30, 'Salémata', 15),
(31, 'Saraya', 16),
(32, 'Touba', 16),
(33, 'Kolda', 17),
(34, 'Médina Yoro Foulah', 17),
(35, 'Vélingara', 18),
(36, 'Bonconto', 18),
(37, 'Sédhiou', 19),
(38, 'Bounkiling', 19),
(39, 'Matam', 20),
(40, 'Ogo', 20),
(41, 'Ranérou', 21),
(42, 'Keur Madiabel', 21),
(43, 'Bakel', 22),
(44, 'Diawara', 22),
(45, 'Louga', 23),
(46, 'Kébémer', 23),
(47, 'Kébémer', 24),
(48, 'Dagana Centre', 24),
(49, 'Linguère', 25),
(50, 'Dahra', 25),
(51, 'Saint-Louis', 26),
(52, 'Podor', 26),
(53, 'Dagana', 27),
(54, 'Richard-Toll', 27),
(55, 'Podor', 28),
(56, 'Thiaroye', 28),
(57, 'Goudomp', 29),
(58, 'Nguekokh', 29),
(59, 'Bignona', 30),
(60, 'Sindia', 30),
(61, 'Ziguinchor', 31),
(62, 'Patar', 31),
(63, 'Oussouye', 32),
(64, 'Tambacounda', 32),
(65, 'Koumpentoum', 33),
(66, 'Goudiry', 33),
(67, 'Nioro du Rip', 34),
(68, 'Ndindy', 34),
(69, 'Kanel', 35),
(70, 'Pambal', 35),
(71, 'Médina Yoro Foulah', 36),
(72, 'Keur Samba Kane', 36);




INSERT INTO village (code_village, nom_village, id_commune, population, latitude, longitude, statut_electrification, date_electrification) VALUES
-- 1-20
('VIL0001','Kagnobon',59,3383,12.842200,-16.420000,'non électrifié',NULL),
('VIL0002','Suzana',59,193,12.843000,-16.421000,'non électrifié',NULL),
('VIL0003','Ndayane',10,4331,14.565000,-17.125556,'non électrifié',NULL),
('VIL0004','Bonconto',36,1001,12.700000,-12.700000,'non électrifié',NULL),
('VIL0005','Darou Hidjiratou',36,2925,12.701000,-12.701000,'non électrifié',NULL),
('VIL0006','Karongué',16,2500,14.200000,-16.350000,'non électrifié',NULL),
('VIL0007','Fass',22,960,14.450000,-15.920000,'non électrifié',NULL),
('VIL0008','Mbour',9,1001,14.430000,-16.960000,'electrifié','2022-01-10'),
('VIL0009','Joal-Fadiouth',10,973,14.115000,-16.936000,'electrifié','2022-02-15'),
('VIL0010','Hann Bel-Air',2,45000,14.722000,-17.440000,'electrifié','2021-11-08'),
('VIL0011','Dakar',1,1500000,14.692778,-17.446667,'electrifié','2000-05-01'),
('VIL0012','Malika',4,1040,14.740000,-17.380000,'non électrifié',NULL),
('VIL0013','Pikine',3,1000,14.747000,-17.317000,'electrifié','2010-07-20'),
('VIL0014','Rufisque',7,2000,14.716000,-17.247000,'electrifié','2005-03-12'),
('VIL0015','Bargny',8,60000,14.716000,-17.227000,'non électrifié',NULL),
('VIL0016','Thiès',12,320000,14.795000,-16.928000,'electrifié','2015-06-30'),
('VIL0017','Tivaouane',11,53000,14.900000,-16.852000,'electrifié','2018-09-14'),
('VIL0018','Fatick',15,45000,14.260000,-16.420000,'electrifié','2013-04-22'),
('VIL0019','Foundiougne',16,38000,14.277000,-16.100000,'non électrifié',NULL),
('VIL0020','Kaolack',19,180000,14.150000,-16.050000,'electrifié','2011-10-05'),

-- 21-40
('VIL0021','Guinguinéo',21,40000,14.166000,-15.383000,'non électrifié',NULL),
('VIL0022','Fass',22,3500,14.450000,-15.920000,'non électrifié',NULL),
('VIL0023','Kaffrine',23,1100,14.033000,-14.433000,'non électrifié',NULL),
('VIL0024','Birkelane',24,15000,13.902000,-14.435000,'non électrifié',NULL),
('VIL0025','Koungheul',25,21000,13.903000,-13.715000,'non électrifié',NULL),
('VIL0026','Keur Massar',13,185000,14.750000,-17.250000,'electrifié','2020-08-01'),
('VIL0027','Malem Hodar',27,10000,14.100000,-14.050000,'non électrifié',NULL),
('VIL0028','Diourbel',28,130000,14.658000,-16.239000,'electrifié','2014-03-15'),
('VIL0029','Kédougou',29,30000,12.545000,-12.184000,'non électrifié',NULL),
('VIL0030','Salémata',30,15000,12.413000,-11.720000,'non électrifié',NULL),
('VIL0031','Saraya',31,21000,12.253000,-12.265000,'non électrifié',NULL),
('VIL0032','Touba',32,530000,14.871000,-15.588000,'electrifié','2019-12-01'),
('VIL0033','Kolda',33,162000,12.881000,-14.967000,'electrifié','2012-05-20'),
('VIL0034','Médina Yoro Foulah',34,12000,12.832000,-14.950000,'non électrifié',NULL),
('VIL0035','Vélingara',35,40000,13.144000,-14.221000,'non électrifié',NULL),
('VIL0036','Bonconto',36,18000,12.700000,-12.700000,'non électrifié',NULL),
('VIL0037','Sédhiou',37,27000,12.675000,-12.644000,'electrifié','2021-07-10'),
('VIL0038','Bounkiling',38,24000,12.660000,-14.296000,'non électrifié',NULL),
('VIL0039','Matam',39,50000,15.652000,-13.227000,'electrifié','2016-02-22'),
('VIL0040','Ogo',40,8000,15.676000,-13.198000,'non électrifié',NULL),

-- 41-60
('VIL0041','Ranérou',41,12000,15.165000,-14.307000,'non électrifié',NULL),
('VIL0042','Keur Madiabel',42,6000,15.143000,-14.270000,'non électrifié',NULL),
('VIL0043','Bakel',43,22000,14.170000,-12.980000,'non électrifié',NULL),
('VIL0044','Diawara',44,8000,14.195000,-12.907000,'non électrifié',NULL),
('VIL0045','Louga',45,132000,15.612000,-16.321000,'electrifié','2017-11-05'),
('VIL0046','Kébémer',46,54000,15.182000,-16.459000,'electrifié','2018-01-20'),
('VIL0047','Kébémer',47,54000,15.182000,-16.459000,'electrifié','2018-01-20'),
('VIL0048','Dagana Centre',48,27000,16.056000,-15.183000,'electrifié','2015-09-12'),
('VIL0049','Linguère',49,31000,15.500000,-14.766000,'non électrifié',NULL),
('VIL0050','Dahra',50,12000,15.363000,-15.215000,'non électrifié',NULL),
('VIL0051','Saint-Louis',51,200000,16.015000,-16.495000,'electrifié','2010-11-30'),
('VIL0052','Podor',52,35000,16.235000,-15.246000,'non électrifié',NULL),
('VIL0053','Dagana',53,120000,16.057000,-15.183000,'electrifié','2013-04-10'),
('VIL0054','Richard-Toll',54,60000,16.195000,-15.239000,'electrifié','2014-07-20'),
('VIL0055','Podor',55,35000,16.235000,-15.246000,'non électrifié',NULL),
('VIL0056','Thiaroye',56,150000,14.700000,-17.433000,'electrifié','2019-05-15'),
('VIL0057','Goudomp',57,12000,12.570000,-13.058000,'non électrifié',NULL),
('VIL0058','Nguekokh',58,9000,14.230000,-16.547000,'non électrifié',NULL),
('VIL0059','Bignona',59,19000,12.832000,-16.505000,'non électrifié',NULL),
('VIL0060','Sindia',60,11000,12.800000,-16.567000,'non électrifié',NULL),

-- 61-80
('VIL0061','Ziguinchor',61,97000,12.573000,-16.269000,'electrifié','2011-08-15'),
('VIL0062','Patar',62,6000,12.580000,-16.250000,'non électrifié',NULL),
('VIL0063','Oussouye',63,8000,12.583000,-16.483000,'non électrifié',NULL),
('VIL0064','Tambacounda',64,78000,13.764000,-13.677000,'electrifié','2014-03-01'),
('VIL0065','Koumpentoum',65,15000,14.335000,-13.675000,'non électrifié',NULL),
('VIL0066','Goudiry',66,16000,13.748000,-13.549000,'non électrifié',NULL),
('VIL0067','Nioro du Rip',67,20000,13.561000,-15.700000,'non électrifié',NULL),
('VIL0068','Ndindy',68,7000,13.550000,-15.720000,'non électrifié',NULL),
('VIL0069','Kanel',69,10000,15.542000,-13.105000,'non électrifié',NULL),
('VIL0070','Pambal',70,5000,15.530000,-13.120000,'non électrifié',NULL),
('VIL0071','Médina Yoro Foulah',71,18000,12.830000,-14.950000,'non électrifié',NULL),
('VIL0072','Keur Samba Kane',72,4500,12.825000,-14.940000,'non électrifié',NULL),
('VIL0073','Camberène',6,12000,14.713000,-17.394000,'electrifié','2020-06-15'),
('VIL0074','Keur Madiabel',42,11000,15.143000,-14.270000,'non électrifié',NULL),

('VIL0081','Thiaroye-sur-Mer',56,27000,14.716100,-17.444400,'electrifié','2021-03-12'),
('VIL0082','Mbacké',28,58000,14.831200,-16.139700,'electrifié','2012-11-05'),
('VIL0083','Diourbel',28,135000,14.659000,-16.239500,'electrifié','2014-04-22'),
('VIL0084','Touba',32,542000,14.871400,-15.588600,'electrifié','2019-12-01'),
('VIL0085','Sindia',60,11500,12.794000,-16.570000,'non électrifié',NULL),
('VIL0086','Nguekokh',58,9500,14.228000,-16.548000,'non électrifié',NULL),
('VIL0087','Karang',18,5200,14.276000,-16.098000,'non électrifié',NULL),
('VIL0088','Birkelane',24,15500,13.905000,-14.436000,'non électrifié',NULL),
('VIL0089','Bonconto',36,18200,12.705000,-12.705000,'non électrifié',NULL),
('VIL0090','Goudiry',66,16200,13.749000,-13.550000,'non électrifié',NULL),
('VIL0091','Koumpentoum',65,15200,14.336000,-13.676000,'non électrifié',NULL),
('VIL0092','Nioro du Rip',67,20500,13.561500,-15.700500,'non électrifié',NULL),
('VIL0093','Ziguinchor',61,98000,12.573200,-16.269200,'electrifié','2011-08-15'),
('VIL0094','Bignona',59,19100,12.832500,-16.505500,'non électrifié',NULL),
('VIL0095','Oussouye',63,8100,12.583200,-16.483200,'non électrifié',NULL),
('VIL0096','Kébémer',46,54500,15.183000,-16.460000,'electrifié','2018-01-20');






INSERT INTO electrification (code_village, type_source, puissance_installee_kw, date_installation, duree_de_vie_annees, cout_initial_fcfa) VALUES
('VIL0008','réseau national',2050.00,'2022-01-10',30,300000000),
('VIL0009','réseau national',450.00,'2022-02-15',30,100000000),
('VIL0010','réseau national',900.00,'2021-11-08',30,180000000),
('VIL0011','réseau national',30000.00,'2000-05-01',30,1000000000),
('VIL0013','réseau national',20000.00,'2010-07-20',30,900000000),
('VIL0014','réseau national',4000.00,'2005-03-12',30,150000000),
('VIL0016','réseau national',6400.00,'2015-06-30',30,220000000),
('VIL0017','solaire',1060.00,'2018-09-14',20,120000000),
('VIL0018','solaire',900.00,'2013-04-22',20,100000000),
('VIL0020','réseau national',3600.00,'2011-10-05',30,160000000),
('VIL0026','réseau national',3700.00,'2020-08-01',30,180000000),
('VIL0028','réseau national',2600.00,'2014-03-15',30,140000000),
('VIL0032','réseau national',10600.00,'2019-12-01',30,400000000),
('VIL0033','réseau national',3200.00,'2012-05-20',30,160000000),
('VIL0037','solaire',540.00,'2021-07-10',20,95000000),
('VIL0039','solaire',1000.00,'2016-02-22',20,120000000),
('VIL0045','réseau national',2640.00,'2017-11-05',30,140000000),
('VIL0046','réseau national',1080.00,'2018-01-20',30,110000000),
('VIL0047','réseau national',1080.00,'2018-01-20',30,110000000),
('VIL0048','solaire',540.00,'2015-09-12',20,95000000),
('VIL0051','réseau national',4000.00,'2010-11-30',30,200000000),
('VIL0053','solaire',2400.00,'2013-04-10',20,100000000),
('VIL0054','solaire',1200.00,'2014-07-20',20,90000000),
('VIL0056','réseau national',3000.00,'2019-05-15',30,130000000),
('VIL0061','réseau national',2000.00,'2011-08-15',30,100000000),
('VIL0064','solaire',1560.00,'2014-03-01',20,95000000),
('VIL0073','réseau national',240.00,'2020-06-15',30,60000000),
('VIL0081','réseau national',540.00,'2021-03-12',30,95000000),
('VIL0082','réseau national',1160.00,'2012-11-05',30,120000000),
('VIL0083','réseau national',2700.00,'2014-04-22',30,150000000),
('VIL0084','réseau national',10840.00,'2019-12-01',30,400000000),
('VIL0093','réseau national',1960.00,'2011-08-15',30,110000000),
('VIL0096','réseau national',1090.00,'2018-01-20',30,115000000);




INSERT INTO consommation (code_village, annee, consommation_kwh) VALUES
('VIL0008', 2023, 20469000.00),
('VIL0009', 2023, 4529000.00),
('VIL0010', 2023, 9000000.00),
('VIL0011', 2023, 300000000.00),
('VIL0013', 2023, 200000000.00),
('VIL0014', 2023, 40000000.00),
('VIL0016', 2023, 64000000.00),
('VIL0017', 2023, 10600000.00),
('VIL0018', 2023, 9000000.00),
('VIL0020', 2023, 36000000.00),
('VIL0026', 2023, 37000000.00),
('VIL0028', 2023, 26000000.00),
('VIL0032', 2023, 106000000.00),
('VIL0033', 2023, 32400000.00),
('VIL0037', 2023, 5400000.00),
('VIL0039', 2023, 10000000.00),
('VIL0045', 2023, 26400000.00),
('VIL0046', 2023, 10800000.00),
('VIL0047', 2023, 10800000.00),
('VIL0048', 2023, 5400000.00),
('VIL0051', 2023, 40000000.00),
('VIL0053', 2023, 24000000.00),
('VIL0054', 2023, 12000000.00),
('VIL0056', 2023, 30000000.00),
('VIL0061', 2023, 19400000.00),
('VIL0064', 2023, 15600000.00),
('VIL0073', 2023, 2400000.00),
('VIL0081', 2023, 5400000.00),
('VIL0082', 2023, 11600000.00),
('VIL0083', 2023, 27000000.00),
('VIL0084', 2023, 108400000.00),
('VIL0093', 2023, 19600000.00),
('VIL0096', 2023, 10900000.00);



INSERT INTO appareil (nom_appareil, puissance_kw, duree_vie_annees) VALUES
('Ampoule LED', 0.01, 5),
('Réfrigérateur', 0.15, 10),
('Téléviseur LED', 0.10, 8),
('Ventilateur', 0.05, 7),
('Chargeur téléphone', 0.005, 3),
('Radio', 0.02, 6),
('Machine à laver', 0.50, 12),
('Pompage eau', 1.50, 15),
('Ordinateur portable', 0.05, 5);




INSERT INTO utilisation_appareil (code_village, id_appareil, nombre) VALUES
-- Mbour (VIL0008) : gros village, usage varié
('VIL0008', 1, 3200),  -- Ampoule LED
('VIL0008', 2, 14),  -- Réfrigérateur
('VIL0008', 3, 110),  -- Téléviseur LED
('VIL0008', 4, 70),   -- Ventilateur
('VIL0008', 5, 2800),  -- Chargeur téléphone
('VIL0008', 6, 800),   -- Radio
('VIL0008', 9, 40),   -- Ordinateur portable

-- Joal-Fadiouth (VIL0009) : moins équipé
('VIL0009', 1, 800),
('VIL0009', 3, 35),
('VIL0009', 5, 700),
('VIL0009', 6, 300),

-- Dakar (VIL0011) : grande ville, appareils variés
('VIL0011', 1, 4500),
('VIL0011', 2, 2000),
('VIL0011', 3, 1800),
('VIL0011', 4, 1200),
('VIL0011', 5, 3000),
('VIL0011', 6, 1000),
('VIL0011', 7, 5000),
('VIL0011', 8, 1500),
('VIL0011', 9, 1200),

-- Pikine (VIL0013)
('VIL0013', 1, 3000),
('VIL0013', 2, 1200),
('VIL0013', 3, 1000),
('VIL0013', 5, 2500),
('VIL0013', 6, 800),
('VIL0013', 7, 2000),

-- Rufisque (VIL0014)
('VIL0014', 1, 600),
('VIL0014', 2, 300),
('VIL0014', 3, 200),
('VIL0014', 4, 500),
('VIL0014', 5, 500),

-- Thiès (VIL0016)
('VIL0016', 1, 900),
('VIL0016', 2, 400),
('VIL0016', 3, 350),
('VIL0016', 4, 200),
('VIL0016', 5, 750),

-- Tivaouane (VIL0017)
('VIL0017', 1, 140),
('VIL0017', 2, 600),
('VIL0017', 3, 500),
('VIL0017', 5, 120),

-- Fatick (VIL0018)
('VIL0018', 1, 130),
('VIL0018', 2, 700),
('VIL0018', 3, 600),
('VIL0018', 5, 150),

-- Kaolack (VIL0020)
('VIL0020', 1, 500),
('VIL0020', 2, 230),
('VIL0020', 3, 180),
('VIL0020', 5, 470),
('VIL0020', 8, 800),

-- Guinguinéo (VIL0021) — NON électrifié donc pas d'appareil

-- Kaffrine (VIL0023) — NON électrifié

-- Diourbel (VIL0028)
('VIL0028', 1, 900),
('VIL0028', 2, 400),
('VIL0028', 3, 350),
('VIL0028', 5, 850),
('VIL0028', 6, 900),

-- Touba (VIL0032)
('VIL0032', 1, 1500),
('VIL0032', 2, 700),
('VIL0032', 3, 650),
('VIL0032', 5, 1700),
('VIL0032', 9, 300),

-- Kolda (VIL0033)
('VIL0033', 1, 500),
('VIL0033', 2, 230),
('VIL0033', 5, 460),

-- Sédhiou (VIL0037)
('VIL0037', 1, 1400),
('VIL0037', 5, 150),

-- Matam (VIL0039)
('VIL0039', 1, 220),
('VIL0039', 5, 260),

-- Louga (VIL0045)
('VIL0045', 1, 300),
('VIL0045', 2, 120),
('VIL0045', 5, 2500),

-- Kébémer (VIL0046)
('VIL0046', 1, 180),
('VIL0046', 2, 70),
('VIL0046', 5, 150),

-- Dagana Centre (VIL0048)
('VIL0048', 1, 130),
('VIL0048', 5, 150),

-- Saint-Louis (VIL0051)
('VIL0051', 1, 850),
('VIL0051', 2, 110),
('VIL0051', 3, 300),
('VIL0051', 5, 900),

-- Podor (VIL0053)
('VIL0053', 1, 250),
('VIL0053', 5, 300),

-- Thiaroye (VIL0056)
('VIL0056', 1, 140),
('VIL0056', 2, 700),
('VIL0056', 3, 600),
('VIL0056', 5, 120),

-- Ziguinchor (VIL0061)
('VIL0061', 1, 550),
('VIL0061', 2, 270),
('VIL0061', 3, 220),
('VIL0061', 5, 600),

-- Tambacounda (VIL0064)
('VIL0064', 1, 210),
('VIL0064', 5, 230),

-- Camberène (VIL0073)
('VIL0073', 1, 90),
('VIL0073', 5, 120),

-- Thiaroye-sur-Mer (VIL0081)
('VIL0081', 1, 150),
('VIL0081', 5, 170),

-- Mbacké (VIL0082)
('VIL0082', 1, 400),
('VIL0082', 5, 450),

-- Diourbel (VIL0083)
('VIL0083', 1, 100),
('VIL0083', 2, 40),
('VIL0083', 5, 800),

-- Touba (VIL0084)
('VIL0084', 1, 160),
('VIL0084', 2, 80),
('VIL0084', 5, 1400),

-- Ziguinchor (VIL0093)
('VIL0093', 1, 560),
('VIL0093', 5, 610),

-- Kébémer (VIL0096)
('VIL0096', 1, 180),
('VIL0096', 2, 70),
('VIL0096', 5, 150);



-- Priorité élevée : grandes populations ou capitales non électrifiées
INSERT INTO priorite (code_village, niveau_priorite, motif, date_classement) VALUES
('VIL0003', 'élevée', 'Population élevée (4331) et zone côtière', '2025-07-20'),
('VIL0021', 'élevée', 'Ville importante sans électrification', '2025-07-20'),
('VIL0023', 'élevée', 'Centre urbain régional non électrifié', '2025-07-20'),
('VIL0025', 'élevée', 'Population > 20 000 sans électricité', '2025-07-20'),
('VIL0029', 'élevée', 'Chef-lieu régional non électrifié', '2025-07-20'),
('VIL0030', 'élevée', 'Commune de plus de 15 000 habitants', '2025-07-20'),
('VIL0034', 'élevée', 'Zone enclavée à forte population', '2025-07-20'),
('VIL0035', 'élevée', 'Ville moyenne sans électricité', '2025-07-20'),
('VIL0036', 'élevée', 'Population importante sans accès au réseau', '2025-07-20'),
('VIL0049', 'élevée', 'Ville stratégique en zone sahélienne', '2025-07-20'),
('VIL0050', 'élevée', 'Commune à forte densité sans électricité', '2025-07-20'),
('VIL0052', 'élevée', 'Grande commune du nord sans électrification', '2025-07-20'),
('VIL0055', 'élevée', 'Zone frontalière densément peuplée', '2025-07-20'),
('VIL0065', 'élevée', 'Centre de transit vers l’est non électrifié', '2025-07-20'),
('VIL0066', 'élevée', 'Ville moyenne à desservir en priorité', '2025-07-20'),
('VIL0071', 'élevée', 'Commune centrale en Casamance', '2025-07-20'),
('VIL0090', 'élevée', 'Important bassin minier et agroélevage', '2025-07-20');

-- Priorité moyenne : population intermédiaire ou proximité du réseau
INSERT INTO priorite (code_village, niveau_priorite, motif, date_classement) VALUES
('VIL0004', 'moyenne', 'Commune de taille moyenne en zone sud', '2025-07-20'),
('VIL0005', 'moyenne', 'Population moyenne, éloigné du réseau', '2025-07-20'),
('VIL0012', 'moyenne', 'Commune proche de Dakar sans électrification', '2025-07-20'),
('VIL0015', 'moyenne', 'Zone périurbaine non électrifiée', '2025-07-20'),
('VIL0019', 'moyenne', 'Commune fluviale stratégique non électrifiée', '2025-07-20'),
('VIL0024', 'moyenne', 'Chef-lieu de département de 15 000 habitants', '2025-07-20'),
('VIL0031', 'moyenne', 'Population modérée', '2025-07-20'),
('VIL0038', 'moyenne', 'Centre départemental proche zone électrifiée', '2025-07-20'),
('VIL0040', 'moyenne', 'Commune proche d’une zone électrifiée', '2025-07-20'),
('VIL0057', 'moyenne', 'Commune rurale de 12 000 habitants', '2025-07-20'),
('VIL0060', 'moyenne', 'Proximité de zones électrifiées (Mbour)', '2025-07-20'),
('VIL0062', 'moyenne', 'Commune casamançaise à population moyenne', '2025-07-20'),
('VIL0063', 'moyenne', 'Chef-lieu d’arrondissement en zone sud', '2025-07-20'),
('VIL0067', 'moyenne', 'Commune rurale centrale du centre-ouest', '2025-07-20'),
('VIL0085', 'moyenne', 'Proximité d’un village électrifié (Sindia)', '2025-07-20'),
('VIL0086', 'moyenne', 'Zone dense proche d’un réseau électrique', '2025-07-20'),
('VIL0087', 'moyenne', 'Commune fluviale de taille modeste', '2025-07-20'),
('VIL0088', 'moyenne', 'Ville intermédiaire à électrifier bientôt', '2025-07-20'),
('VIL0091', 'moyenne', 'Commune stratégique à l’Est du pays', '2025-07-20'),
('VIL0092', 'moyenne', 'Ville moyenne non connectée au réseau', '2025-07-20');

-- Priorité faible : villages isolés à faible population
INSERT INTO priorite (code_village, niveau_priorite, motif, date_classement) VALUES
('VIL0001', 'faible', 'Village rural isolé', '2025-07-20'),
('VIL0002', 'faible', 'Très faible population (193)', '2025-07-20'),
('VIL0006', 'faible', 'Zone reculée de la Petite-Côte', '2025-07-20'),
('VIL0007', 'faible', 'Population inférieure à 3 200', '2025-07-20'),
('VIL0022', 'faible', 'Petit village du centre', '2025-07-20'),
('VIL0027', 'faible', 'Zone rurale éloignée', '2025-07-20'),
('VIL0041', 'faible', 'Commune semi-désertique de faible densité', '2025-07-20'),
('VIL0042', 'faible', 'Village rural de 6 000 habitants', '2025-07-20'),
('VIL0043', 'faible', 'Population faible et éloignée', '2025-07-20'),
('VIL0044', 'faible', 'Village reculé à faible densité', '2025-07-20'),
('VIL0049', 'faible', 'Population moyenne mais priorités ailleurs', '2025-07-20'),
('VIL0058', 'faible', 'Village côtier peu peuplé', '2025-07-20'),
('VIL0059', 'faible', 'Zone secondaire à électrification différée', '2025-07-20'),
('VIL0068', 'faible', 'Zone rurale éloignée', '2025-07-20'),
('VIL0069', 'faible', 'Petit village isolé', '2025-07-20'),
('VIL0070', 'faible', 'Petit village isolé', '2025-07-20'),
('VIL0072', 'faible', 'Très petite population', '2025-07-20'),
('VIL0074', 'faible', 'Village doublon à faible densité', '2025-07-20'),
('VIL0094', 'faible', 'Zone rurale du sud non stratégique', '2025-07-20'),
('VIL0095', 'faible', 'Zone reculée en Casamance', '2025-07-20');



INSERT INTO maintenance (id_electrification, date_maintenance, type_operation, cout_fcfa) VALUES
(1, '2023-12-15', 'Révision annuelle', 1500000),
(2, '2024-01-20', 'Remplacement composants', 1200000),
(3, '2023-11-10', 'Vérification réseau', 1000000),
(4, '2024-02-05', 'Réparation générateur', 1800000),
(5, '2024-03-12', 'Maintenance solaire', 1300000),
(10, '2024-01-30', 'Entretien général', 900000),
(15, '2023-10-15', 'Réparation panne', 1100000);




INSERT INTO distance_village (village_source, village_cible, distance_km)
SELECT 
    v1.code_village AS village_source, 
    v2.code_village AS village_cible,
    6371 * 2 * ASIN(SQRT(
        POWER(SIN(RADIANS(v2.latitude - v1.latitude) / 2), 2) +
        COS(RADIANS(v1.latitude)) * COS(RADIANS(v2.latitude)) *
        POWER(SIN(RADIANS(v2.longitude - v1.longitude) / 2), 2)
    )) AS distance_km
FROM village v1
JOIN village v2 ON v1.code_village <> v2.code_village
WHERE
    -- Limiter aux distances max (ici 150 km)
    6371 * 2 * ASIN(SQRT(
        POWER(SIN(RADIANS(v2.latitude - v1.latitude) / 2), 2) +
        COS(RADIANS(v1.latitude)) * COS(RADIANS(v2.latitude)) *
        POWER(SIN(RADIANS(v2.longitude - v1.longitude) / 2), 2)
    )) <= 150
;




-- QUELQUES REQUETES SQL


-- Liste des villages électrifiés avec leur date d’électrification
SELECT 
    code_village,
    nom_village,
    population,
    date_electrification
FROM village
WHERE statut_electrification = 'electrifié'
ORDER BY date_electrification;



-- Villages non électrifiés classés comme prioritaires
SELECT 
    v.code_village,
    v.nom_village,
    v.population,
    p.niveau_priorite,
    p.motif
FROM village v
JOIN priorite p ON v.code_village = p.code_village
WHERE v.statut_electrification = 'non électrifié'
ORDER BY p.niveau_priorite DESC;


-- Villages classés par importance démographique (du plus peuplé au moins peuplé)
SELECT 
    code_village,
    nom_village,
    population
FROM village
ORDER BY population DESC;


-- Villages non électrifiés dans un rayon de 100 km autour d’un point donné
SELECT 
    v.code_village,
    v.nom_village,
    v.population,
    dv.distance_km
FROM distance_village dv
JOIN village v ON dv.village_cible = v.code_village
WHERE dv.village_source = 'VIL0001' -- Remplacer par le point de référence souhaité
  AND dv.distance_km <= 100
  AND v.statut_electrification = 'non électrifié';

-- ou si j'ai les coordonnées (longitude latitude du point en question )
-- exemple :  latitude = 14.0, longitude = -16.0
SELECT code_village, nom_village, population,
  (6371 * 2 * ASIN(SQRT(
    POWER(SIN(RADIANS(14.0 - latitude) / 2), 2) +
    COS(RADIANS(latitude)) * COS(RADIANS(14.0)) *
    POWER(SIN(RADIANS(-16.0 - longitude) / 2), 2)
  ))) AS distance_km
FROM village
WHERE statut_electrification = 'non électrifié'
HAVING distance_km <= 100;




-- Type d’électrification avec le coût total sur 20 ans (y compris remplacements)
SELECT type_source,
       ROUND(SUM(
         cout_initial_fcfa * CEIL(20.0 / duree_de_vie_annees)
       )) AS cout_total_20_ans
FROM electrification
GROUP BY type_source
ORDER BY cout_total_20_ans ASC;



-- Nombre de villages de plus de 1000 habitants dans la région de Kolda
SELECT COUNT(*) AS nb_villages_plus_1000
FROM village v
JOIN commune c ON v.id_commune = c.id_commune
JOIN departement d ON c.id_departement = d.id_departement
JOIN region r ON d.id_region = r.id_region
WHERE r.nom_region = 'Kolda'
  AND v.population > 1000;



-- Villages ≥500 habitants à moins de 50 km d’un village électrifié
SELECT DISTINCT v1.code_village, v1.nom_village, v1.population
FROM village v1
JOIN distance_village dv ON v1.code_village = dv.village_source
JOIN village v2 ON dv.village_cible = v2.code_village
WHERE v1.population >= 500
  AND v1.statut_electrification = 'non électrifié'
  AND v2.statut_electrification = 'electrifié'
  AND dv.distance_km <= 50;



-- Villages non électrifiés à <10 km d’un village électrifié récent (<2 ans)
SELECT DISTINCT v1.code_village, v1.nom_village
FROM village v1
JOIN distance_village dv ON v1.code_village = dv.village_source
JOIN village v2 ON dv.village_cible = v2.code_village
WHERE v1.statut_electrification = 'non électrifié'
  AND v2.statut_electrification = 'electrifié'
  AND v2.date_electrification >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
  AND dv.distance_km <= 10;



-- Consommation moyenne (kWh) pour villages d’environ 1000 habitants
SELECT ROUND(AVG(consommation_kwh), 2) AS conso_moyenne_kwh
FROM consommation c
JOIN village v ON c.code_village = v.code_village
WHERE v.population BETWEEN 950 AND 1050;




-- Top 5 des appareils les plus utilisés dans les villages électrifiés
SELECT a.nom_appareil, SUM(u.nombre) AS total_utilisation
FROM utilisation_appareil u
JOIN appareil a ON u.id_appareil = a.id_appareil
JOIN village v ON u.code_village = v.code_village
WHERE v.statut_electrification = 'electrifié'
GROUP BY a.nom_appareil
ORDER BY total_utilisation DESC
LIMIT 5;

-- END

