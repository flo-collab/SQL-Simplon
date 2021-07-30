CREATE DATABASE vignoble;

USE vignoble;

CREATE TABLE producteur
(
    numProd INT(2),
    nom VARCHAR(255),
    domaine VARCHAR(255),
    region VARCHAR(255),
    PRIMARY KEY (numProd)
);

CREATE TABLE vin
(
    numVin INT(2),
    appellation VARCHAR(255),
    couleur VARCHAR(255),
    annee YEAR(4),
    degres INT(2),
    PRIMARY KEY (numVin)
);

CREATE TABLE recolte
(
    nProd INT(2),
    nVin INT(2),
    quantite INT(3),
    PRIMARY KEY (nProd, nVin),
    FOREIGN KEY (nProd) REFERENCES producteur(numProd),
    FOREIGN KEY (nVin) REFERENCES vin(numVin)
);

INSERT INTO producteur (numProd, nom, domaine, region) VALUES
(1, 'Producteur1', 'Graves', 'Bordeaux'),
(2, 'Producteur2', 'Domaine Roblet-Monnot', 'Bourgogne'),
(3, 'Producteur3', 'Domaine des Rouges', 'Bordeaux'),
(4, 'Dupont', 'Domaine Marcel Richaud', 'Côte Du Rhône'),
(5, 'Producteur5', 'La Grande Oncle', 'Alsace'),
(6, 'Producteur6', 'Domaine Pierre Labet', 'Bourgogne'),
(7, 'Dupond', 'Domaine Mikulski', 'Bourgogne'),
(8, 'Producteur8', 'Domaine Tissot', 'Jura'),
(9, 'Producteur9', 'Domaine Peyre Rose', 'Languedoc Roussillon'),
(10, 'Producteur10', 'Domaine Chapelas', 'Côte Du Rhône'),
(11, 'Producteur11', 'Domaine Pierre Labet', 'Côte Du Rhône');

INSERT INTO vin (numVin, appellation, couleur, annee, degres) VALUES
(1, 'Château Villa Bel-Air', 'Rouge', 2014, 13),
(2, 'Domaine Roblet-Monnot', 'Rouge', 2017, 13),
(3, 'La Fussière', 'Rouge', 2017, 13),
(4, 'Mistral AOC', 'Rouge', 2004, 15),
(5, 'La Grange Oncle Charles', 'Blanc', 2018, 13),
(6, 'Vieilles Vignes', 'Blanc', 2017, 13),
(7, 'Genevrière', 'Blanc', 1999, 13),
(8, 'Cremant du Jura Blanc', 'Blanc', 2015, 15),
(9, 'Syrah Leone', 'Rosé', 1995, 15),
(10, 'Domaine Chapelas Rosé', 'Rosé', 2004, 14),
(11, 'Vieilles Vignes', 'Blanc', 2000, 15);

INSERT INTO recolte (nProd,nVin,quantite) VALUES
(1, 1, 20),
(2, 2, 40),
(3, 3, 50),
(4, 4, 100),
(5, 5, 70),
(6, 6, 90),
(7, 7, 200),
(8, 8, 5),
(9, 9, 25),
(10, 10, 100),
(11, 20, 70);

-- 01 Donner la liste des appellations des vins de 1995.
SELECT appellation FROM vin WHERE annee = '1995'
-- 02 Donner toutes les informations, hors identifiants, sur les vins après 2000.
SELECT appellation, couleur, annee, degre FROM vin WHERE annee > 2000
-- 03 Donner la liste des vins dont l'année est entre 2000 et 2009 (bornes incluses). 
SELECT numVin FROM vin WHERE annee BETWEEN 2000 AND 2009;
-- 04 Donner la liste des vins blancs de degré supérieur à 14.
SELECT numVin FROM vin WHERE degres > 14  AND couleur = 'Blanc'
-- 05 Donner la liste des vins dont l'appellation contient le sigle « AOC ».
SELECT numVin FROM vin WHERE appellation LIKE '%AOC%'
-- 06 Donner la liste des domaines de production de vins de la région Bordeaux.
SELECT domaine FROM producteur WHERE region = 'Bordeaux'
-- 07 Quels sont les noms et la région des producteurs du vin numéro 5 ? QUESTION DURE
SELECT nom, region FROM producteur 
WHERE numProd IN(SELECT nProd FROM recolte WHERE nVin 
IN (SELECT numVin FROM vin WHERE numVin = 5 ))

