-- Template for creating the database given by `@{database}`.

-- Create the database if it does not exist, and check.
CREATE DATABASE IF NOT EXISTS @{database};
SHOW DATABASES;

-- Enter the database
USE @{database};

-- Create a table of tables
CREATE TABLE IF NOT EXISTS Tables_in (
  tid               INT             NOT NULL    AUTO_INCREMENT,
  TABLE_NAME        VARCHAR(255)    NOT NULL,

  KEY tid (tid),
  CONSTRAINT name_is_primary_key PRIMARY KEY (TABLE_NAME)
);
INSERT IGNORE INTO Tables_in (TABLE_NAME) (
  SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA=database()
);

-- Create the Accounts entity table
CREATE TABLE IF NOT EXISTS Account (
  acid              CHAR(12)        NOT NULL,
  password          VARCHAR(40)     NOT NULL,
  PAT               CHAR(12)        NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (acid)
);
INSERT IGNORE INTO Tables_in (TABLE_NAME) (
  SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA=database()
);

-- Create the Profile entity table
INSERT IGNORE INTO Tables_in VALUES (NULL, 'Profile');
CREATE TABLE IF NOT EXISTS Profile (
  pfid              CHAR(12)        NOT NULL,
  acid              CHAR(12)        NOT NULL,
  UserEmail         VARCHAR(40)     NOT NULL,
  UserName          VARCHAR(20)     NOT NULL,
  UserType          ENUM('educator', 'student')
                                    NOT NULL,
  UserImage         VARCHAR(10000)  NOT NULL,
  StyleSheet        ENUM('lightmode', 'darkmode')
                                    NOT NULL,
  PreferredLanguage VARCHAR(40)     NOT NULL,
  pfLevel           INT             NOT NULL,
  score             INT             NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (pfid),
  CONSTRAINT Account_id_references FOREIGN KEY (acid) REFERENCES Account(acid)
);

-- Create the Group entity table
CREATE TABLE IF NOT EXISTS UserGroup (
  grid              CHAR(12)        NOT NULL,
  groupName         VARCHAR(50)     NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (grid)
);

-- Create the "is in Group" relation table
CREATE TABLE IF NOT EXISTS isinGroup (
  isinGrid          CHAR(24)        NOT NULL,
  pfid              CHAR(12)        NOT NULL,
  grid              CHAR(12)        NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (grid),
  CONSTRAINT isinGr_Profile_id_references FOREIGN KEY (pfid) REFERENCES Profile(pfid),
  CONSTRAINT Group_id_references FOREIGN KEY (grid) REFERENCES UserGroup(grid)
);

-- Create the Lesson entity table
INSERT IGNORE INTO Tables_in VALUES (NULL, 'Lesson');
CREATE TABLE IF NOT EXISTS Lesson (
  lsid              CHAR(18)        NOT NULL,
  pfid              CHAR(12)        NOT NULL,
  lsLevel           INT             NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (lsid),
  CONSTRAINT ls_Profile_id_references FOREIGN KEY (pfid) REFERENCES Profile(pfid)
);

-- Create the Item entity table
-- Note: for itSource, 2048 is the maximum URL length in IExplorer
INSERT IGNORE INTO Tables_in VALUES (NULL, 'Item');
CREATE TABLE IF NOT EXISTS Item (
  itid              CHAR(21)        NOT NULL,
  itName            VARCHAR(255)    NOT NULL,
  itSource          VARCHAR(2048)  NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (itid)
);

-- Create the Question entity table
INSERT IGNORE INTO Tables_in VALUES (NULL, 'Question');
CREATE TABLE IF NOT EXISTS Question (
  qsid              CHAR(20)        NOT NULL,
  lsid              CHAR(18)        NOT NULL,
  qsItid            CHAR(21)        NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (qsid),
  CONSTRAINT Lesson_id_references FOREIGN KEY (lsid) REFERENCES Lesson(lsid),
  CONSTRAINT qsItem_id_references FOREIGN KEY (qsItid) REFERENCES Item(itid)
);

-- Create the answers relation table
INSERT IGNORE INTO Tables_in VALUES (NULL, 'answers');
CREATE TABLE IF NOT EXISTS answers (
  anid              CHAR(21)        NOT NULL,
  qsid              CHAR(20)        NOT NULL,
  itid              CHAR(21)        NOT NULL,
  isCorrect         BOOLEAN         NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (anid),
  CONSTRAINT Question_id_references FOREIGN KEY (qsid) REFERENCES Question(qsid),
  CONSTRAINT Item_id_references FOREIGN KEY (itid) REFERENCES Item(itid)
);

-- Create the Room entity table
INSERT IGNORE INTO Tables_in VALUES (NULL, 'Room');
CREATE TABLE IF NOT EXISTS Room (
  room_id           CHAR(12)        NOT NULL,
  room_name         VARCHAR(200)    NOT NULL,
  room_type         VARCHAR(20)     NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (room_id)
);

-- Create the Message entity table
INSERT IGNORE INTO Tables_in VALUES (NULL, 'Message');
CREATE TABLE IF NOT EXISTS Message (
  message_id        CHAR(12)        NOT NULL,
  room_id           CHAR(12)        NOT NULL,
  from_user_id      INT             NOT NULL,
  to_user_id        INT             NOT NULL,
  content           VARCHAR(200)    NOT NULL,

  CONSTRAINT id_is_primary_key PRIMARY KEY (message_id),
  CONSTRAINT Room_id_references FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

-- Show table of tables
SELECT tid, TABLE_NAME FROM Tables_in;

-- Show all tables created
SHOW TABLES;
