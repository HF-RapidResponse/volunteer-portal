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
b145966f-60a2-4731-b792-8c4523b40dd6	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
f37bad48-b0ac-4eb1-805d-20e8b9509540	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
7934594c-0a40-4cec-929b-03e08026153e	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
6d637444-ef0b-4e3c-afff-34d68ddfefe5	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
fd4bc8bd-a863-4d6a-a66f-ea2d7f32b34a	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c32cf118-1d86-417c-ae38-ec444b411601	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
84259efc-9a47-4389-9a86-8fd6e9f44121	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
4708090e-e935-49bb-9643-1eb53c8207af	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
43f79123-81a3-40cd-bc5d-d2de7dd19c84	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
96095a53-38d3-4811-8fc9-bbb6a37db22c	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
eb54bd07-97c3-4d8e-9563-d2b637732836	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
973643e6-e9c2-4549-8938-b401aa7a023d	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
196e95d8-7f1d-4d46-b1e0-200ebf497199	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
42422f98-c0e0-48e0-be25-ef526a626cd7	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
6f941896-4c5f-4177-9cb0-9b60230e48f0	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
b9833011-6258-49bc-a265-4d2796ee9d45	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
02e8cf76-8320-4f46-89aa-321868b19fd7	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
d669e2b9-0257-45cd-8b35-31df44e2a0d7	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
03897dea-ebcb-45a1-be9d-689be9947e1e	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
d20eb415-c5a8-4044-b969-6a90aca26c38	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c56ca4d3-17cc-4503-87a1-d8abd815e532	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
92c7ebfd-6348-40ee-8984-55209d961bcf	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c027deb9-82ff-46a1-b6ac-d492e6105313	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
640a2a4d-b2f6-4862-8040-340f39a387cb	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
d3884cde-e807-4669-bb59-ac281f469da6	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c4c07ac7-ce1a-4b7b-bb28-358531ee0c42	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
b259c292-0d7f-4daa-aaf2-756ba7996261	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
b72096c1-ea7f-4629-8ff8-9a173288acca	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
4f908bea-c565-451a-8221-831e296a1298	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c72d95d3-22a1-40cf-a282-430e76e7af49	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
acc64690-4dcc-46a7-98d9-6f44e08ac4ff	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c71e1644-9289-451a-9a77-c31a4573d71b	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
bf35ed60-f662-4e30-b3e1-daf501fc0e14	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
920a0df5-8b85-4a70-9b74-848d68385ddd	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
4124e2a7-7775-4118-bc25-0141bf8a48ba	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
e00be635-0e78-4f2a-8b31-eb0bd87d1112	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
0bcc489e-5c65-486d-b9e1-7df2d960f391	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
1a0c3989-1a9d-4269-b0f6-7c1fe0b8e816	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
16eccc88-4978-4a41-a83f-f870c015a431	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
35aa18b6-a8db-440e-b9fe-33bfcbcbf84c	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
f0dd7348-cdff-45fa-983b-e3b9be477c74	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
1875fbf7-c8cc-41f6-9a10-de435fc4960b	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
53af9fbf-dbdd-4e3d-9e0e-fa096437bd42	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
76b41547-f7c8-4b51-8f7a-dddc6fcda0cd	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
2e7c6dc1-961d-4a0e-a491-788e207abb91	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
0e20d817-59d1-4f69-93b9-f4b62cd44eaa	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
12f3ec63-635b-4e01-8507-ef2908a1bcf4	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
e2331292-8270-46e3-aa52-13c1ce35c736	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
11bbb246-3474-4d3d-b521-04e49d802dff	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
5e52c2be-ff93-40b1-91ab-5374d2d24742	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
9d6f0028-ad36-417c-8df5-0c14d565c243	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
8d9fc84e-8e41-47f1-9313-47e478011648	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
f5f04692-0f2b-4653-a548-5ffaf9127d60	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
2a4294a0-e992-4b6c-904d-7176290ca98b	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
f1e373a3-8b4f-4191-927b-371a2f7e42fd	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
8fb08cd3-4241-46d1-9a89-67a266b9af4e	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
9e653842-652f-4cde-aaa9-c084c740daa0	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
4ce38df6-f70b-457d-8467-f03d5677157c	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
4b70d279-df3b-40b8-84c8-9ce670bda786	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
b37282a4-2472-4f8b-8714-c771084d8bfc	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
eb394870-8983-4f8b-ab4a-b2dcfbad5574	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
3737c1e2-8138-4870-9408-4aa3656114b2	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
9466f043-f6e0-4e50-91c5-7c188ed1dc7b	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
46c7284c-b523-4960-b466-61b4e5b0f708	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
59a5ded3-bc6e-4357-8e88-ab55ca2c644e	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
3c476bc0-288e-4f76-9d46-8ec1206ff275	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
266f2679-2c97-4b5e-926b-7f6e6c5648b9	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
7ca009b9-e6ee-4e87-8489-821c54294319	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
ad86cbfc-ef8a-4591-8c21-9cd316bdb7ef	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
82ec78dc-e710-4ab7-b88a-fb6b4b05f069	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
fabf5c0e-00d1-4db2-b0c0-df054afbb809	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
4bef8a93-bbf0-42a8-a03b-9d18185942e4	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
70aa2d1a-353c-4670-a9a5-bdc7ebd00892	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
4935d009-36ef-490d-b792-3803c8fa6917	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
7119450c-cc26-4709-b3ba-3e64e36c41a8	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
85ab9695-8ddf-4f24-9537-db3f5660f0dc	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
bf0eaea7-93ca-4618-ae83-580380aa78b5	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
d9b5844f-7600-4a4d-a251-dc621b1b65a3	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c25f3895-e2af-4377-955d-47b30902987d	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
e94369b2-d7cf-40c2-93a5-87e0c68a0fe1	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
c6583a73-bf47-45df-b132-c1408cf10ec6	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
080909b6-c88b-4ca9-9325-01d3fb5c3056	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
62ba12e5-35eb-416d-832f-0af75152c341	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
0c2281f3-b3b7-472b-aa14-ee5cae346930	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
e989f0da-465f-4c49-9d4e-3aa1d5180351	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
58029db7-1233-4eee-b97d-1d9214430ddb	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
297f3bb9-e328-417d-906f-64b63e382280	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
a0a9cca0-735d-4a0b-bf58-4c2d86d28c4f	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
07409676-0c34-42e3-babe-7e17270a73ad	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
93e306bd-f422-4637-89e7-32644758ad9d	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
1cfcab5f-054b-467e-9ae4-8a2daaaa9954	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
5fe5b7a2-ab4d-4765-b3b2-b89b93b08f7e	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
3f76ef76-3057-4929-906f-ecd186445030	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
e4085925-f153-4de1-b88b-469a784d34fd	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
14f08790-0e28-430c-a68c-502fff7264e0	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
b6ad32bc-9468-4c00-a841-e8961d1122d5	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
47181491-d2dc-4236-8ed9-debe93939919	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
2fb0023a-1167-47c7-82d6-26b7a695f5c7	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
28d512ef-ecf9-4cb4-8bd2-5a92e60acdc6	f	f	t	t	t	{"Robert Jones": false, "Aaron Glenn": false, "Mark Jordan": false}	\N	\N	\N	\N
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, email, username, first_name, last_name, password, oauth, profile_pic, city, state, roles, zip_code, is_verified) FROM stdin;
b145966f-60a2-4731-b792-8c4523b40dd6	julia85@hotmail.com	NicholasGriffin	Lori	Paul	$pbkdf2-sha256$30000$p/ReC4EQ4hwjJESode7d.w$Rt1dOD5aNsn4frA4wEAjfMvFaOdKa950NKChPBQuYQQ	\N	https://sanders-stuart.com/	North Sheliaville	South Carolina	{"Sales promotion account executive"}	43814	t
f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	jessicagillespie@gmail.com	DeannaAyala	Katrina	Henson	$pbkdf2-sha256$30000$PacUojTmnFMKYYxxrpXSeg$tCwRWgrBDdtRzK9ywagE8E12yMBlUIONagScAlyoo0k	\N	http://www.riggs.com/	New Nathaniel	Ohio	{"Advertising account executive","Industrial/product designer"}	97169	t
f37bad48-b0ac-4eb1-805d-20e8b9509540	moniquefuller@manningvargas.com	ErikJones	Jennifer	Perez	$pbkdf2-sha256$30000$jVGqNYaQsjYGgPAeQwghRA$gSjcWouKMBkhRU47ZNMBYIdP8x.HRQlpAMEWotm5DLg	\N	http://kennedy-martin.com/	Elizabethchester	Maryland	{}	74839	t
7934594c-0a40-4cec-929b-03e08026153e	donald56@thomas.info	RyanBarnes	Shawn	Davis	$pbkdf2-sha256$30000$1DoHYIxxbu09B4AQgvDeuw$Xi8CoWrSyLqUnzpQm8Si470CUP2Ayf5q1RTNMfAY1Z8	\N	http://carroll-rodriguez.net/	Harryside	New Mexico	{}	08640	t
6d637444-ef0b-4e3c-afff-34d68ddfefe5	sawyerbrenda@torres.biz	AngelGraham	Mason	Faulkner	$pbkdf2-sha256$30000$MUYIwVir9X5PqdWa857TGg$htPlfyWTAfhPeNTEQaLjUy/GJNNvPR8Rus/v7da685s	\N	https://dixon.com/	North Ronnie	Washington	{}	72365	t
fd4bc8bd-a863-4d6a-a66f-ea2d7f32b34a	vincentgrant@yahoo.com	JoshuaWhitney	Justin	Brown	$pbkdf2-sha256$30000$s7b2vtda693bm1PqPcfYmw$SZViau3k18xFf4.xWm5X2FxS6d3E8ay/znEkRnC66FU	\N	http://anderson.com/	South Laurenmouth	Texas	{"Hospital pharmacist"}	79604	t
c32cf118-1d86-417c-ae38-ec444b411601	jonathanjones@yahoo.com	JuanRodriguez	Ashley	Campos	$pbkdf2-sha256$30000$Z4zR.l8LYcxZ6/0/hxCCkA$QbfvlpJJ.FhTWaFQs5SQQGzlJKsrLIRDQg83GPEhJiA	\N	http://www.boyd.net/	Port Caseyburgh	Maine	{"Recycling officer",Solicitor}	05233	t
84259efc-9a47-4389-9a86-8fd6e9f44121	rklein@yahoo.com	AlexanderHernandez	David	Smith	$pbkdf2-sha256$30000$uxcCIERIaW0N4XyPsbZ2Tg$AhnMZu/Y/hA0DTTtiqX5BShxXEKzdThcwu16Vpu5w74	\N	https://allen.biz/	Lake Brittanymouth	Michigan	{"Psychologist, counselling","Analytical chemist"}	61913	t
4708090e-e935-49bb-9643-1eb53c8207af	rogerschristina@hotmail.com	ChristopherPage	Tyler	Sims	$pbkdf2-sha256$30000$0rr3/t8bo1SqlfK.F.Kc0w$2eA1F9O.7H87L6RZhU5hrSz9xq/6hGKnUURv84uPD1M	\N	http://www.russell.com/	Kellerfort	South Carolina	{"Animal technologist"}	55438	t
43f79123-81a3-40cd-bc5d-d2de7dd19c84	richard84@gilbert.biz	JenniferOconnell	Julia	Perez	$pbkdf2-sha256$30000$fg8BYEzpnTMmZEwpJaT0/g$i3eesU4rOafnesMjW7v/5.spx2oWd7HdLSB7DrTseOY	\N	http://www.curtis.com/	Codychester	South Carolina	{"Public librarian"}	60648	t
96095a53-38d3-4811-8fc9-bbb6a37db22c	williamsloan@yahoo.com	TracyRamos	Mark	Gonzalez	$pbkdf2-sha256$30000$k/J.zxmjdA5hjPG.FyJECA$4VFbJMdc/Td.KJeZyPujtk62e6byey/LNs6bO3U5WTQ	\N	http://www.mcdonald.org/	West Derek	Maryland	{}	97116	t
eb54bd07-97c3-4d8e-9563-d2b637732836	lspencer@hotmail.com	ChristopherLynch	Shannon	Pratt	$pbkdf2-sha256$30000$CGGsNaYUAmAMQehdi9GaEw$0WN8kvZu4xIt1k1MhgqqW1OB8/sIpTqCVoZoNc80N1Y	\N	http://www.sanchez.org/	South Amanda	Florida	{"Electrical engineer"}	13214	t
973643e6-e9c2-4549-8938-b401aa7a023d	andrea39@yahoo.com	JenniferBarrett	James	White	$pbkdf2-sha256$30000$2vuf0zonxPj/n/OeszYGwA$PLf8cUJDnHX9XVoPmuQ0cP99t69XP4D.6rV5sipIpgc	\N	http://www.robinson.info/	Andrewhaven	Wyoming	{}	91970	t
196e95d8-7f1d-4d46-b1e0-200ebf497199	ortizchristopher@gmail.com	MichaelReid	Erik	Sanders	$pbkdf2-sha256$30000$m9Oa0xqjtDYmxLg3JgRgrA$xzFLIJk4Ls9i5xkNBnXq6FLSWB0Jdj3SFMafYV0mrM8	\N	http://www.chan.com/	South Samanthaport	Louisiana	{Oncologist}	25280	t
42422f98-c0e0-48e0-be25-ef526a626cd7	sodom@sweeney.org	AmyAshley	Oscar	Mercer	$pbkdf2-sha256$30000$TImRktI6B0CotXZOKeU8hw$m/gsn2B5FyfAXj7EVHXqQL9Nh9BfzcOrMs/cQtI7t88	\N	https://edwards.com/	West Monicaton	Maryland	{"Regulatory affairs officer","Surveyor, minerals"}	59632	t
6f941896-4c5f-4177-9cb0-9b60230e48f0	jessicariley@hotmail.com	WendySolomon	Ruth	Charles	$pbkdf2-sha256$30000$xVirFQKgdI7xXmtNidF6zw$GY8dTQOAu0H5L97pTKMKRPi/fmPqAfoSCSRf8CxIB6I	\N	http://ballard.com/	North Jessicaburgh	Connecticut	{"Medical laboratory scientific officer"}	13599	t
b9833011-6258-49bc-a265-4d2796ee9d45	jayjones@williamsclark.biz	JosephAllen	Sarah	Mason	$pbkdf2-sha256$30000$hBBibM15rzUmBIDwXovxfg$rOFMmWmhcg4.wCP39dyQvFzvoT71Te6/.GDhUYpCt7E	\N	http://www.bell.com/	North Michelle	Nevada	{}	52618	t
02e8cf76-8320-4f46-89aa-321868b19fd7	jonestodd@hotmail.com	KatherineGonzalez	Bethany	Chambers	$pbkdf2-sha256$30000$qdVaK4WQEsKY834vJWRs7Q$OZuTGglZXafxt7B37jHW9L7i1pIIEtHJ/rTXoaeRUXA	\N	https://www.newton.net/	Chapmanside	Massachusetts	{"Surveyor, planning and development"}	51234	t
d669e2b9-0257-45cd-8b35-31df44e2a0d7	grodriguez@yahoo.com	CherylIrwin	Heidi	Howard	$pbkdf2-sha256$30000$YcwZwxjjPAdgjHHunXPOeQ$bIYF.w00dB2SFU5cFj82rVQFCLdn1CbYYE7O4X6ytxc	\N	http://www.moore-mclean.org/	Peterborough	Florida	{}	40444	t
03897dea-ebcb-45a1-be9d-689be9947e1e	kwinters@thompson.com	KyleHardy	Gary	Wilson	$pbkdf2-sha256$30000$cE6ptfaekxLinNOak/L./w$5Mj9nMC1NSRy63Whzrzy3QFrkq9yXkYrcTMSQszqo7U	\N	http://www.hogan-smith.com/	Oconnellbury	Vermont	{"Systems analyst"}	17824	t
d20eb415-c5a8-4044-b969-6a90aca26c38	zburnett@fieldswerner.com	DanielTurner	Sara	Taylor	$pbkdf2-sha256$30000$qrX2/v8fw7g3ZmwtZazV2g$U0FKlKFruYtng7x4aX9MXZYNlFbkHrFaFCL6VGDUuas	\N	http://robertson-jones.org/	West Jessica	Vermont	{"Engineer, broadcasting (operations)"}	71889	t
c56ca4d3-17cc-4503-87a1-d8abd815e532	qpatel@cunningham.com	SethParker	Evan	Weaver	$pbkdf2-sha256$30000$HcM4hxAiROj9fw8hZKwV4g$M4OesqSUYQIipgNXmflHY4rKBIZum6eGcTZpaj0HjjQ	\N	http://www.sanchez.biz/	Jasonbury	Missouri	{"Exhibitions officer, museum/gallery","Hydrographic surveyor"}	16023	t
92c7ebfd-6348-40ee-8984-55209d961bcf	michele78@williams.com	StevenFarrell	Marcus	Hendricks	$pbkdf2-sha256$30000$nvP.H.O8l1KK0ZoTovT.Hw$a4sDK8VcPWntd2RiigzRy9JOfinPS00M.wTvvgCDZJc	\N	http://horton-hubbard.org/	Carneyfort	West Virginia	{}	25414	t
c027deb9-82ff-46a1-b6ac-d492e6105313	langjamie@johnson.biz	BrianGeorge	Leslie	Horn	$pbkdf2-sha256$30000$GsMYY4xx7t37n1PKWUupVQ$9N2cH93K8Ygf4VMLlWqS1t00rwdULn/62aMGJkmJHf0	\N	https://www.jimenez-bullock.net/	Elizabethtown	Maryland	{"Investment banker, operational"}	25676	t
640a2a4d-b2f6-4862-8040-340f39a387cb	carlhenry@hotmail.com	StephenJohnson	Clinton	King	$pbkdf2-sha256$30000$LcWY05rTeq9VirGW0nrvnQ$XuZBVNgvC.SUt9c2/9bW1Ul8J5eB3jYE2XrpcOm45ts	\N	https://jones-barnes.com/	Port Devin	Hawaii	{"Police officer","Structural engineer"}	28137	t
d3884cde-e807-4669-bb59-ac281f469da6	bjohnson@rice.com	CherylBooker	Michelle	Donaldson	$pbkdf2-sha256$30000$mhMCgNBaq5XSmjOmdG7NmQ$//4P1zAqmDM3YkAeqT12y4LU2kOXX6S7Xhku2hHsLd0	\N	https://taylor.com/	South Bryantown	Ohio	{"Presenter, broadcasting","Advertising account executive"}	43512	t
c4c07ac7-ce1a-4b7b-bb28-358531ee0c42	natalie29@yahoo.com	ElizabethButler	Kevin	Wallace	$pbkdf2-sha256$30000$PkdIqVUqZYxxTqn1PgeAsA$c8B0iEkTeYfpM1xagyIO1e2W2PWRAmnpanInBrpAKaE	\N	http://alvarado.com/	West Zacharytown	Missouri	{"Insurance broker","Geographical information systems officer"}	55701	t
b259c292-0d7f-4daa-aaf2-756ba7996261	jeanettehudson@gmail.com	DavidAnderson	Ronald	Robertson	$pbkdf2-sha256$30000$A.Dc.x/DWGvtnbO21noPYQ$YqwD6cC/Fb88dT2y7F9yDRCvab.Zz/nSKzdYqlVksqc	\N	http://hall.com/	South Scottshire	Nevada	{}	70528	t
b72096c1-ea7f-4629-8ff8-9a173288acca	swheeler@gmail.com	JustinSutton	Craig	Baker	$pbkdf2-sha256$30000$QmitNea8t/Z.7713bi2F8A$KKsgg1pnF2duhhCzabtUPD3TNAnY/MmqhwzRnlzC2g4	\N	https://www.moreno.com/	Jonathanberg	Kentucky	{}	52558	t
4f908bea-c565-451a-8221-831e296a1298	christopherjensen@garcia.org	RichardJones	Ashley	Watts	$pbkdf2-sha256$30000$e8.5l3JOac1Zi5FS6r239g$djVHH1AE.K4NVK9K1CfaCc10fqNeP560tlpms.Xbe9Y	\N	http://clark.com/	East Shannon	New Hampshire	{}	78871	t
c72d95d3-22a1-40cf-a282-430e76e7af49	gloriamclaughlin@hotmail.com	KatherineRios	Martha	Evans	$pbkdf2-sha256$30000$BSBEKMW4l3IuhTBGSCmFUA$uLk2Ljl11xwtr8mf63a7D//OaAwCxRf5ZX3pA3taUOU	\N	https://www.robles-allen.info/	New Matthewfurt	Rhode Island	{"Engineer, agricultural","Water engineer"}	01649	t
acc64690-4dcc-46a7-98d9-6f44e08ac4ff	vparks@allen.com	KevinBarrera	Edward	Barnett	$pbkdf2-sha256$30000$UmrtHQOgNAbgvFeqdc45Rw$wO61LN9NZDuk8OnPLTdW98NKwmPn00gZNPAD3u8i9H8	\N	https://espinoza.info/	Millerland	North Dakota	{"Paediatric nurse"}	84787	t
c71e1644-9289-451a-9a77-c31a4573d71b	bashley@hotmail.com	RobertSnow	Matthew	West	$pbkdf2-sha256$30000$C2FszRkjhJByDiHEGCOEsA$wHXJCr0FoBYWUKR.HtysTxjU6xaMCfgECnY5uOwFOI0	\N	https://www.moody-salinas.com/	Thomasstad	Kentucky	{"Nurse, learning disability"}	63443	t
bf35ed60-f662-4e30-b3e1-daf501fc0e14	hperez@hotmail.com	GarrettDiaz	Kevin	Roberts	$pbkdf2-sha256$30000$1FqLMSZEyPl/zxnDWOt9rw$Tc1HIXnJcPuGdBI4SFZPES93QIQKgKhQdF6YLo93Kmk	\N	http://www.johnson-cervantes.org/	Lake Charles	Tennessee	{"Systems developer","Health promotion specialist"}	95819	t
920a0df5-8b85-4a70-9b74-848d68385ddd	iphelps@wilson.com	GlennCraig	Mandy	Mcknight	$pbkdf2-sha256$30000$tZay9h4DoBRCqFUK4bz3vg$xcrQWgDLG7TKSYAcCD2sB92Crbp5/6sBg0JCj9VNjwg	\N	https://www.smith.com/	East Megan	Arkansas	{"Research scientist (medical)","Engineer, drilling"}	05403	t
4124e2a7-7775-4118-bc25-0141bf8a48ba	usexton@hotmail.com	AudreyMartinez	William	Hale	$pbkdf2-sha256$30000$pZRSqnWu1RrjPOfcO8cY4w$JcieOZ25..38d9mc0Xjyl/WbzcoNN3Zs8Lq4WP/UVaA	\N	http://prince.info/	Hernandezland	Missouri	{"Publishing rights manager","Psychologist, forensic"}	96314	t
e00be635-0e78-4f2a-8b31-eb0bd87d1112	ymack@chavez.com	DavidGrant	Charles	Oconnor	$pbkdf2-sha256$30000$Regdg5DSGuOcs7aW0npPqQ$ynBZvm1caNuGJ3Hv9jxdCZ4WUnKK.ovdKZy1V/sHGTE	\N	http://www.garrett-velazquez.biz/	West Scott	Mississippi	{"Radio broadcast assistant",Toxicologist}	82010	t
0bcc489e-5c65-486d-b9e1-7df2d960f391	harrisrenee@hotmail.com	WilliamHill	Robert	Russell	$pbkdf2-sha256$30000$LGUMQciZE.K815ozJkSIcQ$6cBsbBov7I0vTLF5pSBsW44k.Q8NBkCCLG1Wo8on694	\N	https://www.watson-tapia.com/	Lake Bettyton	Iowa	{"Broadcast journalist","Video editor"}	47737	t
1a0c3989-1a9d-4269-b0f6-7c1fe0b8e816	kwheeler@salinasibarra.com	LaurenSmith	Denise	Cox	$pbkdf2-sha256$30000$816LkbL2fk9JyZlTijHGmA$3Zv0rN6qA4IVAtJYwapAPlyraV2vLPhbmtLfTRUevjc	\N	http://may-rose.com/	Laurafurt	Idaho	{"Stage manager","Hospital pharmacist"}	42972	t
16eccc88-4978-4a41-a83f-f870c015a431	caldwellwendy@gmail.com	JessicaMedina	Leslie	Gardner	$pbkdf2-sha256$30000$/Z9zDkGIcS7FeC.llFKq1Q$mhJQKN//xtJmnwPiI9A6rB5QUN8ly.67KHXsT9yHWp0	\N	http://gross.com/	Santoshaven	Oregon	{}	74684	t
35aa18b6-a8db-440e-b9fe-33bfcbcbf84c	btorres@gmail.com	RonaldCruz	Kelly	Davis	$pbkdf2-sha256$30000$w5izNiYEgLB2jlGK8d5bSw$.a/jPTcKRP1xQoGyZW.bLkLNJ64Yhx4HA/7liI6NWDo	\N	http://www.fisher.info/	New Clinton	Arizona	{"Designer, graphic","Designer, television/film set"}	03222	t
f0dd7348-cdff-45fa-983b-e3b9be477c74	obell@yahoo.com	AngelaClarke	Anna	Baker	$pbkdf2-sha256$30000$tzZm7N17L2UsZWzN.T/HOA$VQsMqq0Dewa1Mdc4wUyvfYadZuqyfXc4KRHZASFzomM	\N	http://www.anderson-williams.com/	Port Justinside	Florida	{}	14537	t
1875fbf7-c8cc-41f6-9a10-de435fc4960b	maria19@jensenthompson.com	JamieMcguire	Nichole	Forbes	$pbkdf2-sha256$30000$EcIYw1jLmfNeC0ForTVmDA$5LWZ2reo4cyqe2HqajCp3MvCky03zt6ZNq9GzDQY2rI	\N	https://newman.com/	Port Jason	Hawaii	{}	63402	t
53af9fbf-dbdd-4e3d-9e0e-fa096437bd42	jamiesawyer@yahoo.com	CatherineDavis	Amber	Nguyen	$pbkdf2-sha256$30000$k7JWyjmHsPZey1mLcY5xbg$hAjpYGLOZdfotsNTJNafYK5jHYVK9hFRdwPiVqcKeKg	\N	http://harper.biz/	Harrisbury	Iowa	{"Mental health nurse"}	78245	t
76b41547-f7c8-4b51-8f7a-dddc6fcda0cd	dhall@gmail.com	ShannonHawkins	Lance	Bell	$pbkdf2-sha256$30000$lVJKiRGi1NqbEyJEqJXyfg$eUijEuuNEzhF.b2xVTNcVnl5Rz0bAOchPFjHtHzDfq0	\N	https://www.lopez-escobar.com/	South Seanhaven	West Virginia	{"Merchant navy officer"}	88911	t
2e7c6dc1-961d-4a0e-a491-788e207abb91	janetnewman@yahoo.com	AshleyWalker	Sandy	Campbell	$pbkdf2-sha256$30000$gnBOqVUKQegdg3DOee8dIw$6hiDOTuGQ39FnvKkYyyAiQLkwBUhRtmF046oQdCCOzY	\N	https://hill-oconnell.biz/	North Ryanstad	Texas	{}	22097	t
0e20d817-59d1-4f69-93b9-f4b62cd44eaa	jennifer35@yahoo.com	ScottHall	Sarah	Richard	$pbkdf2-sha256$30000$13ov5Zxzbm2N0boXYgyBcA$L9fYpnmGbcjY14HgKrvnvrlERpY3oT7mKsNYrf2pjaU	\N	http://www.gray.info/	Autumnchester	Idaho	{"Town planner"}	59892	t
12f3ec63-635b-4e01-8507-ef2908a1bcf4	thutchinson@gmail.com	AnthonyMorgan	Vanessa	Franklin	$pbkdf2-sha256$30000$FCLkPEeo9Z5z7h0jhFCqFQ$IimI4trei88lsym9l4j9yhPhGlWCbF1d.Tkwzr4xKhE	\N	https://gutierrez.com/	Edwardsville	Nebraska	{"Trade mark attorney","Educational psychologist"}	81978	t
e2331292-8270-46e3-aa52-13c1ce35c736	akennedy@hotmail.com	StephenRoberts	Jessica	Mejia	$pbkdf2-sha256$30000$GENobS3lHCPE.J/z3vvfuw$JCFDAFDW3W3sFiTlKbrXF4Qkj1BUj0kwyuZVBnooGMo	\N	https://bradford.info/	South Madeline	Kansas	{"Immigration officer",Actuary}	97531	t
11bbb246-3474-4d3d-b521-04e49d802dff	masonvictoria@hotmail.com	RobertShaw	Kaitlyn	Wheeler	$pbkdf2-sha256$30000$C2FMSQkBQAhh7F3rvVfKmQ$OioYUNy3pZ7QhR9h2uqLxh0pcXKKpMGRUmlNKvsxViw	\N	http://www.nielsen.net/	Morganfurt	Arkansas	{}	40760	t
5e52c2be-ff93-40b1-91ab-5374d2d24742	stephaniehunter@gmail.com	RebeccaWallace	Christina	Davis	$pbkdf2-sha256$30000$Ssl5rxViLKVUao3x/t97bw$3L3C562zt7Vi/AU1eyNDpsbXhUXyecwGJ5PV0MJ58MU	\N	http://white.com/	Emilyton	Montana	{}	32853	t
9d6f0028-ad36-417c-8df5-0c14d565c243	laurawilliams@aguilar.net	DavidHorn	Joshua	Shannon	$pbkdf2-sha256$30000$LYUwxtibs9b6/79X6h1jTA$HSHzLjo0n8SenndUFRzU1wqoWNWFT7ksLTl1N4BuRwE	\N	http://www.mendez-peterson.com/	South Amyfort	Oklahoma	{"Manufacturing engineer"}	99083	t
8d9fc84e-8e41-47f1-9313-47e478011648	lopeztiffany@wright.com	AmandaSilva	Ryan	Riley	$pbkdf2-sha256$30000$SUkJASAk5DxnDMH4n/NeCw$UZo8r9KMPj/Qphoc3vk0ojWyIsW.zIxfgYqWR7sLWpk	\N	https://www.foster.net/	Paulland	Tennessee	{"Scientist, research (medical)","Investment analyst"}	24707	t
f5f04692-0f2b-4653-a548-5ffaf9127d60	alexandra98@hicks.com	KathleenYoung	Emily	Ward	$pbkdf2-sha256$30000$dU5pLQUgBIDQeq81RghhzA$qxS08dWND6TtHAdyqICkqIfP9p.Fmy4/Lqbbvy5FZVc	\N	https://www.marsh.net/	Barbaraborough	Montana	{"Producer, radio","Retail manager"}	48692	t
c6583a73-bf47-45df-b132-c1408cf10ec6	hoopermonica@hollandbarrera.org	MelissaCarrillo	Michael	Washington	$pbkdf2-sha256$30000$izHGuDemdC6ldO59zzmn9A$9uyxVPYv19/z2qNrl7VnmzoKgnpFMD.yppfG4ALo.M8	\N	http://www.sanchez-smith.com/	South Andrea	New Jersey	{}	06044	t
2a4294a0-e992-4b6c-904d-7176290ca98b	hallryan@yahoo.com	LauraGonzales	Shannon	Duncan	$pbkdf2-sha256$30000$19pba23NeW9NaS0lpLQWwg$jM1MD7f/TydRerLGupRiz4jOe0J6AAGi5hFvoIiyGSI	\N	http://pittman.com/	South Marciaside	Georgia	{Ergonomist,"Doctor, hospital"}	73282	t
f1e373a3-8b4f-4191-927b-371a2f7e42fd	steven35@ramirezbishop.com	TylerCurtis	Randall	Aguilar	$pbkdf2-sha256$30000$l7I2JgTg/F8rRQhhDEFojQ$wQuw.KtuKW0SFN53es2oC0HWASjfG347gX6pR4M4jjA	\N	http://hopkins-kennedy.org/	New Roger	Pennsylvania	{}	59801	t
8fb08cd3-4241-46d1-9a89-67a266b9af4e	vmarshall@yahoo.com	AmandaBlankenship	Jacob	Berry	$pbkdf2-sha256$30000$9Z7T.v///38PQSglRGht7Q$ga.LxCs5xosHkXPUr2tPl4H8CYq8Y0pxKfI0isW0F2o	\N	http://buckley-hunter.com/	Williamburgh	Connecticut	{"Contracting civil engineer"}	57474	t
9e653842-652f-4cde-aaa9-c084c740daa0	ryanskinner@roach.com	JoanLambert	Erin	Hobbs	$pbkdf2-sha256$30000$yBmjVGrtPQfAWEtp7b3Xug$HiUg/d/hLKzg0qxSb1KrGMkGmQQK9DROJFtYgjgBweM	\N	http://delacruz.com/	Justinmouth	Maryland	{"Travel agency manager"}	15377	t
4ce38df6-f70b-457d-8467-f03d5677157c	caseymonica@gmail.com	JackWebster	Leslie	Camacho	$pbkdf2-sha256$30000$AUDoPQcgpFRqbU1JKaU0pg$0.nDdevDkoBXl7INF9CdPS13HEEK0q/c1nSTPDaKsF8	\N	https://www.wilson.com/	Sandymouth	Connecticut	{"Structural engineer"}	39426	t
4b70d279-df3b-40b8-84c8-9ce670bda786	pollardlauren@hotmail.com	LisaGarcia	David	Ware	$pbkdf2-sha256$30000$Nab0fo.xlnKu1VpLqbV2Tg$SPfVVAcXHK9mDNC42VnWaS1jFPpYoyK.a/jMHO5r2PU	\N	http://www.rodriguez.com/	Port Dianaview	Alabama	{Make,"Fast food restaurant manager"}	75696	t
b37282a4-2472-4f8b-8714-c771084d8bfc	jimmy63@mcmahongrimes.net	ErikHernandez	Christopher	Watson	$pbkdf2-sha256$30000$pFSKUWqtde59TwkhpBTi/A$MZ4/ZUbvR6no8dVxXOqNQE8g.feM/O39XsqoTrBprK8	\N	http://brewer-watson.org/	Rachelview	Mississippi	{"Teacher, adult education","Engineer, technical sales"}	85619	t
eb394870-8983-4f8b-ab4a-b2dcfbad5574	davisolivia@murray.com	RobertLara	Jamie	Wilson	$pbkdf2-sha256$30000$BaAUwhjD.N87R6gVYsz5Pw$za7ZbVfaLABX5/PJ05h3lqucOlH976Is1unH1NiCUps	\N	http://dean.com/	Lake Joseph	South Carolina	{"Insurance risk surveyor","Recruitment consultant"}	23179	t
3737c1e2-8138-4870-9408-4aa3656114b2	shannon85@johnsontaylor.biz	CarlosMorris	Phillip	Maldonado	$pbkdf2-sha256$30000$51yLcQ7h3DundK6VMiZkbA$XiZ1X83oX2PBMfcLCTcpczJigdWW73jFdQIpMqJCZCw	\N	http://page.com/	Lake Ronnieville	North Carolina	{"Teacher, adult education"}	79505	t
9466f043-f6e0-4e50-91c5-7c188ed1dc7b	travisburton@gmail.com	StevenWilkerson	Madison	Good	$pbkdf2-sha256$30000$SWnt/R.jVKq1VgrhPCfk3A$qS4ge6fx57yE/6otdZ.muj43IoxAT.YO1dWpWAgkLD4	\N	http://ochoa.info/	Brownstad	Colorado	{"Engineering geologist"}	67157	t
46c7284c-b523-4960-b466-61b4e5b0f708	dawndodson@montgomeryfernandez.org	KyleRobinson	Jessica	Harrell	$pbkdf2-sha256$30000$.L/X2lvLuTfmvPf.n9OaMw$e530Ajw2TILlEB2ru/tG4TFA3qpUZSuzzjvSqwDr2JQ	\N	http://www.brown-smith.org/	West Alyssa	Alaska	{Animator,"Surveyor, insurance"}	41722	t
59a5ded3-bc6e-4357-8e88-ab55ca2c644e	xboyd@gmail.com	AmandaRichards	Christian	Pratt	$pbkdf2-sha256$30000$J6Q0RogxRojxvjeGEGLsvQ$.cmbCtPW07uEIe6uTo4bX6MbF5ar0kiahBdlrCdNu4w	\N	http://brown.com/	Sarahville	Alabama	{}	84236	t
3c476bc0-288e-4f76-9d46-8ec1206ff275	oliviabanks@yahoo.com	DanDavis	Megan	Heath	$pbkdf2-sha256$30000$G.Pc29sbg3AOASBkjNEaww$DVScT71kKCGRxXmVmz3CO1uEDLWiiTyqgaSz7.4UlUs	\N	http://www.harper.com/	New Scottfort	Kansas	{Psychotherapist,Copy}	53567	t
266f2679-2c97-4b5e-926b-7f6e6c5648b9	martindaniel@anderson.com	MichaelMurphy	Robert	Smith	$pbkdf2-sha256$30000$aS2F0JrTmhMiBOB8L2WsVQ$w2OVjAglw4BQNpaSWnerRa0eSfEuo0tS8tAllQDOONA	\N	http://pierce.biz/	Emilystad	Florida	{Cytogeneticist,"Financial manager"}	20554	t
7ca009b9-e6ee-4e87-8489-821c54294319	donald29@white.com	ThomasStevenson	Carrie	Henderson	$pbkdf2-sha256$30000$BGAMAQBAKMWYM.a8V8q5tw$l7x1yrh2FDL3vfJBjva/8OKwdr6gzwoTd7vsV6HbBa8	\N	https://www.diaz.com/	Karenfurt	Maine	{"Designer, interior/spatial"}	34716	t
ad86cbfc-ef8a-4591-8c21-9cd316bdb7ef	xschwartz@yahoo.com	NicholasNelson	Jacqueline	Jones	$pbkdf2-sha256$30000$vHeOcY4xprQWQkgp5bw3Zg$ZlppeFsw6gDwrdkdEzMxxhak.kH23lC/6OlAev/a80M	\N	https://www.morrison.biz/	North Brianberg	Minnesota	{"Engineer, biomedical"}	98856	t
82ec78dc-e710-4ab7-b88a-fb6b4b05f069	clayton42@white.biz	DustinDavis	Travis	Price	$pbkdf2-sha256$30000$793be.8dQygFQOid0/rfWw$7GsX4tz.OcNElmRfks3040gOa3dC9SnT/SL1XZSgEdM	\N	https://www.flowers.com/	Port George	Utah	{"Engineer, maintenance"}	99417	t
fabf5c0e-00d1-4db2-b0c0-df054afbb809	tknight@halljordan.biz	StevenConrad	Elizabeth	Taylor	$pbkdf2-sha256$30000$jxFirBUC4Py/9763tpbS2g$LBFWvRT3WrPtrnla2agJsArfqsvLPRLmG/Og/swSH5A	\N	http://taylor-george.com/	Louisstad	Minnesota	{"Chief Strategy Officer"}	66275	t
4bef8a93-bbf0-42a8-a03b-9d18185942e4	griffindanielle@martinez.com	JasmineAdams	Manuel	Blankenship	$pbkdf2-sha256$30000$9N6bkxLCuJcSIsSYM6YU4g$tXIadU81qbhwRZcE7cpA0LetjKAAQYhZKEH5KvYYlhY	\N	http://hardy.com/	Andreport	New Mexico	{}	66838	t
70aa2d1a-353c-4670-a9a5-bdc7ebd00892	brittany96@adams.com	CourtneyWatkins	Monica	Bright	$pbkdf2-sha256$30000$4Jxz7p0TQqh1jpHSek9pTQ$cppgt8Eou3uAR/UoxPjE7pMhp7RL9UhxZNTZPGiBwJw	\N	https://brown.com/	East Kimberg	Virginia	{}	19192	t
4935d009-36ef-490d-b792-3803c8fa6917	ynewton@yahoo.com	DawnVillanueva	Dana	Allen	$pbkdf2-sha256$30000$RSjFWKu1lpKyVsoZoxSi1A$DIJN/VCtC2v6oTC.9gjZtGZHAY.2oM.iqgxS9MGsvkw	\N	http://www.phillips.com/	Port Michaelview	Maryland	{}	78166	t
7119450c-cc26-4709-b3ba-3e64e36c41a8	terry04@gmail.com	BrittanyDaniel	Jeremy	Holt	$pbkdf2-sha256$30000$/N97j1HKuXeOUYpxjvE.hw$pPZN4i1PGYhehopdWNQojxsd22W37VTL.e6p98z3XSs	\N	https://www.nelson-brown.com/	Penningtontown	Connecticut	{"Media planner","Mining engineer"}	65341	t
85ab9695-8ddf-4f24-9537-db3f5660f0dc	glennbarrera@solis.org	MichaelBecker	Evelyn	Riggs	$pbkdf2-sha256$30000$0TqHsFaKsZbSOgeAUGptjQ$VG1A7ysOqOSm/OKR1WWD57ngn8rErUEU0x010Ou4tCA	\N	https://www.brady-yang.biz/	Silvafurt	Michigan	{"Fisheries officer","Scientist, research (life sciences)"}	67903	t
bf0eaea7-93ca-4618-ae83-580380aa78b5	jenna94@rogers.info	ChristySmith	Evan	Thomas	$pbkdf2-sha256$30000$9/7/35szRujd.9/7X2tNaQ$Y7ru59QhfTLpeBmXCfAEriq2G6VGcQX/OFB1ncjRIHg	\N	http://brown.com/	North Dustinburgh	Tennessee	{"Aeronautical engineer","Data scientist"}	55534	t
d9b5844f-7600-4a4d-a251-dc621b1b65a3	richard97@yang.com	ChristopherNichols	Catherine	Schmitt	$pbkdf2-sha256$30000$upeyFgLg3BvjvHdOCWHMGQ$3dxvONWQiTIwo9ewaZKfeZXilWRjScdzO5JGVkeVqwY	\N	http://www.woods-jensen.com/	Armstrongfurt	New Hampshire	{}	78520	t
c25f3895-e2af-4377-955d-47b30902987d	wucourtney@ramos.biz	TiffanyFrancis	Jose	Holland	$pbkdf2-sha256$30000$.r83Zuzd2zsH4PwfQ.idUw$upahd9Tpr9nLPkg/1a8bGd8aqwF5RK.w70RjwmGHT2c	\N	http://stewart-gross.com/	Valenciahaven	Nebraska	{}	96190	t
e94369b2-d7cf-40c2-93a5-87e0c68a0fe1	daviddavis@yahoo.com	AmyHebert	Amanda	Khan	$pbkdf2-sha256$30000$KiUkJCQk5Pz/v1fK.T.ntA$ryAupiyaY5P50lFvNOdOnoIJYYXCrE6E8Ujj/prKYlg	\N	https://www.hill.biz/	Parkershire	Alaska	{"Manufacturing systems engineer"}	01867	t
080909b6-c88b-4ca9-9325-01d3fb5c3056	sean79@yahoo.com	AnthonySmith	Marie	Green	$pbkdf2-sha256$30000$IcSYM.a8N6ZUytnb2xsjZA$TcUt8yFPnW30wVHm5pwxYmVpRt5AF4KpY1osalTFYRU	\N	https://warren.com/	North Frank	Colorado	{}	01967	t
62ba12e5-35eb-416d-832f-0af75152c341	kevinfinley@durhamcarlson.org	CurtisGillespie	Jackie	Harris	$pbkdf2-sha256$30000$3ztHSKmVkhJijDFmzLkXgg$XWdHqRZ6oT0sxiCNSE6imGe.JygF9vSRiFECBe91qSw	\N	https://mercado.com/	New Shannonbury	Pennsylvania	{}	70224	t
0c2281f3-b3b7-472b-aa14-ee5cae346930	barbaramurillo@brady.com	CharlesMartin	Kathy	Chapman	$pbkdf2-sha256$30000$opTS.v.fc07Jubd2TmnN.Q$ECYNNUsT0MgDR9gmzVbG6CJ0vSHHFdH66GlRwQ5XWRA	\N	http://www.brennan.biz/	Deniseville	Maine	{}	22509	t
e989f0da-465f-4c49-9d4e-3aa1d5180351	dianesmith@hotmail.com	KatherineHuerta	Justin	Johnson	$pbkdf2-sha256$30000$7733fg/B2Pv/fy.F0PqfUw$cAvcaAlJj7jb.x2qiJjDEDMvSqJz8SYOWc1U/7/qYYU	\N	http://www.diaz.com/	Lake Stevenmouth	Mississippi	{"Press sub"}	67382	t
58029db7-1233-4eee-b97d-1d9214430ddb	mark12@mendez.org	AlexisPerezDVM	Donald	Patterson	$pbkdf2-sha256$30000$h1AqJeTcOwdAiBGCEMJ4rw$a9uy5UrAC1vji/K4RbY1XOLDGfeyhbDR0ecgWPPQn/A	\N	http://morgan.info/	Garciamouth	Oklahoma	{"Research scientist (life sciences)","Industrial buyer"}	99075	t
297f3bb9-e328-417d-906f-64b63e382280	jreeves@miller.com	TylerWhite	Miranda	Burnett	$pbkdf2-sha256$30000$DQHgPKc0xnjv/X8vpTSGkA$VSRR/6PTTMbvKAHJEVoZEMQW/xCnxL9b/ll862Es.kE	\N	https://hatfield-young.com/	Walkerburgh	Ohio	{"Engineer, maintenance","Politician's assistant"}	20927	t
a0a9cca0-735d-4a0b-bf58-4c2d86d28c4f	ibest@dunnnelson.com	JosephTurner	Olivia	Collins	$pbkdf2-sha256$30000$vNe6N0aIcS5FiDFmjJGS0g$JY7H.iR1GjBXEf4ap97tCW5lwNPNGLieLLVhVad7Gdk	\N	https://www.jones.org/	Adamsbury	Utah	{}	73294	t
07409676-0c34-42e3-babe-7e17270a73ad	ubass@taylor.com	RonaldOrtega	Eric	Barker	$pbkdf2-sha256$30000$lHKOkbIW4lwrpfReC2Fs7Q$e301SWCB.hsPknuN05N4WNcbYXm1jtW2/FNvmxgKp.k	\N	https://www.sanchez.com/	Grayfort	Tennessee	{"Petroleum engineer"}	51434	t
93e306bd-f422-4637-89e7-32644758ad9d	tnoble@hotmail.com	BrendanMiller	David	Watson	$pbkdf2-sha256$30000$2/ufcw6B0Nr7nxNCqDWGEA$Pzsvat3ohIzCIaecZ7aSEk7jR0NMVyTZYzc2jjVL5bw	\N	http://parker-neal.net/	Samuelside	Georgia	{"Scientist, research (life sciences)"}	79906	t
1cfcab5f-054b-467e-9ae4-8a2daaaa9954	nicolepetersen@gmail.com	SheilaPittman	Mary	Olson	$pbkdf2-sha256$30000$bo1RSinF2Ps/x3hPqZUyJg$czVzWQouRNXX1v7Fw9XNUT8HKY7f2urLWaD1BwPLu3M	\N	https://garcia.com/	Port Elizabethville	Georgia	{"Sales professional, IT","Best boy"}	19592	t
5fe5b7a2-ab4d-4765-b3b2-b89b93b08f7e	nicholasdonovan@waltershumphrey.org	KristinSmith	Amy	Davis	$pbkdf2-sha256$30000$KsU4h3BOqVXKmfP./z/HuA$2aExHTRdKHC3Kg69K1gO1lhaiwnjAmA3YV4XDBz0F7w	\N	https://www.brown.net/	East Patriciatown	Rhode Island	{"Clinical biochemist"}	60389	t
3f76ef76-3057-4929-906f-ecd186445030	barneswilliam@hotmail.com	BrandiKing	Robert	Ellis	$pbkdf2-sha256$30000$hJCSUmotRUgJASDE2FsrpQ$Gy3hoGtoq8YngefhtmRMEECSzk/gc/iGIJhyHZ6dlu4	\N	http://king.com/	Hansenbury	Florida	{}	91023	t
e4085925-f153-4de1-b88b-469a784d34fd	carla97@wyatt.com	RobertGarcia	Kimberly	Craig	$pbkdf2-sha256$30000$bU0JoZSSUkqJEaLUWouRsg$0czIcJ7pFtZUx0g3ik6abM3QsQ7k5wXuOPC2ak4EjMI	\N	https://www.woodward.com/	Pattersontown	Maine	{}	92187	t
14f08790-0e28-430c-a68c-502fff7264e0	patriciawilson@valdez.com	TimothyMedina	Joshua	Davis	$pbkdf2-sha256$30000$DoEwhvC.VwohxHhPae3duw$JrIDIekR0jh.tKa/cOJaxCjY9iFgAUwv1aBEDrbAaLw	\N	http://www.thomas.com/	New Connieshire	Wyoming	{"Horticulturist, amenity",Photographer}	53884	t
b6ad32bc-9468-4c00-a841-e8961d1122d5	wgallagher@yahoo.com	JamesSawyer	Jennifer	Stewart	$pbkdf2-sha256$30000$WuudE6K09v4/BwBASAnBOA$3YKo1.i7Zf3h5pC7fwCrelVei8oFD0Amt.QPgYAwM1s	\N	https://www.anderson.net/	Ericastad	Delaware	{Psychotherapist}	42476	t
47181491-d2dc-4236-8ed9-debe93939919	morganjennifer@gmail.com	AngelaWilkins	Karen	Garcia	$pbkdf2-sha256$30000$3Ttn7D0HAADAWAuhVEqplQ$jQD/QBkS43dE5a.KkF/0YBEWntiALFjNEN0uS.RWvTI	\N	http://moore.org/	West Melvinfort	Maine	{"Accountant, chartered","Biochemist, clinical"}	85566	t
2fb0023a-1167-47c7-82d6-26b7a695f5c7	jonathan86@rivera.com	JaredRyan	Robert	Woods	$pbkdf2-sha256$30000$.18rBaAU4hwjpBSi9B7jPA$LqsCLv9nFdUeS1Rapttf5Ke5jatbt8.K.5gE7mXzaKQ	\N	https://www.boyd-henson.com/	Thompsonville	Ohio	{"Furniture conservator/restorer"}	25473	t
28d512ef-ecf9-4cb4-8bd2-5a92e60acdc6	zgray@gmail.com	JacquelineTorres	Michael	Heath	$pbkdf2-sha256$30000$aU1JKSXEuLfWGsNYa41xLg$1r25LkYLIL3oIQzr5u5LadWVIYpwUvlJwDsK1AdDK7w	\N	https://www.wilcox.net/	Port Lauren	New York	{"Publishing copy","Armed forces technical officer"}	11205	t
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
5987081480295	2021-04-26 23:59:28.991062	2021-04-29 23:59:28.991062	f	b95728ed-f7f9-455f-adb3-1ab6da858461	Reach authority think thing.	{}	http://lewis-anderson.com/search/about.htm	2021-05-06 23:59:28.991062	2021-05-10 23:59:28.991062	Between time think trip lay why if. Whose difficult ahead measure senior movie arrive assume. Direction actually score night old. Place laugh well economy rise send require.
5018204229726	2021-05-02 23:59:28.993232	2021-05-06 23:59:28.993232	f	779340a5-29f0-4b32-ae0a-ec09947a2475	Speech prove civil old drop read.	{}	http://www.lara-taylor.com/index/	2021-05-13 23:59:28.993232	2021-05-15 23:59:28.993232	Design campaign pay easy floor time whether. Land evening clear Democrat pay medical attention four. Start both think financial truth remember. Brother outside reduce station local close.
0701742490172	2021-04-26 23:59:28.995092	2021-05-01 23:59:28.995092	f	976af35a-7744-4efe-9763-834df4398bbb	Toward economic figure image expert.	{}	https://www.reyes-rodriguez.com/tag/tags/tags/post.php	2021-05-08 23:59:28.995092	2021-05-16 23:59:28.995092	Color listen professional risk occur scene alone. Street peace economic.
7325089218409	2021-04-29 23:59:28.997555	2021-05-03 23:59:28.997555	f	cdaba459-a619-4ffc-82cd-89abdcae3c55	Kid old international effort research.	{}	http://vang.com/app/wp-content/tag/homepage/	2021-05-09 23:59:28.997555	2021-05-10 23:59:28.997555	Paper certainly story trip. Action adult network actually deep low per adult. Page stage large happen.
3199566662597	2021-04-27 23:59:28.999605	2021-05-02 23:59:28.999605	f	32ccd92a-c1d8-4f40-9fbb-c472e6a90062	Dream development dog house behavior open.	{"{\\"url\\": \\"https://dummyimage.com/779x1000\\"}"}	http://www.morgan-alexander.net/blog/main/search/main.html	2021-05-08 23:59:28.999605	2021-05-12 23:59:28.999605	Fast sport move use. This left civil apply gun other answer. Near bad discussion pattern. Need current a well analysis seek toward.
2956729094913	2021-04-22 23:59:29.025306	2021-04-26 23:59:29.025306	f	d8fd42c4-e00b-45bf-b780-ca8f0666ae2b	Great source suggest south standard dog move.	{"{\\"url\\": \\"https://dummyimage.com/0x439\\"}"}	http://www.griffin.com/	2021-05-04 23:59:29.025306	2021-05-13 23:59:29.025306	Republican home picture important majority seven generation. Field opportunity image short majority base about. Gun pattern debate ball study.
7574743886663	2021-04-18 23:59:29.027373	2021-04-21 23:59:29.027373	f	bd6264f9-df51-4f2a-b4bb-2fcc5d4d6943	Memory girl should cover easy go have.	{"{\\"url\\": \\"https://placekitten.com/105/249\\"}"}	http://morgan-santiago.com/search/	2021-04-29 23:59:29.027373	2021-05-07 23:59:29.027373	Sound herself never quickly teacher interest. Item team opportunity them. Night medical break full difference party create.
8725946535479	2021-04-26 23:59:29.029111	2021-05-02 23:59:29.029111	f	212fd73f-746f-421a-84dd-cd4daaf9fb50	Into government subject debate conference south.	{}	http://www.smith-mcgee.com/main/list/main/search/	2021-05-08 23:59:29.029111	2021-05-15 23:59:29.029111	Series morning door front change than station finish. Ground want factor election mind begin. Many stock commercial paper.
4011128706725	2021-04-21 23:59:29.04266	2021-04-24 23:59:29.04266	f	c479f582-e27d-42bb-901e-1bf1db73f81e	Town paper although reality design around we.	{"{\\"url\\": \\"https://placeimg.com/393/408/any\\"}"}	https://www.gray.com/tag/faq.php	2021-05-02 23:59:29.04266	2021-05-06 23:59:29.04266	Like education among weight. World daughter decade thing. Cell age institution without my perhaps. Place new benefit voice pull position represent. Media leg work event respond.
8934045647673	2021-04-14 23:59:29.044289	2021-04-16 23:59:29.044289	f	843b8890-3b10-45da-94fa-2bede10698a6	Since lead nothing parent nature national dark director.	{"{\\"url\\": \\"https://placekitten.com/248/352\\"}"}	http://mills.biz/	2021-04-24 23:59:29.044289	2021-04-28 23:59:29.044289	Success imagine base popular. Describe sport door record rich subject. Require picture actually watch sort you. Design make worker call.
6294846464797	2021-04-29 23:59:29.045723	2021-05-04 23:59:29.045723	f	5918e05f-0f52-4385-816c-759f2ccd1d22	Edge leave surface which study Democrat.	{}	http://www.ruiz.com/terms.html	2021-05-10 23:59:29.045723	2021-05-14 23:59:29.045723	Their win husband focus beautiful store Mr choice. State science idea service into have little.
3546257065067	2021-04-30 23:59:29.055588	2021-05-05 23:59:29.055588	f	46d0e0d8-2fe8-439e-acdf-53f8230c9352	Guy marriage police nearly tonight.	{"{\\"url\\": \\"https://placekitten.com/613/863\\"}"}	https://harris-cunningham.net/	2021-05-12 23:59:29.055588	2021-05-13 23:59:29.055588	Choose safe natural final. Attorney interview week positive thing. Single call meet partner. Consumer blood behavior present between window idea.
6232805283553	2021-04-29 23:59:29.056823	2021-05-01 23:59:29.056823	f	4b2f938f-2b26-4db7-aa77-79a7943b1292	Drop strong somebody southern professor tonight.	{"{\\"url\\": \\"https://dummyimage.com/927x63\\"}"}	http://west-obrien.com/category/	2021-05-09 23:59:29.056823	2021-05-19 23:59:29.056823	Manage mention research chair. All would smile game. Together good order really. Special water during product create hit politics speak. Painting left fine perform father begin performance.
5465722542781	2021-04-24 23:59:29.05812	2021-04-28 23:59:29.05812	f	41b34820-a465-47f9-bacd-c10171b028df	Too myself if perhaps choose.	{}	https://www.hunter.org/faq.asp	2021-05-06 23:59:29.05812	2021-05-10 23:59:29.05812	Herself include or full despite cost mention energy. Occur not cause perhaps. Actually son nearly financial. Mention attention blue decade.
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.groups (uuid, group_name, location_description, description, zip_code, approved_public, social_media_links) FROM stdin;
cec24383-0f9e-4699-9f00-c455923d801c	Paul Scott Yang Gang	Louisiana	Remain traditional difference while. Too since up. Hotel value its college. Course policy state card before use. Will baby check economic himself.	97122	t	{"Facebook": "http://clark.org/author/"}
8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	John Sparks Yang Gang	Oklahoma	Stage car somebody add morning rest. Receive learn remain less and letter arm. Color military toward machine lawyer not man. Three year exist position. Ask around prove white score do even.	41619	t	{}
240e44d8-f092-4339-bb08-dcb2415d1b74	Brittany Williams Yang Gang	Alabama	Nation anything part. Though organization player. Thus team recently significant check way. Find meeting interview break opportunity strategy. Get majority leg.	15278	t	{"Facebook": "https://townsend-evans.com/"}
5b358456-0e04-4f81-9f05-d79d07ae2def	Edward Nixon Yang Gang	North Dakota	Such I produce fund. Go whether find usually space. Thousand second southern open us.	34652	t	{"twitter": "https://khan-ware.com/faq/", "Facebook": "https://moore-brown.com/homepage/"}
02244ce2-cc10-4075-98e8-a2ee2f776d29	Harry Yates Yang Gang	California	Question wear sometimes individual forward her bed. More middle lawyer nothing involve all. Wife garden same own science leg eye.	08919	t	{"discord": "https://www.lopez-brown.com/main/", "twitter": "https://www.silva-allison.com/wp-content/homepage.htm"}
8d7925e0-4525-430e-8b62-215e9e4ab99a	Benjamin Harris Yang Gang	Texas	Wonder crime government idea draw less wonder occur. Method sometimes better find. Improve baby food maintain training affect. Value bag herself wait direction attorney attention large. Rest cell owner away memory treatment.	15530	t	{"Facebook": "https://martin-salazar.com/home/"}
33df28fc-b53c-4c7a-9c03-d34c22132782	Michelle Johnson Yang Gang	Kentucky	Fill before past she news. Where few hit fly yard cell public all. Year treat stuff act want.	56597	t	{"Facebook": "http://johnston-freeman.com/blog/register/", "discord": "http://rivera-stevenson.com/main/search/faq.htm"}
4d9b366a-958f-4709-8463-0a15f59f92a5	Erik Mejia Yang Gang	Florida	Concern everyone probably standard relationship way task. Wall of forget night boy nation.	17596	t	{"twitter": "http://webb.biz/"}
003bdbab-8b1e-4479-b223-95f15e87cc0b	Destiny Chang Yang Gang	Mississippi	Note may old son argue factor close. Sort suddenly away green particular relationship subject. Myself all option scene. Fish price simply.	33742	t	{}
463803ff-c673-41c6-a299-dd2bee84a96c	Jackson Hall Yang Gang	Texas	Suggest well end market defense health. Purpose wear model minute during treat occur. Weight finish garden upon once big.	93326	t	{"Facebook": "http://www.merritt-graves.net/categories/posts/main/main/", "twitter": "https://www.chapman-norman.com/terms.jsp", "discord": "http://www.baker-bush.org/explore/wp-content/category/"}
7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	Sherry Hubbard Yang Gang	Wisconsin	Home prove organization. War yet magazine be. Defense lawyer black especially.	84821	t	{}
07600eee-fd64-4a09-9aef-6c79b4115553	David Anderson Yang Gang	Pennsylvania	Indicate deal these carry no compare man. Threat company leader learn room. When keep despite officer method.	20119	t	{"twitter": "https://www.thomas.com/", "Facebook": "https://www.shepherd.com/app/app/login.htm", "discord": "http://www.johnson.com/home.html"}
fc4009d8-52f0-4c55-87c9-2e2564cd8873	Michael Smith Yang Gang	Wisconsin	Task Congress then future. Development research across scene seat best sea. Already administration and.	08169	t	{"discord": "https://www.bradshaw-murray.org/"}
f04d8390-3443-4ece-89df-8be5fcc23c64	Jerry Harrison Yang Gang	Montana	Entire she beyond identify. Reflect allow yard office threat if represent threat.	11626	t	{"Facebook": "http://dyer.com/"}
25a89485-caf3-47c7-b0f3-5d93a95f507e	Jesus Smith Yang Gang	California	Suggest sister order hour. Effect itself history. Bed trade none hot. Huge sort travel environment political.	50943	t	{"twitter": "http://www.berg.com/", "discord": "https://rodriguez-garcia.com/category/posts/privacy.html"}
17b0bb37-b184-4a9a-9197-dc14f4dd5532	Peter Bauer Yang Gang	Alabama	Tell store second yet any understand nature. Employee short social evidence country entire. Around pull claim soon where. Sense score still room little community shoulder.	99122	t	{}
c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	Justin Contreras Yang Gang	Maine	Bill girl on. Per recently later mean fire thousand rock likely. Every still tend citizen continue sing poor. Move effort rather building pay throw.	31122	t	{"twitter": "https://jackson.com/register/", "Facebook": "http://rice-ramirez.biz/"}
05544486-a453-4e6b-bed7-d0f4f88c1a44	Meagan Patterson Yang Gang	California	Employee different student. Movement foreign lot.	43764	t	{"discord": "https://saunders.com/"}
e26ec83c-b3d3-4177-93b9-8f05533369ac	Mark Ryan Yang Gang	Kentucky	Them form feel possible. Sound court difference well.	83958	t	{"twitter": "http://www.harris.com/author.html", "Facebook": "https://ross.com/faq.html"}
70f5f8ce-bb82-46af-a710-06ec2bc5fe27	Victoria Carroll Yang Gang	South Dakota	Kind hold film machine democratic. Sea major daughter. Consumer expect loss field former. Want speak ability stand. Quality fund should director.	95658	t	{"Facebook": "https://whitaker.org/author.jsp"}
88c04fa6-ba26-49f7-a5d5-c043466bdc14	Dawn Martin Yang Gang	New York	Serious rest war. Possible tonight major environment fight modern author down. Authority return bed care. Experience should call near.	29564	t	{"twitter": "https://garcia-dawson.com/main.html", "discord": "http://www.garcia-myers.com/explore/tags/about.asp"}
d9455044-1e7c-4fe0-9b06-82fec5a62a30	James Miller Yang Gang	Tennessee	Itself half growth. Middle gas within night. Card professional true view develop lead. Toward quickly organization focus rock whole analysis. Traditional also animal job one foot left.	54408	t	{}
80dc70a3-7903-4f38-9fa7-35f40be5d61b	Benjamin Ramirez Yang Gang	Alabama	Environment really black media else. End whether cost seem everybody blue center.	54175	t	{"twitter": "http://www.cooper.info/post/", "Facebook": "https://www.taylor.net/"}
5d547dcd-ac29-4687-a680-2b15f50452c4	Randy Walton Yang Gang	Texas	Month argue whom yard. Once account collection crime discover clearly.	72454	t	{}
35ababae-cf85-42e4-8972-04d6b491d6d8	Katelyn Morrison Yang Gang	Nebraska	Break often no green option personal measure treatment. Rate focus play time. Least walk charge ability deep.	47219	t	{"discord": "https://martinez.com/index.php", "twitter": "http://www.bradley-johnson.com/explore/list/privacy.htm"}
171fcb9a-60b2-456b-a435-8a40898230f4	Raymond Baker Yang Gang	Pennsylvania	Edge thing current describe state information follow. Blue now it reduce particular themselves hot. But grow number draw dog. Stock street pay kind financial total. Arrive lose understand determine prepare his great.	20598	t	{"discord": "http://castillo-mendoza.com/main/", "twitter": "http://www.villarreal-lee.com/explore/main/"}
5ed4ba49-1105-4591-be25-9f88927c9c8e	Laura Curry Yang Gang	Virginia	Likely foot go media establish phone. City conference win run. Agreement fire sing less mind kind assume.	47626	t	{}
5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	Ruben Morris Yang Gang	Colorado	Thought name you within it dark present analysis. Beyond spend machine similar pass author meet brother. Sign really because hope.	70080	t	{"Facebook": "http://gutierrez.org/tag/faq/", "discord": "https://www.chapman.net/register/"}
a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	Ms. Brooke Johnson MD Yang Gang	Connecticut	Physical whatever let defense. Represent well official next.	83512	t	{"twitter": "https://www.reese.com/blog/wp-content/explore/category/"}
5303a30d-a6b2-4c95-85d9-18d61dc6cfac	Kenneth Kramer Yang Gang	Arkansas	Line treat wind. Administration ability TV wide baby kitchen.	43545	t	{"Facebook": "http://harrington.biz/search/"}
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
4362991075563	2021-04-19 23:59:29.031614	2021-04-24 23:59:29.031614	f	90b21451-5ed8-4912-a243-9a44e2e1f206	Robert Jones	1	http://neal.net/main.php	{"{\\"url\\": \\"https://www.lorempixel.com/900/518\\"}"}	Moment when Republican nation information argue later. Ask finally together yourself against. Station suffer recent strong wide. Office stock open.	{3258883640593,3551698141034}	{2956729094913,7574743886663,8725946535479}
8264723067203	2021-05-03 23:59:29.047835	2021-05-06 23:59:29.047835	f	54fcf438-d243-4271-acec-9b883a6d28b1	Aaron Glenn	2	http://holloway.info/index.php	{"{\\"url\\": \\"https://placekitten.com/906/598\\"}"}	Market list up vote that. Maintain along note environmental decade item. Near choice general town population. Sense south bag true identify.	{7910296728041,5275526302883}	{4011128706725,8934045647673,6294846464797}
8722568088482	2021-04-23 23:59:29.059136	2021-04-27 23:59:29.059136	f	bfbfb886-2794-4a7e-a568-3f15a5291104	Mark Jordan	3	http://www.parker.com/list/app/main/homepage/	{}	Its court family condition me. Good provide require ball study. Happy road benefit partner future present read.	{5920164477546,4380083170088}	{3546257065067,6232805283553,5465722542781}
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
692931de-4033-47a4-bf19-deb095e48393	b145966f-60a2-4731-b792-8c4523b40dd6	cec24383-0f9e-4699-9f00-c455923d801c	ADMIN
eb2ce749-1c2f-4175-8551-d24ea75db3f5	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	ADMIN
97ee3edd-6c46-4ee6-bb0e-073f639b2b82	f37bad48-b0ac-4eb1-805d-20e8b9509540	240e44d8-f092-4339-bb08-dcb2415d1b74	ADMIN
7d422d83-848a-47a9-9cf1-c6f75a743866	7934594c-0a40-4cec-929b-03e08026153e	5b358456-0e04-4f81-9f05-d79d07ae2def	ADMIN
2204cbc8-402e-4127-9126-7aad4644b4aa	6d637444-ef0b-4e3c-afff-34d68ddfefe5	02244ce2-cc10-4075-98e8-a2ee2f776d29	ADMIN
7f506811-2ebe-45fb-8a99-10215622545b	fd4bc8bd-a863-4d6a-a66f-ea2d7f32b34a	8d7925e0-4525-430e-8b62-215e9e4ab99a	ADMIN
15feb30d-cf4a-4cd9-85ba-ce2a8c1968a9	c32cf118-1d86-417c-ae38-ec444b411601	33df28fc-b53c-4c7a-9c03-d34c22132782	ADMIN
ce88115f-ff6a-479e-bf86-255bf017b79f	84259efc-9a47-4389-9a86-8fd6e9f44121	4d9b366a-958f-4709-8463-0a15f59f92a5	ADMIN
3867dceb-6228-44fd-8eb2-bb82bf70cac3	4708090e-e935-49bb-9643-1eb53c8207af	003bdbab-8b1e-4479-b223-95f15e87cc0b	ADMIN
d5155709-ac12-4cb3-981f-21119d6e0f22	43f79123-81a3-40cd-bc5d-d2de7dd19c84	463803ff-c673-41c6-a299-dd2bee84a96c	ADMIN
866d466e-69ae-4e23-bf54-a46fe5488de7	96095a53-38d3-4811-8fc9-bbb6a37db22c	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	ADMIN
8082fed4-5edd-47e3-affa-336eb027c46c	eb54bd07-97c3-4d8e-9563-d2b637732836	07600eee-fd64-4a09-9aef-6c79b4115553	ADMIN
58f724a2-d5e0-4b57-ba69-642dfbaa6090	973643e6-e9c2-4549-8938-b401aa7a023d	fc4009d8-52f0-4c55-87c9-2e2564cd8873	ADMIN
deb14292-b0f0-4c43-ac03-c11d68acd0ba	196e95d8-7f1d-4d46-b1e0-200ebf497199	f04d8390-3443-4ece-89df-8be5fcc23c64	ADMIN
82735f07-2e8a-4f20-b504-c0f187ecfccc	42422f98-c0e0-48e0-be25-ef526a626cd7	25a89485-caf3-47c7-b0f3-5d93a95f507e	ADMIN
9cdf0561-050d-4329-85c6-6b1b9a924bce	6f941896-4c5f-4177-9cb0-9b60230e48f0	17b0bb37-b184-4a9a-9197-dc14f4dd5532	ADMIN
242f0834-9a39-476b-ab8a-1c3fc4026a13	b9833011-6258-49bc-a265-4d2796ee9d45	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	ADMIN
643f98fc-5f53-4106-85b4-820000a996b1	02e8cf76-8320-4f46-89aa-321868b19fd7	05544486-a453-4e6b-bed7-d0f4f88c1a44	ADMIN
b4b902b4-a3a1-4dc2-b590-167b459060b0	d669e2b9-0257-45cd-8b35-31df44e2a0d7	e26ec83c-b3d3-4177-93b9-8f05533369ac	ADMIN
0e1e4c3d-eeb2-4be1-8b09-5a42ce330884	03897dea-ebcb-45a1-be9d-689be9947e1e	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	ADMIN
00c6a9cf-099c-4015-9e1c-46c1738eacfc	d20eb415-c5a8-4044-b969-6a90aca26c38	88c04fa6-ba26-49f7-a5d5-c043466bdc14	ADMIN
f5aba0d5-a58c-4324-8d4f-bdbddfea023f	c56ca4d3-17cc-4503-87a1-d8abd815e532	d9455044-1e7c-4fe0-9b06-82fec5a62a30	ADMIN
9ebc7f8c-8d51-45d4-8639-02b809239a37	92c7ebfd-6348-40ee-8984-55209d961bcf	80dc70a3-7903-4f38-9fa7-35f40be5d61b	ADMIN
76129866-2ba4-42f9-a053-f2a2b0e67e4f	c027deb9-82ff-46a1-b6ac-d492e6105313	5d547dcd-ac29-4687-a680-2b15f50452c4	ADMIN
3617cc4f-39c6-49d1-9f50-ddf8a1f1f5d8	640a2a4d-b2f6-4862-8040-340f39a387cb	35ababae-cf85-42e4-8972-04d6b491d6d8	ADMIN
1cf1bd49-b708-42f1-a684-d79cdf8f83e8	d3884cde-e807-4669-bb59-ac281f469da6	171fcb9a-60b2-456b-a435-8a40898230f4	ADMIN
ed924194-a84d-4c24-9f1f-ea6709327c5b	c4c07ac7-ce1a-4b7b-bb28-358531ee0c42	5ed4ba49-1105-4591-be25-9f88927c9c8e	ADMIN
9b1b7938-270d-4ec8-8bd0-c6877d438704	b259c292-0d7f-4daa-aaf2-756ba7996261	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	ADMIN
c4022432-f2b0-4d7a-a8ca-572d3c8050e0	b72096c1-ea7f-4629-8ff8-9a173288acca	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	ADMIN
aabd5d11-39fb-4310-8746-ade632b7be5c	4f908bea-c565-451a-8221-831e296a1298	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	ADMIN
58fa2f90-1a81-4bac-9793-e8a10e5ec728	b145966f-60a2-4731-b792-8c4523b40dd6	cec24383-0f9e-4699-9f00-c455923d801c	ADMIN
730c75f5-8cf7-4de2-92de-be0573073acf	b145966f-60a2-4731-b792-8c4523b40dd6	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
d9fce830-ea05-4884-b3d6-a108beeab2f0	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	ADMIN
8a97ecf5-a979-4b96-a8a8-d9ad2a131e37	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
b19c66f3-abc1-459a-a755-3aa644833325	f37bad48-b0ac-4eb1-805d-20e8b9509540	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	ADMIN
34d77a90-54bf-494c-85d8-61c039f67320	f37bad48-b0ac-4eb1-805d-20e8b9509540	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
ec5c181c-85e2-4d10-81a5-33e3d435764d	7934594c-0a40-4cec-929b-03e08026153e	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	ADMIN
e9664243-6148-48b1-81e1-99e0c89f4fa2	7934594c-0a40-4cec-929b-03e08026153e	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
f904458d-6b88-451a-9ad4-3ed3f98abc08	6d637444-ef0b-4e3c-afff-34d68ddfefe5	5ed4ba49-1105-4591-be25-9f88927c9c8e	ADMIN
f82630a9-8e1c-4c15-a965-bb244e10c81f	6d637444-ef0b-4e3c-afff-34d68ddfefe5	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
11961b08-0b74-4640-936d-d8840825ecaa	fd4bc8bd-a863-4d6a-a66f-ea2d7f32b34a	171fcb9a-60b2-456b-a435-8a40898230f4	ADMIN
7c074a1e-42ed-41dd-b353-84ab2e2d1d56	fd4bc8bd-a863-4d6a-a66f-ea2d7f32b34a	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
78d8d87b-a373-4b14-b90f-2ef6bfb4d9d8	c32cf118-1d86-417c-ae38-ec444b411601	35ababae-cf85-42e4-8972-04d6b491d6d8	ADMIN
0f7daa16-fc6a-4e0e-a214-9f6e7529c497	c32cf118-1d86-417c-ae38-ec444b411601	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
378a9000-06b0-412c-8667-2648be39de6d	84259efc-9a47-4389-9a86-8fd6e9f44121	5d547dcd-ac29-4687-a680-2b15f50452c4	ADMIN
95392add-64e4-43f3-b249-752a92fcc089	84259efc-9a47-4389-9a86-8fd6e9f44121	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
07354a07-ddd6-412c-ab19-58e22cd786ee	4708090e-e935-49bb-9643-1eb53c8207af	80dc70a3-7903-4f38-9fa7-35f40be5d61b	ADMIN
35ee16bc-0e02-45b8-93e2-5a1d8259cf68	4708090e-e935-49bb-9643-1eb53c8207af	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
287a6191-0395-45c1-bef8-18c3aaba09ce	43f79123-81a3-40cd-bc5d-d2de7dd19c84	d9455044-1e7c-4fe0-9b06-82fec5a62a30	ADMIN
74027ad2-eaaf-4180-8526-d27ab18d446c	43f79123-81a3-40cd-bc5d-d2de7dd19c84	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
4f9745ad-49cc-4ed0-9fe9-b16e85dc119f	96095a53-38d3-4811-8fc9-bbb6a37db22c	88c04fa6-ba26-49f7-a5d5-c043466bdc14	ADMIN
299d5c33-ef04-40b5-813a-5e49015ff7d5	96095a53-38d3-4811-8fc9-bbb6a37db22c	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
c36fa196-1b5f-4870-a97a-31ac0bd8353e	eb54bd07-97c3-4d8e-9563-d2b637732836	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	ADMIN
f3a108a0-1718-415f-aac0-333a65aa9e24	eb54bd07-97c3-4d8e-9563-d2b637732836	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
56434912-dd0e-4414-a50a-77707a9e3e13	973643e6-e9c2-4549-8938-b401aa7a023d	e26ec83c-b3d3-4177-93b9-8f05533369ac	ADMIN
e38656f3-7a21-4c9f-83bd-bf5407f40b1b	973643e6-e9c2-4549-8938-b401aa7a023d	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
bf122cc3-2ff7-4c84-9ecd-e8cbfc5b562e	196e95d8-7f1d-4d46-b1e0-200ebf497199	05544486-a453-4e6b-bed7-d0f4f88c1a44	ADMIN
3f0c305d-9c1f-4292-813a-ff9084a88bda	196e95d8-7f1d-4d46-b1e0-200ebf497199	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
c67cc088-bde2-406b-bb7c-8371d006bb7a	42422f98-c0e0-48e0-be25-ef526a626cd7	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	ADMIN
48d4f326-5fe2-4283-94f3-a4818325a747	42422f98-c0e0-48e0-be25-ef526a626cd7	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
fe9a9061-12ed-46e5-94dd-ed1bd4dc4810	b145966f-60a2-4731-b792-8c4523b40dd6	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
5aa19f50-b91f-4ca2-b7e3-5ba29a5534ed	b145966f-60a2-4731-b792-8c4523b40dd6	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
4e5cc38e-6b5d-42df-a629-23dec5c249e0	b145966f-60a2-4731-b792-8c4523b40dd6	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
a1c9e019-9376-4109-9eeb-9838f4c3bc4c	b145966f-60a2-4731-b792-8c4523b40dd6	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
7492e401-fb37-4ef3-a71d-9cddb9d70e72	b145966f-60a2-4731-b792-8c4523b40dd6	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
dfc37968-ae5e-4822-a86d-c16630b1304c	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
9e3190b8-a15a-45fb-9027-4697d0014560	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
50538edd-0315-44b0-a66d-216a18b96c41	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
1ab05c65-4768-41bc-aef6-100023f8fad7	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
297772e5-2c6a-40d0-8e6c-d6b8216e0efa	f1bc15d5-1f3e-4769-9c9d-1cd84c4fc355	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
5d77c069-d521-4ff2-b154-74acdca0dbd0	f37bad48-b0ac-4eb1-805d-20e8b9509540	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
50839569-9c46-4a35-bf92-b6bbbd1a0920	f37bad48-b0ac-4eb1-805d-20e8b9509540	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
36523f86-23a7-4f03-aa90-646f3f0c9408	f37bad48-b0ac-4eb1-805d-20e8b9509540	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
0bc39f26-3660-4c45-bfb5-287f7e0b8e2d	f37bad48-b0ac-4eb1-805d-20e8b9509540	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
7b876094-c299-4a11-8d5c-934b0a44b046	7934594c-0a40-4cec-929b-03e08026153e	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
ac851f2c-d509-43c5-ac6b-0aab63fab20a	7934594c-0a40-4cec-929b-03e08026153e	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
45ddd650-9978-49e7-b6aa-d6e42ed6dbca	6d637444-ef0b-4e3c-afff-34d68ddfefe5	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
fbacb3c2-6c60-4627-8d46-80b0e7a3b72d	6d637444-ef0b-4e3c-afff-34d68ddfefe5	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
223c19ca-9321-49c7-8b68-ce4d67817e07	fd4bc8bd-a863-4d6a-a66f-ea2d7f32b34a	f04d8390-3443-4ece-89df-8be5fcc23c64	MEMBER
7065b09b-b514-4b3c-8bbe-b833a7a618bb	fd4bc8bd-a863-4d6a-a66f-ea2d7f32b34a	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
75b7a0ea-06df-43e9-8281-028e2ff6b9cb	c32cf118-1d86-417c-ae38-ec444b411601	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
dc9ba19d-9469-42eb-8b35-39dcf55362dd	c32cf118-1d86-417c-ae38-ec444b411601	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
608823ba-63c1-4206-9c47-670b3e50ac4a	c32cf118-1d86-417c-ae38-ec444b411601	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
74f4b082-10f6-4794-83b9-64f911e976f3	c32cf118-1d86-417c-ae38-ec444b411601	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
48b32990-57d6-4e58-be2c-b578ba11ab42	c32cf118-1d86-417c-ae38-ec444b411601	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
63741fa7-c1d8-46a4-b07f-1527b16f60e2	84259efc-9a47-4389-9a86-8fd6e9f44121	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
a7dba714-b601-4189-ad9b-9aed25522b9b	84259efc-9a47-4389-9a86-8fd6e9f44121	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
1b1a6a9e-8725-4501-8105-e4c2eca63b54	84259efc-9a47-4389-9a86-8fd6e9f44121	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
89bacc8f-667c-4063-8635-341bc8e00bec	4708090e-e935-49bb-9643-1eb53c8207af	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
f3531240-9554-434d-8ca7-19683e8bbcff	4708090e-e935-49bb-9643-1eb53c8207af	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
c1b51094-8836-4254-ba71-628b1363c92b	4708090e-e935-49bb-9643-1eb53c8207af	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
e3f7e07a-7492-45ed-bbd2-e99dddb2c065	4708090e-e935-49bb-9643-1eb53c8207af	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
6683ea54-9548-4a64-902a-f6b0df7719be	4708090e-e935-49bb-9643-1eb53c8207af	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
7176475e-278b-4621-852a-3fdfe3da1446	43f79123-81a3-40cd-bc5d-d2de7dd19c84	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
00342a1a-232d-48c1-9928-371a039f3170	43f79123-81a3-40cd-bc5d-d2de7dd19c84	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
24fbefe2-81e2-45aa-b9eb-3e4a214fab16	43f79123-81a3-40cd-bc5d-d2de7dd19c84	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
c392238c-a0fc-4e3d-aa8a-629755ad091a	96095a53-38d3-4811-8fc9-bbb6a37db22c	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
ebbc2a2b-edc1-4040-8f2b-5624f5d7960b	96095a53-38d3-4811-8fc9-bbb6a37db22c	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
e896677d-d036-4bb2-ab57-df18f8476d14	96095a53-38d3-4811-8fc9-bbb6a37db22c	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
da4ec26c-b069-40f5-9675-5ab9f4fded38	96095a53-38d3-4811-8fc9-bbb6a37db22c	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
d8a65b34-cc46-49aa-b6a4-e30a2e1c74ac	96095a53-38d3-4811-8fc9-bbb6a37db22c	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
b03fd857-3c2c-4924-b9a4-14076c387232	eb54bd07-97c3-4d8e-9563-d2b637732836	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
055f90e4-22e7-4673-89b6-c8a1f1663296	eb54bd07-97c3-4d8e-9563-d2b637732836	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
aa6f6279-b3ba-42a5-99a5-023fb75829da	973643e6-e9c2-4549-8938-b401aa7a023d	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
1916c7a7-fb11-40cb-a2c0-b6aaaa6632f7	973643e6-e9c2-4549-8938-b401aa7a023d	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
626403ca-3caa-439b-b02e-2f0b8a43faa9	973643e6-e9c2-4549-8938-b401aa7a023d	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
221a6f5c-8d69-4e1a-a9b1-6c5b73d074c2	973643e6-e9c2-4549-8938-b401aa7a023d	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
d44247b8-d3bb-495d-a0c4-7f8e9438298a	973643e6-e9c2-4549-8938-b401aa7a023d	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
749cdfd0-2fd2-43fd-8477-c87c4a32a687	196e95d8-7f1d-4d46-b1e0-200ebf497199	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
4a0e09e8-7a14-48df-a7d7-3dc71ef71163	196e95d8-7f1d-4d46-b1e0-200ebf497199	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
d734af98-70d8-4a68-a07f-67ea50d6488a	42422f98-c0e0-48e0-be25-ef526a626cd7	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
91f660cb-708c-4d02-b37a-a826c98058ee	42422f98-c0e0-48e0-be25-ef526a626cd7	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
0c7977fb-9748-47c8-8241-864f195913c8	42422f98-c0e0-48e0-be25-ef526a626cd7	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
f7f4b21a-d01a-4662-9ad0-75b3d2bc51f1	42422f98-c0e0-48e0-be25-ef526a626cd7	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
ab4e201a-dfdf-4880-aa08-60ebc4285470	42422f98-c0e0-48e0-be25-ef526a626cd7	f04d8390-3443-4ece-89df-8be5fcc23c64	MEMBER
94e9306c-7d15-4ec4-977d-60ed2f4743ad	6f941896-4c5f-4177-9cb0-9b60230e48f0	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
18d2ca9c-dfac-46a0-9d90-3ffef2a2a508	6f941896-4c5f-4177-9cb0-9b60230e48f0	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
61928b3a-7fd2-4929-a420-457ad382269d	6f941896-4c5f-4177-9cb0-9b60230e48f0	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
8db25635-b0b7-47c6-b151-93b738ddda3c	b9833011-6258-49bc-a265-4d2796ee9d45	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
2cca2a53-ae26-4246-bdc4-ee1b79ca45cc	02e8cf76-8320-4f46-89aa-321868b19fd7	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
ca7cc888-37ea-45ae-9739-42d790dee1c9	02e8cf76-8320-4f46-89aa-321868b19fd7	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
5b4e90fa-9012-4cdc-833b-df3cc83ac899	02e8cf76-8320-4f46-89aa-321868b19fd7	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
d4f90391-234d-424d-902e-ac54bae0bd2f	02e8cf76-8320-4f46-89aa-321868b19fd7	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
0a3d234d-1658-477e-a663-48f30ebfd7ce	02e8cf76-8320-4f46-89aa-321868b19fd7	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
82662c7a-0899-456c-b103-d9188c2c6a5c	d669e2b9-0257-45cd-8b35-31df44e2a0d7	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
0f5f1ec9-cd51-423b-a884-75648c9f6690	d669e2b9-0257-45cd-8b35-31df44e2a0d7	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
cbe14166-f7c3-4ce0-be25-cc234c50185f	03897dea-ebcb-45a1-be9d-689be9947e1e	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
d3ae0bb0-435f-4da9-bae4-f9c4b4d15efd	03897dea-ebcb-45a1-be9d-689be9947e1e	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
aca51103-1aef-4796-8d01-4ed5e6a8375a	d20eb415-c5a8-4044-b969-6a90aca26c38	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
7665d38b-5d8d-4796-9040-a9d8a8911eda	d20eb415-c5a8-4044-b969-6a90aca26c38	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
63b4e6db-015c-4119-b339-7e51d337df6c	c56ca4d3-17cc-4503-87a1-d8abd815e532	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
5bb0ae4a-3ed4-4018-9648-3fb9fed61900	c56ca4d3-17cc-4503-87a1-d8abd815e532	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
aaed7d2d-5c56-4738-a08f-4dac830a3eb8	c56ca4d3-17cc-4503-87a1-d8abd815e532	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
6b39563f-05bd-488e-bfac-a3aeac649f56	c56ca4d3-17cc-4503-87a1-d8abd815e532	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
3852d366-b3e7-4911-9cef-e097f3e48b9d	c56ca4d3-17cc-4503-87a1-d8abd815e532	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
72e5a004-db48-471c-be05-496e5a28535a	92c7ebfd-6348-40ee-8984-55209d961bcf	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
c0971c30-613f-4a61-ab91-ab3c34c44865	92c7ebfd-6348-40ee-8984-55209d961bcf	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
470d66c9-fdb6-48f6-83b7-1fcd0cdf2647	92c7ebfd-6348-40ee-8984-55209d961bcf	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
a074cc21-297a-4fb4-b148-8fa841163d50	92c7ebfd-6348-40ee-8984-55209d961bcf	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
d63d5f41-2dbb-4372-a902-540085ad79f6	92c7ebfd-6348-40ee-8984-55209d961bcf	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
9afca913-209f-409e-94e9-d86aec9ccffd	c027deb9-82ff-46a1-b6ac-d492e6105313	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
77764271-68e3-4dff-ac85-d92575d1d6fa	c027deb9-82ff-46a1-b6ac-d492e6105313	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
a2ae3734-195e-4238-acc6-b34d62c28cb5	c027deb9-82ff-46a1-b6ac-d492e6105313	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
cfb4ac2a-06a9-4f32-a961-2765be461cf2	640a2a4d-b2f6-4862-8040-340f39a387cb	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
deaf20a0-8b5e-4db8-9094-8a0c894f5811	640a2a4d-b2f6-4862-8040-340f39a387cb	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
af147a4f-2670-4eaf-adb1-367f010947a5	d3884cde-e807-4669-bb59-ac281f469da6	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
9a296789-2a20-481b-bd1f-bbf0f0b38298	c4c07ac7-ce1a-4b7b-bb28-358531ee0c42	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
1842a864-0d0b-4935-be83-f4625ec0be4e	c4c07ac7-ce1a-4b7b-bb28-358531ee0c42	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
2e3206dc-911d-42f2-a503-05ea89ad2a74	b259c292-0d7f-4daa-aaf2-756ba7996261	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
e80a6797-8af3-4731-8175-9b53481f5835	b259c292-0d7f-4daa-aaf2-756ba7996261	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
2a1f5d44-4be0-4735-88fd-d25b57048785	b259c292-0d7f-4daa-aaf2-756ba7996261	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
489201a0-4733-415c-adb2-5dafc716edc0	b259c292-0d7f-4daa-aaf2-756ba7996261	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
d1a2ddc9-30cb-4304-bbf0-0fc76cb9a13c	b259c292-0d7f-4daa-aaf2-756ba7996261	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
88c5f1ad-d2e2-4861-b02c-f88b9d98a182	b72096c1-ea7f-4629-8ff8-9a173288acca	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
a4e6bd75-4e96-4072-95d8-da8cfed91121	4f908bea-c565-451a-8221-831e296a1298	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
523c065b-8600-48e8-ab4d-12140b2aa4a6	4f908bea-c565-451a-8221-831e296a1298	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
d341fbec-5eaa-4583-b703-2409880b81d6	4f908bea-c565-451a-8221-831e296a1298	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
86dd221b-d895-474b-ac91-70dc4c0f8f77	4f908bea-c565-451a-8221-831e296a1298	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
389e6f95-4562-4dd8-a304-3224ba41b340	c72d95d3-22a1-40cf-a282-430e76e7af49	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
822d9864-ee40-49a6-a792-3e9a8c085e9b	acc64690-4dcc-46a7-98d9-6f44e08ac4ff	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
3c2bb6ac-1c0a-48f5-887a-5cd5429ea391	acc64690-4dcc-46a7-98d9-6f44e08ac4ff	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
53104195-172c-4433-93f8-3ae22030fb95	c71e1644-9289-451a-9a77-c31a4573d71b	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
82c6fe56-0772-4604-bef0-5821607389c3	c71e1644-9289-451a-9a77-c31a4573d71b	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
d9f251ef-4016-4e64-8d72-9bf30671978c	c71e1644-9289-451a-9a77-c31a4573d71b	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
2a45cef5-7481-472c-8e23-28cc277271b3	c71e1644-9289-451a-9a77-c31a4573d71b	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
570db4b0-8d50-4649-8f0a-34e48ccdba72	bf35ed60-f662-4e30-b3e1-daf501fc0e14	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
07467df0-574e-45e9-a4c6-210d2cc47cbc	920a0df5-8b85-4a70-9b74-848d68385ddd	f04d8390-3443-4ece-89df-8be5fcc23c64	MEMBER
aed689e1-2b82-4104-b2a7-ece7bcdebd80	920a0df5-8b85-4a70-9b74-848d68385ddd	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
989e92ac-7d42-4db9-a104-6d38c720b416	4124e2a7-7775-4118-bc25-0141bf8a48ba	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
6e82a9ae-7d84-4b95-b6ac-d912fd30cd07	4124e2a7-7775-4118-bc25-0141bf8a48ba	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
5d5ef1a1-bded-42a2-9a6a-e252f9d9f23b	4124e2a7-7775-4118-bc25-0141bf8a48ba	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
154ed7ea-113d-4e5f-a6da-6a1b71fbf5e4	4124e2a7-7775-4118-bc25-0141bf8a48ba	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
ee38e9ef-fd19-4ddf-ba8c-960d0e8b4f9b	4124e2a7-7775-4118-bc25-0141bf8a48ba	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
af5084d6-0aa0-4acd-b423-b4d62a422b47	e00be635-0e78-4f2a-8b31-eb0bd87d1112	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
7c1e04b6-17df-4809-85ca-9bcc6aa41b67	e00be635-0e78-4f2a-8b31-eb0bd87d1112	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
74101bb8-a1d5-4aac-abbf-d1f54cc68a4e	e00be635-0e78-4f2a-8b31-eb0bd87d1112	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
e3855d43-96f3-4a47-87ac-c62975a8ba7a	e00be635-0e78-4f2a-8b31-eb0bd87d1112	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
78426766-685b-450d-9fba-ba9c72ace92d	e00be635-0e78-4f2a-8b31-eb0bd87d1112	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
a8f961f5-e1c3-456f-8b7b-1fa0bf7a0e15	0bcc489e-5c65-486d-b9e1-7df2d960f391	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
9c2dceaf-6c75-458c-bdd4-ba2f87d923ce	0bcc489e-5c65-486d-b9e1-7df2d960f391	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
0206bb21-fe84-43f9-8288-7de086e50a27	0bcc489e-5c65-486d-b9e1-7df2d960f391	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
68e6837c-62a3-432a-a3e9-7ee3a4c023dc	0bcc489e-5c65-486d-b9e1-7df2d960f391	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
56167bd6-769f-4e40-80e9-70f5d954ae61	0bcc489e-5c65-486d-b9e1-7df2d960f391	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
3b270dc3-a58e-44bd-abe1-dd2e4f7dc73d	1a0c3989-1a9d-4269-b0f6-7c1fe0b8e816	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
117859b6-846b-4ae5-848b-51e96c97c5dd	1a0c3989-1a9d-4269-b0f6-7c1fe0b8e816	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
791e3f1c-9f14-4037-92f4-d15f05ddb11b	1a0c3989-1a9d-4269-b0f6-7c1fe0b8e816	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
8fc596c8-f2a0-4c24-80f1-90a2b1d40681	1a0c3989-1a9d-4269-b0f6-7c1fe0b8e816	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
6bdc217a-00fb-44a1-92bc-56548863c3e9	16eccc88-4978-4a41-a83f-f870c015a431	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
9b273256-d6ee-40b9-8b57-881fd4a9434d	16eccc88-4978-4a41-a83f-f870c015a431	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
ae6b8d78-9293-4e3b-9f40-07e2271c3f50	35aa18b6-a8db-440e-b9fe-33bfcbcbf84c	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
541ed228-fb07-4370-8041-65be0c046d67	35aa18b6-a8db-440e-b9fe-33bfcbcbf84c	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
c7b6d31a-b6f1-4383-a346-0b1cd6fca73f	35aa18b6-a8db-440e-b9fe-33bfcbcbf84c	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
c38e0b98-4959-4573-84ca-835b6d1afdb4	35aa18b6-a8db-440e-b9fe-33bfcbcbf84c	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
f2545781-f396-40cf-99da-70a16ddb9167	35aa18b6-a8db-440e-b9fe-33bfcbcbf84c	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
696fd6a4-4f7c-4e64-b557-098c8d8ba766	f0dd7348-cdff-45fa-983b-e3b9be477c74	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
1a035011-a681-4411-994d-07d06f1e047a	f0dd7348-cdff-45fa-983b-e3b9be477c74	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
51699b8f-e23a-4041-b7e2-eda0f06a568c	1875fbf7-c8cc-41f6-9a10-de435fc4960b	f04d8390-3443-4ece-89df-8be5fcc23c64	MEMBER
559db974-8537-48f7-9277-17563fc269f8	1875fbf7-c8cc-41f6-9a10-de435fc4960b	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
523f5fb0-a794-4f2f-877d-08bf26a7f9d7	1875fbf7-c8cc-41f6-9a10-de435fc4960b	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
fd649a0c-5267-4c3d-8646-ac45d1d7db59	1875fbf7-c8cc-41f6-9a10-de435fc4960b	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
d5a122aa-18e3-44bf-b001-bb0ccbab6877	53af9fbf-dbdd-4e3d-9e0e-fa096437bd42	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
54c7b9b2-62eb-4a27-9c28-cf3d2e0960be	53af9fbf-dbdd-4e3d-9e0e-fa096437bd42	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
7e8f10ad-904b-4372-96dc-e3a00da1558a	53af9fbf-dbdd-4e3d-9e0e-fa096437bd42	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
2b24b070-1b00-4d06-8e6c-5b0185dba9b8	53af9fbf-dbdd-4e3d-9e0e-fa096437bd42	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
e2320b75-deaf-4a2d-8652-056e75780e6c	76b41547-f7c8-4b51-8f7a-dddc6fcda0cd	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
81bc18b7-c770-40c5-ab27-3fc6cb817b83	76b41547-f7c8-4b51-8f7a-dddc6fcda0cd	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
97089efd-c15b-49fb-a899-e6d4015e79e8	2e7c6dc1-961d-4a0e-a491-788e207abb91	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
e8f0e569-ff0a-4428-b390-56df68b5c7d5	2e7c6dc1-961d-4a0e-a491-788e207abb91	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
e3ae36c4-7f4f-4647-987b-bb1a8367180d	2e7c6dc1-961d-4a0e-a491-788e207abb91	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
8ac1fd43-028a-439e-85f0-761059d190b6	2e7c6dc1-961d-4a0e-a491-788e207abb91	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
187f4267-51f8-4441-914b-8021a3799ed3	2e7c6dc1-961d-4a0e-a491-788e207abb91	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
32951895-60c8-4b27-8d3e-b3e6dfbfa891	0e20d817-59d1-4f69-93b9-f4b62cd44eaa	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
2cca652d-dcd3-455f-9cf1-89ef4a7782f6	0e20d817-59d1-4f69-93b9-f4b62cd44eaa	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
fdb3cb9b-b736-4b82-ac3f-0fd3f98bdb5d	12f3ec63-635b-4e01-8507-ef2908a1bcf4	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
5d4de550-6790-4318-9717-ab2a613e9b96	12f3ec63-635b-4e01-8507-ef2908a1bcf4	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
70c3763f-7b25-4be1-87e0-9c356d7685f5	12f3ec63-635b-4e01-8507-ef2908a1bcf4	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
3fae0a4b-46fa-45fc-9c83-3ba4010e3b55	e2331292-8270-46e3-aa52-13c1ce35c736	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
6b2f14ba-dbf0-4847-81e0-ee31fca92d59	e2331292-8270-46e3-aa52-13c1ce35c736	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
cfd465ac-9595-4ad2-9d2d-130c9ad1fbc4	11bbb246-3474-4d3d-b521-04e49d802dff	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
021b33ee-77b7-4fa3-9a77-cdebb50616f8	11bbb246-3474-4d3d-b521-04e49d802dff	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
b2e805ff-ebcc-4627-ac9c-ab12f4a22868	11bbb246-3474-4d3d-b521-04e49d802dff	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
fb22090b-cbb1-4f33-b55e-5cc429d34041	5e52c2be-ff93-40b1-91ab-5374d2d24742	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
83bc8645-e40a-4629-89a8-ab5d8593c41f	5e52c2be-ff93-40b1-91ab-5374d2d24742	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
fd196341-f048-41f0-975e-99ab75da5159	5e52c2be-ff93-40b1-91ab-5374d2d24742	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
328549d8-2387-4586-89f1-175c3e035460	5e52c2be-ff93-40b1-91ab-5374d2d24742	5d547dcd-ac29-4687-a680-2b15f50452c4	MEMBER
23db9393-b839-4634-93cd-1324b3be6f4d	9d6f0028-ad36-417c-8df5-0c14d565c243	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
2b193d26-c7af-4a3b-b6cc-9797a1c618b5	9d6f0028-ad36-417c-8df5-0c14d565c243	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
aa089d21-9d4d-479a-984c-aabbf1d55b44	9d6f0028-ad36-417c-8df5-0c14d565c243	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
bceadcb6-c397-4cd6-be0b-24566705f130	8d9fc84e-8e41-47f1-9313-47e478011648	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
f4a42268-b9ac-4254-ae4d-730673ead9b1	8d9fc84e-8e41-47f1-9313-47e478011648	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
106960a8-9af5-4039-96c3-672f40fcf9ea	f5f04692-0f2b-4653-a548-5ffaf9127d60	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
eee3e149-b511-4267-b448-ecb4589212c2	f5f04692-0f2b-4653-a548-5ffaf9127d60	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
7adfb160-c958-4edb-9383-6a45fce74b77	f5f04692-0f2b-4653-a548-5ffaf9127d60	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
d882081c-b233-4fd6-84af-d6e205345c69	f5f04692-0f2b-4653-a548-5ffaf9127d60	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
23585cc0-9edd-46fb-9c2a-42a6bc715149	c6583a73-bf47-45df-b132-c1408cf10ec6	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
c5813f7b-b67c-4917-93db-01b392663cc8	c6583a73-bf47-45df-b132-c1408cf10ec6	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
aca4b077-5028-4384-9d46-b3402ae78fec	c6583a73-bf47-45df-b132-c1408cf10ec6	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
7e67e060-c79f-46b5-81e1-4bb8e58b7176	c6583a73-bf47-45df-b132-c1408cf10ec6	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
7d9af13d-b7e6-4321-a078-f7a702df11f8	2a4294a0-e992-4b6c-904d-7176290ca98b	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
88d6f421-016a-42ee-a1dd-cc6c14efaf89	f1e373a3-8b4f-4191-927b-371a2f7e42fd	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
68f659ed-df88-4544-8309-c24d4190957e	8fb08cd3-4241-46d1-9a89-67a266b9af4e	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
a0e646f7-a88c-46b6-851c-08fc3438c40c	9e653842-652f-4cde-aaa9-c084c740daa0	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
01d5b224-06a3-4fa1-a1d8-0bafa4d75685	9e653842-652f-4cde-aaa9-c084c740daa0	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
9f89c6bd-2837-4cc8-8c04-5052cd249b0b	9e653842-652f-4cde-aaa9-c084c740daa0	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
870640a2-e7e6-469a-b617-355dee3a432a	4ce38df6-f70b-457d-8467-f03d5677157c	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
e2fd5a30-941e-4561-9c0e-70fb8d559607	4b70d279-df3b-40b8-84c8-9ce670bda786	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
b0a1390b-2b3e-4bbc-afa7-d6d7e773222c	b37282a4-2472-4f8b-8714-c771084d8bfc	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
71acd0a3-531d-419b-888b-5d9857757f4f	b37282a4-2472-4f8b-8714-c771084d8bfc	33df28fc-b53c-4c7a-9c03-d34c22132782	MEMBER
e81f7076-c196-4c01-a544-303f0fdd66b5	b37282a4-2472-4f8b-8714-c771084d8bfc	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
ababb0a8-28d1-467b-8bb7-c1e0ec7980a1	eb394870-8983-4f8b-ab4a-b2dcfbad5574	f04d8390-3443-4ece-89df-8be5fcc23c64	MEMBER
5d8820cf-0adb-4b9d-be18-d23465f46fd6	eb394870-8983-4f8b-ab4a-b2dcfbad5574	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
322ae82a-9ab5-47f7-be4d-39442cbc485f	eb394870-8983-4f8b-ab4a-b2dcfbad5574	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
06583dd3-e14e-4e48-aa8d-a98a8b815122	eb394870-8983-4f8b-ab4a-b2dcfbad5574	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
8edb7ed1-b03f-4837-9981-c461f14bdec4	3737c1e2-8138-4870-9408-4aa3656114b2	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
133999ad-7b5b-4559-9896-c1a49104b85e	3737c1e2-8138-4870-9408-4aa3656114b2	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
2b1b1eff-0dfe-42b6-8e21-68ddf8b83bc0	3737c1e2-8138-4870-9408-4aa3656114b2	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
648f2d01-7f28-4c3e-bc6c-f3a4163eb6de	3737c1e2-8138-4870-9408-4aa3656114b2	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
e796cd99-e51c-4454-92a0-97c3c46c85ea	3737c1e2-8138-4870-9408-4aa3656114b2	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
8edf94e1-4138-4fd6-aa62-0052204b1d99	9466f043-f6e0-4e50-91c5-7c188ed1dc7b	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
bad6bc2d-3f14-418b-80bf-87d9d02e0fcb	46c7284c-b523-4960-b466-61b4e5b0f708	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
70be8ffe-cf4d-422d-a1f0-56e9a212e804	46c7284c-b523-4960-b466-61b4e5b0f708	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
e9c94bfb-bed8-47a6-9576-818ac431c1ae	46c7284c-b523-4960-b466-61b4e5b0f708	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
1c51d8bf-ad0b-4bf2-850d-a76f945d86bb	59a5ded3-bc6e-4357-8e88-ab55ca2c644e	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
7d70e91f-d660-42fa-a4bf-54f9f2a000ec	59a5ded3-bc6e-4357-8e88-ab55ca2c644e	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
bdfb0744-79f1-4130-a0bf-4e744d377cc5	59a5ded3-bc6e-4357-8e88-ab55ca2c644e	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
0f154b1c-6e2b-422e-bb6b-bb9ff6380c2f	59a5ded3-bc6e-4357-8e88-ab55ca2c644e	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
2890c29e-10fd-4ac6-a5ac-87b31bebc7e9	59a5ded3-bc6e-4357-8e88-ab55ca2c644e	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
461153de-88c0-479e-8f98-fa09ff92488c	3c476bc0-288e-4f76-9d46-8ec1206ff275	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
557445ea-11f0-4fa9-8033-5304a8f403e4	3c476bc0-288e-4f76-9d46-8ec1206ff275	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
aa66a299-072a-44e3-b890-4f29fe6f20b3	3c476bc0-288e-4f76-9d46-8ec1206ff275	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
c4858d39-f414-4ca3-bd1c-17d1d5a441cf	3c476bc0-288e-4f76-9d46-8ec1206ff275	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
05a87683-ad59-4fc1-a3a6-80afe003126f	266f2679-2c97-4b5e-926b-7f6e6c5648b9	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
14b70655-3931-4b6c-9ee0-0553a87148e7	266f2679-2c97-4b5e-926b-7f6e6c5648b9	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
800a2658-305c-4b71-b50e-d3aa7eb80cf8	7ca009b9-e6ee-4e87-8489-821c54294319	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
a89987df-6727-41f5-888d-e3e4235a4dd9	7ca009b9-e6ee-4e87-8489-821c54294319	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
0e3322dc-de91-4d46-b4b6-8b6ee2f30a4a	7ca009b9-e6ee-4e87-8489-821c54294319	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
8348297e-1b2a-4595-a75c-454ec711698c	7ca009b9-e6ee-4e87-8489-821c54294319	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
92191531-294e-4169-9a3d-778156e32c95	7ca009b9-e6ee-4e87-8489-821c54294319	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
00ec5da4-4a99-4db1-b000-283da50d99fe	ad86cbfc-ef8a-4591-8c21-9cd316bdb7ef	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
d3229bb4-3362-4c78-832e-5c11c11c7abf	ad86cbfc-ef8a-4591-8c21-9cd316bdb7ef	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
58e3dd54-5b18-47a1-a534-8d35c8cdc786	ad86cbfc-ef8a-4591-8c21-9cd316bdb7ef	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
c18d8a5d-dfae-4a14-b3c7-66355e1f0f61	ad86cbfc-ef8a-4591-8c21-9cd316bdb7ef	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
04b882b8-5021-4ec6-9a62-f8bddc50dbd8	82ec78dc-e710-4ab7-b88a-fb6b4b05f069	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
1f3892e0-8b85-489e-99d0-5b34cfcc8b40	fabf5c0e-00d1-4db2-b0c0-df054afbb809	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
acd200ee-9537-41e6-9671-7aacdc76fd9b	fabf5c0e-00d1-4db2-b0c0-df054afbb809	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
7d9cc1a5-ca3c-46d7-919f-371e1689ce29	fabf5c0e-00d1-4db2-b0c0-df054afbb809	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
e2251ef9-4245-41e0-920f-96ab3b220c38	fabf5c0e-00d1-4db2-b0c0-df054afbb809	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
35d4d42b-ddbd-48a8-ba26-05cdd8d3ac75	4bef8a93-bbf0-42a8-a03b-9d18185942e4	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
333fb1a2-fc7c-4dba-9a3e-5b36046f166c	4bef8a93-bbf0-42a8-a03b-9d18185942e4	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
4e26f340-730b-4de2-ac6e-e2f0fbedd609	4bef8a93-bbf0-42a8-a03b-9d18185942e4	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
2e87fb46-b396-49ba-a17b-bdef05b92818	70aa2d1a-353c-4670-a9a5-bdc7ebd00892	171fcb9a-60b2-456b-a435-8a40898230f4	MEMBER
e8912d6a-0fee-4ee5-abda-63202c2b98f0	70aa2d1a-353c-4670-a9a5-bdc7ebd00892	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
68ad13a1-8d7c-43ad-959d-1d8c4d52a8d6	70aa2d1a-353c-4670-a9a5-bdc7ebd00892	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
a6b37f71-da99-48d0-80bf-e88cb9c686c5	70aa2d1a-353c-4670-a9a5-bdc7ebd00892	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
d19af4bd-c016-4e4f-92ad-8befa7a1afab	4935d009-36ef-490d-b792-3803c8fa6917	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
73e27fe7-423e-4ec4-9d91-8686421ad234	4935d009-36ef-490d-b792-3803c8fa6917	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
28944262-932f-4344-909e-5728a5102beb	4935d009-36ef-490d-b792-3803c8fa6917	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
0e7922b3-283d-46ee-a03e-3b226a706878	4935d009-36ef-490d-b792-3803c8fa6917	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
48d2074d-6ac6-4aab-a0fc-ef224130ecb4	7119450c-cc26-4709-b3ba-3e64e36c41a8	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
b3c85586-0106-43b3-b55c-dad1987ce4de	7119450c-cc26-4709-b3ba-3e64e36c41a8	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
df41535e-7505-40cf-ab09-b3cb3613e179	85ab9695-8ddf-4f24-9537-db3f5660f0dc	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
227e796f-48ec-47d7-933a-3019b3fa6d20	bf0eaea7-93ca-4618-ae83-580380aa78b5	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
b77254c1-b1d2-4bb1-81a5-cbd25c384d5e	d9b5844f-7600-4a4d-a251-dc621b1b65a3	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
5de1a58c-681f-4207-a8e6-2188b5e9088a	d9b5844f-7600-4a4d-a251-dc621b1b65a3	02244ce2-cc10-4075-98e8-a2ee2f776d29	MEMBER
677d7605-e30d-461f-aab8-ae4177442e2d	d9b5844f-7600-4a4d-a251-dc621b1b65a3	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
d1b2e6aa-1511-40db-9ec4-8116579e6777	d9b5844f-7600-4a4d-a251-dc621b1b65a3	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
0bf8060a-8c09-4b1e-8890-d6bae5dbd4e1	d9b5844f-7600-4a4d-a251-dc621b1b65a3	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
5e82381b-8256-4f76-9581-7614178cc68a	c25f3895-e2af-4377-955d-47b30902987d	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
a2f9f014-757d-464d-93fa-7f08a74fffb6	c25f3895-e2af-4377-955d-47b30902987d	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
86e4c064-b8fc-4759-9709-0ab16330f966	c25f3895-e2af-4377-955d-47b30902987d	fc4009d8-52f0-4c55-87c9-2e2564cd8873	MEMBER
e770ee4d-ffca-47fc-9394-1f11639ce980	c25f3895-e2af-4377-955d-47b30902987d	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
3145dcf8-6761-4aa2-93f7-438a1943e6f5	c25f3895-e2af-4377-955d-47b30902987d	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
021b0894-a9ae-47dc-9dd0-14835675059e	e94369b2-d7cf-40c2-93a5-87e0c68a0fe1	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
e97873f6-0b07-409f-b8ea-3e35193b2dff	e94369b2-d7cf-40c2-93a5-87e0c68a0fe1	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
48d47aab-ecb3-4b1e-b915-dd386317e77f	e94369b2-d7cf-40c2-93a5-87e0c68a0fe1	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
039f57c4-fdf7-4b79-a2ed-4ca31595c0b7	e94369b2-d7cf-40c2-93a5-87e0c68a0fe1	5b358456-0e04-4f81-9f05-d79d07ae2def	MEMBER
b989437d-776c-454b-8545-3e7f18dfed8f	080909b6-c88b-4ca9-9325-01d3fb5c3056	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
b0aafe15-a1d4-4890-94a8-dd5dae8b0ca5	080909b6-c88b-4ca9-9325-01d3fb5c3056	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
65e99bbe-9317-451c-859d-1c9aaacee2e1	080909b6-c88b-4ca9-9325-01d3fb5c3056	8d7925e0-4525-430e-8b62-215e9e4ab99a	MEMBER
f857e37d-5a29-41ec-9dd5-ff47c8f55bc9	62ba12e5-35eb-416d-832f-0af75152c341	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
c32c06d3-5a89-4c25-bdc5-8a39d8c89149	62ba12e5-35eb-416d-832f-0af75152c341	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
45d395f5-d40f-46e6-81d5-44f7dd164454	62ba12e5-35eb-416d-832f-0af75152c341	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
e688bf20-1cab-4928-834a-a8fb41d26bf1	62ba12e5-35eb-416d-832f-0af75152c341	70f5f8ce-bb82-46af-a710-06ec2bc5fe27	MEMBER
47cc9230-bc3e-464b-8fcf-50ac320e0dd7	62ba12e5-35eb-416d-832f-0af75152c341	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
a5a24fd9-967a-4444-a91f-efc7ffdc2129	0c2281f3-b3b7-472b-aa14-ee5cae346930	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
415970af-2435-4824-bdff-9e17092fdc93	0c2281f3-b3b7-472b-aa14-ee5cae346930	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
e755ecb1-70a3-4ac0-ab92-0a4ab6311c0e	0c2281f3-b3b7-472b-aa14-ee5cae346930	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
e3824140-c064-4a36-8aa0-5113ea738260	0c2281f3-b3b7-472b-aa14-ee5cae346930	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
871e11d5-920e-4231-abb9-59f3400995f7	0c2281f3-b3b7-472b-aa14-ee5cae346930	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
bf305c34-d07f-4cfd-bce6-7533c0154c72	e989f0da-465f-4c49-9d4e-3aa1d5180351	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
2403ffd2-6383-45b1-9b31-28884d3b8063	e989f0da-465f-4c49-9d4e-3aa1d5180351	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
dddc0cea-ae8a-46a4-8d81-795f33dfb2e7	e989f0da-465f-4c49-9d4e-3aa1d5180351	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
63ba9deb-de2f-46f8-95eb-d515a56ec981	e989f0da-465f-4c49-9d4e-3aa1d5180351	05544486-a453-4e6b-bed7-d0f4f88c1a44	MEMBER
c6b9e349-357a-43e9-98d7-9cc9e00f9bbb	e989f0da-465f-4c49-9d4e-3aa1d5180351	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
1e32b08d-295a-46e0-bbbb-5afa2b7ee40d	58029db7-1233-4eee-b97d-1d9214430ddb	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
a7ef88d6-70bb-420c-a927-c03f2bb2e8a5	58029db7-1233-4eee-b97d-1d9214430ddb	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
0523f65a-7b87-40b8-9314-70190a5c0ebf	297f3bb9-e328-417d-906f-64b63e382280	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
ba9e1fe3-b047-4dfa-8207-a2a03673b5db	a0a9cca0-735d-4a0b-bf58-4c2d86d28c4f	8a64d2c3-67aa-4ea5-b5ab-dba253d34ae7	MEMBER
24a72995-eba7-4f8e-a56a-5cfd8aaf0686	a0a9cca0-735d-4a0b-bf58-4c2d86d28c4f	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
7ed60827-b755-48c4-bb7a-77cd29a350c1	a0a9cca0-735d-4a0b-bf58-4c2d86d28c4f	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
d891d0fe-17ee-4b8b-a2cb-82bad30bc52b	a0a9cca0-735d-4a0b-bf58-4c2d86d28c4f	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
42fdad44-ca93-4957-9b53-e80db2a546eb	07409676-0c34-42e3-babe-7e17270a73ad	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
aef9dfb5-0d9c-43f0-bc29-56e1572f1b9f	93e306bd-f422-4637-89e7-32644758ad9d	a10b1e7c-d52c-4b6b-bf3e-dd37dea560b0	MEMBER
267ad112-bb55-4990-a0a8-462d072009f8	93e306bd-f422-4637-89e7-32644758ad9d	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
abb4b1db-873b-4487-8c9d-945efc279012	1cfcab5f-054b-467e-9ae4-8a2daaaa9954	4d9b366a-958f-4709-8463-0a15f59f92a5	MEMBER
4a9be505-31b9-4177-a952-ca05717b6776	1cfcab5f-054b-467e-9ae4-8a2daaaa9954	240e44d8-f092-4339-bb08-dcb2415d1b74	MEMBER
f34acf9a-6bb1-42fa-8388-2140d86af552	5fe5b7a2-ab4d-4765-b3b2-b89b93b08f7e	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
5b389268-ad6a-4165-a1c3-d70ee3b3f1b8	5fe5b7a2-ab4d-4765-b3b2-b89b93b08f7e	07600eee-fd64-4a09-9aef-6c79b4115553	MEMBER
5c688e0f-652a-446d-b7e0-dc09844a3c0f	5fe5b7a2-ab4d-4765-b3b2-b89b93b08f7e	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
6286033d-7ac9-49a7-a63b-65bdf6cc276d	3f76ef76-3057-4929-906f-ecd186445030	003bdbab-8b1e-4479-b223-95f15e87cc0b	MEMBER
0cafd5ef-fcaa-4b9e-b4ce-a4f0f5809355	3f76ef76-3057-4929-906f-ecd186445030	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
6a56ebd3-c84d-4cce-b2e8-c6bf79c12ec6	3f76ef76-3057-4929-906f-ecd186445030	c9e9ca7c-aca3-42d8-ba94-ca118d5871ad	MEMBER
7b416df0-6dfe-4a83-a787-7eddddd566c9	3f76ef76-3057-4929-906f-ecd186445030	5ed4ba49-1105-4591-be25-9f88927c9c8e	MEMBER
d11b9c1e-c6a6-4bd3-9e16-ff5104e26a7a	3f76ef76-3057-4929-906f-ecd186445030	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
f27d8099-0f1e-4a11-a8e6-033c00e29476	e4085925-f153-4de1-b88b-469a784d34fd	35ababae-cf85-42e4-8972-04d6b491d6d8	MEMBER
e1cc7c96-9618-492a-bcff-6d68a265cc15	14f08790-0e28-430c-a68c-502fff7264e0	88c04fa6-ba26-49f7-a5d5-c043466bdc14	MEMBER
677be033-dc43-4cd9-9eae-3f2cbf24b106	b6ad32bc-9468-4c00-a841-e8961d1122d5	5c50aff7-526c-4c51-8ff5-6a6f6e7cc259	MEMBER
b13b9584-9376-45af-b07e-937f932b9100	b6ad32bc-9468-4c00-a841-e8961d1122d5	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
1d43c303-43e5-44c9-81ec-19540533ddb9	b6ad32bc-9468-4c00-a841-e8961d1122d5	e26ec83c-b3d3-4177-93b9-8f05533369ac	MEMBER
af54d01d-1469-4d75-8b13-d3d2ff8ac9e8	47181491-d2dc-4236-8ed9-debe93939919	7d4333a6-b1c1-44bb-b9fb-0896f95e3c42	MEMBER
f00e53ff-049a-44b2-8e37-0a46c652e07a	47181491-d2dc-4236-8ed9-debe93939919	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
62aea4ed-1a30-4c75-a070-ae1361a419ee	47181491-d2dc-4236-8ed9-debe93939919	463803ff-c673-41c6-a299-dd2bee84a96c	MEMBER
bfda9a13-8b79-4453-8859-4b218e46db13	2fb0023a-1167-47c7-82d6-26b7a695f5c7	80dc70a3-7903-4f38-9fa7-35f40be5d61b	MEMBER
ffb3fa1f-0502-4b35-9e92-2b2c7702a344	2fb0023a-1167-47c7-82d6-26b7a695f5c7	17b0bb37-b184-4a9a-9197-dc14f4dd5532	MEMBER
718dfb5e-77f3-440e-88d0-c78684e1c187	28d512ef-ecf9-4cb4-8bd2-5a92e60acdc6	d9455044-1e7c-4fe0-9b06-82fec5a62a30	MEMBER
c411cd27-3118-47d6-9742-af57e0aea80f	28d512ef-ecf9-4cb4-8bd2-5a92e60acdc6	25a89485-caf3-47c7-b0f3-5d93a95f507e	MEMBER
bccaa396-ce3b-4ed6-80b2-75c576fdf300	28d512ef-ecf9-4cb4-8bd2-5a92e60acdc6	cec24383-0f9e-4699-9f00-c455923d801c	MEMBER
c2259c27-1a6d-498a-bd80-3bd5ca4cb530	28d512ef-ecf9-4cb4-8bd2-5a92e60acdc6	5303a30d-a6b2-4c95-85d9-18d61dc6cfac	MEMBER
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
5756560757292	2021-04-25 23:59:28.951977	2021-04-30 23:59:28.951977	f	755ff5ec-318a-4319-85a9-4307abe13644	Other floor energy mouth state important.	{"{\\"url\\": \\"https://www.lorempixel.com/297/135\\"}"}	https://www.taylor-hawkins.net/main/about/	https://www.rios-smith.com/category/tag/search/main/	MEDIUM	{1338512859076}	{}	6	2	8	Perform even something then training result skin. Assume standard operation so class culture. Democrat analysis home than. Red TV common cause if deep hand. Quite find order idea.	Rest upon research quality suggest become. Benefit shake push young college. Home off threat.	Left animal chance receive collection present. Hair production do generation feeling above stay race.	Fish understand station any energy. Off culture age several chair.	REQUIRES_APPLICATION
1879109801394	2021-04-18 23:59:28.956396	2021-04-21 23:59:28.956396	f	6e7b6700-1348-484a-a2d2-184494c98af8	World their book one manage.	{"{\\"url\\": \\"https://www.lorempixel.com/376/847\\"}"}	https://www.white.com/main/	https://navarro-rivers.net/wp-content/category.php	MEDIUM	{0139229350457}	{0007696378581}	6	8	4	Enter put she always term. North manage throughout phone. International cause where several. Everything mean few able painting offer ability throughout.	Reveal window computer throw data into. Of bit door tonight be. Size hand Mrs resource expert.	Offer idea try race father space. Knowledge opportunity exactly but. Save night yes sense. May arrive land few build nor. Story responsibility from least skill standard.	Material real mind. College although us early power us professional music.	OPEN_TO_ALL
2194495028125	2021-04-19 23:59:28.959899	2021-04-21 23:59:28.959899	f	a1fe3742-4a6e-4b08-a618-6516e14cf529	Music themselves offer summer.	{"{\\"url\\": \\"https://www.lorempixel.com/441/949\\"}"}	https://everett.org/app/wp-content/homepage.html	https://friedman-finley.info/posts/homepage/	MEDIUM	{2722494754488}	{}	3	8	7	Today party meeting home action particular. Laugh open player. Everything themselves rate pattern order us.	Market southern yourself thing matter draw. Knowledge fire chair maintain section son key. Language eight paper tend network.	Enjoy strategy director ten. Certain check religious agreement history everybody. Why teacher not gas authority often side. Again describe role recognize of agreement option.	Evening like activity hand sea age around might. Other open any. Ten around source. Believe top foreign turn adult away dinner month. Manage camera dark.	REQUIRES_APPLICATION
2083460464375	2021-04-28 23:59:28.96471	2021-05-02 23:59:28.96471	f	db36344b-7465-4a79-9824-cce0e4e02f01	Modern rest dark include.	{"{\\"url\\": \\"https://placekitten.com/155/481\\"}"}	http://www.cook.org/main/blog/search.htm	http://www.lawrence.com/	MEDIUM	{2431040373812}	{0858999622525}	2	5	3	Wonder maybe environment size explain. Economy keep leave food.	Style none reach region what. Would until why season blood seat training. Blue I nature.	Feeling media next south support. Concern which sometimes. Others party middle remain industry none. Animal decade save manage. None partner relate team choose include room.	Buy need community let. Sometimes authority film commercial TV will. Space share administration middle Republican low. Base office young high already happy off. Community boy near way.	OPEN_TO_ALL
5728293013495	2021-04-24 23:59:28.967803	2021-04-27 23:59:28.967803	f	de696252-c9f1-4d92-9473-e8e8437c0044	Decision support scientist.	{"{\\"url\\": \\"https://placekitten.com/564/884\\"}"}	https://www.hutchinson.info/category/author.html	https://hines.biz/posts/category/post.html	MEDIUM	{5270241313312}	{}	5	9	9	Ok consumer plant. Region seven property include. Blue budget career fight phone course. Cost player white tax health begin staff.	World area party owner this better. Coach mission level discover realize learn. Away southern lay officer lead few. Over save sound TV student economic this director.	Time imagine option father throw pass. Reduce identify condition discussion move way. Hear another identify company. Pm sell fund item. Site safe fall need best politics.	Threat general huge. Single often security end answer final. Remember condition police affect safe. Day kitchen avoid dark.	REQUIRES_APPLICATION
3258883640593	2021-04-24 23:59:29.017348	2021-04-28 23:59:29.017348	f	96563b94-fee3-4868-b13b-0327a721696a	Show walk paper character.	{"{\\"url\\": \\"https://www.lorempixel.com/383/982\\"}"}	https://www.romero.com/blog/main/categories/home.php	http://smith.com/explore/posts/tags/about.php	MEDIUM	{5637873391390}	{6938444294065}	3	9	6	Lot learn speech as process base. Apply need rather apply if bad local. House study finish marriage sell. Draw charge method suddenly line.	Away listen almost dinner oil. Game seat example red. Enough because within matter himself certainly according. Stay wall capital wife southern middle door.	Time southern thus meet wife just crime. Example some off visit whatever whom. Ago large power. Event chair party never wind positive law medical.	Game set cell impact feeling. First carry class line. Notice growth experience risk.	OPEN_TO_ALL
3551698141034	2021-04-28 23:59:29.021489	2021-05-02 23:59:29.021489	f	01933ef1-d97d-4f40-b883-2f7168687e1a	Thank season politics.	{"{\\"url\\": \\"https://placeimg.com/570/210/any\\"}"}	http://wilson-thompson.com/blog/blog/main.asp	http://www.kelley-randall.net/	MEDIUM	{1262024599857}	{}	2	4	4	Age side take. Reality green pass reduce major. Will score rule single. Policy open ever set tonight each. Blue apply law.	Since education source audience. Body next every media.	Speech theory benefit church enter coach. Institution early control mission true skin billion. Sing message center pick base since mission answer.	None to challenge section agree lot some. Successful professor size her forward become. Building but design ask. Especially course position wish.	OPEN_TO_ALL
7910296728041	2021-04-16 23:59:29.033974	2021-04-21 23:59:29.033974	f	7aa9f0cb-b9a4-4667-839e-8ee83304134a	Bed staff shoulder pick their statement.	{"{\\"url\\": \\"https://dummyimage.com/888x967\\"}"}	https://www.gill.com/terms/	https://www.berg.com/blog/privacy/	MEDIUM	{2254448147423}	{8288567096168}	3	9	5	Hear exist data shoulder customer see civil. Interview too guy class action station employee. Evening computer mouth painting production able.	Food great firm pass enjoy. Treat seem always us.	Claim cell senior series get. Now market somebody yeah area health town activity. Floor chair while these. Already must benefit still arm individual.	Daughter member quite age dinner fill company. Chair appear whom. Pick receive sound increase someone able. Want commercial more bag law positive happen. Line family the house TV after commercial.	REQUIRES_APPLICATION
5275526302883	2021-04-17 23:59:29.038463	2021-04-20 23:59:29.038463	f	ce289110-91ec-4820-838c-23859888ad1e	Whom national other all bed.	{"{\\"url\\": \\"https://dummyimage.com/662x27\\"}"}	http://www.andrews-kennedy.biz/post/	https://anderson.com/about.htm	MEDIUM	{6998667844072}	{5547124658281}	3	3	6	Another father born also approach. Affect many choose indeed event character indeed. Give public even all. People unit especially student policy inside reveal.	Candidate own box line. Once white rate ahead although again phone. Organization ten street cause prepare as. Operation prove dog along become writer find. Account president often join nothing area.	May paper majority. Top area now next artist artist. National else answer marriage give movie. Radio without part crime represent international own.	Exactly improve build beat. Break member already amount. Security this somebody they serious maybe current. Around course difference third light economic ball.	REQUIRES_APPLICATION
5920164477546	2021-05-03 23:59:29.050019	2021-05-06 23:59:29.050019	f	fef9d979-00ad-4411-842c-691e593c1dd4	Light market three.	{"{\\"url\\": \\"https://www.lorempixel.com/1012/236\\"}"}	http://martin.info/terms.html	http://www.schroeder-smith.com/wp-content/wp-content/faq/	MEDIUM	{4905720658431}	{}	2	8	5	Market democratic defense across action talk. Sister so body without son federal.	Clearly PM similar clearly on. Sea training think. Culture offer less include. Man eye check structure seem work kitchen.	Couple within protect lay enjoy. Stay particular grow star.	Win as fly natural. Trial soldier analysis agency. High only until upon. Traditional in effort morning. Mention manage line safe share benefit.	REQUIRES_APPLICATION
4380083170088	2021-04-17 23:59:29.052713	2021-04-21 23:59:29.052713	f	fd76d04e-3a20-4b93-a619-68a7fc97f3f9	Want themselves appear.	{}	https://torres.com/login.html	https://www.khan-brown.com/	MEDIUM	{5901632305127}	{0640075524416}	6	4	6	Address traditional body evidence spring argue real interest. Region line hope our country. Ask brother common stock professor may always. Bill around member hundred.	Property identify program result guess join. Into skill safe. Change discussion prove. Him be past road almost course. Policy area camera imagine peace skill.	Of yourself and seat mention garden party clear. City paper main mouth number likely.	Race work national know challenge staff staff. Air agree tax property life manage. Once design history color. Sound compare listen positive. Crime determine ok really.	REQUIRES_APPLICATION
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
-- PostgreSQL database dump complete
--

