--
-- PostgreSQL database dump
--

-- Dumped from database version 12.6 (Ubuntu 12.6-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.6 (Ubuntu 12.6-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: ballot_type; Type: TYPE; Schema: public; Owner: chmbc
--

CREATE TYPE public.ballot_type AS ENUM (
    'electronic',
    'paper'
);


ALTER TYPE public.ballot_type OWNER TO chmbc;

--
-- Name: add_user_details(); Type: FUNCTION; Schema: public; Owner: chmbc
--

CREATE FUNCTION public.add_user_details() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
         UPDATE users SET user_firstname = roster.firstname, user_lastname = user_roster.lastname, user_email = roster.email, user_cellphone = roster.cellphone WHERE username = roster.userid;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_user_details() OWNER TO chmbc;

--
-- Name: lock_ballot(); Type: FUNCTION; Schema: public; Owner: chmbc
--

CREATE FUNCTION public.lock_ballot() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   UPDATE e_ballot SET ballot_lock_code = CONCAT(election_id,'-',candidate_id,'-', usr_id);
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.lock_ballot() OWNER TO chmbc;

--
-- Name: roster_create_code(); Type: FUNCTION; Schema: public; Owner: chmbc
--

CREATE FUNCTION public.roster_create_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
         UPDATE roster SET RosterKey = CONCAT(LEFT(FirstName,1),chmbc,UserID);
 
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.roster_create_code() OWNER TO chmbc;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: chmbc
--

CREATE TABLE public.access_tokens (
    id integer NOT NULL,
    access_token text,
    user_id text
);


ALTER TABLE public.access_tokens OWNER TO chmbc;

--
-- Name: access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: chmbc
--

CREATE SEQUENCE public.access_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_tokens_id_seq OWNER TO chmbc;

--
-- Name: access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chmbc
--

ALTER SEQUENCE public.access_tokens_id_seq OWNED BY public.access_tokens.id;


--
-- Name: audit; Type: TABLE; Schema: public; Owner: chmbc
--

CREATE TABLE public.audit (
    id integer NOT NULL,
    audit_date date DEFAULT CURRENT_DATE NOT NULL,
    election_id text NOT NULL,
    userid integer NOT NULL,
    ballot_method public.ballot_type NOT NULL
);


ALTER TABLE public.audit OWNER TO chmbc;

--
-- Name: audit_id_seq; Type: SEQUENCE; Schema: public; Owner: chmbc
--

CREATE SEQUENCE public.audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_id_seq OWNER TO chmbc;

--
-- Name: audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chmbc
--

ALTER SEQUENCE public.audit_id_seq OWNED BY public.audit.id;


--
-- Name: candidate; Type: TABLE; Schema: public; Owner: chmbc
--

CREATE TABLE public.candidate (
    candidate_id integer NOT NULL,
    ballot_date timestamp with time zone NOT NULL,
    title character varying(100),
    firstname character varying(100),
    middlename character varying(100),
    lastname character varying(100),
    "position" character varying(100),
    bio text,
    image_location character varying(100)
);


ALTER TABLE public.candidate OWNER TO chmbc;

--
-- Name: candidate_candidate_id_seq; Type: SEQUENCE; Schema: public; Owner: chmbc
--

CREATE SEQUENCE public.candidate_candidate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidate_candidate_id_seq OWNER TO chmbc;

--
-- Name: candidate_candidate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chmbc
--

ALTER SEQUENCE public.candidate_candidate_id_seq OWNED BY public.candidate.candidate_id;


--
-- Name: e_ballot; Type: TABLE; Schema: public; Owner: chmbc
--

CREATE TABLE public.e_ballot (
    ballot_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    ballot_date timestamp with time zone DEFAULT now() NOT NULL,
    election_id character varying(100) NOT NULL,
    candidate_id character varying(100) NOT NULL,
    usr_id character varying(100) NOT NULL,
    ballot_response character varying(100) NOT NULL,
    ballot_lock_code text
);


ALTER TABLE public.e_ballot OWNER TO chmbc;

--
-- Name: elections; Type: TABLE; Schema: public; Owner: chmbc
--

CREATE TABLE public.elections (
    election_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    election_date timestamp with time zone NOT NULL,
    is_election_active boolean DEFAULT false,
    election_title character varying(100),
    election_notes text
);


ALTER TABLE public.elections OWNER TO chmbc;

--
-- Name: roster; Type: TABLE; Schema: public; Owner: chmbc
--

CREATE TABLE public.roster (
    roster_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    userid integer,
    familyid integer,
    rosterkey character varying(100),
    firstname character varying(100),
    preferredname character varying(100),
    lastname character varying(100),
    formalfullname character varying(100),
    birthday character varying(100),
    age character varying(100),
    gender character varying(100),
    email character varying(100),
    secondaryemail character varying(100),
    homephone character varying(100),
    cellphone character varying(100),
    address character varying(100),
    city character varying(100),
    state character varying(100),
    zipcode character varying(100),
    chmbc integer DEFAULT 1600
);


ALTER TABLE public.roster OWNER TO chmbc;

--
-- Name: users; Type: TABLE; Schema: public; Owner: chmbc
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_uuid uuid DEFAULT public.uuid_generate_v4(),
    username text,
    user_password text
);


ALTER TABLE public.users OWNER TO chmbc;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: chmbc
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO chmbc;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chmbc
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: access_tokens id; Type: DEFAULT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.access_tokens ALTER COLUMN id SET DEFAULT nextval('public.access_tokens_id_seq'::regclass);


--
-- Name: audit id; Type: DEFAULT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.audit ALTER COLUMN id SET DEFAULT nextval('public.audit_id_seq'::regclass);


--
-- Name: candidate candidate_id; Type: DEFAULT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.candidate ALTER COLUMN candidate_id SET DEFAULT nextval('public.candidate_candidate_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: access_tokens access_tokens_access_token_key; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.access_tokens
    ADD CONSTRAINT access_tokens_access_token_key UNIQUE (access_token);


--
-- Name: access_tokens access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.access_tokens
    ADD CONSTRAINT access_tokens_pkey PRIMARY KEY (id);


--
-- Name: audit audit_pkey; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.audit
    ADD CONSTRAINT audit_pkey PRIMARY KEY (id);


--
-- Name: candidate candidate_pkey; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.candidate
    ADD CONSTRAINT candidate_pkey PRIMARY KEY (candidate_id);


--
-- Name: e_ballot e_ballot_ballot_lock_code_key; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.e_ballot
    ADD CONSTRAINT e_ballot_ballot_lock_code_key UNIQUE (ballot_lock_code);


--
-- Name: elections elections_pkey; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.elections
    ADD CONSTRAINT elections_pkey PRIMARY KEY (election_date);


--
-- Name: roster roster_pkey; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.roster
    ADD CONSTRAINT roster_pkey PRIMARY KEY (roster_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: chmbc
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: roster ins_roster_code; Type: TRIGGER; Schema: public; Owner: chmbc
--

CREATE TRIGGER ins_roster_code AFTER INSERT ON public.roster FOR EACH ROW EXECUTE FUNCTION public.roster_create_code();


--
-- Name: e_ballot lock_ballot_trigger; Type: TRIGGER; Schema: public; Owner: chmbc
--

CREATE TRIGGER lock_ballot_trigger AFTER INSERT ON public.e_ballot FOR EACH ROW EXECUTE FUNCTION public.lock_ballot();


--
-- PostgreSQL database dump complete
--

