DROP DATABASE btp ;
CREATE DATABASE IF NOT EXISTS btp ;
USE btp  ;
CREATE TABLE IF NOT EXISTS fournisseur (
    id INTEGER(10),
    nom VARCHAR (255),
    age INTEGER (4),
    ville VARCHAR(255),
    PRIMARY KEY(id)
    ); 

CREATE TABLE IF NOT EXISTS client (
    id INTEGER(10),
    nom VARCHAR (255),
    anneeNaiss INTEGER (4),
    ville VARCHAR(255),
    PRIMARY KEY(id)
    ); 

CREATE TABLE IF NOT EXISTS produit (
    label VARCHAR (255),
    idF INTEGER (10),
    prix INTEGER (10),
    PRIMARY KEY(label,idF),
    FOREIGN KEY(idF) REFERENCES Fournisseur(id),
    FOREIGN KEY(label) REFERENCES Commande(labelP)
    ); 

CREATE TABLE IF NOT EXISTS commande (
    num INTEGER (10),
    idC INTEGER (10),
    labelP VARCHAR (255),
    quantitie INTEGER (10),
    PRIMARY KEY(num, idC, labelP),
    FOREIGN KEY(labelP) REFERENCES Produit(label),
    FOREIGN KEY(idC) REFERENCES Client(id)
);

INSERT INTO produit (label,idF,prix)
VALUES
('sable',1,300),
('briques',1,1500),
('parpaing',1,1150),
('sable',2,350),
('tuiles',3,1200),
('parpaing',3,1300),
('briques',4,1500),
('ciment',4,1300),
('parpaing',4,1450),
('briques',5,1450),
('tuiles',5,1100);

INSERT INTO client (id,nom,anneeNaiss,ville)
VALUES
(1,'Jean',1965,'75006 Paris'),
(2,'Paul',1958,'75003 Paris'),
(3,'Vincent',1954,'94200 Evry'),
(4,'Pierre',1950,'92400 Courbevoie'),
(5,'Daniel',1963,'44000 Nantes');

INSERT INTO fournisseur (id,nom,age,ville)
VALUES
(1,'Abounayan',52,'92190 Meudon'),
(2,'Cima',37,'44150 Nantes'),
(3,'Preblocs',48,'92230 Gennevilliers'),
(4,'Samaco',61,'75018 Paris'),
(5,'Damasco',29,'49100 Angers');


INSERT INTO commande (num, idC, labelP, quantitie)
VALUES
(1,1,'briques',5),
(1,1,'ciment',10),
(2,2,'briques',12),
(2,2,'sable',9),
(2,2,'parpaing',15),
(3,3,'sable',17),
(4,4,'briques',8),
(4,4,'tuiles',17),
(5,5,'parpaing',10),
(5,5,'ciment',14),
(6,5,'briques',21),
(7,2,'ciment',12),
(8,4,'parpaing',8),
(9,1,'tuiles',15);

-- toutes les informations sur les clients
SELECT * FROM client;

-- toutes les informations « utiles à l’utilisateur » sur les clients
SELECT nom,anneeNaiss,ville FROM client ;

-- le nom des clients dont l’âge est supérieur à 50 
SELECT nom FROM client WHERE anneeNaiss < (YEAR(CURDATE()) - 50);

-- la liste des produits (leur label), sans doublon ! 
SELECT DISTINCT label FROM produit;

-- idem, mais cette fois la liste est triée par ordre alphabétique décroissant 
SELECT DISTINCT label FROM produit ORDER BY label DESC;

-- Les commandes avec une quantité entre 8 et 18 inclus
-- version avec le mot-clé BETWEEN 
SELECT * FROM commande WHERE quantitie  BETWEEN 8 AND 18;

-- version sans
SELECT * FROM commande WHERE quantitie > 8 AND quantitie < 18 ;

-- le nom et la ville des clients dont le nom commence par ’P’
SELECT nom,ville FROM client WHERE LEFT(nom, 1) = 'P';

-- le nom des fournisseurs situés à PARIS. 
SELECT nom FROM fournisseur WHERE ville LIKE '%Paris';

