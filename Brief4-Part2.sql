CREATE DATABASE IF NOT EXISTS musique ;
USE musique ;
CREATE TABLE IF NOT EXISTS concert (
    nom VARCHAR (255),
    nom_O VARCHAR (255),
    date_ DATE,
    lieu VARCHAR (255),
    prix INTEGER(10),
    PRIMARY KEY(nom),
    FOREIGN KEY(nom_O) REFERENCES orchestre(nom)
    );
CREATE TABLE IF NOT EXISTS musicien (
    nom VARCHAR (255),
    instrument VARCHAR (255),
    anneeE INT(10),
    nom_O VARCHAR (255),
    PRIMARY KEY(nom),
    FOREIGN KEY(nom_O) REFERENCES orchestre(nom)
    );
CREATE TABLE IF NOT EXISTS orchestre (
    nom VARCHAR (255),
    style VARCHAR (255),
    chef VARCHAR (255),
    PRIMARY KEY(nom)
    );

INSERT INTO orchestre VALUES
('orchestre1', 'jazz', 'leonardo'),
('orchestre2', 'pop', 'michaelgelo'),
('orchestre3', 'rnb', 'raphael'),
('orchestre4', 'house', 'donatello'),
('orchestre5', 'classic', 'Smith'),
('orchestre6', 'classic', 'Smith'),
('orchestre7', 'blues', 'Ray');

INSERT INTO concert VALUES
('Ultrall', 'orchestre1', '2021-06-15', 'Stade de France', 500),
('Die rich or trie dying', 'orchestre2', '2004-09-03', 'Zenith', 100),
('Ultral', 'orchestre1', '2014-09-05', 'NY', 600),
('Life', 'orchestre3', '2020-11-22', 'Dubai', 400),
('Fiestea', 'orchestre3', '2010-07-12', 'Miami', 50),
('Power', 'orchestre2', '1997-08-16', 'Douala', 1000),
('Mozart', 'orchestre5', '2019-04-20', 'Opéra Bastille', 10),
('Zen', 'orchestre7', '2015-02-22', 'LA', 50),
('Relax', 'orchestre6', '2016-01-01', 'PARIS', 200);

INSERT INTO musicien VALUES 
('Yannick', 'guitare', 10, 'orchestre1'),
('Patrick', 'piano', 10, 'orchestre1'),
('Cedric', 'violon', 10, 'orchestre1'),
('Jordan', 'batterie', 2, 'orchestre2'),
('Gaelle', 'saxophone', 4, 'orchestre3'),
('Georges', 'harmonica', 20, 'orchestre6');


-- 1 Donner la liste des noms des jeunes musiciens et leurs instruments ; 
-- où jeune si moins de 5 ans d'expérience.
SELECT nom, instrument FROM musicien WHERE anneeE < 5;
-- 2 Donner la liste des différents instruments de l'orchestre « Jazz92 ».
XXX NO ANSWER XXX;
-- 3 Donner toutes les informations sur les musiciens jouant du violon.
SELECT * FROM musicien WHERE instrument = 'violon';
-- 4 Donner la liste des instruments dont les musiciens ont plus de 20 ans d'expérience.
SELECT instrument FROM musicien WHERE anneeE >=20;
-- 5 Donner la liste des noms des musiciens ayant entre 5 et 10 ans d'expérience (bornes incluses).
SELECT nom FROM musicien WHERE anneeE BETWEEN 5 AND 10;
-- 6 Donner la liste des instruments commençants par « vio » (e.g. violon, violoncelle, ...)
SELECT instrument FROM musicien WHERE instrument LIKE 'vio%';
-- 7 Donner la liste des noms d'orchestre de style jazz.
SELECT nom FROM orchestre WHERE style LIKE 'jazz'
-- 8 Donner la liste des noms d'orchestre dont le chef est John Smith.
SELECT nom FROM orchestre WHERE chef LIKE 'Smith'
-- 9 Donner la liste des concert triés par ordre alphabétique.
SELECT nom FROM concert ORDER BY nom ASC
-- 10 Donner la liste des concerts se déroulant le 31 décembre 2015 à Versailles
SELECT nom FROM concert WHERE date_ LIKE '2015-12-31' AND lieu LIKE 'Vers%'
-- 11 Donner les lieux de concerts où le prix est supérieur à 150 euros.
SELECT lieux FROM concert WHERE prix > 150
-- 12 Donner la liste des concerts se déroulant à Opéra Bastille pour moins de 50 euros.
SELECT nom FROM concert WHERE lieu LIKE '%Bastille' AND prix < 50
-- 13 Donner la liste des concert ayant eu lieu en 2014.
SELECT nom FROM concert WHERE date_ LIKE '2014%'


