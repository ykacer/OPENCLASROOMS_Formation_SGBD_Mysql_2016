DROP DATABASE p2p_blog;
CREATE DATABASE p2p_blog CHARACTER SET 'utf8';
USE p2p_blog;

CREATE TABLE Categorie (
	id INT UNSIGNED AUTO_INCREMENT,
	nom VARCHAR(150) NOT NULL,
	PRIMARY KEY(id)
)
ENGINE=InnoDB;
ALTER TABLE Categorie
ADD COLUMN description TEXT NOT NULL;

CREATE TABLE Utilisateur (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	pseudo VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL, -- on accepte qu'un email ait plusieurs comptes (donc pas de UNIQUE)
	password VARCHAR(30) NOT NULL,
	CONSTRAINT UNIQUE ind_unique_pseudo (pseudo) -- ne jamais accepter deux utilisateurs avec meme pseudo (donc index UNIQUE sur pseudo)
)
ENGINE=InnoDB; 

CREATE TABLE Article (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	titre VARCHAR(200) NOT NULL,
	texte TEXT,
	resume VARCHAR(300),
	utilisateur_id INT UNSIGNED NOT NULL,
	CONSTRAINT fk_article_utilisateur_id FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) -- on ne rajoute un élément que si l'utilisateur associé (utilisateur_id) existe dans la table Utilisateur
)
ENGINE=InnoDB; -- moteur pour gérer les clés etrangères

CREATE TABLE Categorie_article (
	categorie_id INT UNSIGNED,
	article_id INT UNSIGNED,
	PRIMARY KEY (categorie_id, article_id)
)
ENGINE=InnoDB;

ALTER TABLE Categorie_article
MODIFY categorie_id INT UNSIGNED NOT NULL; -- chaque article doit possèder au moins une categorie (categorie_id = NOT NULL)
ALTER TABLE Categorie_article
ADD CONSTRAINT fk_categorie_id_article_id FOREIGN KEY (article_id) REFERENCES Categorie(id); -- on ne rajoute un élément que si la categorie associée (categorie_id) existe dans la table Categorie 
ALTER TABLE Categorie_article
ADD CONSTRAINT fk_article_id_categorie_id FOREIGN KEY (categorie_id) REFERENCES Article(id); -- on ne rajoute un élément que si l'article associé (article_id) existe dans la table Article

CREATE TABLE Commentaire (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	contenu TEXT NOT NULL,
	utilisateur_id INT UNSIGNED, -- possibilité d'avoir un commentaire sans utilisateur (i.e. possible que utilisateur_id = NULL)
	CONSTRAINT fk_commentaire_utilisateur_id FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) -- si l'utilisateur_id est NOT NULL alors il doit exister dans la table Utilisateur
)
ENGINE=InnoDB;