-- l’identifiant Fournisseur et le prix associés des "briques" et des "parpaing". 
-- une version sans le mot-clé IN 
SELECT idF,prix FROM fournisseur WHERE label = "briques" OR label = "parpaing";

-- une version avec le mot-clé IN 
SELECT idF,prix FROM fournisseur WHERE label IN ("briques","parpaing");

-- la liste des noms des clients avec ce qu’ils ont commandé (label + quantité des produits). 
-- version avec jointure (pas de produit cartésien) 
SELECT nom, labelP, quantitie FROM client JOIN commande ON client.id = commande.idC;
-- le produit cartésien entre les clients et les produits (i.e. toutes les combinaisons possibles     d’un achat par un client), on affichera le nom des clients ainsi que le label produits. 
-- Constatez le nombre de réponses (i.e. nombre de lignes du résultat) par rapport à la requête précédente ! 
SELECT nom, label FROM client CROSS JOIN produit;

-- la liste, triée par ordre alphabétique, des noms des clients qui commandent le produit"briques". 
SELECT nom FROM client WHERE id IN (SELECT idC FROM commande WHERE labelP = "briques" );

-- le nom des fournisseurs qui vendent des "briques" ou des "parpaing". 
-- une version avec jointure 
SELECT nom FROM fournisseur JOIN produit ON fournisseur.id = produit.idF 
WHERE label IN ("briques","parpaing");

-- une version avec requête imbriquée 
SELECT nom FROM fournisseur WHERE id IN (SELECT idF FROM produit WHERE label IN ("briques","parpaing"));

-- Attention : aucun produit cartésien 
-- Constatez que l’ordre d’affichage (et donc l’ordre de traitement) n’est pas le même ! 

-- le nom des produits fournis par des fournisseurs parisiens (intra muros uniquement). 
-- en 3 versions différentes (jointure, produit cartésien et requête imbriquée) 
--jointure
SELECT label FROM produit JOIN fournisseur ON fournisseur.id = produit.idF 
WHERE ville LIKE '%Paris';
--produit cartésien
SELECT label FROM produit, fournisseur WHERE id = idF AND ville LIKE '%Paris' ;
--requête imbriquée
SELECT label FROM produit WHERE idF IN (SELECT id FROM fournisseur WHERE ville LIKE '%Paris' );

-- les nom et adresse des clients ayant commandé des briques, tel que la quantité commandée soit comprise entre 10 et 15. 
SELECT nom, ville FROM client WHERE id IN
 (SELECT idC FROM commande WHERE labelP LIKE '%briques' AND quantitie  BETWEEN 10 AND 15);

-- le nom des fournisseurs, le nom des produits et leur coût, correspondant pour tous les fournisseurs proposant au moins un produit commandé par Jean. 
SELECT label, prix, nom FROM fournisseur , produit WHERE label IN
(SELECT labelP FROM commande WHERE idC IN
(SELECT id FROM client WHERE nom = 'Jean'));
-- Attention : utilisez la chaîne "Jean" dans la requête, et pas directement son id (non nécessairement connu). 

-- idem, mais on souhaite cette fois que le résultat affiche le nom des fournisseurs trié dans l’ordre alphabétique descendant et pour chaque fournisseur le nom des produits dans l’ordre ascendant. 
SELECT label, prix, nom FROM fournisseur , produit  WHERE label IN
(SELECT labelP FROM commande WHERE idC IN
(SELECT id FROM client WHERE nom = 'Jean'))
ORDER BY nom DESC, label ASC;

-- le nom et le coût moyen des produits. 
SELECT  label, AVG(prix) FROM produit GROUP BY label;

-- le nom des produits proposés et leur coût moyen lorsque celui-ci est supérieur à 1200. 
SELECT  label, AVG(prix) FROM produit GROUP BY label HAVING AVG(prix)> 1200;

-- le nom des produits dont le coût est inférieur au coût moyen de tous les produits. 
SELECT label FROM produit WHERE prix <(SELECT AVG(prix) FROM produit);

-- le nom des produits proposés et leur coût moyen pour les produits fournis par au moins 3 fournisseurs. 
SELECT label, AVG(prix) FROM produit GROUP BY label HAVING COUNT(label)>2;

