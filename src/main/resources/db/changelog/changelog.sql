-- liquibase formatted sql

/*--------------------------- Организации --------------------*/
-- changeset organization:1
DROP TABLE IF EXISTS organization CASCADE;
CREATE TABLE organization (
  id serial4 PRIMARY KEY,
  name VARCHAR NOT NULL,
  country VARCHAR NOT NULL,
  city VARCHAR,
  short_name VARCHAR,
  ogrn VARCHAR,
  inn VARCHAR
)

-- changeset organization_identifier:2
DROP TYPE IF EXISTS organization_identificators;
CREATE TYPE organization_identificators AS ENUM('OPEN_ALEX', 'ELIBRARY', 'WOS', 'SCOPUS', 'ROR', 'GRID');

DROP TABLE IF EXISTS organization_identifier;
CREATE TABLE organization_identifier (
  id serial4 PRIMARY KEY,
  organization_id int4 NOT NULL,
  value VARCHAR(255),
  organization_identificator organization_identificators NOT NULL,
  FOREIGN KEY (organization_id) REFERENCES organization (id)
)

/*--------------------------- Источники --------------------*/
-- changeset subject:3
DROP TYPE IF EXISTS subject_system CASCADE;
CREATE TYPE subject_system AS ENUM('OECD', 'GRNTI', 'VAK', 'WOS_CATEGORY', 'SCOPUS_CATEGORY');

DROP TABLE IF EXISTS subject;
CREATE TABLE subject (
  id serial4 PRIMARY KEY,
  subj_code VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  system subject_system NOT NULL
)

-- changeset population_class:4
DROP TYPE IF EXISTS population_class;
CREATE TYPE population_class AS ENUM('PROCEEDINGS', 'JOURNALS', 'OTHER');

-- changeset source:5
DROP TABLE IF EXISTS source;
CREATE TABLE source (
  id serial4 PRIMARY KEY,
  name VARCHAR NOT NULL,
  type VARCHAR
)

-- changeset source_identifier:6
DROP TYPE IF EXISTS source_system;
CREATE TYPE source_system AS ENUM('ISSN', 'EISSN', 'ISBN', 'EDN', 'ELIBRARY', 'OPEN_ALEX', 'WOS', 'SCOPUS');

DROP TABLE IF EXISTS source_identifier;
CREATE TABLE source_identifier(
  id serial4 PRIMARY KEY,
  source_id int4 NOT NULL,
  value VARCHAR NOT NULL,
  system_link VARCHAR NOT NULL,
  system source_system NOT NULL,
  FOREIGN KEY (source_id) REFERENCES source (id)
)

-- changeset source_rating_system:7
DROP TYPE IF EXISTS source_rating_system;
CREATE TYPE source_rating_system AS ENUM('VAK_CATEGORY', 'VAK_SUBJECT', 'WOS', 'SCOPUS', 'WHITE_JOURNALS_LIST');

DROP TABLE IF EXISTS source_rating;
CREATE TABLE source_rating (
  id serial4 PRIMARY KEY,
  source_id int4 NOT NULL,
  rating_value VARCHAR,
  system source_rating_system NOT NULL,
  start_rating_date DATE NOT NULL,
  end_rating_date DATE NOT NULL,
  FOREIGN KEY (source_id) REFERENCES source (id)
)

-- changeset source_rating_subject:8
DROP TABLE IF EXISTS source_rating_subject;
CREATE TABLE source_rating_subject (
  id serial4 PRIMARY KEY,
--  source_rating_id int4 NOT NULL,
  source_id int4 NOT NULL,
  subject_id int4 NOT NULL,
  value VARCHAR,
  start_rating_date DATE NOT NULL,
  end_rating_date DATE NOT NULL,
--  FOREIGN KEY (source_rating_id) REFERENCES source_rating (id),
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (subject_id) REFERENCES subject (id)
)

--/*--------------------------- Авторы и пользователи --------------------*/
-- changeset role:9
DROP TABLE IF EXISTS role;
CREATE TABLE role (
  id serial4 PRIMARY KEY,
  name VARCHAR
)

-- changeset user:10
DROP TABLE IF EXISTS "user";
CREATE TABLE "user" (
  id serial4 PRIMARY KEY,
  email VARCHAR,
  login VARCHAR UNIQUE,
  password VARCHAR NOT NULL,
  role_id int4,
  FOREIGN KEY (role_id) REFERENCES role (id)
)

