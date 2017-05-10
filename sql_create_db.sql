-- Database: mirnaplatform_bd

-- DROP DATABASE mirnaplatform_bd;

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md5ca7b69e4ca4f93e2eceb063f03e8ad01';

--
-- Database creation
--
-- CREATE DATABASE mirnaplatform_bd WITH TEMPLATE = template0 OWNER = postgres;
-- CREATE DATABASE mirnaplatform_bd_test WITH TEMPLATE = template0 OWNER = postgres;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

-- Started on 2017-04-21 23:02:25 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA mirnaplatform
    AUTHORIZATION postgres;
ALTER SCHEMA mirnaplatform OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 12655)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2533 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = mirnaplatform, pg_catalog;


-- SECUENCIAS
CREATE SEQUENCE mirnaplatform.bs_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.bs_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.bs_id_seq
    IS 'Secuencia para el campo binding_sites.bs_id';


CREATE SEQUENCE mirnaplatform.datasets_ensembl_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.datasets_ensembl_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.datasets_ensembl_id_seq
    IS 'Secuencia para el campo datasets_ensembl.ds_id';


CREATE SEQUENCE mirnaplatform.feat_cons_mirna_family_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.feat_cons_mirna_family_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.feat_cons_mirna_family_id_seq
    IS 'Secuencia para el campo feat_conservation_mirna_family.mf_id';


CREATE SEQUENCE mirnaplatform.feat_cons_mirna_sites_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.feat_cons_mirna_sites_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.feat_cons_mirna_sites_id_seq
    IS 'Secuencia para el campo feat_conservation_mirna_sites.ms_id';


CREATE SEQUENCE mirnaplatform.feat_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.feat_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.feat_id_seq
    IS 'Secuencia para el campo features.feat_id';


CREATE SEQUENCE mirnaplatform.feat_new_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.feat_new_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.feat_new_id_seq
    IS 'Secuencia para el campo feature_new.feat_new_id';


CREATE SEQUENCE mirnaplatform.feat_seed_regions_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.feat_seed_regions_id_seq
    OWNER TO postgres;
COMMENT ON SEQUENCE mirnaplatform.feat_seed_regions_id_seq
    IS 'Secuencia para el campo feat_seed_regions.sr_id';


CREATE SEQUENCE mirnaplatform.feat_seed_types_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.feat_seed_types_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.feat_seed_types_id_seq
    IS 'Secuencia para el campo feat_seed_regions.st_id';


CREATE SEQUENCE mirnaplatform.input_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.input_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.input_id_seq
    IS 'Secuencia para el campo input_user.input_id.';


CREATE SEQUENCE mirnaplatform.new_feature_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.new_feature_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.new_feature_id_seq
        IS 'Secuencia campo new_feature.id';


CREATE SEQUENCE mirnaplatform.output_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.output_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.output_id_seq
    IS 'Secuencia para el campo output_user.output_id.';


CREATE SEQUENCE mirnaplatform.tm_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.tm_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.tm_id_seq
    IS 'Secuencia para el campo text_mining.tm_id.';


CREATE SEQUENCE mirnaplatform.tg_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE mirnaplatform.tg_id_seq
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.tg_id_seq
    IS 'Secuencia para targets';


-- TIPOS

-- Type: new_feature

-- DROP TYPE mirnaplatform.new_feature;

CREATE TYPE mirnaplatform.new_feature AS
(
	id integer,
	name text,
	description text,
	properties jsonb,
	resume text
);

ALTER TYPE mirnaplatform.new_feature
    OWNER TO postgres;

COMMENT ON SEQUENCE mirnaplatform.bs_id_seq
    IS 'Secuencia para el campo binding_sites.bs_id';

-- TABLAS

-- Table: mirnaplatform.mirna

-- DROP TABLE mirnaplatform.mirna;