--JOINTURES
--1 Donner la liste des noms et instruments des musiciens ayant plus de 3 ans d'expérience 
--et faisant partie d'un orchestre de style jazz. On affichera par ordre alphabétique sur les noms.
SELECT musicien.nom, instrument FROM musicien JOIN orchestre ON musicien.nom_O = orchestre.nom 
WHERE style = 'jazz';
--2 Donner les différents lieux, triés par ordre alphabétique, de concerts où l'orchestre 
--du chef Smith joue avec un prix inférieur à 20.
SELECT lieu FROM concert JOIN orchestre ON orchestre.nom = concert.nom_O 
WHERE prix < 20 AND orchestre.chef LIKE '%Smith%';
--3 Donner le nombre de concerts de style blues en 2015.
SELECT COUNT(orchestre.style) FROM concert JOIN orchestre ON orchestre.nom = concert.nom_O
WHERE style = 'jazz'
--4 Donner le prix moyen des concerts de style jazz par lieu de production.
SELECT AVG(concert.prix) FROM concert JOIN orchestre ON orchestre.nom = concert.nom_O
WHERE style = 'jazz'
--5 Donner la liste des instruments participant aux concerts donnés par le chef Smith 
--le 1er janvier 2016.
SELECT instrument FROM musicien JOIN orchestre ON orchestre.nom = musicien.nom_O
JOIN concert ON orchestre.nom = concert.nom_O
WHERE chef LIKE '%Smith%' AND date_ = '2016-01-01'
--6 Donner le nombre moyen d'années d'expérience des joueurs de trompette par style d'orchestre.
SELECT AVG(anneeE) FROM musicien JOIN orchestre ON orchestre.nom = musicien.nom_O
WHERE instrument = 'trompette' GROUP BY style;

-- Essai perso
SELECT AVG(anneeE) FROM musicien JOIN orchestre ON orchestre.nom = musicien.nom_O
WHERE instrument IN ('violon','guitare','batterie') GROUP BY style;

--SOUS REQUETES
--1 Donner la liste des noms et instruments des musiciens ayant plus de 3 ans d'expérience 
--et faisant partie d'un orchestre de style jazz. On affichera par ordre alphabétique sur les noms.
SELECT nom, instrument FROM musicien WHERE anneeE > 3 
AND nom_O IN (SELECT nom FROM orchestre WHERE style = 'jazz') 
ORDER BY nom ASC
--2 Donner les différents lieux, triés par ordre alphabétique, de concerts où l'orchestre 
--du chef Smith joue avec un prix inférieur à 20.
SELECT lieu FROM concert WHERE prix < 20 AND nom_O 
IN (SELECT nom FROM orchestre WHERE chef LIKE '%Smith%')
ORDER BY lieu ASC
--3 Donner le nombre de concerts de style blues en 2015.
SELECT COUNT(concert.nom) FROM concert WHERE nom_O 
IN(SELECT nom FROM orchestre WHERE style = 'blues')

--4 Donner le prix moyen des concerts de style jazz par lieu de production.
SELECT AVG(concert.prix) FROM concert 
WHERE nom_O IN (SELECT nom FROM orchestre WHERE style = 'jazz') GROUP BY lieu
--5 Donner la liste des instruments participant aux concerts donnés par le chef Smith 
--le 1er janvier 2016.
SELECT instrument FROM musicien WHERE nom_O 
IN (SELECT nom FROM orchestre WHERE chef LIKE '%Smith%' 
AND nom IN (SELECT nom_O FROM concert WHERE date_ = '2016-01-01'))