-- changeset author:11
DROP TABLE IF EXISTS author;
CREATE TABLE author (
  id serial4 PRIMARY KEY,
  name VARCHAR NOT NULL,
  surname VARCHAR NOT NULL,
  patronymic VARCHAR,
  confirmed boolean NOT NULL,
  user_id int4,
  birthday DATE,
  FOREIGN KEY (user_id) REFERENCES "user" (id)
)

-- changeset author_organization:12
DROP TABLE IF EXISTS author_organization;
CREATE TABLE author_organization (
  id serial4 PRIMARY KEY,
  author_id serial4 NOT NULL,
  organization_id serial4 NOT NULL,
  FOREIGN KEY (organization_id) REFERENCES organization (id),
  FOREIGN KEY (author_id) REFERENCES author (id)
)

-- changeset group:13
DROP TABLE IF EXISTS "group";
CREATE TABLE "group" (
  id serial4 PRIMARY KEY,
  parent_id serial4,
  name VARCHAR NOT NULL,
  FOREIGN KEY (parent_id) REFERENCES "group" (id)
)

-- changeset author_group:14
DROP TABLE IF EXISTS author_group;
CREATE TABLE author_group (
  id serial4 PRIMARY KEY,
  group_id serial4 NOT NULL,
  author_id serial4 NOT NULL,
  FOREIGN KEY (author_id) REFERENCES author (id),
  FOREIGN KEY (group_id) REFERENCES "group" (id)
)

-- changeset organization_group:15
DROP TABLE IF EXISTS organization_group;
CREATE TABLE organization_group (
  id serial4 PRIMARY KEY,
  group_id serial4 NOT NULL,
  organization_id serial4,
  FOREIGN KEY (group_id) REFERENCES "group" (id),
  FOREIGN KEY (organization_id) REFERENCES organization (id)
)

-- changeset author_identifier:16
DROP TYPE IF EXISTS author_identificators;
CREATE TYPE author_identificators AS ENUM('SPIN_CODE', 'ORCID', 'SCOPUS_AUTHOR_ID', 'RESEARCHER_ID', 'ELIBRARY_ID');

DROP TABLE IF EXISTS author_identifier;
CREATE TABLE author_identifier (
  id serial4 PRIMARY KEY,
  author_id int4 NOT NULL,
  identifier_value VARCHAR(255) NOT NULL,
  link VARCHAR,
  system author_identificators,
  FOREIGN KEY (author_id) REFERENCES author (id)
)


--/*--------------------------- публикации--------------------*/
-- changeset publication_type:17
DROP TABLE IF EXISTS publication_type;
CREATE TABLE publication_type (
  id serial4 PRIMARY KEY,
  name VARCHAR NOT NULL
)

-- changeset publication:18
DROP TABLE IF EXISTS publication;
CREATE TABLE publication (
  id serial4 PRIMARY KEY,
  type_id int4 NOT NULL,
  source_id int4 NOT NULL,
  title VARCHAR NOT NULL,
  abstract VARCHAR,
  publication_date DATE NOT NULL,
  accepted boolean NOT NULL,
  rate float8,
  FOREIGN KEY (source_id) REFERENCES source (id),
  FOREIGN KEY (type_id) REFERENCES publication_type (id)
)

-- changeset keyword:19
DROP TABLE IF EXISTS keyword;
CREATE TABLE keyword (
  id serial4 PRIMARY KEY,
  text VARCHAR NOT NULL
)

-- changeset publication_keyword:20
DROP TABLE IF EXISTS publication_keyword;
CREATE TABLE publication_keyword (
  id serial4 PRIMARY KEY,
  publication_id int4 NOT NULL,
  keyword_id int4 NOT NULL,
  FOREIGN KEY (publication_id) REFERENCES publication (id),
  FOREIGN KEY (keyword_id) REFERENCES keyword (id)
)

-- changeset publication_identificators:21
DROP TYPE IF EXISTS publication_identificators;
CREATE TYPE publication_identificators AS ENUM('OPEN_ALEX', 'DOI', 'EDN', 'ELIBRARY');

