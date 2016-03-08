USE p2p_Insertion1;

SELECT a.id, DATE_FORMAT(a.date_publication, '%d/%m/%Y') AS date_publication, u.pseudo, a.titre, SUBSTRING(a.resume,1,20), COUNT(c.id) as nb_commentaires
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
LEFT JOIN Commentaire AS c ON c.article_id = a.id
GROUP BY a.id, a.date_publication, u.pseudo, a.titre, a.resume
ORDER BY a.date_publication DESC;

SELECT a.id, DATE_FORMAT(a.date_publication, '%d %M \'%y') AS date_publication, u.pseudo, a.titre, SUBSTRING(a.resume,1,20)
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
WHERE u.id = 2
ORDER BY a.date_publication DESC;

SELECT a.id, DATE_FORMAT(a.date_publication, '%d/%m/%Y %h:%i') AS date_publication, u.pseudo, a.titre, SUBSTRING(a.resume,1,20)
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
INNER JOIN Categorie_article AS ca ON ca.article_id = a.id 
WHERE ca.categorie_id = 3
ORDER BY a.date_publication DESC;

SELECT a.id, DATE_FORMAT(a.date_publication, '%d %M %Y à %h heures %i') AS date_publication, u.pseudo, a.titre, SUBSTRING(a.contenu,1,20), GROUP_CONCAT(c.nom SEPARATOR ', ')
FROM Article AS a
INNER JOIN Utilisateur AS u ON a.auteur_id = u.id
INNER JOIN Categorie_article AS ca ON ca.article_id = a.id 
INNER JOIN Categorie AS c ON ca.categorie_id = c.id
WHERE a.id = 4
GROUP BY a.id, a.date_publication, u.pseudo, a.titre, a.contenu;