CREATE TABLE mirnaplatform.mirna
(
    mirna_id text COLLATE pg_catalog."default" NOT NULL,
    mirna_ref integer,
    mirna_precomp integer,
    mirna_seq text COLLATE pg_catalog."default",
    CONSTRAINT mirna_id PRIMARY KEY (mirna_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.mirna
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.mirna
    IS 'Datos sobre secuencias de miRNA'

COMMENT ON COLUMN mirnaplatform.mirna.mirna_id
    IS 'ID de la secuencia miRNA';

COMMENT ON COLUMN mirnaplatform.mirna.mirna_ref
    IS 'miRNA de referencia';

COMMENT ON COLUMN mirnaplatform.mirna.mirna_precomp
    IS 'miRNA precomputado';

COMMENT ON COLUMN mirnaplatform.mirna.mirna_seq
    IS 'Secuencia nucleótidos de miRNA';

-- Index: mirna_index

-- DROP INDEX mirnaplatform.mirna_index;

CREATE UNIQUE INDEX mirna_index
	ON mirnaplatform.mirna USING btree
    (mirna_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: gen_index

-- DROP INDEX mirnaplatform.gen_index;

CREATE UNIQUE INDEX gen_index
    ON mirnaplatform.gen USING btree
    (gen_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;


-- Table: mirnaplatform.utr_gen

-- DROP TABLE mirnaplatform.utr_gen;

CREATE TABLE mirnaplatform.utr_gen
(
    utr_id text COLLATE pg_catalog."default" NOT NULL,
    utr_gen_id text COLLATE pg_catalog."default",
    utr_ref text COLLATE pg_catalog."default",
    utr_precomp text COLLATE pg_catalog."default",
    utr_seq text COLLATE pg_catalog."default",
    CONSTRAINT utr_id PRIMARY KEY (utr_id),
    CONSTRAINT utr_gen_id FOREIGN KEY (utr_gen_id)
        REFERENCES mirnaplatform.gen (gen_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.utr_gen
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.utr_gen
    IS 'Datos sobre secuencias extremos 3’UTR'

COMMENT ON COLUMN mirnaplatform.utr_gen.utr_id
    IS 'ID de la secuencia 3’UTR';

COMMENT ON COLUMN mirnaplatform.utr_gen.utr_gen_id
    IS 'ID del gen asociado';

COMMENT ON COLUMN mirnaplatform.utr_gen.utr_ref
    IS '3’UTR de referencia';

COMMENT ON COLUMN mirnaplatform.utr_gen.utr_precomp
    IS '3’UTR precomputado';

COMMENT ON COLUMN mirnaplatform.utr_gen.utr_seq
    IS 'Secuencia de nucleótidos de 3’ UTR';

-- Index: utr_gen_index

-- DROP INDEX mirnaplatform.utr_gen_index;

CREATE UNIQUE INDEX utr_gen_index
    ON mirnaplatform.utr_gen USING btree
    (utr_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

    -- Table: mirnaplatform.gen

    -- DROP TABLE mirnaplatform.gen;

CREATE TABLE mirnaplatform.gen
(
    gen_id text COLLATE pg_catalog."default" NOT NULL,
    gen_attrib jsonb,
    CONSTRAINT gen_id PRIMARY KEY (gen_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.gen
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.gen
    IS 'Datos sobre secuencias extremos 3’UTR'

COMMENT ON COLUMN mirnaplatform.gen.gen_id
    IS 'ID de la secuencia del gen';

COMMENT ON COLUMN mirnaplatform.gen.gen_attrib
    IS 'Atributos del gen';

-- Table: mirnaplatform.binding_sites
-- DROP TABLE mirnaplatform.binding_sites;

CREATE TABLE mirnaplatform.binding_sites
(
    bs_id integer NOT NULL DEFAULT nextval('mirnaplatform.bs_id_seq'::regclass),
    mirna_id text COLLATE pg_catalog."default" NOT NULL,
    utr_id text COLLATE pg_catalog."default" NOT NULL,
    feat_id integer,
    bs_mirna_seq_start integer,
    bs_mirna_seq_end integer,
    bs_utr_seq_start integer,
    bs_utr_seq_end integer COLLATE pg_catalog."default",
    bs_seq_seed text COLLATE pg_catalog."default",
    bs_seq_seed_start integer,
    bs_seq_seed_end integer,
    bs_seq_region_3 text COLLATE pg_catalog."default",
    bs_seq_region_3_start integer,
    bs_seq_region_3_end integer,
    bs_seq_region_total text COLLATE pg_catalog."default",
    bs_seq_region_total_start integer,
    bs_seq_region_total_end integer,
    bs_score numeric(6,2),
    bs_scoring_matrix numeric[],
    bs_type integer NOT NULL,
    bs_other jsonb,
    CONSTRAINT bs_id PRIMARY KEY (bs_id),
    CONSTRAINT mirna_id FOREIGN KEY (mirna_id)
        REFERENCES mirnaplatform.mirna (mirna_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT utr_id FOREIGN KEY (utr_id)
        REFERENCES mirnaplatform.utr_gen (utr_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.binding_sites
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.binding_sites
    IS 'Datos sobre Binding-sites de pares miRNA - Extremo 3’ UTR';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_type
    IS 'Tipo de binding site:
0=potencial
1=definitivo';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.binding_sites.mirna_id
    IS 'ID de la secuencia miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.utr_id
    IS 'ID de la secuencia 3’UTR';

COMMENT ON COLUMN mirnaplatform.binding_sites.feat_id
    IS 'ID de tabla features';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_mirna_seq_start
    IS 'Comienzo de binding-site en la secuencia de miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_mirna_seq_end
    IS 'Fin de binding-site en la secuencia de miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_utr_seq_start
    IS 'Comienzo de binding-site en la secuencia de 3’UTR';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_utr_seq_end
    IS 'Comienzo de binding-site en la secuencia de 3’UTR';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_seed
    IS 'Secuencia de la región 5 o semilla de binding-site';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_seed_start
    IS 'Secuencia de la región 3 de binding-site';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_seed_end
    IS 'Final de semilla en la  secuencia de miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_region_3
    IS 'Secuencia de la región 3 de binding-site';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_region_3_start
    IS 'Posición de comienzo de semilla en la  secuencia de miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_region_3_end
    IS 'Posición de fin de región 3 en la  secuencia de miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_region_total
    IS 'región 5 (semilla) + región 3';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_region_total_start
    IS 'Posición de inicio de región total en la  secuencia de miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_seq_region_total_end
    IS 'Posición de fin de región total en la  secuencia de miRNA';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_score
    IS 'Puntuación';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_scoring_matrix
    IS 'Matriz de puntuación';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_type
    IS 'Tipo de binding site:
0=potencial
1=definitivo';

COMMENT ON COLUMN mirnaplatform.binding_sites.bs_other
    IS 'Otros binding-sites
';
-- Index: bs_index

-- DROP INDEX mirnaplatform.bs_index;

CREATE INDEX bs_index
    ON mirnaplatform.binding_sites USING btree
    (mirna_id COLLATE pg_catalog."default", utr_id COLLATE pg_catalog."default")
    TABLESPACE pg_default;


-- Table: mirnaplatform.features

-- DROP TABLE mirnaplatform.features;

CREATE TABLE mirnaplatform.features
(
     feat_id integer DEFAULT nextval('mirnaplatform.feat_id_seq'::regclass) NOT NULL,
     feat_seed_type_id integer,
     -- feat_seed_cutoff_value numeric(5,2),
     feat_seed_score numeric(6,2),
     feat_seed_pct numeric(6,2),
     feat_seed_add jsonb,

     feat_cons_mf_id integer,
     feat_cons_ms_id integer,
     feat_cons_add jsonb,

     feat_free_energy numeric(6,2),
     feat_free_energy_add jsonb,

     feat_insite_fe_region jsonb,
     feat_insite_match_region jsonb,
     feat_insite_mismatch_region jsonb,
     feat_insite_gc_match_region jsonb,
     feat_insite_gc_mismatch_region jsonb,
     feat_insite_au_match_region jsonb,
     feat_insite_au_mismatch_region jsonb,
     feat_insite_gu_match_region jsonb,
     feat_insite_gu_mismatch_region jsonb,
     feat_insite_bulges_mirna_region jsonb,
     feat_insite_bulged_nucl_region jsonb,
     feat_insite_add jsonb,

     feat_acc_energy numeric(5,2),
     feat_ae_add jsonb,
     feat_new_id integer,
     CONSTRAINT feat_id PRIMARY KEY (feat_id),

     CONSTRAINT feat_seed_type_id FOREIGN KEY (feat_seed_type_id)
        REFERENCES mirnaplatform.feat_seed_types (st_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
     CONSTRAINT feat_cons_mf_id FOREIGN KEY (feat_cons_mf_id)
        REFERENCES mirnaplatform.feat_conservation_mirna_family (mf_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
     CONSTRAINT feat_cons_ms_id FOREIGN KEY (feat_cons_ms_id)
        REFERENCES mirnaplatform.feat_conservation_mirna_sites (ms_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
 )
 WITH (
     OIDS = FALSE
 )
 TABLESPACE pg_default;

 ALTER TABLE mirnaplatform.features
     OWNER to postgres;

COMMENT ON COLUMN mirnaplatform.features.feat_id
   IS 'ID indentificador de fila';

COMMENT ON COLUMN mirnaplatform.features.feat_seed_type_id
   IS 'ID de la tabla feat_seed_type';

COMMENT ON COLUMN mirnaplatform.features.feat_seed_score
   IS 'Puntuación';

COMMENT ON COLUMN mirnaplatform.features.feat_seed_pct
   IS 'PCT  agregado';

COMMENT ON COLUMN mirnaplatform.features.feat_seed_add
   IS 'Otros atributos feat seed';

COMMENT ON COLUMN mirnaplatform.features.feat_cons_mf_id
   IS 'ID mirRNA family';

COMMENT ON COLUMN mirnaplatform.features.feat_cons_ms_id
   IS 'ID mirRNA sites';

COMMENT ON COLUMN mirnaplatform.features.feat_cons_add
   IS 'Otros atributos feat conservation';

COMMENT ON COLUMN mirnaplatform.features.feat_free_energy
   IS 'Energía libre';

COMMENT ON COLUMN mirnaplatform.features.feat_free_energy_add
   IS 'Otros atributos feat free energy';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_fe_region
   IS 'Energia libre por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_match_region
   IS 'Matches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_mismatch_region
   IS 'Mismatches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_gc_match_region
   IS 'GC matches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_gc_mismatch_region
   IS 'GC mismatches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_au_match_region
   IS 'AU matches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_au_mismatch_region
   IS 'AU mismatches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_gu_match_region
   IS 'GU matches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_gu_mismatch_region
   IS 'GU mismatches por región';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_bulges_mirna_region
   IS 'Bulges miRNA';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_bulged_nucl_region
   IS 'Bulged nucleotids';

COMMENT ON COLUMN mirnaplatform.features.feat_insite_add
   IS 'Otros atributos feat free energy';

COMMENT ON COLUMN mirnaplatform.features.feat_acc_energy
   IS 'Energía de acceso';

COMMENT ON COLUMN mirnaplatform.features.feat_ae_add
   IS 'Otros atributos de energía de acceso';

COMMENT ON COLUMN mirnaplatform.features.feat_new_id
   IS 'Nuevo feature';

   -- Table: mirnaplatform.features

   -- DROP TABLE mirnaplatform.features;

   -- CREATE TABLE mirnaplatform.features
   -- (
   --    feat_id integer NOT NULL DEFAULT nextval('mirnaplatform.feat_id_seq'::regclass),
   --   feat_seed "mirnaplatform.new_feature",
   --    feat_conservation "mirnaplatform.new_feature",
   --    feat_free_energy "mirnaplatform.new_feature",
   --    feat_insite "mirnaplatform.new_feature",
   --    feat_access_energy "mirnaplatform.new_feature",
   --    feat_new_id integer NOT NULL,
   --    CONSTRAINT feat_id PRIMARY KEY (feat_id)
   -- )
   -- WITH (
   --    OIDS = FALSE
   -- )
   -- TABLESPACE pg_default;

   -- ALTER TABLE mirnaplatform.features
   --    OWNER to postgres;




-- Table: mirnaplatform.input_user

-- DROP TABLE mirnaplatform.input_user;

CREATE TABLE mirnaplatform.input_user
(
    input_id integer NOT NULL DEFAULT nextval('mirnaplatform.input_id_seq'::regclass),
    input_datetime timestamp(6) without time zone NOT NULL,
    input_mirna_id text[] COLLATE pg_catalog."default" NOT NULL,
    input_utr_id text[] COLLATE pg_catalog."default" NOT NULL,
    input_gen_id text[] COLLATE pg_catalog."default",
    input_alg text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT input_id PRIMARY KEY (input_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.input_user
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.input_user
    IS 'Datos de entrada que el usuario introduce a través de la aplicación.';

COMMENT ON COLUMN mirnaplatform.input_user.input_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.input_user.input_datetime
    IS 'Fecha y hora del input';

COMMENT ON COLUMN mirnaplatform.input_user.input_mirna_id
    IS 'miRNA ID';

COMMENT ON COLUMN mirnaplatform.input_user.input_utr_id
    IS '3’UTR ID';

COMMENT ON COLUMN mirnaplatform.input_user.input_gen_id
    IS 'gen ID';

COMMENT ON COLUMN mirnaplatform.input_user.input_alg
    IS 'Nombre del algoritmo utilizado';

-- Table: mirnaplatform.output_user

-- DROP TABLE mirnaplatform.output_user;

CREATE TABLE mirnaplatform.output_user
(
    output_id integer NOT NULL DEFAULT nextval('mirnaplatform.output_id_seq'::regclass),
    output_datetime timestamp(6) without time zone NOT NULL,
    input_id integer NOT NULL,
    output_target jsonb,

    CONSTRAINT output_id PRIMARY KEY (output_id),
    CONSTRAINT input_id FOREIGN KEY (input_id)
        REFERENCES mirnaplatform.input_user (input_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.output_user
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.output_user
    IS 'Datos de salida resultado de la ejecución del algoritmo.';

COMMENT ON COLUMN mirnaplatform.output_user.output_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.output_user.output_datetime
    IS 'Fecha y hora del input';

COMMENT ON COLUMN mirnaplatform.output_user.input_id
    IS 'ID del input';

COMMENT ON COLUMN mirnaplatform.output_user.output_target
    IS 'pares miRNA-targets';

-- Table: mirnaplatform.feat_seed_types

-- DROP TABLE mirnaplatform.feat_seed_types;

CREATE TABLE mirnaplatform.feat_seed_types
(
    st_id integer NOT NULL DEFAULT nextval('mirnaplatform.feat_seed_types_id_seq'::regclass),
    st_des text COLLATE pg_catalog."default" NOT NULL,
    st_description text COLLATE pg_catalog."default",
    CONSTRAINT st_id PRIMARY KEY (st_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.feat_seed_types
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.feat_seed_types
    IS 'Datos sobre el tipo de secuencias semilla.';

COMMENT ON COLUMN mirnaplatform.feat_seed_types.st_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.feat_seed_types.st_name
    IS 'Nombre';

COMMENT ON COLUMN mirnaplatform.feat_seed_types.st_description
    IS 'Descripción';

-- Table: mirnaplatform.feat_conservation_mirna_family

-- DROP TABLE mirnaplatform.feat_conservation_mirna_family;

CREATE TABLE mirnaplatform.feat_conservation_mirna_family
(
    mf_id integer NOT NULL DEFAULT nextval('mirnaplatform.feat_cons_mirna_familiy_id_seq'::regclass),
    mf_name text COLLATE pg_catalog."default" NOT NULL,
    mf_description text COLLATE pg_catalog."default",

    CONSTRAINT cons_mirna_fam_id PRIMARY KEY (mf_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.feat_conservation_mirna_family
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.feat_conservation_mirna_family
    IS 'For miRNA families in TargetScan 6 (Human and Mouse), conservation cutoffs are as if Friedman et al. (2009):
broadly conserved = conserved across most vertebrates, usually to zebrafish (Supplemental Table 1 of Friedman et al.)
conserved = conserved across most mammals, but usually not beyond placental mammals (Supplemental Tables 2 & 3 of Friedman et al.)
poorly conserved = all others';

COMMENT ON COLUMN mirnaplatform.feat_conservation_mirna_family.mf_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.feat_conservation_mirna_family.mf_name
    IS 'Nombre';

COMMENT ON COLUMN mirnaplatform.feat_conservation_mirna_family.mf_description
    IS 'Descripción';


-- Table: mirnaplatform.feat_conservation_mirna_sites

-- DROP TABLE mirnaplatform.feat_conservation_mirna_sites;

CREATE TABLE mirnaplatform.feat_conservation_mirna_sites
(
    ms_id integer NOT NULL DEFAULT nextval('mirnaplatform.feat_cons_mirna_sites_id_seq'::regclass),
    ms_name text COLLATE pg_catalog."default",
    ms_threshold numeric(5,2),
    ms_description text COLLATE pg_catalog."default",

    CONSTRAINT ms_id PRIMARY KEY (ms_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.feat_conservation_mirna_sites
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.feat_conservation_mirna_sites
    IS 'Datos sobre el atributo “sitios miRNA” del feature “conservación de secuencias”.';

COMMENT ON COLUMN mirnaplatform.feat_conservation_mirna_sites.ms_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.feat_conservation_mirna_sites.ms_name
    IS 'Nombre';

COMMENT ON COLUMN mirnaplatform.feat_conservation_mirna_sites.ms_threshold
    IS 'Threshold';

COMMENT ON COLUMN mirnaplatform.feat_conservation_mirna_sites.ms_description
    IS 'Descripción';

-- Table: mirnaplatform.feat_seed_regions

-- DROP TABLE mirnaplatform.feat_seed_regions;

CREATE TABLE mirnaplatform.feat_seed_regions
(
    sr_id integer NOT NULL DEFAULT nextval('mirnaplatform.feat_seed_regions_id_seq'::regclass),
    sr_name text COLLATE pg_catalog."default",
    sr_start integer NOT NULL,
    sr_end integer NOT NULL,
    sr_description text COLLATE pg_catalog."default",
    CONSTRAINT sr_id PRIMARY KEY (sr_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.feat_seed_regions
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.feat_seed_regions
    IS 'Datos sobre la posición de la secuencia semilla.';

COMMENT ON COLUMN mirnaplatform.feat_seed_regions.sr_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.feat_seed_regions.sr_name
    IS 'Nombre';

COMMENT ON COLUMN mirnaplatform.feat_seed_regions.sr_start
    IS 'Posición de Inicio de secuencia';

COMMENT ON COLUMN mirnaplatform.feat_seed_regions.sr_end
    IS 'Posición de final de secuencia';

COMMENT ON COLUMN mirnaplatform.feat_seed_regions.sr_description
    IS 'Descripción';


-- Table: mirnaplatform.mirnatargets_release_targetscan

-- DROP TABLE mirnaplatform.mirnatargets_release_targetscan;

CREATE TABLE mirnaplatform.mirnatargets_release_targetscan
(
    mir_family text COLLATE pg_catalog."default",
    gene_id text COLLATE pg_catalog."default",
    gene_symbol text COLLATE pg_catalog."default",
    transcript_id text COLLATE pg_catalog."default",
    species_id integer,
    utr_start integer,
    utr_end integer,
    msa_start integer,
    msa_end integer,
    seed_match text COLLATE pg_catalog."default",
    pct text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.mirnatargets_release_targetscan
    OWNER to postgres;
COMMENT ON TABLE mirnaplatform.mirnatargets_release_targetscan
    IS 'Predicted (conserved) targets of conserved miRNA families. Includes positions on UTRs (without gaps) and UTR multiple sequence alignments (MSA; with gaps);
Last updated 16 Sep 2016';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.mir_family
    IS 'Familia miRNA';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.gene_id
    IS 'gen ID';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.gene_symbol
    IS 'Símbolo de gen';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.transcript_id
    IS 'ID de transcripto';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.species_id
    IS 'ID de especie';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.utr_start
    IS 'Posición de inicio de secuencia 3’UTR';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.utr_end
    IS 'Posición de fin de secuencia 3’UTR';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.msa_start
    IS 'Posición de inicio de secuencia UTR (contando gaps)';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.msa_end
    IS 'Posición de fin de secuencia UTR (contando gaps)';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.seed_match
    IS 'seed match feature';

COMMENT ON COLUMN mirnaplatform.mirnatargets_release_targetscan.pct
    IS 'PCT agregado';


-- Index: mir_family_index

-- DROP INDEX mirnaplatform.mir_family_index;

CREATE INDEX ds_mir_family_index
    ON mirnaplatform.mirnatargets_release_targetscan USING btree
    (mir_family COLLATE pg_catalog."default")
    TABLESPACE pg_default;


-- Table: mirnaplatform.datasets_ensembl

-- DROP TABLE mirnaplatform.datasets_ensembl;

CREATE TABLE mirnaplatform.datasets_ensembl
(
    ds_id integer NOT NULL DEFAULT nextval('mirnaplatform.datasets_ensembl_id_seq'::regclass),
    ds_name text COLLATE pg_catalog."default" NOT NULL,
    ds_description text COLLATE pg_catalog."default",
    ds_version text COLLATE pg_catalog."default",
    CONSTRAINT ds_id PRIMARY KEY (ds_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.datasets_ensembl
    OWNER to postgres;
    COMMENT ON COLUMN mirnaplatform.datasets_ensembl.ds_id
        IS 'ID de fila';

    COMMENT ON COLUMN mirnaplatform.datasets_ensembl.ds_name
        IS 'Nombre';

    COMMENT ON COLUMN mirnaplatform.datasets_ensembl.ds_description
        IS 'Descripción';

    COMMENT ON COLUMN mirnaplatform.datasets_ensembl.ds_version
        IS 'Versión';

-- Table: mirnaplatform.text_mining

-- DROP TABLE mirnaplatform.text_mining;

CREATE TABLE mirnaplatform.text_mining
(
    tm_id integer NOT NULL DEFAULT nextval('mirnaplatform.tm_id_seq'::regclass),
    mirna_id text COLLATE pg_catalog."default" NOT NULL,
    utr_id text COLLATE pg_catalog."default" NOT NULL,
    tm_gen_info jsonb,
    tm_mirna_info jsonb,
    CONSTRAINT tm_id PRIMARY KEY (tm_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.text_mining
    OWNER to postgres;

COMMENT ON COLUMN mirnaplatform.text_mining.tm_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.text_mining.mirna_id
    IS 'ID de la secuencia miRNA';

COMMENT ON COLUMN mirnaplatform.text_mining.utr_id
    IS 'ID de la secuencia 3’UTR';

COMMENT ON COLUMN mirnaplatform.text_mining.tm_gen_info
    IS 'Información sobre miRNA';

COMMENT ON COLUMN mirnaplatform.text_mining.tm_mirna_info
    IS 'información sobre targets';

-- Table: mirnaplatform.feat_new

-- DROP TABLE mirnaplatform.feat_new;

CREATE TABLE mirnaplatform.feature_new
(
    feat_new_id integer NOT NULL DEFAULT nextval('mirnaplatform.feat_new_id_seq'::regclass),
    feat_new_item mirnaplatform.new_feature NOT NULL,
    CONSTRAINT feat_other_id PRIMARY KEY (feat_new_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.feature_new
    OWNER to postgres;


-- Table: mirnaplatform.targets

-- DROP TABLE mirnaplatform.targets;

CREATE TABLE mirnaplatform.targets
(
    tg_id integer NOT NULL DEFAULT nextval('mirnaplatform.tg_id_seq'::regclass),
    mirna_id text COLLATE pg_catalog."default" NOT NULL,
    gen_id text COLLATE pg_catalog."default" NOT NULL,
    bs_id integer NOT NULL,
    tm_id integer,
    tg_score numeric(6, 2),
    CONSTRAINT target_pkey PRIMARY KEY (tg_id),
    CONSTRAINT bs_id FOREIGN KEY (bs_id)
        REFERENCES mirnaplatform.binding_sites (bs_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT gen_id FOREIGN KEY (gen_id)
        REFERENCES mirnaplatform.gen (gen_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT mirna_id FOREIGN KEY (mirna_id)
        REFERENCES mirnaplatform.mirna (mirna_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tx_id FOREIGN KEY (tm_id)
        REFERENCES mirnaplatform.text_mining (tm_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE mirnaplatform.targets
    OWNER to postgres;

COMMENT ON TABLE mirnaplatform.targets
    IS 'Info de targets';

COMMENT ON COLUMN mirnaplatform.targets.tg_id
    IS 'ID de fila';

COMMENT ON COLUMN mirnaplatform.targets.mirna_id
    IS 'miRNA ID';

COMMENT ON COLUMN mirnaplatform.targets.gen_id
    IS 'Extremo gen ID';

COMMENT ON COLUMN mirnaplatform.targets.tm_id
    IS 'Text_mining ID';

COMMENT ON COLUMN mirnaplatform.targets.tg_score
    IS 'Puntuación del target';