-- Sinon 
SELECT nom, region FROM producteur 
WHERE numProd = 5

-- 08 Quels sont les producteurs de la région Beaujolais ?
SELECT numProd FROM producteur  WHERE region = 'Beaujolais'
-- 09 Donner la liste des producteurs dont le nom commence par « Dupon » (e.g. Dupont, Dupond, ...) 
SELECT nom FROM producteur WHERE nom LIKE 'Dupon%'
-- 10 Donner la liste des noms des producteurs triée par ordre alphabétique.
SELECT nom FROM producteur ORDER BY nom ASC

---1 Donner la ou les années (par ordre décroissant)
--- où les vins ont le plus fort degré, en les triant par couleur.
SELECT annee FROM vin 
WHERE degres IN (SELECT MAX(degres)FROM vin)
ORDER BY annee DESC, couleur ASC

---2 Donner toutes les informations sur les vins, 
---ordonnés par couleur (ordre alphabétique) et degré (de plus fort au plus faible),
---dont le degré est supérieur au degré moyen de tous les vins.
SELECT * FROM vin
WHERE degres > (SELECT AVG(degres)FROM vin)
ORDER BY couleur ASC, degres DESC

---3 Donner le degré minimum et maximum des vins par appellation et par couleur.
SELECT MIN(degres),MAX(degres) FROM vin GROUP BY appellation, couleur

-- Por Verifier 
SELECT appellation, couleur, MIN(degres),MAX(degres) FROM vin GROUP BY appellation, couleur


--- Niveau Difficile
-- JOINTURES
-- 1 Donner les noms des producteurs qui produisent du vin numéro 20 en quantité supérieure à 50.
SELECT nom FROM producteur JOIN recolte 
ON producteur.numProd = recolte.nProd 
WHERE nVin = 20 AND quantite > 50

-- 2 Donner le nombre de récoltes de vin rouge en 2004 ? 
SELECT SUM(quantite) FROM recolte JOIN vin ON vin.numVin= recolte.nVin 
WHERE couleur='Rouge' AND annee='2004'

-- 3 Donner la quantité totale par année de vin blanc récolté.
SELECT count(annee) FROM vin WHERE couleur = 'Blanc' GROUP BY annee
-- Verification
SELECT * FROM vin WHERE couleur = 'Blanc' GROUP BY annee

-- 4 Donner le degré moyen par année de vin blanc récolté. 
 SELECT AVG(degres) FROM vin WHERE couleur = 'Blanc' GROUP BY annee

-- 5 Donner la liste des noms et des domaines des producteurs de vin rouge. 
SELECT producteur.nom, producteur.domaine FROM producteur 
JOIN recolte ON producteur.numProd = recolte.nProd 
JOIN vin ON vin.numVin=recolte.nVin 
WHERE vin.couleur ='Rouge'

-- 6 Donner l’appellation, le numéro du producteur et la quantité produite 
-- pour les vins récoltés en 1999 avec une quantité de 200.
SELECT appellation, numProd, quantite FROM producteur 
JOIN recolte ON producteur.numProd = recolte.nProd 
JOIN vin ON vin.numVin=recolte.nVin 
WHERE annee = '1999' AND quantite = 200

-- SOUS REQUETES
-- 1 Donner les noms des producteurs qui produisent du vin numéro 20 en quantité supérieure à 50.
SELECT nom FROM producteur 
WHERE numProd IN (SELECT nProd FROM recolte 
WHERE nVin = 20 AND quantite > 50)

-- 2 Donner le nombre de récoltes de vin rouge en 2004 ? 
SELECT SUM(quantite) FROM recolte WHERE nVin 
IN (SELECT numVin from vin WHERE annee = 2004 AND couleur='Rouge')

-- 4 Donner le degré moyen par année de vin blanc récolté.
SELECT AVG(degres) FROM vin WHERE couleur = 'Blanc' GROUP BY annee

-- 5 Donner la liste des noms et des domaines des producteurs de vin rouge.
SELECT nom, domaine FROM producteur 
WHERE numProd IN(
    SELECT nProd FROM recolte WHERE nVin IN(
        SELECT numVin FROM vin WHERE couleur = 'Rouge'))