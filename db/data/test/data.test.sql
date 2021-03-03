--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1 (Debian 13.1-1.pgdg100+1)
-- Dumped by pg_dump version 13.1 (Debian 13.1-1.pgdg100+1)

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
-- Name: hf_volunteer_portal_test; Type: DATABASE; Schema: -; Owner: admin
--

CREATE DATABASE hf_volunteer_portal_test WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE hf_volunteer_portal_test OWNER TO admin;

\connect hf_volunteer_portal_test

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
-- Name: identifiertype; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.identifiertype AS ENUM (
    'EMAIL',
    'PHONE',
    'SLACK_ID',
    'GOOGLE_ID'
);


ALTER TYPE public.identifiertype OWNER TO admin;

--
-- Name: notificationchannel; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.notificationchannel AS ENUM (
    'EMAIL',
    'SMS',
    'SLACK'
);


ALTER TYPE public.notificationchannel OWNER TO admin;

--
-- Name: notificationstatus; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.notificationstatus AS ENUM (
    'SCHEDULED',
    'SENT',
    'FAILED'
);


ALTER TYPE public.notificationstatus OWNER TO admin;

--
-- Name: priority; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.priority AS ENUM (
    'TOP_PRIORITY',
    'HIGH',
    'MEDIUM',
    'LOW',
    'COULD_BE_NICE',
    'NONE'
);


ALTER TYPE public.priority OWNER TO admin;

--
-- Name: roletype; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.roletype AS ENUM (
    'REQUIRES_APPLICATION',
    'OPEN_TO_ALL'
);


ALTER TYPE public.roletype OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.accounts (
    uuid uuid NOT NULL,
    username character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    email_identifier_id uuid,
    phone_number_identifier_id uuid
);


ALTER TABLE public.accounts OWNER TO admin;

--
-- Name: donation_emails; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.donation_emails (
    donation_uuid uuid NOT NULL,
    email text,
    request_sent_date timestamp without time zone
);


ALTER TABLE public.donation_emails OWNER TO admin;

--
-- Name: events; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events (
    id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    event_name character varying(255) NOT NULL,
    event_graphics json[],
    signup_link text NOT NULL,
    start timestamp without time zone NOT NULL,
    "end" timestamp without time zone,
    description text
);


ALTER TABLE public.events OWNER TO admin;

--
-- Name: initiatives; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.initiatives (
    id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    initiative_name character varying(255) NOT NULL,
    "order" integer NOT NULL,
    details_link character varying(255),
    hero_image_urls json[],
    description text NOT NULL,
    roles character varying[] NOT NULL,
    events character varying[] NOT NULL
);


ALTER TABLE public.initiatives OWNER TO admin;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.notifications (
    notification_uuid uuid NOT NULL,
    channel public.notificationchannel NOT NULL,
    recipient text NOT NULL,
    message text NOT NULL,
    scheduled_send_date timestamp without time zone NOT NULL,
    status public.notificationstatus NOT NULL,
    send_date timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO admin;

--
-- Name: personal_identifiers; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.personal_identifiers (
    uuid uuid NOT NULL,
    type public.identifiertype NOT NULL,
    value text NOT NULL,
    verified boolean NOT NULL
);


ALTER TABLE public.personal_identifiers OWNER TO admin;

--
-- Name: volunteer_openings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.volunteer_openings (
    id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    role_name character varying(255) NOT NULL,
    hero_image_urls json[],
    application_signup_form text,
    more_info_link text,
    priority public.priority NOT NULL,
    team character varying(255)[],
    team_lead_ids character varying(255)[],
    num_openings integer,
    minimum_time_commitment_per_week_hours integer,
    maximum_time_commitment_per_week_hours integer,
    job_overview text,
    what_youll_learn text,
    responsibilities_and_duties text,
    qualifications text,
    role_type public.roletype NOT NULL
);


ALTER TABLE public.volunteer_openings OWNER TO admin;

--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (uuid);


--
-- Name: donation_emails donation_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.donation_emails
    ADD CONSTRAINT donation_emails_pkey PRIMARY KEY (donation_uuid);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (uuid);


--
-- Name: initiatives initiatives_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.initiatives
    ADD CONSTRAINT initiatives_pkey PRIMARY KEY (uuid);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_uuid);


--
-- Name: personal_identifiers personal_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_pkey PRIMARY KEY (uuid);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- Name: accounts accounts_email_identifier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_email_identifier_id_fkey FOREIGN KEY (email_identifier_id) REFERENCES public.personal_identifiers(uuid);


--
-- Name: accounts accounts_phone_number_identifier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_phone_number_identifier_id_fkey FOREIGN KEY (phone_number_identifier_id) REFERENCES public.personal_identifiers(uuid);


--
-- PostgreSQL database dump complete
--

