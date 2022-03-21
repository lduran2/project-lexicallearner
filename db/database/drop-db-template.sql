-- Template for deleting the database given by `@{database}`.

-- Enter the database, creating it if it does not exist.
CREATE DATABASE IF NOT EXISTS @{database};
USE @{database};

-- Clean up all tables if they already exist, and check
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS Question;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Lesson;
DROP TABLE IF EXISTS Profile;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Tables_in;
SHOW TABLES;

-- Now remove the database, and check
DROP DATABASE @{database};
SHOW DATABASES;
