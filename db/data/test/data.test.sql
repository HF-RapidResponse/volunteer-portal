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
    'GOOGLE_ID',
    'GITHUB_ID'
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

--
-- Name: subscriptionentity; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.subscriptionentity AS ENUM (
    'INITIATIVE'
);


ALTER TYPE public.subscriptionentity OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_settings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.account_settings (
    uuid uuid NOT NULL,
    account_uuid uuid,
    show_name boolean NOT NULL,
    show_email boolean NOT NULL,
    show_location boolean NOT NULL,
    organizers_can_see boolean NOT NULL,
    volunteers_can_see boolean NOT NULL,
    password_reset_hash text,
    password_reset_time timestamp without time zone
);


ALTER TABLE public.account_settings OWNER TO admin;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.accounts (
    uuid uuid NOT NULL,
    username character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    password text,
    profile_pic text,
    city character varying(32),
    state character varying(32),
    roles character varying[] NOT NULL,
    zip_code character varying(32),
    _primary_email_identifier_uuid uuid,
    _primary_phone_number_identifier_uuid uuid
);


ALTER TABLE public.accounts OWNER TO admin;

--
-- Name: events; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events (
    external_id character varying(255) NOT NULL,
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
    external_id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    initiative_name character varying(255) NOT NULL,
    "order" integer NOT NULL,
    details_url character varying(255),
    hero_image_urls json[],
    content text NOT NULL,
    role_ids character varying[] NOT NULL,
    event_ids character varying[] NOT NULL
);


ALTER TABLE public.initiatives OWNER TO admin;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.notifications (
    uuid uuid NOT NULL,
    channel public.notificationchannel NOT NULL,
    recipient text NOT NULL,
    title text,
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
    account_uuid uuid,
    verified boolean NOT NULL,
    slack_workspace_id text
);


ALTER TABLE public.personal_identifiers OWNER TO admin;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.subscriptions (
    uuid uuid NOT NULL,
    entity_type public.subscriptionentity NOT NULL,
    entity_uuid uuid,
    verified boolean NOT NULL,
    identifier_uuid uuid,
    account_uuid uuid
);


ALTER TABLE public.subscriptions OWNER TO admin;

--
-- Name: verification_tokens; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.verification_tokens (
    uuid uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    already_used boolean NOT NULL,
    counter bigint NOT NULL,
    personal_identifier_uuid uuid,
    subscription_uuid uuid
);


ALTER TABLE public.verification_tokens OWNER TO admin;

--
-- Name: volunteer_openings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.volunteer_openings (
    external_id character varying(255) NOT NULL,
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
-- Name: account_settings account_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_settings
    ADD CONSTRAINT account_settings_pkey PRIMARY KEY (uuid);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (uuid);


--
-- Name: accounts accounts_username_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_username_key UNIQUE (username);


--
-- Name: events events_external_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_external_id_key UNIQUE (external_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (uuid);


--
-- Name: initiatives initiatives_external_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.initiatives
    ADD CONSTRAINT initiatives_external_id_key UNIQUE (external_id);


--
-- Name: initiatives initiatives_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.initiatives
    ADD CONSTRAINT initiatives_pkey PRIMARY KEY (uuid);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (uuid);


--
-- Name: personal_identifiers personal_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_pkey PRIMARY KEY (uuid);


--
-- Name: personal_identifiers personal_identifiers_type_value_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_type_value_key UNIQUE (type, value);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (uuid);


--
-- Name: verification_tokens verification_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (uuid);


--
-- Name: volunteer_openings volunteer_openings_external_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_external_id_key UNIQUE (external_id);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- Name: ix_account_uuid; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_account_uuid ON public.personal_identifiers USING hash (account_uuid);


--
-- Name: ix_event_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_event_id ON public.events USING hash (external_id);


--
-- Name: ix_role_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_role_id ON public.volunteer_openings USING hash (external_id);


--
-- Name: ix_sub_account_uuid; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_sub_account_uuid ON public.subscriptions USING hash (account_uuid);


--
-- Name: ix_sub_id_uuid; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_sub_id_uuid ON public.subscriptions USING hash (identifier_uuid);


--
-- Name: ix_value; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_value ON public.personal_identifiers USING hash (value);


--
-- Name: account_settings account_settings_account_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_settings
    ADD CONSTRAINT account_settings_account_uuid_fkey FOREIGN KEY (account_uuid) REFERENCES public.accounts(uuid);


--
-- Name: accounts accounts__primary_email_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts__primary_email_identifier_uuid_fkey FOREIGN KEY (_primary_email_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: accounts accounts__primary_phone_number_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts__primary_phone_number_identifier_uuid_fkey FOREIGN KEY (_primary_phone_number_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: personal_identifiers personal_identifiers_account_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_account_uuid_fkey FOREIGN KEY (account_uuid) REFERENCES public.accounts(uuid);


--
-- Name: subscriptions subscriptions_account_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_account_uuid_fkey FOREIGN KEY (account_uuid) REFERENCES public.accounts(uuid);


--
-- Name: subscriptions subscriptions_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_identifier_uuid_fkey FOREIGN KEY (identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: verification_tokens verification_tokens_personal_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_personal_identifier_uuid_fkey FOREIGN KEY (personal_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: verification_tokens verification_tokens_subscription_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_subscription_uuid_fkey FOREIGN KEY (subscription_uuid) REFERENCES public.subscriptions(uuid);


--
-- PostgreSQL database dump complete
--

