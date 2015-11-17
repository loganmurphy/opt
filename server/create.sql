DROP TABLE IF EXISTS comments;

CREATE TABLE comments (
    id INT(6) AUTO_INCREMENT PRIMARY KEY, 
    link varchar(128) UNIQUE, 
    name varchar(256), 
    text varchar(2000),
    vote int(6),
    timestamp int(11)
);