-- changeset publication_identifier:22
DROP TABLE IF EXISTS publication_identifier;
CREATE TABLE publication_identifier (
  id serial4 PRIMARY KEY,
  publication_id int4 NOT NULL,
  link VARCHAR NOT NULL,
  system publication_identificators NOT NULL,
  value VARCHAR NOT NULL,
  FOREIGN KEY (publication_id) REFERENCES publication (id)
)

-- changeset author_publication:23
DROP TABLE IF EXISTS author_publication;
CREATE TABLE author_publication (
  id serial4 PRIMARY KEY,
  author_id int4 NOT NULL,
  publication_id int4 NOT NULL,
  FOREIGN KEY (publication_id) REFERENCES publication (id),
  FOREIGN KEY (author_id) REFERENCES author (id)
)

-- changeset author_publication_organization:24
DROP TABLE IF EXISTS author_publication_organization;
CREATE TABLE author_publication_organization (
  id serial4 PRIMARY KEY,
  author_publication_id int4 NOT NULL,
  organization_id int4 NOT NULL,
  FOREIGN KEY (organization_id) REFERENCES organization (id),
  FOREIGN KEY (author_publication_id) REFERENCES author_publication (id)
)

--/*-------------------------------НИОКТР----------------------------------*/
-- changeset nioktr:25
DROP TABLE IF EXISTS nioktr;
CREATE TABLE nioktr (
  id serial4 PRIMARY KEY,
  name VARCHAR NOT NULL,
  rosrid_id VARCHAR,
  abstract VARCHAR,
  contract_number VARCHAR,
  customer_name VARCHAR,
  create_date DATE NOT NULL,
  document_date DATE NOT NULL,
  work_start_date DATE NOT NULL,
  work_end_date DATE NOT NULL,
  work_supervisor_id int4 NOT NULL,
  organization_supervisor_id int4 NOT NULL,
  organization_executor_id int4 NOT NULL,
  FOREIGN KEY (organization_executor_id) REFERENCES organization (id),
  FOREIGN KEY (organization_supervisor_id) REFERENCES author (id),
  FOREIGN KEY (work_supervisor_id) REFERENCES author (id)
)

-- changeset nioktr_keyword:26
DROP TABLE IF EXISTS author_publication_organization;
CREATE TABLE author_publication_organization (
  id serial4 PRIMARY KEY,
  nioktr_id int4 NOT NULL,
  keyword_id int4,
  FOREIGN KEY (keyword_id) REFERENCES keyword (id),
  FOREIGN KEY (nioktr_id) REFERENCES nioktr (id)
)

-- changeset nioktr_subject:27
DROP TABLE IF EXISTS nioktr_subject;
CREATE TABLE nioktr_subject (
  id serial PRIMARY KEY,
  nioktr_id int4 NOT NULL,
  subject_id int4 NOT NULL,
  FOREIGN KEY (subject_id) REFERENCES subject (id),
  FOREIGN KEY (nioktr_id) REFERENCES nioktr (id)
)

-- changeset organization_coexecutor:28
DROP TABLE IF EXISTS organization_coexecutor;
CREATE TABLE organization_coexecutor (
  id serial4 PRIMARY KEY,
  organization_id int4 NOT NULL,
  nioktr_id int4 NOT NULL,
  FOREIGN KEY (nioktr_id) REFERENCES nioktr (id),
  FOREIGN KEY (organization_id) REFERENCES organization (id)
)

-- changeset nioktr_budget:29
DROP TABLE IF EXISTS nioktr_budget;
CREATE TABLE nioktr_budget (
  id serial4 NOT NULL,
  funds INTEGER,
  kbk VARCHAR,
  type VARCHAR NOT NULL,
  "nioktr_id" int4 NOT NULL,
  FOREIGN KEY (nioktr_id) REFERENCES nioktr (id)

  --Indexes{
  -- id[pk, name: "nioktr_budget_pkey"]
  --}
)

-- changeset nioktr_types:30
DROP TABLE IF EXISTS nioktr_types;
CREATE TABLE nioktr_types (
  id serial4 NOT NULL,
  name VARCHAR NOT NULL,
  nioktr_id int4 NOT NULL,
  FOREIGN KEY (nioktr_id) REFERENCES nioktr (id)

--Indexes{
-- id[pk, name: "nioktr_types_pkey"]
--}
)