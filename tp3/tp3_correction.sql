-- Nombre de commentaires des articles

ALTER TABLE Article 
ADD nb_commentaires INT NOT NULL DEFAULT 0;

DELIMITER |
CREATE TRIGGER after_insert_commentaire AFTER INSERT
ON Commentaire FOR EACH ROW
BEGIN
	UPDATE Article SET nb_commentaires = nb_commentaires + 1 WHERE id = NEW.article_id;
END|


CREATE TRIGGER after_delete_commentaire AFTER DELETE
ON Commentaire FOR EACH ROW
BEGIN
	UPDATE Article SET nb_commentaires = nb_commentaires - 1 WHERE id = OLD.article_id;
END|


CREATE TRIGGER after_update_commentaire AFTER UPDATE
ON Commentaire FOR EACH ROW
BEGIN
	UPDATE Article SET nb_commentaires = nb_commentaires - 1 WHERE id = OLD.article_id;
	UPDATE Article SET nb_commentaires = nb_commentaires + 1 WHERE id = NEW.article_id;
END |
DELIMITER ;

-- Résumé par défaut

CREATE VIEW V_Article
AS SELECT id, titre, COALESCE(resume, SUBSTRING(contenu, 1, 150)), contenu, auteur_id, date_publication, nb_commentaires
FROM Article;

-- Vue matérialisée donnant les stats des utilisateurs

CREATE TABLE VM_Stat (
	id INT UNSIGNED,
	pseudo VARCHAR(100) NOT NULL,
	nb_articles INT NOT NULL DEFAULT 0,
	dernier_article DATETIME,
	nb_commentaires INT NOT NULL DEFAULT 0,
	dernier_commentaire DATETIME,
	PRIMARY KEY(id)
);

INSERT INTO VM_Stat
SELECT u.id, u.pseudo, COUNT(DISTINCT a.id), MAX(a.date_publication), COUNT(DISTINCT c.id), MAX(c.date_commentaire)
FROM Utilisateur AS u
LEFT JOIN Article AS a ON a.auteur_id = u.id
LEFT JOIN Commentaire AS c ON c.auteur_id = u.id
GROUP BY u.id, u.pseudo;

DELIMITER |
CREATE PROCEDURE maj_vm_stat()
BEGIN
    DELETE FROM VM_Stat;

    INSERT INTO VM_Stat
    SELECT u.id, u.pseudo, COUNT(DISTINCT a.id), MAX(a.date_publication), COUNT(DISTINCT c.id), MAX(c.date_commentaire)
	FROM Utilisateur AS u
	LEFT JOIN Article AS a ON a.auteur_id = u.id
	LEFT JOIN Commentaire AS c ON c.auteur_id = u.id
	GROUP BY u.id, u.pseudo;
END |
DELIMITER ;


