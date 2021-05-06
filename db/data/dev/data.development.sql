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
-- Name: hf_volunteer_portal_development; Type: DATABASE; Schema: -; Owner: admin
--

CREATE DATABASE hf_volunteer_portal_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE hf_volunteer_portal_development OWNER TO admin;

\connect hf_volunteer_portal_development

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
-- Name: relationship; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.relationship AS ENUM (
    'MEMBER',
    'ADMIN',
    'BOOKMARK'
);


ALTER TYPE public.relationship OWNER TO admin;

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
-- Name: account_settings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.account_settings (
    uuid uuid NOT NULL,
    show_name boolean NOT NULL,
    show_email boolean NOT NULL,
    show_location boolean NOT NULL,
    organizers_can_see boolean NOT NULL,
    volunteers_can_see boolean NOT NULL,
    initiative_map json NOT NULL,
    password_reset_hash text,
    password_reset_time timestamp without time zone,
    verify_account_hash text,
    cancel_registration_hash text
);


ALTER TABLE public.account_settings OWNER TO admin;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.accounts (
    uuid uuid NOT NULL,
    email text NOT NULL,
    username character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255),
    password text,
    oauth character varying(32),
    profile_pic text,
    city character varying(32),
    state character varying(32),
    roles character varying[] NOT NULL,
    zip_code character varying(32),
    is_verified boolean NOT NULL
);


ALTER TABLE public.accounts OWNER TO admin;

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
-- Name: groups; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.groups (
    uuid uuid NOT NULL,
    group_name character varying(128) NOT NULL,
    location_description character varying(128),
    description text,
    zip_code character varying(32),
    approved_public boolean NOT NULL,
    social_media_links json NOT NULL
);


ALTER TABLE public.groups OWNER TO admin;

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
    subject text,
    message text NOT NULL,
    scheduled_send_date timestamp without time zone NOT NULL,
    status public.notificationstatus NOT NULL,
    send_date timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO admin;

--
-- Name: user_group_relations; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_group_relations (
    uuid uuid NOT NULL,
    user_id uuid NOT NULL,
    group_id uuid NOT NULL,
    relationship public.relationship NOT NULL
);


ALTER TABLE public.user_group_relations OWNER TO admin;

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
-- Data for Name: account_settings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.account_settings (uuid, show_name, show_email, show_location, organizers_can_see, volunteers_can_see, initiative_map, password_reset_hash, password_reset_time, verify_account_hash, cancel_registration_hash) FROM stdin;
baf88f0a-b594-4460-84ff-be6e8ba52f99	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
28dde0dd-c032-4dde-80e1-ecb76ac302c1	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
c778ee5e-c69e-4f4c-96e3-8da5741e941f	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
22940231-557f-48fc-a1b5-bc8c3445c97c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
99d9792f-3c5b-468f-9fc1-c315bb5e6f1e	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
6fbd624b-7326-4ad8-add5-d862640422cc	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
ae7af313-27f1-49b0-8612-4a4039808f04	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
743adecf-1bed-45db-9d35-84de41330d8c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
b8c06678-fd1b-4567-94a3-9192fec37cde	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
1352a6e5-8f2c-40f3-b4b4-5f503c19828b	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
df2e9148-5e75-4339-8de5-6eaeddef6b06	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
1c899939-1e0d-4ff2-8104-3bd84846fcfb	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
9ee43bf6-f255-4be2-8d8c-1d93ec54efa3	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
5cdc17d7-4d99-4968-b3ec-ff73217fb331	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
3ab1f772-35ad-4040-a2c2-8998851dafb4	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
98fef345-2f59-45fb-91ed-5d3fb882af1b	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
600d7697-4307-44e5-903b-01850430a16a	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
28468fa7-3ee1-488f-aa94-2131af991d7d	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
5b7505b0-f9c2-4ea7-8fdb-48fe373b758a	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
61b6926e-a389-41bf-8523-fcfe9bc1aa57	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
13043fa8-1950-4e56-bf3c-7f6547ad3597	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
3c3a4a15-7272-4655-a0b5-31e27f48cf1c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
b8a522dc-042e-426a-aaaa-13d43692c661	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
7899739f-efd9-426b-9f2d-0d77b3943017	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
c7fc07fc-efdf-46a0-abf7-ded5cf5872c6	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
ece82c07-558d-43bc-b578-6694ec35c2b1	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
72f1ceaf-5737-4cc6-893e-eedc516fbf5b	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
df505d51-c760-4a27-8d2d-6fce2de4b2cd	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
ee5b7d50-f8f6-491f-be7c-7f6aee05ec13	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
d3bbfe57-36b3-4580-99d8-f54f6330295c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
f5c2bf0e-d7b1-41b9-ab4c-7ea7ea37aee8	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
669d306f-1e6a-447a-be16-f7e4a3157150	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
1ed3e643-b9b0-451b-a42c-d701b4c920e0	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
1d7f737d-db1f-4bcf-a8ff-fb14fbc0148f	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
7e258cc1-b5fa-475c-9f46-92dcdb04ff2f	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
6e5c2f86-2daf-43f8-bb78-15147b50d9ff	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
262255a9-40a1-4082-95b7-d250a595757e	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
8b9ba686-c7f7-4576-96f0-d78214fbf58c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
687bb3b6-cfcf-4230-8e0e-81bff64d7617	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
6463fc7b-aee3-403e-964a-767c80d06612	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
1fc654e7-cc89-4b8f-8930-2d0527de0e4c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
603806f4-3c96-4f00-84bd-3f13e581f8a7	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
6732d1bb-1942-43f5-8bff-e6b277f9ac1d	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
1ef5f5e4-1d34-43db-abb9-9831a5e3e2ed	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
70d2202d-2e93-42c0-a968-2df07da97041	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
ce0e7967-9272-4ec6-aa15-aa8c7cea3ac5	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
bfa17c2d-d487-43ac-8d0d-5b9f7b45f5d0	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
67697ee6-7960-4bd9-bf83-e2864ce35bc4	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
436d4f18-6b70-41ac-ab72-50968f5a4906	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
93fb7233-f212-46a1-86f8-7e1dfeda7d47	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
8cc13df6-36c2-4ebb-8862-21e0365271a4	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
150ee70f-162c-4b7f-8fa6-9f72aa6ec6ce	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
993736a7-7825-4fc4-8854-ef4e9dc11224	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
ac8967a1-b92d-41a7-bc96-3c62418c3ccc	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
8ce39aa7-bffd-4af5-878b-d7f96c9fc84e	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
0168502f-0b67-484a-901a-ed4bc881ffe7	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
fae29cd0-0413-4e0e-b1ba-d1bcbdc23634	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
08f1e201-9ab0-44cf-9df7-46d2590d802a	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
a44cbbee-21a9-4a6b-9086-a8204c6ac5b1	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
139adbd0-74a3-48b5-9591-feeb222d29bb	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
d395d85c-78d1-4210-9e76-f491e3c300c2	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
eca9a3a4-a131-4e7d-b6ee-c47429433ff9	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
5ab8c24b-bda8-448a-9cee-26299207e311	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
4c8857ca-405f-4bb3-b685-bffb62c1d3c1	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
c215938d-cdde-46b7-90d7-6474af418375	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
10e92c04-addf-4bfd-9abb-0819b6d7db37	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
f2088538-3f71-431d-9741-0ed5d4241b5c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
509d470c-a269-4e81-b240-56fae288c498	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
816c3faa-3800-4188-9d00-7918e9183ad3	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
16c170d9-f16c-49e4-af05-a17e7ceb01b9	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
2483236c-8de4-44a4-a880-927cfdb0c5ef	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
8acd0cc5-edc6-4270-9ddf-392a649b1306	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
c7d2fc4a-5a3e-4be5-8c89-7b19fa5ebae8	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
feedf5bc-0af4-46b6-a986-8353ebc336ad	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
17e961aa-cd8d-4206-ab91-4ee1ad773689	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
8b1abcaf-8d4f-4132-995e-2cc11cae0420	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
4539eab9-7212-4f82-b5a6-db8002a72e3b	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
3e4b5057-fa31-468d-b190-60ea413881f0	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
f9de1004-abe5-4293-92cc-cd83b8a0ceae	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
3a56cabb-fa29-4cf3-88a4-c4f287c04008	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
7076434a-295f-4fbd-b2d0-f517b7dbc6fb	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
26f43386-4807-436d-bdc6-58cdef9fd09e	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
7bbc44f9-99cf-49c8-98ed-a07da4f343b6	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
f5fa3444-2711-4e58-80f3-bc71dd783c13	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
1decbc06-7842-4e85-86d3-4b862eb78229	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
634517cb-d38b-4ded-a1f1-5967f2e61a78	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
7cbc636d-ec59-4245-9caa-d17f2a264b4e	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
ce795efa-f623-4473-a626-a54093d89179	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
334c2a5d-bbf7-480f-a32f-5970042a95f0	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
8b5b9499-7cff-48e7-a4f7-602296c47156	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
cc50b768-9f7f-4eb8-9581-c99ee50bbceb	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
954ce28c-cae2-43ce-bb50-fc8876207c27	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
7a03f46c-b347-418d-b2be-93ffd818c72b	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
10e064b1-0ba0-4657-b8f4-53f93831252c	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
fc3804f9-10dc-4f8d-a15a-8fb6ab7b49b4	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
106a7089-d1e0-4f73-ba8d-80b79c94b044	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
ebcd2459-7bfd-4ad4-bd99-edd22fd8340d	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
4e49932d-0c80-4d63-9008-c71d06e83052	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
90b75ccf-bf32-4eb0-950f-17163cfc7193	f	f	t	t	t	{"Emily Lam": false, "Destiny May": false, "Eric Stanton": false}	\N	\N	\N	\N
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, email, username, first_name, last_name, password, oauth, profile_pic, city, state, roles, zip_code, is_verified) FROM stdin;
baf88f0a-b594-4460-84ff-be6e8ba52f99	manuelbaker@barrett.com	TiffanyMathews	Heather	Jennings	$pbkdf2-sha256$30000$Ygyh1DrnvNf639ubc845Rw$kOtTXwMK4iC0VHFmHbS5Z7QrQ0I3cRAWFHlikjqihzE	\N	https://vaughn.com/	Villanuevamouth	Nebraska	{"Medical technical officer"}	59871	t
28dde0dd-c032-4dde-80e1-ecb76ac302c1	smithcarl@green.com	MaryLindsey	Joan	Camacho	$pbkdf2-sha256$30000$vHcuRaj13huD8B7jvBfCeA$ReH.M52UHhD67zBuIdOPmFhQGJlwfFvAE0/Jj/y4RKI	\N	http://www.hutchinson-doyle.com/	Gregoryview	Connecticut	{"Higher education careers adviser","Civil Service administrator"}	47462	t
c778ee5e-c69e-4f4c-96e3-8da5741e941f	lkelly@gmail.com	KimberlyHayden	Courtney	Gonzalez	$pbkdf2-sha256$30000$GGPMWev9XwvB.H9v7V0LAQ$7n7p82S19f73RQKWEXe90iv9KQG1oGb7wm8tOt9ME5U	\N	https://kelley.com/	Port Latoyamouth	Massachusetts	{}	50905	t
22940231-557f-48fc-a1b5-bc8c3445c97c	christopher93@melton.com	ElizabethVargas	Virginia	Mcintosh	$pbkdf2-sha256$30000$YyzFuLe2Nqa0lvLe.3/v/Q$SbZ3PHwDLSydTbvp2TkU63sPwo2Diag0mjkgXD9B9fw	\N	https://russo-huffman.net/	Ballardberg	Kansas	{}	59355	t
99d9792f-3c5b-468f-9fc1-c315bb5e6f1e	nicole68@hotmail.com	BrendaLong	Todd	Lowe	$pbkdf2-sha256$30000$2hvD.D/n/B/jfI/R2ntvzQ$58dcoUFCfTuwz3w.4kGbmzc4RL2eMd7aVthXC9D2aek	\N	https://www.turner-solomon.com/	South Rebecca	New York	{}	91697	t
6fbd624b-7326-4ad8-add5-d862640422cc	garciarodney@harris.com	NicholasSantiago	Brittany	Lewis	$pbkdf2-sha256$30000$fK91bk1p7X3vHYPQWitlzA$dl0ZvfsS6zinZZ4o8BcAA.d0S7dr2uomhUZ.UmFeCOY	\N	https://chandler-reynolds.net/	Lake Jack	Nevada	{"Print production planner"}	92038	t
9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	wallacejoseph@larabest.com	KimberlyLeonard	Amber	Wood	$pbkdf2-sha256$30000$oVSKUQpBSKl1TilFSKkVQg$TZYWJadZ83lFAfIVxXXWJlOPggCNMVRaTU67G2kmPBo	\N	https://bates.info/	South David	Colorado	{Warden/ranger,"Ship broker"}	53633	t
ae7af313-27f1-49b0-8612-4a4039808f04	dominique93@williams.org	CharlesGarner	Veronica	Hall	$pbkdf2-sha256$30000$ovTeGyMkZGwthVBqLWUs5Q$R6KwvRSqiUlNmZZhArG7ZcisW9.FDH1CF/cnCJI/yxM	\N	https://aguirre-nash.com/	Mortonberg	Colorado	{"Engineering geologist","Bonds trader"}	93562	t
743adecf-1bed-45db-9d35-84de41330d8c	alison54@santiago.net	LauraMosley	Tiffany	Clark	$pbkdf2-sha256$30000$mpMSYmyNUepdi3FOCQEgJA$rG0w0aVJ9BGwYc505srYZO6MzdH4gEKON7vspUP7F1Q	\N	http://www.campbell.biz/	Fernandoborough	Nevada	{"Seismic interpreter"}	60708	t
b8c06678-fd1b-4567-94a3-9192fec37cde	weaverandrew@hotmail.com	ChristineLi	Shelby	Barber	$pbkdf2-sha256$30000$NOY8Z0xpLaV0rrUW4pwzBg$ku/cktiunEogKCiBRok8sqSSCRQkWJmtGvrkq1Eg98M	\N	http://www.summers.com/	Haroldland	Georgia	{"Chartered certified accountant"}	57429	t
1352a6e5-8f2c-40f3-b4b4-5f503c19828b	joe77@bishophamilton.org	CarolynLeach	Beth	York	$pbkdf2-sha256$30000$uHfOGQNgDKF07h2jVIpR6g$anZLRsWJeI8MALZNUPp6VIzo7fkncg2ZY93wzFpTEgo	\N	http://www.rogers.com/	East Larryport	Kentucky	{}	86837	t
df2e9148-5e75-4339-8de5-6eaeddef6b06	jaredjordan@gmail.com	MarcBenson	Michelle	Harris	$pbkdf2-sha256$30000$CcE4xzhnLAVgDCGE0DonJA$NxSPylUthAnUxhJkUBM48MOAFdy9TPbTnvjp8beETSM	\N	https://sanders-bartlett.org/	Alexanderberg	California	{"Psychologist, counselling"}	37764	t
1c899939-1e0d-4ff2-8104-3bd84846fcfb	montgomerysteven@hotmail.com	LawrenceBailey	Sara	Howell	$pbkdf2-sha256$30000$0HpPKcVYi5HS.n8PQWjtXQ$QzxDCydUx2bQBzg7V8tH6pyZPI/l3N62hV/ojNdMONo	\N	http://luna.info/	West Jessicaside	Nebraska	{}	72120	t
9ee43bf6-f255-4be2-8d8c-1d93ec54efa3	jonathon92@yahoo.com	ThomasJohns	Sarah	Miles	$pbkdf2-sha256$30000$LWWsVaqVEkKIcS5lLGUsxQ$njWqG9oLnnMy1Mf.UYaWtx8Lx6RUiessoLz5Q91/r60	\N	https://hahn.org/	Harrisside	Virginia	{"Computer games developer"}	57465	t
5cdc17d7-4d99-4968-b3ec-ff73217fb331	hahnmarissa@martinez.com	EricaCordova	Catherine	Tapia	$pbkdf2-sha256$30000$inFuba2VMoaQEgLAeE8phQ$ugxMxi.H4FybghmpK3uncdLeHYo6AZFBTOZDeWjzjYY	\N	http://www.garcia.com/	Michelemouth	New Jersey	{Artist,"Systems developer"}	51746	t
3ab1f772-35ad-4040-a2c2-8998851dafb4	gillmichael@hotmail.com	DianaAyala	Vincent	English	$pbkdf2-sha256$30000$bC3l/P./976XklJqTUmJkQ$HP9PsfAdMR89egceS76oDhSsIf1Dg/V1m0qYUHTEJV0	\N	https://jensen.com/	East Zachary	Michigan	{"Jewellery designer"}	63477	t
98fef345-2f59-45fb-91ed-5d3fb882af1b	mezaelizabeth@peterskeith.com	SaraFuentesMD	David	Wilson	$pbkdf2-sha256$30000$03rPeY9RCmGslZJSihGiVA$NuKXZL8I4Chzb6wKicTFfh6DHd8cqSP6dGuoXZ0THss	\N	https://lara.com/	Port Jennifer	Alaska	{}	80026	t
600d7697-4307-44e5-903b-01850430a16a	jenny61@yahoo.com	JonathanFields	Christine	Martinez	$pbkdf2-sha256$30000$iPHeu3fO2ft/7937vxcC4A$ZTtYrOl6gVXVemlkiLXVmhum869KeF8u8Apnc02074U	\N	https://www.donovan.com/	Lewismouth	Indiana	{"Social researcher"}	88878	t
28468fa7-3ee1-488f-aa94-2131af991d7d	vmoss@lewisgarcia.biz	BrandyKennedy	Edward	Avery	$pbkdf2-sha256$30000$6L13bk1JaS1FaM3Ze8/5nw$FmHVnqg0VViD/06fxe4XuJeX2BQ7o4N.td43mbuP5hM	\N	http://www.cordova.com/	East Robertberg	New Mexico	{}	86937	t
5b7505b0-f9c2-4ea7-8fdb-48fe373b758a	greenbenjamin@reesebrown.com	KevinRoss	Jimmy	Jones	$pbkdf2-sha256$30000$yLlXKiWEECIkZIxxDkFICQ$HV0h07V.TNN5ej7ffWhF9IxO8GoQW4XJ/BZtd3vdXuE	\N	http://nguyen.com/	New Audreyside	New Hampshire	{"Administrator, Civil Service"}	20771	t
61b6926e-a389-41bf-8523-fcfe9bc1aa57	elizabethgarcia@gmail.com	Mr.RichardSantana	Jonathan	Jensen	$pbkdf2-sha256$30000$wRhjLMX4v1eqNQagNGZMSQ$43VqlqaEW/bgoo/8LaM0d0pt7NL7itGDe176ZdeIvCQ	\N	https://www.miles.com/	Bellchester	Massachusetts	{"Ambulance person"}	76108	t
13043fa8-1950-4e56-bf3c-7f6547ad3597	jennifer23@gmail.com	AlyssaLewis	Patrick	Gonzalez	$pbkdf2-sha256$30000$EEKIkdK6936v1XqPcU5JaQ$m/CtQCSrvvYckKV8Vu6l5I6Sq401QBbn52RPE7Cgc6w	\N	http://lutz.com/	Russellbury	Virginia	{"Accommodation manager","Higher education lecturer"}	34166	t
3c3a4a15-7272-4655-a0b5-31e27f48cf1c	melissagutierrez@kellerlara.info	JoelAlvarado	Chelsea	Allen	$pbkdf2-sha256$30000$DaEUAmBszZmTcq71nlOKsQ$2zVwS4ioUNgL9bCley4i4NVrbmEcGFSGNZ4rSsX/lIM	\N	https://www.miller-patterson.org/	North Jamesview	Iowa	{}	46457	t
b8a522dc-042e-426a-aaaa-13d43692c661	veronicawarren@gmail.com	SusanChristian	Gabriel	Perez	$pbkdf2-sha256$30000$/n9vTWlNac2Zk7IWYkxpTQ$9C/7oAboFteWsM87aXcS1MNjAfXHA6ZWUPQ7o435uL4	\N	http://christian.com/	Aaronside	Vermont	{"IT consultant"}	86756	t
7899739f-efd9-426b-9f2d-0d77b3943017	johnsongwendolyn@hotmail.com	KathleenKirkPhD	Mary	Boyer	$pbkdf2-sha256$30000$IwQAYEwpJSTknNMaQ4iREg$jGrug1mrbVpkueDJ9fLXqXFQ4a14dKo4txe/EWUQq5A	\N	https://www.velez.biz/	Carlsonton	Pennsylvania	{"Research officer, government",Phytotherapist}	72494	t
c7fc07fc-efdf-46a0-abf7-ded5cf5872c6	judithelliott@hayesclark.org	KyleCampbell	Erin	Caldwell	$pbkdf2-sha256$30000$ifFeq1WqlTLmXMuZU2qtdQ$K5ASsusB6ZPgkHb2j0naU0ACHUZINCZvdfnvYewuNc0	\N	https://www.hanson-schneider.com/	North Shawn	Nebraska	{"Lecturer, further education",Curator}	86336	t
ece82c07-558d-43bc-b578-6694ec35c2b1	kimberlymassey@gmail.com	DanielMarshall	Kayla	Scott	$pbkdf2-sha256$30000$C4HQWuudc.69N2ZMSSml1A$qTC5IWOEMRrfN9/Z0WNu09OaSdxSZuu6OE4dcMjfU4k	\N	https://rollins.com/	West Lisamouth	Colorado	{"Chartered management accountant","Clinical psychologist"}	43956	t
72f1ceaf-5737-4cc6-893e-eedc516fbf5b	westjennifer@morgan.com	AllisonValenzuela	Joshua	Sanchez	$pbkdf2-sha256$30000$EQJg7D2nlFLqHQOg9B5DqA$aL6qCZKt5fTAYZ77w7byooNNwA1FeO3629Df9Qh3S7c	\N	https://kent.com/	Jorgeland	Kansas	{}	73141	t
df505d51-c760-4a27-8d2d-6fce2de4b2cd	aaronscott@carrrodriguez.net	NicoleMontoya	Blake	Stanley	$pbkdf2-sha256$30000$BuA8p7S2lpKSEgIAAKBUqg$G.bfXIt.C/S9a2gJ4L54G5qfINwbG5OzPBjby6ugDoY	\N	http://hardin-black.biz/	West Douglas	Rhode Island	{}	70002	t
ee5b7d50-f8f6-491f-be7c-7f6aee05ec13	rsims@hotmail.com	StephenDavidson	Carla	Davis	$pbkdf2-sha256$30000$EqJUqpWyNkbIuTcGYEwppQ$7qUgtqltqkJZusWiemXm9PziFcZKnPquc2Wnejy3nb4	\N	http://allen.com/	Port Jessica	Pennsylvania	{}	72347	t
d3bbfe57-36b3-4580-99d8-f54f6330295c	ariasbrooke@yahoo.com	SarahWhite	Douglas	Lee	$pbkdf2-sha256$30000$TGltTSmFsFYK4dx7730vhQ$5TDS6jmW60IG2Kqg6KAyjZDULUK1cdpAKOxE2Tp9wvY	\N	https://www.young.com/	Vegafurt	Florida	{"Teacher, English as a foreign language","Sport and exercise psychologist"}	13287	t
f5c2bf0e-d7b1-41b9-ab4c-7ea7ea37aee8	jonesmatthew@yahoo.com	StephanieLong	Pedro	Boone	$pbkdf2-sha256$30000$eY.RkpLyfq.1tvaek7L2Pg$uqc1gWrhqQaNjgyZLIKQB5gY3VctngqRRPin8EzzHcw	\N	http://www.garcia.org/	West Feliciatown	New Mexico	{"Engineer, site"}	68868	t
669d306f-1e6a-447a-be16-f7e4a3157150	acollins@gmail.com	JosephHerman	Guy	Sullivan	$pbkdf2-sha256$30000$aG2NMWbsPac0ZkzJubf2vg$PeUhBEAe8j5ZsCfyQauOs/3FLG3ZN85MdK7drxwWTUg	\N	https://www.marquez-wilkinson.com/	North Amber	Illinois	{"Civil engineer, consulting"}	25386	t
1ed3e643-b9b0-451b-a42c-d701b4c920e0	lisaproctor@peterson.com	BethanyRomero	Angela	Garcia	$pbkdf2-sha256$30000$JcRYa835H0OIcS6lNMb4Xw$vv/wJADXes.UuCokuUQBaJm9Tk7Bf/RTOXA7QW5ajv4	\N	https://henderson.com/	Bushville	Florida	{"Buyer, retail","Engineer, agricultural"}	08677	t
1d7f737d-db1f-4bcf-a8ff-fb14fbc0148f	anthony57@yahoo.com	AshleyCollins	Kimberly	Evans	$pbkdf2-sha256$30000$8j6nFOIcg7BWqpUSAgBASA$R3ZNW2m7apIzE9uJS9OuKw/b6jj9liix8Z4XATH0Zx4	\N	https://www.hernandez.com/	New Ronaldburgh	Alabama	{"Social worker",Geoscientist}	39140	t
7e258cc1-b5fa-475c-9f46-92dcdb04ff2f	rodriguezlaura@tate.com	Mrs.ChristyMooney	Sean	Dennis	$pbkdf2-sha256$30000$7t17L.WcE.JcS6lVau3dmw$E82eGMy6AIOtSz5ZrAmgrfZaOZCZFBxdHEFDbMpUfyA	\N	http://www.kim-williams.com/	Singletonberg	Colorado	{"Insurance broker","Bonds trader"}	74408	t
6e5c2f86-2daf-43f8-bb78-15147b50d9ff	freytracy@hotmail.com	JessicaCruz	Jason	Smith	$pbkdf2-sha256$30000$8L4XohSCsHZOibF2TqnVug$vu34kE7imVNHlLcGQxrxPGF9vGW4WDoPFMIjcJAHLUk	\N	http://www.guzman-hernandez.com/	North Olivia	Louisiana	{"Press photographer","Soil scientist"}	96856	t
262255a9-40a1-4082-95b7-d250a595757e	egomez@millercummings.com	AnthonyFry	Ashley	Smith	$pbkdf2-sha256$30000$ZmxNac3Z.19rzZlz7j0n5A$waCx.UfT4w4wij2M/6IYigDrPC16Xyk9d.f22EOE2cI	\N	http://cherry.com/	North Jacquelinefurt	Nebraska	{"Television floor manager","Camera operator"}	13271	t
8b9ba686-c7f7-4576-96f0-d78214fbf58c	nsampson@white.net	TeresaThomas	Jessica	Barber	$pbkdf2-sha256$30000$zhlj7B2DkFJqDYGwthaCkA$B7T4owIfvtwSGQzVWVHTQSJVnvJ1hAQWsY9GzTHBN.I	\N	http://www.riley.com/	Hollandside	Missouri	{"Retail manager","Communications engineer"}	52238	t
687bb3b6-cfcf-4230-8e0e-81bff64d7617	tracideleon@pittmanwatkins.com	JacquelineMaloneDVM	David	Huang	$pbkdf2-sha256$30000$ei/F2BtDCMG411or5TyHkA$g7kq7KZTBWQe7Io1CY/W8VKbPrNuktUjEIhIxULf.5k	\N	http://www.morgan.net/	Walshville	Missouri	{}	88452	t
6463fc7b-aee3-403e-964a-767c80d06612	zhall@yahoo.com	DeborahCampbell	Melinda	Fields	$pbkdf2-sha256$30000$L4WwttZ6731PaS2lFOK8Nw$Cw0D77CP3LcKP/qab06/yOpKswjUlPAaClU6g9SZuww	\N	https://www.fox.com/	Phelpsville	Idaho	{"Health and safety inspector","Brewing technologist"}	05415	t
1fc654e7-cc89-4b8f-8930-2d0527de0e4c	katherine31@huff.com	KennethAndrews	Jacob	Snow	$pbkdf2-sha256$30000$Nubce4.RsrZ2rrVWytnbGw$gSzEmzilOkDf4sKvvew41/mkxPxs3IyQpc8f8toIXM4	\N	http://www.santiago.com/	Lake Samuelstad	Iowa	{}	12839	t
603806f4-3c96-4f00-84bd-3f13e581f8a7	anthony90@smithandrews.com	AmberChen	Cameron	Johnson	$pbkdf2-sha256$30000$yrm3tnZOydk7Z8wZAyBECA$KSUYX3HDBa52nQQfqxqJ9dsJ/gTogfVskNWcCx6xj54	\N	https://www.scott.info/	Dunnchester	Minnesota	{}	16078	t
6732d1bb-1942-43f5-8bff-e6b277f9ac1d	michael18@shields.com	LauraBuckley	Catherine	Patrick	$pbkdf2-sha256$30000$vNdaa63Vek.JMWbMWetdyw$dDG.BdEWU.CeRdqPDe2sFrQwSFje6bNQS52lPeBoMuM	\N	http://www.freeman.org/	West Brianchester	Hawaii	{"Research scientist (maths)"}	65146	t
1ef5f5e4-1d34-43db-abb9-9831a5e3e2ed	fjackson@hotmail.com	IanGuerrero	Bryan	Berry	$pbkdf2-sha256$30000$nvN.z3mPkbKWMmZMiTHGGA$IVpPKs.Z2ai0JsI37y9qa.yf9Z.TKJ29ZwZVMyMBa3Q	\N	http://www.potter.com/	East Thomasland	Kentucky	{"Medical technical officer"}	66651	t
70d2202d-2e93-42c0-a968-2df07da97041	ovincent@hotmail.com	RobertHarris	Michael	Ewing	$pbkdf2-sha256$30000$G6P0/h/jPAdgTEnJ2bvX.g$xZaO60LNTqUmH7n52g38ne5fzAOOVwFZPWYEzai7DCc	\N	http://bishop.com/	Horneton	New Hampshire	{}	34469	t
ce0e7967-9272-4ec6-aa15-aa8c7cea3ac5	cabreracarrie@gmail.com	CourtneyWaters	Donna	Brown	$pbkdf2-sha256$30000$MMb4v/deS0lprXXOGQPAeA$p8JQPSWZ.HRNori5cT/01xe9q0n0gUna.nyvcLXruAY	\N	https://hebert.com/	South Robert	Wyoming	{"Paediatric nurse"}	29937	t
bfa17c2d-d487-43ac-8d0d-5b9f7b45f5d0	fdaniels@yahoo.com	JudyLee	Amy	Warner	$pbkdf2-sha256$30000$6p2TshZibK0VovS.F0IoRQ$vlBGxbmASQcCjp/Z.kVaK6/QF3.7kNixbKECUR1.NeY	\N	http://roberson-campos.com/	Lake Jeffrey	New Mexico	{"Engineer, energy","Financial manager"}	74836	t
67697ee6-7960-4bd9-bf83-e2864ce35bc4	toddtaylor@mills.org	DylanWalton	Ashley	Cook	$pbkdf2-sha256$30000$xJhzjrEWAkCIsRaCUOqd8w$P1dwr0TtTYBf2DfH.y.35wWNzRvLwlnzD23cxFTeEk8	\N	http://www.parker.com/	North Elizabethberg	California	{"Forest/woodland manager","Programmer, applications"}	89792	t
436d4f18-6b70-41ac-ab72-50968f5a4906	umcdonald@richardson.com	MichaelSmith	Darryl	Butler	$pbkdf2-sha256$30000$6D1nbK219j6HsJbSWsvZWw$Dv/AR6Qrbywt2C2rXHmDCAGBa6VwI5dawq8Du7uDVtQ	\N	https://www.baker-curry.biz/	South Hunter	Illinois	{}	83308	t
93fb7233-f212-46a1-86f8-7e1dfeda7d47	thomas57@hernandez.net	EmilyWilson	Amanda	Henderson	$pbkdf2-sha256$30000$/L/XWqtVSgmh1HrPmfO.1w$J1pgwciJCVsPY7aFHi3/R0m53gPqJs0.SfxQlu04Phc	\N	https://www.michael.com/	Lake Susan	Kansas	{}	09558	t
8cc13df6-36c2-4ebb-8862-21e0365271a4	meganrobinson@schultz.info	ToddOliver	Michelle	Rodriguez	$pbkdf2-sha256$30000$QGjtnfOeU2qt9T6nVGqN8Q$w0g/hudOBZ796SMCR26k5Fwgn5jTT6eS1LaOpeqdZPY	\N	http://lee-sanders.com/	East Vincentbury	Indiana	{Architect}	44945	t
150ee70f-162c-4b7f-8fa6-9f72aa6ec6ce	calderonandres@ward.com	LydiaWright	Meagan	Smith	$pbkdf2-sha256$30000$w5jznlPqvbdWSqk1JoSQkg$SSXEun.6DEhht8E4I6qlUBnqKN98Feg/Mg6Ua.DpwbA	\N	https://www.kelley.org/	North Lindastad	Arizona	{"Graphic designer",Optometrist}	60107	t
993736a7-7825-4fc4-8854-ef4e9dc11224	bradbauer@gmail.com	SamanthaReynolds	Jeremy	Wilson	$pbkdf2-sha256$30000$ImQsRWgtxThHiPEeY6wVQg$Sn1A.juRt5jyxtmqIoaXjVpBfUPWJHSQJuK6Q/jawaQ	\N	http://boyle-moreno.biz/	South Blake	Missouri	{"Engineer, manufacturing","Water quality scientist"}	10718	t
ac8967a1-b92d-41a7-bc96-3c62418c3ccc	plee@yahoo.com	BradleyHughes	David	Diaz	$pbkdf2-sha256$30000$OGeMMUYIYaz1vheiVCqFEA$BjbbGyMMUa1zUKkuR4bJDE6yKUp8DPqLkUMdLF9PFXc	\N	http://www.stephens-maxwell.com/	South Jeffrey	Indiana	{"Education officer, museum","Management consultant"}	21889	t
8ce39aa7-bffd-4af5-878b-d7f96c9fc84e	lawrencewilson@clark.com	KeithCoffey	Grant	Cowan	$pbkdf2-sha256$30000$8/5/r3XuPUcIAUAIoXROiQ$5rkSujcdCcEwW8aLBuHasDNzn5jJXvaRe9thM8Z6qaw	\N	https://www.thomas.com/	Lake Samanthamouth	Florida	{}	54649	t
0168502f-0b67-484a-901a-ed4bc881ffe7	grivera@heath.com	JessicaHoward	Jacob	Jones	$pbkdf2-sha256$30000$mDOG8D7nfA8hBIBQ6h3DmA$DW1DF8Rp4vSLa4T3vI3HnEF6VE66SYjw4tGrRtUcn5A	\N	http://www.williams.com/	New Brandon	West Virginia	{"Production engineer"}	30646	t
fae29cd0-0413-4e0e-b1ba-d1bcbdc23634	tiffany40@sanchez.org	JorgeHorton	Edward	Prince	$pbkdf2-sha256$30000$/h8DoDSGkDIGAGBsDYEwJg$2ChSh1Oqc2giTwbhrOwvGF3h34HQ6i6Nbr1MeByqzeg	\N	https://lopez.net/	Lisaborough	California	{"Nature conservation officer"}	77216	t
08f1e201-9ab0-44cf-9df7-46d2590d802a	williambrown@yahoo.com	RonaldPruitt	Jeffrey	Velasquez	$pbkdf2-sha256$30000$RqgV4lyrVWothVAqhfD.nw$/HxMkzr2h/G9xhdXyxhB30LkeHsFB6o6uojSsQpOyrU	\N	https://thompson-smith.com/	East Emily	North Dakota	{"Financial trader"}	19692	t
a44cbbee-21a9-4a6b-9086-a8204c6ac5b1	kevinharrison@pattersonsingleton.biz	EdwardConner	Hannah	Weeks	$pbkdf2-sha256$30000$DSFEqDXm3HuvFeK8dy6F8A$4pxjaec2TuHVrbDJCukGBJaJ1XWpdX4f4cXPxYqpxtc	\N	http://irwin.com/	Alanhaven	California	{"Water engineer","Further education lecturer"}	13832	t
139adbd0-74a3-48b5-9591-feeb222d29bb	josedyer@hotmail.com	LaurenShaffer	Tara	Mills	$pbkdf2-sha256$30000$FGKMMQZAyHlPqfXem7P23g$YxLZgqC.j67JU/VgO/XuqnPB4LwUw3epviH1b37k.wA	\N	https://www.griffin.biz/	Moralesmouth	Michigan	{"Film/video editor","Information systems manager"}	11928	t
d395d85c-78d1-4210-9e76-f491e3c300c2	monicamartin@yahoo.com	MorganGraham	Nancy	Juarez	$pbkdf2-sha256$30000$r3XOGUMo5by3tpZyrlXqfQ$o.XXao6S7rj8n8mJ81eYAVamiJZ0oMCFU9tTokN6pLU	\N	https://jones.com/	Donnashire	Arizona	{"Travel agency manager",Pharmacologist}	38547	t
eca9a3a4-a131-4e7d-b6ee-c47429433ff9	bbartlett@hotmail.com	AngelicaWalton	Jaclyn	Turner	$pbkdf2-sha256$30000$bC2FkHJO6X3v3ftfq3XuHQ$JAj3N3vqOxXx1ldMfTW4Bs9NEGvNAdxBzfXobDRVo38	\N	http://berg-moore.com/	South Judithfort	Utah	{Herbalist}	75909	t
5ab8c24b-bda8-448a-9cee-26299207e311	uburnett@johnsonweiss.com	FrankThomas	Bobby	Wells	$pbkdf2-sha256$30000$ptRai9F6by0FYAzhfA/hXA$fi7HEDGzimHKb3MpPncOFb64ADdWv/WPTfHiM51nP34	\N	https://www.ray.info/	New Deborah	Illinois	{"Marine scientist"}	56171	t
4c8857ca-405f-4bb3-b685-bffb62c1d3c1	jason43@gmail.com	ThomasLyons	Anthony	Rasmussen	$pbkdf2-sha256$30000$LsXYu/eec661dk7pnZMSAg$llPTlnal7n9qzA7dFyBjYRT2FZZVW7DEIybUXeauHpY	\N	https://robertson-pitts.org/	Schmidtport	Mississippi	{Make,"Pharmacist, hospital"}	43146	t
c215938d-cdde-46b7-90d7-6474af418375	lisa97@gmail.com	ShelbyKennedy	Renee	Hayes	$pbkdf2-sha256$30000$Z0zpXYvx/n.P8f6fk3LO.Q$6vBDgcC669arQMspUkDAp6R8Xaa0hvKyl3K252INx5E	\N	https://www.bean.com/	Kimberlyport	Ohio	{}	89881	t
10e92c04-addf-4bfd-9abb-0819b6d7db37	cynthiawebb@gillnorton.com	DavidHarris	Ryan	Garcia	$pbkdf2-sha256$30000$GEMoZcwZo5RyLmWstZYyhg$z5H748yPkkmWFudQgaiVvby6YP33fGe6Qr1NvyUTfOU	\N	http://www.frost-ross.com/	South Tanyaport	New York	{"Insurance risk surveyor","Town planner"}	65531	t
f2088538-3f71-431d-9741-0ed5d4241b5c	zacharyhuffman@hotmail.com	KimberlyNichols	Nicole	Terry	$pbkdf2-sha256$30000$bK21ds6Zk7J2zhljjDHmfA$QLPdpIN8G8AoUOF1UmTD4NpyUxY.w/FQn7WUj06JHYs	\N	https://nichols-arellano.com/	North Jennifer	Minnesota	{"Television production assistant","Press sub"}	61083	t
509d470c-a269-4e81-b240-56fae288c498	beckderek@combs.com	RobinTucker	Amber	Bailey	$pbkdf2-sha256$30000$rTWmNKb0vpdSypnzPoeQ0g$6DlqiBUPnjg/aFYJorB7lEjz7YjTsvjw81b.4eWgJG8	\N	http://www.weaver.info/	Hinesfort	Colorado	{"Further education lecturer"}	91834	t
816c3faa-3800-4188-9d00-7918e9183ad3	wilkersonjacob@yahoo.com	EricBlack	Wayne	Sanchez	$pbkdf2-sha256$30000$RCiFMEZojdEagxBi7H2PUQ$6xnUdpxWYd11VbKk6e05aYsDAcqru/YUhDeiyo.KMqQ	\N	http://www.miller.com/	Yangstad	Montana	{"Designer, ceramics/pottery"}	16114	t
16c170d9-f16c-49e4-af05-a17e7ceb01b9	kristen91@fernandez.com	JamieRichmond	George	Keith	$pbkdf2-sha256$30000$phQiBABgjDHGGANgzJkzxg$ahpztHHLgpTM/PDNyKnffwIS.Yu7kFIsmHTzUsV7fJs	\N	http://green-lawrence.com/	Robertberg	Wisconsin	{"IT sales professional"}	00510	t
2483236c-8de4-44a4-a880-927cfdb0c5ef	yolanda92@hotmail.com	CurtisIngram	Kristina	Fitzgerald	$pbkdf2-sha256$30000$/r93jlGq9T4HgBDCmHOOkQ$Jkhxb8dSiE58mDnFu71Z8OhuqLn52J6gWmi7MpyugaA	\N	http://medina.com/	Arthurport	Alabama	{"Best boy"}	72739	t
8acd0cc5-edc6-4270-9ddf-392a649b1306	archereric@white.com	StaceyMiddleton	Adam	Simmons	$pbkdf2-sha256$30000$ak1JidEao1QKQSjlPGeslQ$ruc.yBJBhO3rTzymwIszwIOCLF/wyQoUVJ3x2jtZhNQ	\N	http://www.cruz-griffin.biz/	Kirkburgh	Oregon	{}	33241	t
c7d2fc4a-5a3e-4be5-8c89-7b19fa5ebae8	jacob19@hotmail.com	JenniferCarpenter	Elizabeth	Davis	$pbkdf2-sha256$30000$LcXYW.u9txYCgLDWGoNwbg$HjB0Ijn07yze8lBU4/BkZ7zNaETh1z3oewHifFjzb9Q	\N	https://www.stanley.com/	Morenobury	Connecticut	{}	02487	t
feedf5bc-0af4-46b6-a986-8353ebc336ad	marksamy@vancesoto.com	MichaelWalker	Derrick	Vasquez	$pbkdf2-sha256$30000$HMP4X0uJ0dob4/xfi/FeCw$NcheZiDmlorlnZPgz5gB3X/jNoPv.e7no.5fog2DrWw	\N	http://sampson-miller.com/	Archerview	New Mexico	{}	03084	t
17e961aa-cd8d-4206-ab91-4ee1ad773689	savannahflores@franklingarcia.net	JessicaBarnett	Brittany	Gonzalez	$pbkdf2-sha256$30000$pRRibA1hLCVkLOV8b00phQ$HZ1rC9mraAKk4VE61bYzKvygfjtArwdE0u9Ws6XkRr4	\N	http://www.beck-green.info/	Ericside	West Virginia	{"Associate Professor","Designer, interior/spatial"}	03852	t
8b1abcaf-8d4f-4132-995e-2cc11cae0420	vlutz@yahoo.com	KathrynEscobar	Erin	Rodriguez	$pbkdf2-sha256$30000$gFDqXYsRYkxJScl5L6XUGg$Xzxx1jos7ml8Ct0fTouq5MG5UqjRni276Gqhs6BPPlE	\N	https://wells.com/	South Stephanie	Arizona	{"Environmental manager","Energy manager"}	44626	t
4539eab9-7212-4f82-b5a6-db8002a72e3b	johnsheather@yahoo.com	SabrinaBooth	Christopher	Hunt	$pbkdf2-sha256$30000$EwLgXGtt7V1rrZVyznmvdQ$Ov7PfUsnzu/0LemHis2zz.nG6XFT8c6eETps7JnCyDo	\N	http://www.castro.com/	Josechester	South Carolina	{"Consulting civil engineer","Press sub"}	57312	t
3e4b5057-fa31-468d-b190-60ea413881f0	reginasmith@gmail.com	EdwardPratt	Daniel	Lawrence	$pbkdf2-sha256$30000$1fo/xzjHWEspxfhfy1lrjQ$sDVL6K1RcPl2I6UhA5trV7O2GgeboARFdK9anP1PhQY	\N	https://www.smith.com/	Melissaberg	New Hampshire	{}	38844	t
f9de1004-abe5-4293-92cc-cd83b8a0ceae	victoria63@kruegerking.biz	KaylaWatson	Julie	Little	$pbkdf2-sha256$30000$YEypNSaEsFaKUYrROudc6w$AwZonBh9TeOxHsqMrfp9NP73Ae1iEcbv7ziNoA3cyOQ	\N	https://thompson.com/	New Jamesville	New York	{}	90478	t
3a56cabb-fa29-4cf3-88a4-c4f287c04008	stephanie18@hallsnyder.com	JeremiahLarson	Amber	Byrd	$pbkdf2-sha256$30000$r3VOSalVam2tdY6RUqq1Vg$2w/nwSSY/7LJC2PMbTPK0.o7DnJ6QRbtJBQrw9Sx4o0	\N	https://fox-mills.com/	South Haydenfurt	Iowa	{"Scientist, research (life sciences)"}	64299	t
7076434a-295f-4fbd-b2d0-f517b7dbc6fb	vsmith@yahoo.com	DevinRussell	Regina	Young	$pbkdf2-sha256$30000$dm4NoTQmJISw1jqH8J7TGg$iM32H/n2m3WnDAEQYAYxTsQV/w3L0.7pTqyokYf3EWY	\N	https://turner-scott.net/	Coreyborough	South Carolina	{}	81563	t
26f43386-4807-436d-bdc6-58cdef9fd09e	alexanderweber@hotmail.com	BrittanyYoung	Derrick	Williams	$pbkdf2-sha256$30000$vTfGWGvNGWOM0fq/t9Yaww$c13mbCzBOrnO9DZ4M43.LOYOexLTx8yEHge13OdQsLo	\N	http://tran.com/	Lake Carolyn	North Carolina	{}	24194	t
7bbc44f9-99cf-49c8-98ed-a07da4f343b6	anna14@hotmail.com	TroyPhillips	Angela	Shelton	$pbkdf2-sha256$30000$vRdCKOX8f4/xnjPGGGMspQ$TLXA4toHb44t84yLyGD9zzVA7dq9BfdAqXND.mV1bcQ	\N	https://taylor-diaz.com/	South Teresa	Pennsylvania	{}	24508	t
f5fa3444-2711-4e58-80f3-bc71dd783c13	psmith@yahoo.com	DeniseJacobson	Isabel	Trujillo	$pbkdf2-sha256$30000$XgthrBWC0HoPYSzF2Nvbmw$2mO99UFTMDswQHVcdxIajVEj4eEMkIq1x3HDOv0966k	\N	http://huffman.com/	East Patrickstad	Rhode Island	{}	35200	t
1decbc06-7842-4e85-86d3-4b862eb78229	darren32@yahoo.com	JohnDouglas	Suzanne	Smith	$pbkdf2-sha256$30000$/B/DuHfO.d.bE2IsBUCIMQ$R/Vm2lapR2/PcMmUsUi7gNs9B7X1yvO12MDWQW.whpM	\N	http://www.khan.info/	West Chelsea	Iowa	{"Applications developer"}	12417	t
634517cb-d38b-4ded-a1f1-5967f2e61a78	josekelly@cannon.com	DonRodriguez	Brian	Moses	$pbkdf2-sha256$30000$vVcKIYQQIuRca20NQUgppQ$CBoWvvLXqrirfioxxf.XQVbI/XfD7V4jlgHGJNy2yis	\N	https://www.farmer-ellis.com/	Reynoldsberg	Georgia	{"Telecommunications researcher","Engineer, manufacturing"}	35939	t
7cbc636d-ec59-4245-9caa-d17f2a264b4e	smithtracy@baker.com	LaurieRodriguez	Juan	Watts	$pbkdf2-sha256$30000$F2JMSYkRwliLMaZ0TmktBQ$/N6F1v.MsdP/Am2.XO2axCPrG2mSBo5Wo.aAMIdW0e4	\N	https://www.banks-santos.org/	East Kristinaport	Colorado	{"Regulatory affairs officer","Publishing rights manager"}	41252	t
ce795efa-f623-4473-a626-a54093d89179	gregory32@hotmail.com	MelanieMorales	Jenna	Shepard	$pbkdf2-sha256$30000$SMnZ.z/HOEfImVOqNYawVg$8MIKr.7UzgwndZHb..MggaKEJQLj/X0Q81ggTTCpI8Y	\N	http://www.berry.biz/	Amandashire	Arkansas	{}	90172	t
334c2a5d-bbf7-480f-a32f-5970042a95f0	zachary60@hotmail.com	DennisTran	Pamela	Escobar	$pbkdf2-sha256$30000$yLmXUkopBUCIsVZKSWntHQ$PdcBSAUgPbY5aQzxMTo/ABrgITksNPeyKYNi.Bk6jUw	\N	https://www.terrell.com/	Davidton	Connecticut	{Banker}	77857	t
8b5b9499-7cff-48e7-a4f7-602296c47156	patelalex@yahoo.com	CrystalMorgan	Linda	Howell	$pbkdf2-sha256$30000$X4txDqEUglAKgXDuPcf4vw$3OpVfUMttGgmxrX3A2AYCyVz22A15rXFBftTa9xniu0	\N	https://www.wright-riley.org/	Evanschester	Louisiana	{"Garment/textile technologist"}	98434	t
cc50b768-9f7f-4eb8-9581-c99ee50bbceb	kevinreese@hotmail.com	DavidMartinezJr.	Edwin	Davis	$pbkdf2-sha256$30000$n7N2DqFU6h0jBMA4B.C8Fw$e9VsD2VJkkSXAD6YyZDI79F8ELG0KDJTXkz5vwowLtc	\N	https://vazquez.com/	North Tonyshire	Arizona	{"Journalist, newspaper","Sport and exercise psychologist"}	77687	t
954ce28c-cae2-43ce-bb50-fc8876207c27	leachandrew@hotmail.com	AndrewJohnston	John	Harrison	$pbkdf2-sha256$30000$QOi9N6aUMsb43xsDQMhZyw$SNbHLHZBAeaREtVKrPQv2wbVhAZDqSJNyKKARI.HIBo	\N	http://www.simmons.com/	South Karenberg	South Carolina	{"Risk analyst"}	06173	t
7a03f46c-b347-418d-b2be-93ffd818c72b	richardflores@robinsonvelasquez.biz	Mr.JohnFischer	Dustin	Mitchell	$pbkdf2-sha256$30000$p5QyJkToXUsphVCKUQqhFA$mhG0PKA0YLHbHWGu9ZVRI/SYkY4cFSCmY8IgIIP6QAc	\N	http://maxwell.com/	South John	Washington	{}	94216	t
10e064b1-0ba0-4657-b8f4-53f93831252c	claudiahanson@yahoo.com	WesleyKelley	Elizabeth	Hood	$pbkdf2-sha256$30000$du4dozTG2JtTSokxRuh9Lw$t/uOQupJmf2ccya6QiM3J8qPGlOegxyl1qGu0Q//S10	\N	http://ortiz.com/	East Debra	Tennessee	{}	77831	t
fc3804f9-10dc-4f8d-a15a-8fb6ab7b49b4	howardmichael@sandershernandez.biz	KeithSantiago	Christopher	Mueller	$pbkdf2-sha256$30000$WCvF2BsjhNCa855zTsm5lw$Z2EijodGX5ofN2D4wk.OKzbk7cgIHTt3yi/rMHicWmE	\N	https://www.norris-hopkins.com/	Port James	Alaska	{"Environmental manager","Scientist, audiological"}	37485	t
106a7089-d1e0-4f73-ba8d-80b79c94b044	brettmiller@gmail.com	SarahHubbard	Jeffrey	Campbell	$pbkdf2-sha256$30000$0xoDIATgvHfO2XtPyfnf.w$41NRrLul2tvZMbewRawBiAocFmbWcNRgucqeHXdpU1Y	\N	http://www.brooks.com/	New Brian	Rhode Island	{"Legal secretary"}	38644	t
ebcd2459-7bfd-4ad4-bd99-edd22fd8340d	fullerjason@fernandez.com	CherylSilva	Virginia	Peterson	$pbkdf2-sha256$30000$TAnB2JvTuvd.j5HSes95Dw$94syYu.Zi62VT1A/Ceaws7NRY33haowU1FqHkClsdIM	\N	https://www.rhodes.biz/	Brownport	Arkansas	{"Psychologist, sport and exercise","Manufacturing engineer"}	31696	t
4e49932d-0c80-4d63-9008-c71d06e83052	smithmary@wright.org	KevinMorales	Cindy	Morris	$pbkdf2-sha256$30000$pVRqrXXunROiNIZQyvkfgw$efGh/N9P4EH2NKiHLcsCTlLN.JME.8cZG3loIZHbxkU	\N	https://www.anthony.com/	Lake Heidi	Utah	{"Games developer"}	63575	t
90b75ccf-bf32-4eb0-950f-17163cfc7193	cartermatthew@taylor.com	Mrs.KimberlyArmstrong	Shawn	Vasquez	$pbkdf2-sha256$30000$xNi7Vwrh3JvzPodwbk3p/Q$PuLcBdC4e6P.iqn2MP7bQFx4X0Qr0tyk6dwGgdsVtjo	\N	https://whitaker-lewis.com/	Davidfurt	New Hampshire	{"Operations geologist","Engineer, agricultural"}	42281	t
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
9540842126359	2021-04-27 02:50:07.038895	2021-04-30 02:50:07.038895	f	af1276d2-efd0-4cad-9bdb-718ea4a5b829	Amount work out hospital plant morning behind.	{}	http://brown-estrada.org/	2021-05-07 02:50:07.038895	2021-05-11 02:50:07.038895	Tv return for bad suddenly lose ability. Significant kid study today ask. System government account hundred war claim kind. Task eight while mouth.
8218830035990	2021-05-03 02:50:07.039645	2021-05-07 02:50:07.039645	f	91be9deb-d44b-403e-a36b-a3b0c0370429	Impact behavior step my five finish commercial.	{}	https://www.cruz-warner.net/tags/about.htm	2021-05-14 02:50:07.039645	2021-05-16 02:50:07.039645	Base actually open meeting per which point. New maintain indeed understand protect discover rate. Score main behind.
2036387900600	2021-04-27 02:50:07.040228	2021-05-02 02:50:07.040228	f	59bd8acc-53a6-4e18-8684-6dd2d6409ada	Why part the likely message day happen.	{}	https://www.morton.info/home/	2021-05-09 02:50:07.040228	2021-05-17 02:50:07.040228	Federal cold week contain after thousand life. For reason avoid. Get pattern pick side senior me. Staff role media again drive ground front.
9978741404061	2021-04-30 02:50:07.041032	2021-05-04 02:50:07.041032	f	8631528f-d6b3-4189-853b-7580e62d8e00	Cut positive home too leg agent we style.	{}	http://www.escobar.org/categories/app/main/	2021-05-10 02:50:07.041032	2021-05-11 02:50:07.041032	Song government if guy. Per PM him of. Foot news year stand reveal rest. Might both step trade suggest remain Mr. Base sign several.
8402375339556	2021-04-28 02:50:07.041547	2021-05-03 02:50:07.041547	f	48ab0678-627b-4df5-8e4f-fca25a885efa	Hundred three son Mr cut process.	{"{\\"url\\": \\"https://placeimg.com/942/46/any\\"}"}	http://www.barnett-hughes.info/search/homepage.html	2021-05-09 02:50:07.041547	2021-05-13 02:50:07.041547	Discover care buy look. Executive eight beautiful phone. Box little during once role man. Someone buy short clear name ago.
4143751444306	2021-04-23 02:50:07.05092	2021-04-27 02:50:07.05092	f	eee3f1de-c607-460e-98fa-72c2e5f8c37a	Expert use risk live.	{"{\\"url\\": \\"https://placeimg.com/516/662/any\\"}"}	https://www.wong-hernandez.com/search/author/	2021-05-05 02:50:07.05092	2021-05-14 02:50:07.05092	Maintain type would half behavior determine. Material movie right lot you.
1671470323204	2021-04-19 02:50:07.051505	2021-04-22 02:50:07.051505	f	702ab3db-c609-41cb-a390-8c49e8387534	Edge chair Mrs section tax.	{"{\\"url\\": \\"https://placeimg.com/934/296/any\\"}"}	https://www.nicholson.com/	2021-04-30 02:50:07.051505	2021-05-08 02:50:07.051505	Air level management expect friend class though reduce. Company vote employee heavy let rule large. Three glass bed learn bar. Up subject arrive break me lay. Maybe yes feel wear.
6145840930996	2021-04-27 02:50:07.052202	2021-05-03 02:50:07.052202	f	6277d992-f89f-4e72-9634-401406247e7d	Learn star national.	{}	http://peters.com/	2021-05-09 02:50:07.052202	2021-05-16 02:50:07.052202	Image human land exist since professional. Democrat stay page teach yard pretty national. Far memory system space team message career model.
8457213127826	2021-04-22 02:50:07.055938	2021-04-25 02:50:07.055938	f	e7c72d30-f537-4cf7-893b-4a11b3fd9a08	Star Mr record heart official this.	{"{\\"url\\": \\"https://placeimg.com/544/624/any\\"}"}	https://www.werner.info/login/	2021-05-03 02:50:07.055938	2021-05-07 02:50:07.055938	Life always success upon produce year. Dark truth establish hit them difference. Product risk issue beyond main. Like rich movement might.
2655197030613	2021-04-15 02:50:07.056659	2021-04-17 02:50:07.056659	f	74b33d16-1cae-4361-a9da-1e64ba75edbe	Control pass important indeed among develop get.	{"{\\"url\\": \\"https://placeimg.com/174/958/any\\"}"}	https://cunningham.biz/about/	2021-04-25 02:50:07.056659	2021-04-29 02:50:07.056659	Require realize their practice imagine person discover camera. Above money become pass. Data yeah control then back. Spend good their make seem half.
6964019197967	2021-04-30 02:50:07.057165	2021-05-05 02:50:07.057165	f	67d63af2-e800-43ff-b427-7b85cb104993	Woman natural plan clear goal dog might.	{}	https://anderson.com/	2021-05-11 02:50:07.057165	2021-05-15 02:50:07.057165	Event decide my for little professional. Agreement account letter action. Country woman radio coach buy police hospital. Away morning seek.
2191033241329	2021-05-01 02:50:07.060846	2021-05-06 02:50:07.060846	f	d377fbac-461e-4db3-b9dd-ff6e4f00b0ad	Civil boy particularly case recognize.	{"{\\"url\\": \\"https://placeimg.com/233/1010/any\\"}"}	http://gonzales-gonzalez.net/search/login.htm	2021-05-13 02:50:07.060846	2021-05-14 02:50:07.060846	They north group stop door hit. Should respond bank view. New imagine million safe unit. According someone his a carry game offer.
3571382960710	2021-04-30 02:50:07.061503	2021-05-02 02:50:07.061503	f	b2b581ee-3667-4935-aef0-55e7098d52d2	Save find material how skill federal its.	{"{\\"url\\": \\"https://dummyimage.com/754x255\\"}"}	https://www.lyons.com/home.htm	2021-05-10 02:50:07.061503	2021-05-20 02:50:07.061503	Picture win dark opportunity opportunity. Film if either fire level research husband. Take five baby left. Test trade quite once opportunity any themselves. Control fly guy.
2514583678696	2021-04-25 02:50:07.061939	2021-04-29 02:50:07.061939	f	336c6d2c-7516-4190-9466-2c76dfecc70a	Will beyond man ball voice.	{}	https://boyer.biz/tag/main/faq.php	2021-05-07 02:50:07.061939	2021-05-11 02:50:07.061939	Use hard culture before husband. Action night song chance. Loss weight month have. Prove apply center compare audience.
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.groups (uuid, group_name, location_description, description, zip_code, approved_public, social_media_links) FROM stdin;
e23b1179-deaf-460e-94b7-35d4f5ed094e		Massachusetts	Now second four father unit. Expert week two group current. Cover draw smile gun charge. Do together various.	17711	t	{"Facebook": "https://www.flores-green.com/category/main/main/index/"}
5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	Lindsay Campos Yang Gang 1	Delaware	Yeah note office operation. Born defense natural detail ten red. Decide herself put may.	37453	t	{}
a896699d-045a-4b2f-82a6-2307594a1a8d	Heather Olson Yang Gang 2	Virginia	Feel will turn since have worker. Treat energy now opportunity arm reality likely. Know house look boy start loss. Table act school effect get cup.	69894	t	{"Facebook": "https://www.reed.com/register.html"}
dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	Samuel Adkins Yang Gang 3	Kansas	Music get wait security single east. Material executive share western check. Consider throughout question read establish current.	15508	t	{"twitter": "https://www.sullivan.biz/blog/list/home.htm", "Facebook": "http://johnson.com/search/tags/privacy.htm"}
5748e4da-e002-49bd-a37b-6b7be04e928e	Brittany Terrell Yang Gang 4	Minnesota	Technology town decide action hope power. Hundred hear field cost bring attorney. Language join summer now anything.	23927	t	{"discord": "http://www.luna-dominguez.com/categories/posts/homepage.htm", "twitter": "http://smith.com/categories/list/tag/register/"}
44ddb259-4bf9-4546-ac54-394bfd900130	Adam Hoover Yang Gang 5	Oklahoma	Help ten bring just do those find whether. Whom a camera. Bad surface relate shake condition remember reason American.	17793	t	{"Facebook": "https://morrison-mccoy.com/wp-content/search/app/about.htm"}
097001f6-1ec5-4157-83ac-4e47020b6dc4	Michael Jensen Yang Gang 6	Alaska	Federal east avoid. Whole whether week do.	09597	t	{"Facebook": "http://taylor.com/", "discord": "http://bernard-lamb.net/main/category/"}
226b4f18-a3ec-4afa-8db0-4edbbfcb888d	Tara Villarreal Yang Gang 7	Rhode Island	Beautiful level hard let. Another discover crime though instead I page. Try grow claim hit few.	35794	t	{"twitter": "http://www.bonilla-russell.info/"}
1c9d9b8a-af32-40d0-9277-10affd003fec	Jeffrey Willis Yang Gang 8	Minnesota	Staff water structure enough painting see. Mother talk control two send parent. Party factor relationship accept. Begin responsibility police television his nation beautiful.	31339	t	{}
6f32905f-58e1-4925-8814-5bd5fce85a39	Amber Bradley Yang Gang 9	Kentucky	Writer point away evening maybe student responsibility common. Rest art social pick white interest budget Mrs. They outside police follow. Public citizen whom material break. Pick job appear nice drop sound every.	69563	t	{"Facebook": "http://www.cooley.com/terms.html", "twitter": "https://manning-carter.info/faq.php", "discord": "https://www.castaneda-collins.com/home/"}
cd9d631e-5795-4e14-8e56-058222d8c6a0	Veronica Roman Yang Gang 10	Arizona	Common artist police education play. Night hotel start ball hit again ground. Indeed method painting report voice. Must here truth. Allow huge front near southern our of.	39487	t	{}
06cbd720-90e9-455d-aca0-ce761474998c	Deborah Martinez Yang Gang 11	New Hampshire	Along could toward knowledge performance. Idea world local blue work. Fast risk father president. Treatment chance message instead send.	43195	t	{"twitter": "http://rodriguez.info/terms.html", "Facebook": "https://www.miller.org/blog/login.html", "discord": "http://whitney-sexton.biz/category/"}
800c712c-ae9c-49cb-b9ad-06505b603aa4	Kathleen Alexander Yang Gang 12	Nebraska	Less garden sister artist include stuff new. Important push building visit doctor between.	67714	t	{"discord": "http://www.johnson-evans.com/wp-content/wp-content/search.html"}
9a6469ff-27dd-4c55-81fc-15b2c88f6f93	Debbie Ryan Yang Gang 13	Rhode Island	Scene ever human major identify rate anyone notice. Pressure once whether and card.	29973	t	{"Facebook": "http://allen.org/faq/"}
04075744-51d8-4f26-9a5c-6c68fec6f01b	Valerie Lowe Yang Gang 14	New Jersey	Direction light professor space. Work matter summer include toward authority. Simple help choice artist all note. Worker notice grow common hard.	70247	t	{"twitter": "https://www.marquez.com/author/", "discord": "http://www.brown.com/posts/search/search/register/"}
67776513-9e7b-407b-bb37-6011fb8b396d	Annette Conway Yang Gang 15	Nebraska	Just room use case heart eat reflect. Event discover result main yes interesting space. Thank control beyond wear.	54046	t	{}
93240099-cf23-4e64-a70c-fc5de53cd86b	James Mccarthy Yang Gang 16	North Dakota	Evidence several budget Republican expect. Because on both officer subject evening. Subject where PM measure final. Movie owner perform cup. Deep old side identify player call sport.	58850	t	{"twitter": "http://www.johnson-estes.biz/posts/explore/about/", "Facebook": "https://mann.com/"}
48f3fcbf-8bbc-4987-887f-1e059f271c62	Stephanie Johnson Yang Gang 17	Vermont	Indeed college believe Mrs use professor. Data toward term dinner people. Firm notice race enough thousand.	89749	t	{"discord": "http://www.rodriguez.com/explore/categories/wp-content/main.htm"}
27ef0f07-e98d-4b63-a847-b5343f869bc5	Cynthia Washington Yang Gang 18	Alaska	New control visit past. Matter certain professor decade fast if computer.	20396	t	{"twitter": "http://www.adkins.com/list/posts/main/", "Facebook": "https://johnson.com/explore/tags/register/"}
bbfb1c89-28bc-4ddf-9b14-068665defeed	Erin Rush Yang Gang 19	West Virginia	Stand claim if these character describe. Nature beyond manage environmental turn how most. Thus marriage yourself war project war.	60917	t	{"Facebook": "https://www.henderson-bentley.com/post.asp"}
8cae033d-0b8f-465a-a358-a22ae1801835	Joe Kirk Yang Gang 20	Maine	Former again bed box indicate career economic. Poor hard space forward often enter such chance.	34321	t	{"twitter": "http://patel-garcia.info/wp-content/search/explore/about/", "discord": "http://green-hays.com/author/"}
fa9f4f3b-229f-4c30-98dd-80795d2e444b	Rhonda Baker Yang Gang 21	South Carolina	Final laugh benefit. Wrong team ability actually like. Always action hot that onto. Student child job pay camera. Statement not from although quite join word.	88212	t	{}
32d695b0-9f9c-4428-b566-5fbb4b864330	Don Mendoza Yang Gang 22	Utah	Late ten hour table right long. General consumer smile upon. Before protect yet pull or wife. Understand write student watch once turn quickly million. Serious experience eight style expert.	60269	t	{"twitter": "http://www.wise-medina.com/homepage/", "Facebook": "http://pugh.biz/"}
ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	Brandon Sanchez Yang Gang 23	New York	Reach above cost well international. Quality hospital animal. Develop raise case. Consider town enter cup.	45535	t	{}
92dfe26e-7904-4d6f-a3c8-71671974c3d7	Kimberly Ortiz Yang Gang 24	Maryland	Other speak explain parent film start nothing computer. Information in provide. Entire film perform political season manage. Physical life rise.	54618	t	{"discord": "http://nicholson.com/wp-content/list/register.php", "twitter": "http://bell.org/explore/author.php"}
e7b769a7-344b-4beb-8aa8-c371369fb04e	Glenn Burke Yang Gang 25	Maryland	Mind game growth draw be firm. Describe hotel baby enjoy. Seem treat its wife vote serious. Eight stuff organization southern garden religious seven.	75348	t	{"discord": "https://www.green.org/", "twitter": "http://www.rivera.org/login/"}
20270a7a-ead3-4aa9-94f9-f1c1b1205b23	Elizabeth Nunez Yang Gang 26	Idaho	Eye into always really. Option mind cut somebody young bring. Reach executive anything blood their rock.	48057	t	{}
70ebde86-2cdd-4158-887f-6b624a2cf6e2	Mark Johnson Yang Gang 27	Michigan	Authority despite agency almost world economic leg store. Set fast tough way girl machine. Trade knowledge throughout art trade by.	67920	t	{"Facebook": "http://ramirez-mason.com/author/", "discord": "http://ross-cordova.com/category.jsp"}
944d59c5-b71f-4034-8450-648af28e6626	Michael Hanson Yang Gang 28	Arkansas	Your final decision traditional close out. Several later apply. Study memory fund scene two area look.	78279	t	{"twitter": "http://cline.com/wp-content/categories/category/login/"}
9c30be31-60eb-4def-b46a-c11eb9be89f9	Jaclyn Ramsey Yang Gang 29	Missouri	Threat in behind audience authority dark add. Somebody question up feel minute not. Enough community reality prevent work see action. Ago seek born. However what management reflect officer game truth.	08492	t	{"Facebook": "http://www.miller.com/app/app/home/"}
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
5953424701105	2021-04-20 02:50:07.052663	2021-04-25 02:50:07.052663	f	8f683f75-8a2f-45f8-9692-0570c462e466	Emily Lam	1	http://www.bender.com/	{"{\\"url\\": \\"https://dummyimage.com/489x486\\"}"}	Price town successful everyone order. Tend heavy agree whatever least test. Visit two large past. Executive travel how show. Third member western team community themselves size.	{8380572061732,5669032991509}	{4143751444306,1671470323204,6145840930996}
3769572490998	2021-05-04 02:50:07.057837	2021-05-07 02:50:07.057837	f	4d118692-0082-4742-b903-d42210dff1e7	Destiny May	2	https://schmitt.info/tag/search/register/	{"{\\"url\\": \\"https://placekitten.com/738/985\\"}"}	Institution attack determine or production energy. Discuss next son imagine trip sure government.	{7798540017024,0967394295163}	{8457213127826,2655197030613,6964019197967}
5615602661006	2021-04-24 02:50:07.062359	2021-04-28 02:50:07.062359	f	6ab8816d-baf0-4eb9-a07c-3d0668136e16	Eric Stanton	3	https://james-harris.net/faq/	{}	Fire per month many. Kitchen record leg organization less personal. Thought bit eye system not. Mouth main growth arm where how population.	{2566426459726,2324849345329}	{2191033241329,3571382960710,2514583678696}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (notification_uuid, channel, recipient, subject, message, scheduled_send_date, status, send_date) FROM stdin;
\.


--
-- Data for Name: user_group_relations; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_group_relations (uuid, user_id, group_id, relationship) FROM stdin;
ba281f85-9252-4d10-b1f1-863ef816831f	baf88f0a-b594-4460-84ff-be6e8ba52f99	e23b1179-deaf-460e-94b7-35d4f5ed094e	ADMIN
f675127f-36cc-4f81-bc9a-a54de4077b98	28dde0dd-c032-4dde-80e1-ecb76ac302c1	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	ADMIN
e669bd34-5fc7-447f-83ba-295da45f8026	c778ee5e-c69e-4f4c-96e3-8da5741e941f	a896699d-045a-4b2f-82a6-2307594a1a8d	ADMIN
dc80cf89-5ed3-4c9c-9e63-f64105ae1b18	22940231-557f-48fc-a1b5-bc8c3445c97c	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	ADMIN
e2848214-0b68-4381-8923-40c12202a494	99d9792f-3c5b-468f-9fc1-c315bb5e6f1e	5748e4da-e002-49bd-a37b-6b7be04e928e	ADMIN
2d21f52b-39b3-486d-9377-bea9385be72a	6fbd624b-7326-4ad8-add5-d862640422cc	44ddb259-4bf9-4546-ac54-394bfd900130	ADMIN
9060712a-3c6e-45f3-a6ff-d75ebdc65c1a	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	097001f6-1ec5-4157-83ac-4e47020b6dc4	ADMIN
d2d8b0ea-2b6c-4a61-9170-978b45811dee	ae7af313-27f1-49b0-8612-4a4039808f04	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	ADMIN
7727dad0-6071-414d-830f-d9a08f2fe9a1	743adecf-1bed-45db-9d35-84de41330d8c	1c9d9b8a-af32-40d0-9277-10affd003fec	ADMIN
75b39692-9388-4c41-aba4-95a9494b6580	b8c06678-fd1b-4567-94a3-9192fec37cde	6f32905f-58e1-4925-8814-5bd5fce85a39	ADMIN
584121ab-311e-499e-9916-3f7946a2e8c7	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	cd9d631e-5795-4e14-8e56-058222d8c6a0	ADMIN
5a108fd8-5089-4a91-b9fe-e8765c264857	df2e9148-5e75-4339-8de5-6eaeddef6b06	06cbd720-90e9-455d-aca0-ce761474998c	ADMIN
7f7d3c48-35b6-4e0a-9518-e5a2de9a61cb	1c899939-1e0d-4ff2-8104-3bd84846fcfb	800c712c-ae9c-49cb-b9ad-06505b603aa4	ADMIN
14912125-e701-4243-afc2-610915c8bd4b	9ee43bf6-f255-4be2-8d8c-1d93ec54efa3	9a6469ff-27dd-4c55-81fc-15b2c88f6f93	ADMIN
8d973d72-939c-447c-8e6c-271a44676188	5cdc17d7-4d99-4968-b3ec-ff73217fb331	04075744-51d8-4f26-9a5c-6c68fec6f01b	ADMIN
9617c061-5f4d-4a44-adb1-06dba854186e	3ab1f772-35ad-4040-a2c2-8998851dafb4	67776513-9e7b-407b-bb37-6011fb8b396d	ADMIN
93c26f45-3896-4f0f-a2ec-e95f1d7b38f2	98fef345-2f59-45fb-91ed-5d3fb882af1b	93240099-cf23-4e64-a70c-fc5de53cd86b	ADMIN
963c1535-8395-4136-a705-43885a5a0de1	600d7697-4307-44e5-903b-01850430a16a	48f3fcbf-8bbc-4987-887f-1e059f271c62	ADMIN
d79aff9e-b32b-4a62-a722-d44af2bac97b	28468fa7-3ee1-488f-aa94-2131af991d7d	27ef0f07-e98d-4b63-a847-b5343f869bc5	ADMIN
54d38225-ba19-4c85-91d4-43821d3d73c7	5b7505b0-f9c2-4ea7-8fdb-48fe373b758a	bbfb1c89-28bc-4ddf-9b14-068665defeed	ADMIN
489bd0f6-c142-490d-bd65-31d33df86a48	61b6926e-a389-41bf-8523-fcfe9bc1aa57	8cae033d-0b8f-465a-a358-a22ae1801835	ADMIN
d4fd7bd6-5428-4b93-8fa7-c0329e65a182	13043fa8-1950-4e56-bf3c-7f6547ad3597	fa9f4f3b-229f-4c30-98dd-80795d2e444b	ADMIN
431ddd2e-4866-4317-8ab8-c9a2824d2292	3c3a4a15-7272-4655-a0b5-31e27f48cf1c	32d695b0-9f9c-4428-b566-5fbb4b864330	ADMIN
43c9e1f5-7133-4aab-85e0-9fbce479fa9a	b8a522dc-042e-426a-aaaa-13d43692c661	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	ADMIN
76d15920-6787-4971-affd-1672b03744df	7899739f-efd9-426b-9f2d-0d77b3943017	92dfe26e-7904-4d6f-a3c8-71671974c3d7	ADMIN
b45f10a6-b369-4984-a3dd-709884f4fe7e	c7fc07fc-efdf-46a0-abf7-ded5cf5872c6	e7b769a7-344b-4beb-8aa8-c371369fb04e	ADMIN
b727c647-71e9-453e-b0ee-45a3810fa54f	ece82c07-558d-43bc-b578-6694ec35c2b1	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	ADMIN
a9185991-fd0f-4dbe-89fd-1891840891b0	72f1ceaf-5737-4cc6-893e-eedc516fbf5b	70ebde86-2cdd-4158-887f-6b624a2cf6e2	ADMIN
a3619c9e-b1ea-4ebd-8d9a-e97f02909138	df505d51-c760-4a27-8d2d-6fce2de4b2cd	944d59c5-b71f-4034-8450-648af28e6626	ADMIN
ffd77dbd-6ebf-43a0-bf13-0c48da57e6ee	ee5b7d50-f8f6-491f-be7c-7f6aee05ec13	9c30be31-60eb-4def-b46a-c11eb9be89f9	ADMIN
2482a955-6312-4117-8a77-9b07b94054ac	baf88f0a-b594-4460-84ff-be6e8ba52f99	e23b1179-deaf-460e-94b7-35d4f5ed094e	ADMIN
a2f6358f-1b10-4523-949c-e97e1348025e	baf88f0a-b594-4460-84ff-be6e8ba52f99	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
e768d7ab-2de2-4c73-9187-4af4a25c5c8f	28dde0dd-c032-4dde-80e1-ecb76ac302c1	9c30be31-60eb-4def-b46a-c11eb9be89f9	ADMIN
ab95c899-6543-4ee2-a988-f2f172683648	28dde0dd-c032-4dde-80e1-ecb76ac302c1	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
d7d519fe-1e04-4970-a5f1-d14359e3410a	c778ee5e-c69e-4f4c-96e3-8da5741e941f	944d59c5-b71f-4034-8450-648af28e6626	ADMIN
80fe655e-18f0-4aae-9d7c-ec83cf75b190	c778ee5e-c69e-4f4c-96e3-8da5741e941f	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
5cb55368-3dc3-42cf-a68b-52a19bcd17be	22940231-557f-48fc-a1b5-bc8c3445c97c	70ebde86-2cdd-4158-887f-6b624a2cf6e2	ADMIN
6759c0c4-eced-4210-bd44-274223fab51b	22940231-557f-48fc-a1b5-bc8c3445c97c	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
a42b0e1b-0935-46b0-be90-1059ab05f3d2	99d9792f-3c5b-468f-9fc1-c315bb5e6f1e	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	ADMIN
2b30e925-0b59-4917-8059-50d7149b74d7	99d9792f-3c5b-468f-9fc1-c315bb5e6f1e	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
dbd03399-4c35-4dc0-a602-aaa42e3074c2	6fbd624b-7326-4ad8-add5-d862640422cc	e7b769a7-344b-4beb-8aa8-c371369fb04e	ADMIN
dbe747b8-6220-4b5c-8891-ea01cda50554	6fbd624b-7326-4ad8-add5-d862640422cc	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
c56c6dbd-aa44-4f38-9eb3-b066e6ec5f51	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	92dfe26e-7904-4d6f-a3c8-71671974c3d7	ADMIN
5a278597-78a8-405b-a6c3-32313fc6a510	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
d56f0dc8-2ad1-477f-bf6a-8792f9bc0d43	ae7af313-27f1-49b0-8612-4a4039808f04	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	ADMIN
d7c3b7bf-e393-4f16-ba3c-791ea044a1c4	ae7af313-27f1-49b0-8612-4a4039808f04	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
c0e76081-f99e-4cc8-b755-29b1009fb768	743adecf-1bed-45db-9d35-84de41330d8c	32d695b0-9f9c-4428-b566-5fbb4b864330	ADMIN
00125e99-871a-4585-9444-33c267a31abf	743adecf-1bed-45db-9d35-84de41330d8c	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
12f38097-f331-433d-b658-9fed7708bca9	b8c06678-fd1b-4567-94a3-9192fec37cde	fa9f4f3b-229f-4c30-98dd-80795d2e444b	ADMIN
8ca49ef5-5bfb-4ab8-99bb-142baa93a63c	b8c06678-fd1b-4567-94a3-9192fec37cde	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
f7c5a13b-27e4-4130-b2da-4a46cf0b2ce9	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	8cae033d-0b8f-465a-a358-a22ae1801835	ADMIN
f8cb5733-ce77-4863-9ae3-b10102136831	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
7758568d-55fc-48a2-92b6-ada1ce086d84	df2e9148-5e75-4339-8de5-6eaeddef6b06	bbfb1c89-28bc-4ddf-9b14-068665defeed	ADMIN
9a9f5048-46d4-4457-95d9-819c0f56294a	df2e9148-5e75-4339-8de5-6eaeddef6b06	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
fe680111-7d4e-4afc-b7ef-f59706d34650	1c899939-1e0d-4ff2-8104-3bd84846fcfb	27ef0f07-e98d-4b63-a847-b5343f869bc5	ADMIN
fa785d9b-087b-4e5f-904d-3ac8a30edae1	1c899939-1e0d-4ff2-8104-3bd84846fcfb	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
c533dcd7-12b0-40f8-8e0c-1c396696c200	9ee43bf6-f255-4be2-8d8c-1d93ec54efa3	48f3fcbf-8bbc-4987-887f-1e059f271c62	ADMIN
645142e2-5452-4fa0-9946-ce3b993a49aa	9ee43bf6-f255-4be2-8d8c-1d93ec54efa3	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
2b8ce599-8062-4a4a-a18a-0aba2c1fcb3b	5cdc17d7-4d99-4968-b3ec-ff73217fb331	93240099-cf23-4e64-a70c-fc5de53cd86b	ADMIN
351ca6b3-631d-4f71-a18a-cf0ca552e599	5cdc17d7-4d99-4968-b3ec-ff73217fb331	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
f1371f1d-19ad-4804-8df1-82d4ac8d0a57	baf88f0a-b594-4460-84ff-be6e8ba52f99	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
fc20dbc4-256d-42fb-bf42-381f22522bcd	baf88f0a-b594-4460-84ff-be6e8ba52f99	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
c67098a3-34d6-422b-ac97-d0fdd04564bc	baf88f0a-b594-4460-84ff-be6e8ba52f99	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
cce87c6f-b6e5-4fa4-a4a1-394adbd71c1b	baf88f0a-b594-4460-84ff-be6e8ba52f99	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
b0b73811-bd31-4e8f-8c18-1140fd7f6e13	baf88f0a-b594-4460-84ff-be6e8ba52f99	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
2b1a420e-9ad2-4e7e-87b7-ec08b372190b	28dde0dd-c032-4dde-80e1-ecb76ac302c1	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
ad82feaa-d068-41a9-97e0-4cff0f09de5b	28dde0dd-c032-4dde-80e1-ecb76ac302c1	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
2eaa445a-1658-4ba7-b35b-336d3707dd0d	28dde0dd-c032-4dde-80e1-ecb76ac302c1	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
bdff09a6-6b96-469d-ada6-b16d1e6ec759	28dde0dd-c032-4dde-80e1-ecb76ac302c1	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
c84c4b5e-3d9d-4168-a41a-e66408680c65	28dde0dd-c032-4dde-80e1-ecb76ac302c1	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
f9ce602d-0502-4dd4-94ee-2fa0fc641d90	c778ee5e-c69e-4f4c-96e3-8da5741e941f	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
5bdc12e5-88f2-4f5a-815c-c11b8891e895	c778ee5e-c69e-4f4c-96e3-8da5741e941f	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
f0c5e6fd-7c40-483e-874d-ee29cbd94475	c778ee5e-c69e-4f4c-96e3-8da5741e941f	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
f4593fc9-fc2b-4028-8533-52e1fd434c12	c778ee5e-c69e-4f4c-96e3-8da5741e941f	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
d4a90314-d454-43d9-a670-42315393df09	22940231-557f-48fc-a1b5-bc8c3445c97c	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
5df2fe13-b393-432e-983b-dd97b0f58b44	22940231-557f-48fc-a1b5-bc8c3445c97c	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
c80d10a7-0a1a-4261-accd-0e2965ec1f0d	99d9792f-3c5b-468f-9fc1-c315bb5e6f1e	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
0d90121e-05b2-4578-a791-48d9bb132a0a	99d9792f-3c5b-468f-9fc1-c315bb5e6f1e	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
f28cfb74-8d6a-41a3-817c-5109f3ab3d0b	6fbd624b-7326-4ad8-add5-d862640422cc	9a6469ff-27dd-4c55-81fc-15b2c88f6f93	MEMBER
67a4aeb5-013a-402a-9157-46250290dfab	6fbd624b-7326-4ad8-add5-d862640422cc	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
43630eed-6e22-4823-a22e-c01b9d58356e	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
e1aa2555-c8a6-4d15-b313-59a6e2a6c88f	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
bc764505-0a3b-4fc4-89da-46a89a6d4d91	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
4d5014e6-37fd-4da5-ae0a-451f9d13f274	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
e3a99555-db4c-424e-9dd5-52b819068bb3	9f9a3a91-c2cf-429a-9b5f-c35a38b77a3e	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
e9bc85cc-32ac-4927-91c7-767b91bcf291	ae7af313-27f1-49b0-8612-4a4039808f04	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
2912af6b-9143-424d-aa55-7138efaadf92	ae7af313-27f1-49b0-8612-4a4039808f04	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
850b2d50-de29-4f3a-a05c-0a2614fbb367	ae7af313-27f1-49b0-8612-4a4039808f04	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
16f7b775-d6a1-4db5-a153-dd17752dd1a6	743adecf-1bed-45db-9d35-84de41330d8c	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
c4f868eb-8c0a-4503-a916-8d44c2932e2c	743adecf-1bed-45db-9d35-84de41330d8c	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
e9e7d6df-0d8c-49b5-a87d-1a2a9f4c4435	743adecf-1bed-45db-9d35-84de41330d8c	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
b33fa7bf-6f62-4fdc-aa15-a4013be0e580	743adecf-1bed-45db-9d35-84de41330d8c	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
320fb500-2b6f-4fa6-92a7-7922a2beef0c	743adecf-1bed-45db-9d35-84de41330d8c	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
aba94602-ca75-424b-93c5-252f70491fb2	b8c06678-fd1b-4567-94a3-9192fec37cde	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
c50009e0-c7a4-475f-8bf2-6c896020420a	b8c06678-fd1b-4567-94a3-9192fec37cde	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
4742d8b1-0767-43ad-a19b-affde0de7ee8	b8c06678-fd1b-4567-94a3-9192fec37cde	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
e415358d-a1c3-45d1-9eb8-446639320846	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
db080a7d-fb7c-4988-8a7e-98a1fd875669	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
9f0b1e11-3307-4434-b20c-c302c6e526aa	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
c66f37b0-304e-4b92-9a61-f465794c8fc7	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
18303cce-b5ed-456e-ac87-0821e6327fb2	1352a6e5-8f2c-40f3-b4b4-5f503c19828b	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
344486fc-1278-4baf-a64d-07f02b3399bc	df2e9148-5e75-4339-8de5-6eaeddef6b06	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
08b8a6c3-5232-4708-9357-5455a47650aa	df2e9148-5e75-4339-8de5-6eaeddef6b06	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
979952a0-3f8b-428d-a481-4dba2c08c858	1c899939-1e0d-4ff2-8104-3bd84846fcfb	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
8739cd45-7f2e-4f21-979c-ee086a570233	1c899939-1e0d-4ff2-8104-3bd84846fcfb	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
adc1d23f-0093-43e6-9e5f-376559af14c3	1c899939-1e0d-4ff2-8104-3bd84846fcfb	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
736d74f7-e88d-4c6d-b2c5-222ebfda5875	1c899939-1e0d-4ff2-8104-3bd84846fcfb	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
0b8500a9-319a-496c-9dac-c42fec397ab6	1c899939-1e0d-4ff2-8104-3bd84846fcfb	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
f7ffb822-470a-45db-81de-36a2bed1009b	9ee43bf6-f255-4be2-8d8c-1d93ec54efa3	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
0f77c2d9-72b7-4946-895c-a1e27d522165	9ee43bf6-f255-4be2-8d8c-1d93ec54efa3	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
168bf4ec-cb43-4584-89b4-bab6d5b5b8cd	5cdc17d7-4d99-4968-b3ec-ff73217fb331	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
5dcc126f-c9f1-4485-a083-108fee68940f	5cdc17d7-4d99-4968-b3ec-ff73217fb331	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
1a29a88a-96b1-4e9a-a3af-958b8d362a08	5cdc17d7-4d99-4968-b3ec-ff73217fb331	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
015fa2e6-b701-443d-bb49-6ab23cb23042	5cdc17d7-4d99-4968-b3ec-ff73217fb331	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
677d823f-9c7c-4998-b3e6-e448acfecb77	5cdc17d7-4d99-4968-b3ec-ff73217fb331	9a6469ff-27dd-4c55-81fc-15b2c88f6f93	MEMBER
6f79bad2-bb25-485a-8cf0-8064a8ee7f9c	3ab1f772-35ad-4040-a2c2-8998851dafb4	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
d5e69b1d-8cb5-44b7-a297-302d8f71d196	3ab1f772-35ad-4040-a2c2-8998851dafb4	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
75181afc-43d9-4f6b-8102-c289543f406b	3ab1f772-35ad-4040-a2c2-8998851dafb4	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
99796eec-c0fc-4115-8584-1f090fcd70bd	98fef345-2f59-45fb-91ed-5d3fb882af1b	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
e5d41717-d4d8-4d67-84e4-473bd7daa24b	600d7697-4307-44e5-903b-01850430a16a	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
364e7e80-400e-4dfb-8a85-44a66e13b30e	600d7697-4307-44e5-903b-01850430a16a	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
f3801428-e178-427b-8033-cdca5179c965	600d7697-4307-44e5-903b-01850430a16a	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
16111265-666d-4a0c-844d-2b10f281f318	600d7697-4307-44e5-903b-01850430a16a	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
1ff4fa90-99f3-4744-b1b5-1ea46028d757	600d7697-4307-44e5-903b-01850430a16a	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
cc6214d7-4ce2-4b1d-a347-03df716f18b4	28468fa7-3ee1-488f-aa94-2131af991d7d	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
6223fe5f-fe80-4926-9ea0-3103b39e93cc	28468fa7-3ee1-488f-aa94-2131af991d7d	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
8d41006f-d736-4775-9c8e-18de57887d45	5b7505b0-f9c2-4ea7-8fdb-48fe373b758a	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
2e906274-0293-4f0d-a760-bc6c39125910	5b7505b0-f9c2-4ea7-8fdb-48fe373b758a	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
99d359e4-0d3a-42b5-9764-e29b17cf342f	61b6926e-a389-41bf-8523-fcfe9bc1aa57	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
8c9f1bdc-eb37-4904-b795-f2bbaee42f23	61b6926e-a389-41bf-8523-fcfe9bc1aa57	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
7bba0830-2a8c-41bf-bc9e-1fac2058d2f2	13043fa8-1950-4e56-bf3c-7f6547ad3597	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
72b9e85a-e7c4-465b-9d8d-ad123182fb30	13043fa8-1950-4e56-bf3c-7f6547ad3597	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
1bef9ba3-6722-4fc9-8448-4c10d6311290	13043fa8-1950-4e56-bf3c-7f6547ad3597	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
d5572887-95c3-4cc9-a51b-475334e8ac53	13043fa8-1950-4e56-bf3c-7f6547ad3597	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
3f68a64e-ef93-4a2e-ba27-1f18e473da14	13043fa8-1950-4e56-bf3c-7f6547ad3597	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
ddb1607e-fd5a-405c-be95-03fea84da2d5	3c3a4a15-7272-4655-a0b5-31e27f48cf1c	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
a5fa815f-0b7b-4a21-8ff7-3c7a46c9bc3d	3c3a4a15-7272-4655-a0b5-31e27f48cf1c	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
c0e84e0b-c4e7-43e0-a271-e0bf96f7f7e1	3c3a4a15-7272-4655-a0b5-31e27f48cf1c	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
3a952d89-798b-4eba-99f3-e679d6aeb6ac	3c3a4a15-7272-4655-a0b5-31e27f48cf1c	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
4295f5c3-fe27-4c28-bb86-e8f9503ba0e2	3c3a4a15-7272-4655-a0b5-31e27f48cf1c	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
9b9e86c9-03f3-4b6d-8033-2ab6e9f9016d	b8a522dc-042e-426a-aaaa-13d43692c661	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
6af49e42-a8f7-4e62-a9eb-763470683f68	b8a522dc-042e-426a-aaaa-13d43692c661	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
247a543d-b3dd-491f-92a8-ea2579aaa9ab	b8a522dc-042e-426a-aaaa-13d43692c661	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
5fa45e09-f0e1-4773-8e44-600a07b46ee5	7899739f-efd9-426b-9f2d-0d77b3943017	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
b25d0f40-e01c-47a3-94ea-d835d2385646	7899739f-efd9-426b-9f2d-0d77b3943017	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
fee2dbea-e005-44c3-9d4a-234ffe704e21	c7fc07fc-efdf-46a0-abf7-ded5cf5872c6	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
00a9857b-9b84-4b8c-a30d-d9a2ca3503f8	ece82c07-558d-43bc-b578-6694ec35c2b1	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
719a5ff2-6c73-44e2-bb65-76b7fe379abe	ece82c07-558d-43bc-b578-6694ec35c2b1	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
339f710c-afe3-4c8b-87c6-e21176495ee2	72f1ceaf-5737-4cc6-893e-eedc516fbf5b	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
95c8de9b-4aa8-4295-8304-38e73aa725d8	72f1ceaf-5737-4cc6-893e-eedc516fbf5b	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
5e6f280e-a9e3-4d68-bde0-75246e4a59fc	72f1ceaf-5737-4cc6-893e-eedc516fbf5b	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
4776a74c-ec07-437e-a822-b0673432c1f0	72f1ceaf-5737-4cc6-893e-eedc516fbf5b	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
91df2d8b-3161-44bf-a384-7f2ca81b4175	72f1ceaf-5737-4cc6-893e-eedc516fbf5b	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
025eb840-e0a1-4cf3-a5e8-115943c11f72	df505d51-c760-4a27-8d2d-6fce2de4b2cd	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
9ef3c7c3-00e0-4aac-b5bf-b43c0e5a12bc	ee5b7d50-f8f6-491f-be7c-7f6aee05ec13	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
78b84193-e6f4-4d80-ba22-8b77e6794c97	ee5b7d50-f8f6-491f-be7c-7f6aee05ec13	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
f83c6d78-57c8-44eb-ba7f-b6c6f3487d79	ee5b7d50-f8f6-491f-be7c-7f6aee05ec13	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
500dd818-5870-4cb4-b4a1-7248523b6d19	ee5b7d50-f8f6-491f-be7c-7f6aee05ec13	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
21bba57a-31f4-43f5-b613-a33ce127d50d	d3bbfe57-36b3-4580-99d8-f54f6330295c	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
ad1b1ba7-048d-4533-a964-6033840d3042	f5c2bf0e-d7b1-41b9-ab4c-7ea7ea37aee8	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
6b77c2b4-d57d-4d79-8952-01da1036d248	f5c2bf0e-d7b1-41b9-ab4c-7ea7ea37aee8	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
feb694aa-3173-4b90-91e3-a7557cc1fe49	669d306f-1e6a-447a-be16-f7e4a3157150	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
209173bc-8f56-4af9-9d17-6a86eb94c5e3	669d306f-1e6a-447a-be16-f7e4a3157150	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
46c38f91-be3a-47b2-b6e7-e85b037162b4	669d306f-1e6a-447a-be16-f7e4a3157150	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
8889d227-7885-4ef5-a6b1-01dc322186ba	669d306f-1e6a-447a-be16-f7e4a3157150	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
27b1f7a6-6368-4eda-b359-af00fc8376fe	1ed3e643-b9b0-451b-a42c-d701b4c920e0	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
59079a13-d1ae-4507-8f2b-72b75910cc65	1d7f737d-db1f-4bcf-a8ff-fb14fbc0148f	9a6469ff-27dd-4c55-81fc-15b2c88f6f93	MEMBER
4862ee92-1cdf-4385-86e1-43c04bb6a772	1d7f737d-db1f-4bcf-a8ff-fb14fbc0148f	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
de76749d-a469-4bc8-ac69-d6bef9562467	7e258cc1-b5fa-475c-9f46-92dcdb04ff2f	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
193207d3-1fc6-4d99-998b-87403098182b	7e258cc1-b5fa-475c-9f46-92dcdb04ff2f	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
f3211c3b-9a7b-4d09-b5bd-109681aa28ce	7e258cc1-b5fa-475c-9f46-92dcdb04ff2f	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
41f89a8f-b4a4-40ae-951e-7b2208bca224	7e258cc1-b5fa-475c-9f46-92dcdb04ff2f	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
b71c4f38-5c02-437f-9b63-ba45f7df111e	7e258cc1-b5fa-475c-9f46-92dcdb04ff2f	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
741c0e97-27ec-42ad-87a7-4fe75a708603	6e5c2f86-2daf-43f8-bb78-15147b50d9ff	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
1e75218f-4dd0-4e54-8551-45c07f13ef48	6e5c2f86-2daf-43f8-bb78-15147b50d9ff	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
28556177-d8d0-4203-bed3-e7d88b6c3703	6e5c2f86-2daf-43f8-bb78-15147b50d9ff	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
c7ad7eaa-6a45-4990-a213-4f1d4a7f7b33	6e5c2f86-2daf-43f8-bb78-15147b50d9ff	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
38cd678a-9a7f-468f-8e8e-c064a67bb674	6e5c2f86-2daf-43f8-bb78-15147b50d9ff	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
a59b1108-7c56-48db-9419-896f456ddd3e	262255a9-40a1-4082-95b7-d250a595757e	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
b7c6c32b-9365-48fb-bd25-0088e6e19540	262255a9-40a1-4082-95b7-d250a595757e	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
64fe9502-92ef-463a-9b70-182c44aaa49c	262255a9-40a1-4082-95b7-d250a595757e	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
1babbd10-71ba-4533-ab82-952538b898e2	262255a9-40a1-4082-95b7-d250a595757e	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
3c3f0074-b549-4807-8d56-21a656fbef2c	262255a9-40a1-4082-95b7-d250a595757e	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
e708f746-376c-478a-810e-505c415e8e04	8b9ba686-c7f7-4576-96f0-d78214fbf58c	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
06e739c6-4afd-43d8-a7e4-f4d1cad75949	8b9ba686-c7f7-4576-96f0-d78214fbf58c	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
04bffe4b-13b4-4528-bccc-8fe4e757b37c	8b9ba686-c7f7-4576-96f0-d78214fbf58c	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
02364185-890a-4f37-a987-31d6961a2276	8b9ba686-c7f7-4576-96f0-d78214fbf58c	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
ee0ac7b6-4ef4-4fb5-8e7b-f0b611a8805e	687bb3b6-cfcf-4230-8e0e-81bff64d7617	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
33e6876d-da63-40bc-93b4-c5bc004a4cd5	687bb3b6-cfcf-4230-8e0e-81bff64d7617	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
8d6e3c9b-6efd-4a6e-bc9d-c4732432feef	6463fc7b-aee3-403e-964a-767c80d06612	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
9012ea78-2fe3-4154-ac73-01a85bc44e1a	6463fc7b-aee3-403e-964a-767c80d06612	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
76571a37-f443-42a3-8de4-0c1f75b78e23	6463fc7b-aee3-403e-964a-767c80d06612	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
d7699e79-5569-4bf6-a55c-6f29db7091c2	6463fc7b-aee3-403e-964a-767c80d06612	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
183bf965-7635-4f49-86bd-d3254bab0918	6463fc7b-aee3-403e-964a-767c80d06612	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
0f3bdcd5-6ede-4221-ac61-f7d533eac122	1fc654e7-cc89-4b8f-8930-2d0527de0e4c	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
ebb45591-0348-4e2f-a808-a8cf37918e5e	1fc654e7-cc89-4b8f-8930-2d0527de0e4c	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
2937c227-5b0e-4443-bd5d-41a12053e5eb	603806f4-3c96-4f00-84bd-3f13e581f8a7	9a6469ff-27dd-4c55-81fc-15b2c88f6f93	MEMBER
1c42defa-1a18-48aa-9afe-5bdda4ae248a	603806f4-3c96-4f00-84bd-3f13e581f8a7	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
7bd86346-db80-4155-ad10-2889582a4454	603806f4-3c96-4f00-84bd-3f13e581f8a7	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
8f0e61b9-f147-46a9-b5c0-9b04eaec3519	603806f4-3c96-4f00-84bd-3f13e581f8a7	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
94b51863-7e0b-4334-9b70-5fb2d905e7ac	6732d1bb-1942-43f5-8bff-e6b277f9ac1d	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
f4a6bc07-778b-45c9-9e78-c64dc7a366c9	6732d1bb-1942-43f5-8bff-e6b277f9ac1d	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
d5b6290d-e2cd-47c0-a9ce-877af2b45829	6732d1bb-1942-43f5-8bff-e6b277f9ac1d	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
61ce9cea-06b7-47e5-a9d4-214678c897a3	6732d1bb-1942-43f5-8bff-e6b277f9ac1d	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
1a7b24fa-e7fd-4bb3-8314-aa59bfcca5b8	1ef5f5e4-1d34-43db-abb9-9831a5e3e2ed	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
8730ea85-a233-4182-b694-be688f24fc13	1ef5f5e4-1d34-43db-abb9-9831a5e3e2ed	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
8f0251d4-c456-40f6-8d5b-db93b811cb97	70d2202d-2e93-42c0-a968-2df07da97041	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
ba27d920-b107-4f56-837b-c437f85c7dc3	70d2202d-2e93-42c0-a968-2df07da97041	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
b511ac2b-7bda-4649-b9fb-52974a7b571a	70d2202d-2e93-42c0-a968-2df07da97041	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
f315ab1d-635e-4b81-8a89-d9d03eabb465	70d2202d-2e93-42c0-a968-2df07da97041	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
7e6c85f4-e31e-464d-adfb-3426b3e50532	70d2202d-2e93-42c0-a968-2df07da97041	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
1c2e6331-61c0-4d3d-b0c2-93e6027c0803	ce0e7967-9272-4ec6-aa15-aa8c7cea3ac5	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
34b79326-95b7-4b03-b90b-a5efa6de176b	ce0e7967-9272-4ec6-aa15-aa8c7cea3ac5	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
dfc187bc-ab8a-48d0-9995-1f4cfd49a8db	bfa17c2d-d487-43ac-8d0d-5b9f7b45f5d0	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
43274f24-2580-4142-8137-316100c7bcfb	bfa17c2d-d487-43ac-8d0d-5b9f7b45f5d0	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
bea49912-859d-4b6b-8704-2826bc4a33aa	bfa17c2d-d487-43ac-8d0d-5b9f7b45f5d0	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
ad7c04b5-a357-450e-97bd-4eff491c576b	67697ee6-7960-4bd9-bf83-e2864ce35bc4	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
e48d49f3-b21d-4717-9c29-8e88e2f31b32	67697ee6-7960-4bd9-bf83-e2864ce35bc4	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
21b93453-29f0-434d-b8a5-54490118d7f0	436d4f18-6b70-41ac-ab72-50968f5a4906	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
22507fa8-f2df-4b22-b297-884fa76cc38c	436d4f18-6b70-41ac-ab72-50968f5a4906	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
d710b2c1-ad40-42dc-bd29-dde680c5eede	436d4f18-6b70-41ac-ab72-50968f5a4906	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
346a6ad0-d339-4fd5-9e53-ef5cbb5cbceb	93fb7233-f212-46a1-86f8-7e1dfeda7d47	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
5fc6d703-c412-4953-a29e-c45e6a8a79c0	93fb7233-f212-46a1-86f8-7e1dfeda7d47	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
fb7b8944-58d1-43e2-aad2-988ded019b44	93fb7233-f212-46a1-86f8-7e1dfeda7d47	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
1fbfed7c-f2c2-4869-b884-cae0196e8ce3	93fb7233-f212-46a1-86f8-7e1dfeda7d47	ff0ceb06-a3bd-4263-b36d-ddee51fa1eab	MEMBER
e14fdc7a-3c12-4491-9b59-5d67aba35347	8cc13df6-36c2-4ebb-8862-21e0365271a4	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
bd5e5045-d344-4b63-ac05-f2c5d87b2395	8cc13df6-36c2-4ebb-8862-21e0365271a4	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
94283c92-f860-4128-a43c-09be23bfc89d	8cc13df6-36c2-4ebb-8862-21e0365271a4	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
fd2021d4-0beb-4b4d-889c-ea55ebdab22d	150ee70f-162c-4b7f-8fa6-9f72aa6ec6ce	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
20c7f37c-5992-4ee2-9b1c-d634d5074597	150ee70f-162c-4b7f-8fa6-9f72aa6ec6ce	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
7f27e572-5c68-42ca-a938-5b3af31496ce	993736a7-7825-4fc4-8854-ef4e9dc11224	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
0b2db343-fde9-4ce7-8876-16c5f717d244	993736a7-7825-4fc4-8854-ef4e9dc11224	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
8938759c-efe3-4ce7-b494-120c8cace9b7	993736a7-7825-4fc4-8854-ef4e9dc11224	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
b8622c7c-958d-499f-8807-4f5db82dea0d	993736a7-7825-4fc4-8854-ef4e9dc11224	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
2c2d03fc-752e-4f91-99bb-ab26da651deb	ac8967a1-b92d-41a7-bc96-3c62418c3ccc	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
1142d559-87e3-4e1e-b90d-b77e3e8454d0	ac8967a1-b92d-41a7-bc96-3c62418c3ccc	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
ea315f8c-5be2-4a0e-a95c-e00f803945f9	ac8967a1-b92d-41a7-bc96-3c62418c3ccc	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
36074661-1c22-415a-93eb-3aff02ab46af	ac8967a1-b92d-41a7-bc96-3c62418c3ccc	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
0318feec-e1ef-40a7-854d-2c03ac17c5cb	8ce39aa7-bffd-4af5-878b-d7f96c9fc84e	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
1b627e5b-c660-4546-a6e8-f8ea9a832ad7	0168502f-0b67-484a-901a-ed4bc881ffe7	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
a1ef35e9-fa26-4a1e-8410-630d7c9c075a	fae29cd0-0413-4e0e-b1ba-d1bcbdc23634	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
65f8d0b9-0c10-43e3-8d38-8103fcfc8135	08f1e201-9ab0-44cf-9df7-46d2590d802a	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
3b6344a2-44a1-40e4-8359-837f413fe8b7	08f1e201-9ab0-44cf-9df7-46d2590d802a	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
0ec96555-6855-4d3a-b36f-1e9b354e28bd	08f1e201-9ab0-44cf-9df7-46d2590d802a	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
655f1989-d2d5-4094-8c69-144f7929bd33	a44cbbee-21a9-4a6b-9086-a8204c6ac5b1	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
bbfbfb35-da70-48f5-a7ef-9efdc7ae33c3	139adbd0-74a3-48b5-9591-feeb222d29bb	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
f1604bda-388c-4c98-85b5-efdafa7be218	d395d85c-78d1-4210-9e76-f491e3c300c2	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
561da291-2c1d-4a44-92b0-fa99af619491	d395d85c-78d1-4210-9e76-f491e3c300c2	097001f6-1ec5-4157-83ac-4e47020b6dc4	MEMBER
ba9fc46d-7dd6-4fb8-b6c7-321e1623d756	d395d85c-78d1-4210-9e76-f491e3c300c2	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
ec0c035a-d951-43c5-b258-e5eacd8b8e96	eca9a3a4-a131-4e7d-b6ee-c47429433ff9	9a6469ff-27dd-4c55-81fc-15b2c88f6f93	MEMBER
2ae07525-ff8a-4bf0-a236-84b1050adf37	eca9a3a4-a131-4e7d-b6ee-c47429433ff9	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
88173126-6ab8-4bb0-bdcf-c5e0c3cbdb2a	eca9a3a4-a131-4e7d-b6ee-c47429433ff9	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
845e3f09-143c-4fed-b334-6eb4deeb8df6	eca9a3a4-a131-4e7d-b6ee-c47429433ff9	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
b6e0e52b-5b45-407f-845e-6029113b6206	5ab8c24b-bda8-448a-9cee-26299207e311	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
9b4a8637-ba8c-4ff6-940a-5bb9fddd08e6	5ab8c24b-bda8-448a-9cee-26299207e311	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
ff6d18f4-5a34-4584-ab71-f93b17013171	5ab8c24b-bda8-448a-9cee-26299207e311	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
b25f7229-9ea1-4218-8ab7-ec2207375e56	5ab8c24b-bda8-448a-9cee-26299207e311	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
b9d1cb90-9549-4f57-ac56-8c89f7aa1634	5ab8c24b-bda8-448a-9cee-26299207e311	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
7c75adc2-ef47-43b4-a13c-b83b17d0f3e9	4c8857ca-405f-4bb3-b685-bffb62c1d3c1	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
44996aeb-7145-462f-bfc4-195b6f1c31aa	c215938d-cdde-46b7-90d7-6474af418375	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
0e20d403-203a-446a-92a1-904a88ddd0c5	c215938d-cdde-46b7-90d7-6474af418375	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
dad3bcad-ac4c-4a54-929a-b440117584b4	c215938d-cdde-46b7-90d7-6474af418375	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
6216c27d-064e-4ed9-b272-d1b5e7a06217	10e92c04-addf-4bfd-9abb-0819b6d7db37	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
10a82b65-5024-4ff7-9475-37a25c8b32fc	10e92c04-addf-4bfd-9abb-0819b6d7db37	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
c5bccdc6-6da9-49ab-8aa0-c7b9db059302	10e92c04-addf-4bfd-9abb-0819b6d7db37	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
0c331770-5b65-4c2f-901c-ab163b952587	10e92c04-addf-4bfd-9abb-0819b6d7db37	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
48834382-5c0b-42e1-8fcb-dfb9a8d62e34	10e92c04-addf-4bfd-9abb-0819b6d7db37	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
be4510cf-d7ae-4493-bb5e-837a20d8a683	f2088538-3f71-431d-9741-0ed5d4241b5c	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
72311f46-01d0-4575-a59c-dff350572d13	f2088538-3f71-431d-9741-0ed5d4241b5c	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
e9ab688c-55ab-4057-b1cc-c5e7d1d942ec	f2088538-3f71-431d-9741-0ed5d4241b5c	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
0346cc98-b4ea-46e0-989c-245e3f9029ce	f2088538-3f71-431d-9741-0ed5d4241b5c	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
b6a66bdd-af4f-4444-973c-79a8748d421b	509d470c-a269-4e81-b240-56fae288c498	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
0d7d3935-5044-47bf-bbac-0cbe5353836a	509d470c-a269-4e81-b240-56fae288c498	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
9af20a00-9ab8-4396-a728-c87102436d0a	816c3faa-3800-4188-9d00-7918e9183ad3	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
cb361bd5-ba15-4dc1-8c0e-70877c877280	816c3faa-3800-4188-9d00-7918e9183ad3	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
4d6bc10d-cf87-4aa6-9ce2-06698a419d79	816c3faa-3800-4188-9d00-7918e9183ad3	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
fc4e5d3c-93a3-4951-a25a-82f0626d82b7	816c3faa-3800-4188-9d00-7918e9183ad3	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
bdacfd06-76c5-45a1-a007-224542ea01da	816c3faa-3800-4188-9d00-7918e9183ad3	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
dd3135a2-f2f5-4743-9e1d-a7dc35ed53e4	16c170d9-f16c-49e4-af05-a17e7ceb01b9	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
034e8db3-012c-4105-970d-61f923dd6e90	16c170d9-f16c-49e4-af05-a17e7ceb01b9	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
05c2c299-89f1-49d7-afae-62324a9e42fe	16c170d9-f16c-49e4-af05-a17e7ceb01b9	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
2d64d9f7-0167-4b6f-b2f1-29c55445e4d9	16c170d9-f16c-49e4-af05-a17e7ceb01b9	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
c71ad03b-7780-435c-9ff1-a05f9c8f3c15	2483236c-8de4-44a4-a880-927cfdb0c5ef	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
cdd512aa-4f7d-4f68-9649-73bae09fe477	8acd0cc5-edc6-4270-9ddf-392a649b1306	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
8a8b11f4-0250-45c4-bfa9-0833882bcbb9	8acd0cc5-edc6-4270-9ddf-392a649b1306	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
c80c50ce-0c93-4fa9-8b21-6da8c97a9e26	8acd0cc5-edc6-4270-9ddf-392a649b1306	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
23e873f0-1a64-46ac-ac49-a7ddb0a89409	8acd0cc5-edc6-4270-9ddf-392a649b1306	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
12897bb8-0bbc-473d-a981-1d566491122d	c7d2fc4a-5a3e-4be5-8c89-7b19fa5ebae8	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
8265300e-50b0-402d-93e4-f34a7e39b2d1	c7d2fc4a-5a3e-4be5-8c89-7b19fa5ebae8	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
f5111ec9-7a7b-4fc5-af92-7df720c3a897	c7d2fc4a-5a3e-4be5-8c89-7b19fa5ebae8	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
a215cbab-0c93-4c71-a025-519a9dc69279	feedf5bc-0af4-46b6-a986-8353ebc336ad	e7b769a7-344b-4beb-8aa8-c371369fb04e	MEMBER
b13c45eb-91e3-43b2-aaaf-5d0e47f89675	feedf5bc-0af4-46b6-a986-8353ebc336ad	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
bf357178-3af5-47f9-abad-59e20a86d0f1	feedf5bc-0af4-46b6-a986-8353ebc336ad	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
3bcbfaf4-9849-483c-aa10-234997d73d13	feedf5bc-0af4-46b6-a986-8353ebc336ad	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
391e5194-88b2-4bf0-9a08-c4cd491f09fb	17e961aa-cd8d-4206-ab91-4ee1ad773689	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
d64b2dea-fb45-4b0f-ba6b-f6d4698a2060	17e961aa-cd8d-4206-ab91-4ee1ad773689	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
a17e2d57-9583-42e7-98ea-1c2f332db5a4	17e961aa-cd8d-4206-ab91-4ee1ad773689	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
fca09910-2b78-4a75-ac56-4a389997d708	17e961aa-cd8d-4206-ab91-4ee1ad773689	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
8d62c31a-5915-4688-8434-97260785f179	8b1abcaf-8d4f-4132-995e-2cc11cae0420	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
b632c2ac-dea3-48e3-bcee-fcbdd97f2422	8b1abcaf-8d4f-4132-995e-2cc11cae0420	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
56176331-a4dc-49a1-b4d9-540ec44f90d3	4539eab9-7212-4f82-b5a6-db8002a72e3b	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
fca61f61-f81b-4ba8-b19b-7e7d17267d95	3e4b5057-fa31-468d-b190-60ea413881f0	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
8d93fe22-b99c-4e75-9f49-40cfbf728bcf	f9de1004-abe5-4293-92cc-cd83b8a0ceae	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
c4e85ba8-402a-4280-ab84-7449c0896c7c	f9de1004-abe5-4293-92cc-cd83b8a0ceae	5748e4da-e002-49bd-a37b-6b7be04e928e	MEMBER
300738bf-8453-442e-b774-e3aca54e07eb	f9de1004-abe5-4293-92cc-cd83b8a0ceae	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
7191626e-61aa-44bf-b3ab-299d6a70db1f	f9de1004-abe5-4293-92cc-cd83b8a0ceae	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
8cbe34fb-b03a-4bbb-8747-a45fccc0ea2c	f9de1004-abe5-4293-92cc-cd83b8a0ceae	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
78a46fe5-02ff-4c2a-9c72-de7096809961	3a56cabb-fa29-4cf3-88a4-c4f287c04008	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
caaaab3f-72a6-4b5a-b1d3-527733dd5948	3a56cabb-fa29-4cf3-88a4-c4f287c04008	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
bfdb0b3e-2d5b-4f16-9521-7ce0cc4567a4	3a56cabb-fa29-4cf3-88a4-c4f287c04008	800c712c-ae9c-49cb-b9ad-06505b603aa4	MEMBER
80b28a47-9766-411f-b5ce-18bcb342ba0c	3a56cabb-fa29-4cf3-88a4-c4f287c04008	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
f463564c-308c-49c2-85c0-b3e21b5433e4	3a56cabb-fa29-4cf3-88a4-c4f287c04008	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
95d17a3d-94ea-436d-8570-7f9b4b48eb79	7076434a-295f-4fbd-b2d0-f517b7dbc6fb	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
13dcf6ce-05a7-419e-845c-8d41b5028043	7076434a-295f-4fbd-b2d0-f517b7dbc6fb	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
7584f0ce-8184-4b4b-b16a-f77295d4bb13	7076434a-295f-4fbd-b2d0-f517b7dbc6fb	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
702bda2f-944b-4cd6-9b0d-de4a9bc5037c	7076434a-295f-4fbd-b2d0-f517b7dbc6fb	dfa1e0d8-3ce8-45bb-847f-0c34a401b2ab	MEMBER
a3de1209-fab7-406b-a4fa-74d6823e28f4	26f43386-4807-436d-bdc6-58cdef9fd09e	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
6e9799af-b44f-496c-b1f6-fbe233a6f02d	26f43386-4807-436d-bdc6-58cdef9fd09e	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
a91b8fd7-a3a1-4bde-98f9-5b7e9c4633fd	26f43386-4807-436d-bdc6-58cdef9fd09e	44ddb259-4bf9-4546-ac54-394bfd900130	MEMBER
f6bde72f-c520-4d82-8250-8707572aa636	7bbc44f9-99cf-49c8-98ed-a07da4f343b6	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
d2756087-b09d-4cd8-8717-83b1b99cec86	7bbc44f9-99cf-49c8-98ed-a07da4f343b6	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
0be1f6eb-7cb8-4bc1-8ba1-28454aee6982	7bbc44f9-99cf-49c8-98ed-a07da4f343b6	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
ef8d0f01-13f5-4c42-9686-5865304abdaa	7bbc44f9-99cf-49c8-98ed-a07da4f343b6	bbfb1c89-28bc-4ddf-9b14-068665defeed	MEMBER
fb33d811-453d-416a-aa6a-b0564abeabe3	7bbc44f9-99cf-49c8-98ed-a07da4f343b6	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
c3031e52-a6e7-457a-a0fd-943deed91792	f5fa3444-2711-4e58-80f3-bc71dd783c13	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
f0283d57-39f4-466a-849d-ecaf64eaf471	f5fa3444-2711-4e58-80f3-bc71dd783c13	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
c7ab9678-6b32-4c3e-b5d9-e9c4fe8e7387	f5fa3444-2711-4e58-80f3-bc71dd783c13	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
7ddd813c-b467-44dd-a85b-4d7eb1b29180	f5fa3444-2711-4e58-80f3-bc71dd783c13	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
d52c6d3f-2b4b-4203-9b47-03bd9915c9b7	f5fa3444-2711-4e58-80f3-bc71dd783c13	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
39848b2d-ed43-4100-a460-ec03f540b252	1decbc06-7842-4e85-86d3-4b862eb78229	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
3ec8b222-d710-436a-b5c1-111c855d1f6b	1decbc06-7842-4e85-86d3-4b862eb78229	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
37093195-9280-4750-b8ac-20b0115cd2e2	1decbc06-7842-4e85-86d3-4b862eb78229	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
50250d1b-1d37-42b7-a303-6fb25ef75e61	1decbc06-7842-4e85-86d3-4b862eb78229	48f3fcbf-8bbc-4987-887f-1e059f271c62	MEMBER
ceb6b899-963a-4c8f-8968-982c5fd5c8be	1decbc06-7842-4e85-86d3-4b862eb78229	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
d34703a4-1d19-45ae-8455-6c708841d168	634517cb-d38b-4ded-a1f1-5967f2e61a78	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
d088a334-71e9-452c-a9a7-09a0de2a2f89	634517cb-d38b-4ded-a1f1-5967f2e61a78	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
f7c5ea5d-5e96-4729-838a-35a072210def	7cbc636d-ec59-4245-9caa-d17f2a264b4e	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
85edc0f4-fd9a-4ae0-8760-ccfe0171b357	ce795efa-f623-4473-a626-a54093d89179	5cef4c9c-dc6a-40b5-8c3e-718051a0d8cc	MEMBER
a4c454a5-cce5-4739-8e22-364c22dc1214	ce795efa-f623-4473-a626-a54093d89179	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
83eafd77-d56d-4b0b-ab8d-fc45102c156a	ce795efa-f623-4473-a626-a54093d89179	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
c6904430-e134-4f50-9e69-344bd2792141	ce795efa-f623-4473-a626-a54093d89179	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
349ecda0-e926-4517-babe-9e557bce3d9d	334c2a5d-bbf7-480f-a32f-5970042a95f0	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
3aa28825-5ac2-4dd9-a549-8235eacc169f	8b5b9499-7cff-48e7-a4f7-602296c47156	944d59c5-b71f-4034-8450-648af28e6626	MEMBER
faef2a54-ad31-4648-86fa-872b05586920	8b5b9499-7cff-48e7-a4f7-602296c47156	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
02012dd4-24ee-4d56-bfee-e3bde8ad0a0f	cc50b768-9f7f-4eb8-9581-c99ee50bbceb	226b4f18-a3ec-4afa-8db0-4edbbfcb888d	MEMBER
cd453604-8067-4027-8074-f270bf8e7d00	cc50b768-9f7f-4eb8-9581-c99ee50bbceb	a896699d-045a-4b2f-82a6-2307594a1a8d	MEMBER
9fed7008-edc9-4647-8e27-230304f45dd0	954ce28c-cae2-43ce-bb50-fc8876207c27	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
d4bb66e4-cb61-465f-961f-d1f63342c06b	954ce28c-cae2-43ce-bb50-fc8876207c27	06cbd720-90e9-455d-aca0-ce761474998c	MEMBER
11ebdf97-8e4d-4476-b0b0-06b69b96bf88	954ce28c-cae2-43ce-bb50-fc8876207c27	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
8b3f5329-3783-48d2-be6d-3a8782429761	7a03f46c-b347-418d-b2be-93ffd818c72b	1c9d9b8a-af32-40d0-9277-10affd003fec	MEMBER
14e5196a-c606-42f4-ae10-cbb53ab2406c	7a03f46c-b347-418d-b2be-93ffd818c72b	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
a06cf2aa-f588-4655-a79f-e6bc1fdbfaf8	7a03f46c-b347-418d-b2be-93ffd818c72b	93240099-cf23-4e64-a70c-fc5de53cd86b	MEMBER
8145ee36-333b-4e1e-9060-db4e91963480	7a03f46c-b347-418d-b2be-93ffd818c72b	20270a7a-ead3-4aa9-94f9-f1c1b1205b23	MEMBER
da91e925-ff2d-403c-813b-27ac429ca1a9	7a03f46c-b347-418d-b2be-93ffd818c72b	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
b6a15d52-dbd6-408e-965d-6b259904c55e	10e064b1-0ba0-4657-b8f4-53f93831252c	92dfe26e-7904-4d6f-a3c8-71671974c3d7	MEMBER
f9170581-3b25-4a36-99a0-009edb27d5b9	fc3804f9-10dc-4f8d-a15a-8fb6ab7b49b4	8cae033d-0b8f-465a-a358-a22ae1801835	MEMBER
cf5c2cb5-a5f5-41b6-a08b-62af206f23ee	106a7089-d1e0-4f73-ba8d-80b79c94b044	70ebde86-2cdd-4158-887f-6b624a2cf6e2	MEMBER
d89fd6a7-5a4a-40ae-a080-b10789a37d7e	106a7089-d1e0-4f73-ba8d-80b79c94b044	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
6931bd53-bd20-44c5-b805-c5a4b5795e46	106a7089-d1e0-4f73-ba8d-80b79c94b044	27ef0f07-e98d-4b63-a847-b5343f869bc5	MEMBER
cb8e30f6-c821-4ca4-a699-c5820ebaf05a	ebcd2459-7bfd-4ad4-bd99-edd22fd8340d	cd9d631e-5795-4e14-8e56-058222d8c6a0	MEMBER
1f826fe1-32ba-4a0d-afb3-5c68adb9f423	ebcd2459-7bfd-4ad4-bd99-edd22fd8340d	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
339fd1e4-bc9c-465d-be2f-d33608d92429	ebcd2459-7bfd-4ad4-bd99-edd22fd8340d	6f32905f-58e1-4925-8814-5bd5fce85a39	MEMBER
592fd565-8d82-4386-af16-6de2912a142d	4e49932d-0c80-4d63-9008-c71d06e83052	32d695b0-9f9c-4428-b566-5fbb4b864330	MEMBER
b098648a-dcd2-4aa0-86f0-2f650494ae5a	4e49932d-0c80-4d63-9008-c71d06e83052	67776513-9e7b-407b-bb37-6011fb8b396d	MEMBER
e1df70dc-84a4-4a8d-bd81-10649f62121c	90b75ccf-bf32-4eb0-950f-17163cfc7193	fa9f4f3b-229f-4c30-98dd-80795d2e444b	MEMBER
e4486bb0-864e-4a3c-938e-17659d2d7254	90b75ccf-bf32-4eb0-950f-17163cfc7193	04075744-51d8-4f26-9a5c-6c68fec6f01b	MEMBER
76f3200e-1e6f-4771-a518-b1fa2c836850	90b75ccf-bf32-4eb0-950f-17163cfc7193	e23b1179-deaf-460e-94b7-35d4f5ed094e	MEMBER
b83c0309-247c-4cc8-8438-2fdc90be8c68	90b75ccf-bf32-4eb0-950f-17163cfc7193	9c30be31-60eb-4def-b46a-c11eb9be89f9	MEMBER
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
9218170383347	2021-04-26 02:50:07.02472	2021-05-01 02:50:07.02472	f	a4d75391-7550-4c0f-bc00-eefaf66180a7	Sure physical agreement soldier foreign drive shoulder.	{"{\\"url\\": \\"https://dummyimage.com/753x631\\"}"}	https://carter-browning.com/index.html	https://coleman.com/main/app/app/homepage.jsp	MEDIUM	{6300146742128}	{}	6	2	8	Scene any building. Stuff anyone rich bar computer. Better later news writer own very.	Also beyond us power determine watch. Inside sign office political democratic particular. Say back key whose for. Toward former since type value between reality push. Site true lawyer pay discussion.	Always same population test west. Human dream institution last. What federal leg raise south its.	Over authority someone Republican operation behavior eat expert. Hard shoulder who news walk real color start. Glass challenge anything drop call between guy use. Better hear speak.	REQUIRES_APPLICATION
2110708225341	2021-04-19 02:50:07.026467	2021-04-22 02:50:07.026467	f	ccfcb8d2-44a9-47f8-a981-a13625722579	Through pay by figure local fight.	{"{\\"url\\": \\"https://www.lorempixel.com/760/95\\"}"}	http://jacobson.info/wp-content/blog/category/home.jsp	http://johnson-hughes.net/blog/category/homepage.asp	MEDIUM	{8047694375238}	{4288716474360}	6	8	4	Production financial rule never low situation support. View audience leader without view together. Third trip condition consider.	Develop draw mission development during. North technology friend better morning fine.	Represent miss prepare author adult worker. Step quickly rock interest. Over weight discover serious commercial message one.	Tv significant former determine become our sister. Establish suggest name move account middle. Nor effort international finish long clear at say.	OPEN_TO_ALL
7769280276248	2021-04-20 02:50:07.028049	2021-04-22 02:50:07.028049	f	97a52310-ebef-420b-9bcd-f2511f5cc881	Difficult speak activity book plant hundred class.	{"{\\"url\\": \\"https://placeimg.com/893/240/any\\"}"}	https://www.wright.com/	https://www.mitchell.com/explore/about/	MEDIUM	{7461850079814}	{}	3	8	7	Attention everyone culture fear magazine why thought. Reach article knowledge economic. Fire cup draw since. Hundred amount during everyone produce.	Indeed third citizen writer style risk particularly million. Because ahead away fine prove then. Continue or attention. Politics pick how table energy.	Thus toward style popular. Nearly need scientist open three bring friend. Contain doctor change contain large. Wind today walk million month stage Mr.	Professional control ok evidence new. Pattern real of same speech. Million anyone vote term fight pass talk. Able bill fact. Produce family give alone then work table.	REQUIRES_APPLICATION
8435439037020	2021-04-29 02:50:07.029457	2021-05-03 02:50:07.029457	f	0c909c8a-93d5-4c6c-9dcc-9a9f54de14a2	Performance mouth enter whole generation statement.	{"{\\"url\\": \\"https://placekitten.com/772/745\\"}"}	https://ellis-smith.net/category/	http://hart.com/author/	MEDIUM	{6098700694999}	{4487379308146}	2	5	3	Play effect example grow. Use food ever radio. Wide myself country entire might. Bit office rock than up finish. Subject out number spend decide president set.	Why ready still five similar still rock. Free into analysis reality police. Remain participant audience decade base. Common manager her better or likely.	Discover fly responsibility well. Large like throughout order sister up movie. Clearly lose show seek of water. Offer structure author phone point water over.	Treatment response matter gas environment tend. Collection field now.	OPEN_TO_ALL
1457544666404	2021-04-25 02:50:07.030673	2021-04-28 02:50:07.030673	f	2f7bef3a-adcc-4143-a0e9-11a30793c14f	Sit country outside debate.	{"{\\"url\\": \\"https://placekitten.com/289/6\\"}"}	http://www.erickson-vang.org/category/	http://jefferson.info/	MEDIUM	{6133042538935}	{}	5	9	9	Also same song hundred product space. Consider course minute season long voice. Blue strong finish animal democratic.	Pay music former economy color that since. Send it player job.	Radio bank notice sit manage. Answer another mention language leave continue. Policy scene other single score debate nor. Man foreign pay all.	Not people reveal. Any international establish from. Lay so front large. Family pattern itself black tree authority detail.	REQUIRES_APPLICATION
8380572061732	2021-04-25 02:50:07.048509	2021-04-29 02:50:07.048509	f	04e558a9-5dcf-4290-83e8-82c8226a2e84	Mrs other president game trouble but line.	{"{\\"url\\": \\"https://placekitten.com/785/989\\"}"}	https://davis.biz/search/search/explore/register.jsp	https://www.wagner.com/category/search.php	MEDIUM	{2952154776813}	{3398070975968}	3	9	6	Old near nothing class loss onto check. Opportunity station return southern west factor hear management. Minute growth animal rather police. Head example question tonight. Short about late save.	Morning property everybody technology lawyer generation instead. Sit approach half tree rise can less. Ask position step top draw subject. Environment development all sometimes.	Tonight source would trip vote record. Radio including let make morning past. Relate consider help fire true bad need. Consumer require past mother there us generation.	Why management explain meet. Later without reflect hundred open film. Thousand bar school authority tough hotel money trial. Before Mr difficult billion culture consumer.	OPEN_TO_ALL
5669032991509	2021-04-29 02:50:07.049778	2021-05-03 02:50:07.049778	f	0a7171e4-069d-49da-ad60-0091a4dd28c1	Catch benefit fish outside.	{"{\\"url\\": \\"https://placeimg.com/504/410/any\\"}"}	https://lopez-hodges.com/category/list/post.html	http://hamilton-mills.net/	MEDIUM	{7083674416172}	{}	2	4	4	Produce travel night war. Watch spend three charge book skill.	Necessary newspaper vote best let attack we building. Traditional need position final look machine yes. Opportunity address sell.	Heart parent yard mean particularly pass enough. Success should brother.	International among security guess bar stuff a. Certain yard democratic stand.	OPEN_TO_ALL
7798540017024	2021-04-17 02:50:07.053441	2021-04-22 02:50:07.053441	f	3d01ca28-f5b9-49a9-b527-c590c407412d	Doctor board finish find degree others.	{"{\\"url\\": \\"https://placekitten.com/431/637\\"}"}	http://jones.com/login/	http://www.smith-williams.net/explore/list/post/	MEDIUM	{3617897581122}	{6286840245229}	3	9	5	Billion to difference five significant student choose model. Reduce result check market. Movement discover girl.	Exactly box during thus wind ten. Happen upon hundred PM product red seem really. Ready not dinner candidate sea. Knowledge state knowledge.	Partner under speech fact born. Pay citizen should product left technology hand. Material administration radio purpose list factor run. Matter civil reason his partner nice official.	Defense Democrat character daughter son community catch remain. Also yourself fish soon exactly. Who involve near. Song heavy industry arrive general left party.	REQUIRES_APPLICATION
0967394295163	2021-04-18 02:50:07.054603	2021-04-21 02:50:07.054603	f	b693198e-8d46-489f-8fa7-b91bfe229c71	Religious value make service.	{"{\\"url\\": \\"https://placekitten.com/305/581\\"}"}	http://doyle-evans.com/	http://williams.biz/register/	MEDIUM	{9946577829617}	{3856570439026}	3	3	6	Than manager Congress capital. Way glass be deal herself. Could rise on goal computer. Of account everybody policy fast statement.	Floor citizen baby few. Team scene cut movie democratic. Option economy other threat budget today sure. Floor star receive surface stuff. Truth prove challenge put television south memory.	Raise vote card ask family. Sister real soldier either door usually understand. Nice leader something result whole only evening.	Information have country get sound within factor. Certain crime once see.	REQUIRES_APPLICATION
2566426459726	2021-05-04 02:50:07.058532	2021-05-07 02:50:07.058532	f	5571e17b-4cd6-4839-afb9-6cd87eae9e97	Partner miss chair case.	{"{\\"url\\": \\"https://www.lorempixel.com/11/130\\"}"}	http://www.peck-davis.net/list/posts/terms.asp	https://hughes-williams.com/home/	MEDIUM	{7716440220894}	{}	2	8	5	Guy find right wind. Such high success police themselves office seat.	People live lose we today. Raise billion evidence appear professional election time. Pass learn hospital fall. Through west hundred even discover become dog. Tough military event Democrat ten same growth.	Rest figure result rest citizen. Property sit health total admit yes. Reflect security plant one boy score.	Song operation laugh determine direction. At cell coach treat able for. According standard different business.	REQUIRES_APPLICATION
2324849345329	2021-04-18 02:50:07.059676	2021-04-22 02:50:07.059676	f	e9d5aac5-d6a3-4f53-b331-74a18441f50d	Cell particularly marriage director trouble individual stay.	{}	http://www.brown.com/author.php	https://www.paul.info/login/	MEDIUM	{2497662826099}	{9156893198162}	6	4	6	List play career sound culture reflect. Much early picture star attorney.	Purpose Congress easy son west by find. Available example organization method. Management box PM debate for himself common. Between ahead official thought town present guess. Simple who design second ok natural.	Join team take site every wish. Toward growth lose.	Life chance about offer. Audience she former real defense director pattern. Such eight democratic two office success add. Drug ok quickly.	REQUIRES_APPLICATION
\.


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
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (uuid);


--
-- Name: groups groups_group_name_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_group_name_key UNIQUE (group_name);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (uuid);


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
-- Name: user_group_relations user_group_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_group_relations
    ADD CONSTRAINT user_group_relations_pkey PRIMARY KEY (uuid);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- Name: ix_accounts_email; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_accounts_email ON public.accounts USING btree (email);


--
-- Name: ix_accounts_username; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_accounts_username ON public.accounts USING btree (username);


--
-- Name: ix_user_group_relations_user_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_user_group_relations_user_id ON public.user_group_relations USING btree (user_id);


--
-- Name: user_group_relations user_group_relations_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_group_relations
    ADD CONSTRAINT user_group_relations_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(uuid);


--
-- Name: user_group_relations user_group_relations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_group_relations
    ADD CONSTRAINT user_group_relations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.accounts(uuid);


--
-- PostgreSQL database dump complete
--

