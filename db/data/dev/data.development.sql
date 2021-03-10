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
    email text NOT NULL,
    username character varying(255) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    password text,
    oauth character varying(32),
    profile_pic text,
    city character varying(32),
    state character varying(32),
    roles character varying[] NOT NULL
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
-- Name: settings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.settings (
    uuid uuid NOT NULL,
    show_name boolean NOT NULL,
    show_email boolean NOT NULL,
    show_location boolean NOT NULL,
    organizers_can_see boolean NOT NULL,
    volunteers_can_see boolean NOT NULL,
    initiative_map json NOT NULL
);


ALTER TABLE public.settings OWNER TO admin;

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
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, email, username, first_name, last_name, password, oauth, profile_pic, city, state, roles) FROM stdin;
\.


--
-- Data for Name: donation_emails; Type: TABLE DATA; Schema: public; Owner: admin
--

CREATE TABLE public.account_settings (
    uuid uuid NOT NULL PRIMARY KEY,
    show_name boolean,
    show_email boolean,
    show_location boolean,
    organizers_can_see boolean,
    volunteers_can_see boolean,
    initiative_map json
);


ALTER TABLE public.account_settings OWNER TO admin;


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
7311397155451	2021-02-22 16:57:03.136218	2021-02-27 16:57:03.136218	f	85718da0-586a-4c33-b04f-d780e22b6126	Dr. Shelby Carroll	1	https://www.thompson.com/category/	{"{\\"url\\": \\"https://placeimg.com/60/990/any\\"}"}	Effort either employee power. Note apply pretty pass fire teach hair. Car money daughter general visit. Play international evidence ability rather.	{4282339239511,3733359015414}	{6462400563082,0222136292979,5514901764879}
3486566816496	2021-03-08 16:57:03.139942	2021-03-11 16:57:03.139942	f	0a20f625-5b87-43ce-ae47-d3484d1f9b96	Kimberly Le	2	http://stark.org/main.htm	{"{\\"url\\": \\"https://dummyimage.com/362x94\\"}"}	Lawyer audience individual learn director. Medical between other.	{2552241437810,9355804305679}	{2103878553116,2004789252122,3680691425763}
7106918758095	2021-02-26 16:57:03.143815	2021-03-02 16:57:03.143815	f	a5a8554f-3a9c-4633-9f6c-0aab1ae2a325	Christopher Turner	3	http://smith.com/tag/search/login.htm	{}	Son away direction natural Republican. Some deal blue safe. Agreement attorney return argue suggest show good. Ok decade employee relate bill.	{5693662956133,9061924514395}	{2493036508837,5261731143366,0568160213758}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (notification_uuid, channel, recipient, message, scheduled_send_date, status, send_date) FROM stdin;
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.settings (uuid, show_name, show_email, show_location, organizers_can_see, volunteers_can_see, initiative_map) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
9572881518963	2021-02-28 16:57:03.109536	2021-03-05 16:57:03.109536	f	624a86a5-e7c7-461f-9d31-5a4d411e6cda	Possible learn push although movie quickly describe.	{"{\\"url\\": \\"https://www.lorempixel.com/90/872\\"}"}	https://www.johnson-jacobs.com/homepage/	http://odom.com/	MEDIUM	{4895982539534}	{}	6	2	8	Keep personal girl attention memory leg. Staff concern say able.	Even customer trial range significant guess. Nearly four newspaper go especially.	Present behavior scientist if. Really agency office arrive raise letter. Campaign why population other daughter. Coach cell national here treatment positive.	Skin write quite study total. Well just foreign often TV see something white. Laugh future question lot.	REQUIRES_APPLICATION
7807572882132	2021-02-21 16:57:03.111635	2021-02-24 16:57:03.111635	f	df502300-7cb0-4123-a31e-ad9bc5adccd8	Toward specific prove.	{"{\\"url\\": \\"https://www.lorempixel.com/721/152\\"}"}	http://www.davis-boyd.com/	https://ray-willis.com/	MEDIUM	{2167776966720}	{4423038107453}	6	8	4	These fast mother focus significant each. Only anything score college but idea after mouth. Assume report born mouth product increase gun. Policy something north tax go chair. Place almost against friend.	Human wait until. Else able dinner site lose concern. Look down born trade main think.	Because team happen happy car feel. Movie contain per into hit a. Fly maybe address visit door subject agree say.	Party television window why dinner policy technology. Test back black difficult few store animal. Soldier political yeah they media.	OPEN_TO_ALL
8370466092942	2021-02-22 16:57:03.113126	2021-02-24 16:57:03.113126	f	c482c178-4826-4d77-bf52-765e4a3b9eff	Town compare message movement memory meet realize third.	{"{\\"url\\": \\"https://dummyimage.com/858x569\\"}"}	http://mckinney.biz/login/	http://www.butler.biz/blog/search/categories/faq/	MEDIUM	{3186812891337}	{}	3	8	7	Clearly discover must arm decade class. Start goal sure concern tend fish black knowledge. Program lawyer listen both either year friend. Not deal first.	No democratic international lot today dog vote appear. Movie run simply quality among create.	Series face tax wife. Lead structure eye figure. Bill rest north former owner down despite now.	Write these mean with again candidate probably. Process candidate worker brother. Look together usually vote.	REQUIRES_APPLICATION
7959396064543	2021-03-03 16:57:03.114701	2021-03-07 16:57:03.114701	f	c123298f-6623-49cb-b52e-e4b1e4e388ca	Nation over recently not.	{"{\\"url\\": \\"https://placekitten.com/901/535\\"}"}	https://flores.com/explore/register/	https://lambert-turner.com/post.php	MEDIUM	{1371895057929}	{8595175748670}	2	5	3	Project article nor improve home watch write. Recent avoid information daughter word morning stay future. Career class along window. List cell kind offer explain without source writer.	Focus find exactly where still method. Night state picture language man across. Treat TV seven.	Senior once include also cup way feel. Play former letter stock protect. Product be society smile quality very down. Tv her hot story world recent three. Expert opportunity probably mouth however lead.	Political form itself group religious class west. Cold easy bit coach front how final. Authority along finally out father.	OPEN_TO_ALL
9626283841478	2021-02-27 16:57:03.11628	2021-03-02 16:57:03.11628	f	2a41816a-26e6-4733-ad9c-3f5b80ca3811	Face within occur later.	{"{\\"url\\": \\"https://www.lorempixel.com/321/581\\"}"}	http://hardy.biz/wp-content/blog/list/privacy/	http://www.smith.biz/terms.php	MEDIUM	{2849539493505}	{}	5	9	9	Conference even against sometimes actually after conference threat. Stop involve toward use practice able. Any surface time front business. Land western doctor with recognize.	Reason view most sister cut. Address successful control. Include no describe my many third keep at. Audience me public information machine great really.	Street four common fund agree television nice. Mother course not hundred. Three difference myself among community no thank. Positive according rich so.	Strong five significant onto later use town. Over guy job sea stock despite.	REQUIRES_APPLICATION
4282339239511	2021-02-27 16:57:03.133115	2021-03-03 16:57:03.133115	f	e7598586-3521-4f3f-ba4b-285d2305a1ee	Behind modern hundred should term rather.	{"{\\"url\\": \\"https://www.lorempixel.com/156/777\\"}"}	http://www.johnson.org/	https://mclaughlin.com/	MEDIUM	{3409970470467}	{6874620050561}	3	9	6	Someone yeah day sign. Certain quite at. Peace difference mother yard similar first. Organization wish behavior financial. Leave reflect well.	So against tell here trip. Amount discover himself country machine could single. Different hotel require citizen try conference program. Skin strong product forward friend.	Blue gun thousand ten skin. Mother which firm move season human pay. Follow while really staff spend. Hour language help cold.	Current herself never land deep. Concern spring usually sure dinner international him.	OPEN_TO_ALL
3733359015414	2021-03-03 16:57:03.134214	2021-03-07 16:57:03.134214	f	20af51da-4350-4819-8145-956f9f1bffbb	Have business sister half information vote time.	{"{\\"url\\": \\"https://www.lorempixel.com/934/63\\"}"}	https://www.king.com/register/	https://www.park-miller.com/tag/app/tags/privacy/	MEDIUM	{8104945731813}	{}	2	4	4	Leave large college face maintain particularly appear. Food book almost. Marriage quality finish bring building any shoulder. Image fire day side door whose note.	Lose he huge scientist. Enough program when significant choose ball. Wind speech local move run age. Theory yeah article politics whether. Teacher fly cell paper.	Bed green hotel still these. Hope dog continue event picture should. His yard game responsibility into. Science sell add hard. Interview box understand improve happy.	Administration defense far exist test consider what. Sure play during pull. Raise three method address them. Usually safe decide price its pattern must direction. Bed everybody analysis be figure.	OPEN_TO_ALL
2552241437810	2021-02-19 16:57:03.136762	2021-02-24 16:57:03.136762	f	1ccb9357-1c84-410f-9d9e-2d073105f2be	Movement until alone also line.	{"{\\"url\\": \\"https://www.lorempixel.com/532/793\\"}"}	http://becker-king.com/category.html	https://murphy.com/post.htm	MEDIUM	{4318361941099}	{0053258927315}	3	9	5	Themselves range language color. Cold get news political.	Describe coach for magazine today property. Weight speech act explain newspaper type. Degree exist quality radio. Black adult enjoy Mrs against seven be. Keep try traditional everything job nation nothing.	Machine accept work whose. Group cover shoulder eye quickly finish. Suddenly cause work ready likely above while. Machine mouth name truth travel wall. Prepare plan blue store message field yet onto.	Imagine last one stock economic organization dog action. Today technology popular front south. Region leader reality pretty. Make song standard consider we be. Feeling year almost thought wish.	REQUIRES_APPLICATION
9355804305679	2021-02-20 16:57:03.137722	2021-02-23 16:57:03.137722	f	0b48ce23-391a-4103-b5ae-46f90f9eac37	Maintain learn key window activity successful clear.	{"{\\"url\\": \\"https://placeimg.com/539/919/any\\"}"}	http://www.brown.info/faq.asp	http://www.ryan-diaz.com/main.php	MEDIUM	{6563036392807}	{7072401684496}	3	3	6	Improve case age who economic. Population bank center agreement. Control join rather book program environmental. Only education child easy final wonder also.	Actually country economic whose set. Pretty central media during participant generation finish. Republican whom husband guy something drive whatever.	Identify matter company relate involve. Must indeed strategy. Organization low son stage. Ready past few today knowledge new ok.	And three person share. It garden area true key agent. Important important admit million quality main food. Image wear here audience research listen finish subject.	REQUIRES_APPLICATION
5693662956133	2021-03-08 16:57:03.140653	2021-03-11 16:57:03.140653	f	97c38511-987d-401e-9d9f-6b4f8f31532a	Plan media without hundred.	{"{\\"url\\": \\"https://placeimg.com/630/914/any\\"}"}	https://fletcher.biz/faq/	https://www.mcconnell-shea.com/homepage/	MEDIUM	{5139909089757}	{}	2	8	5	Certain expert during management however. Seat thought lot least significant common. Speech those second performance visit. Song institution since.	Blue table knowledge blood enjoy star. Risk environment player available wait authority.	Meeting me high star though response. Because tough style those want life third everyone. Half everything both.	Meet series think future other kind. Wide toward start six we receive candidate would. Else less she that me eight health. Prepare herself effort above key toward eight food. Into trade yet available current room.	REQUIRES_APPLICATION
9061924514395	2021-02-20 16:57:03.141551	2021-02-24 16:57:03.141551	f	ef2805aa-cf70-451e-88f0-ad1761bf30f2	I at eight include.	{}	https://jenkins.com/categories/tag/blog/main/	http://edwards.com/home/	MEDIUM	{3056987961428}	{6151953060833}	6	4	6	Cultural increase yes think lot by effort voice. Authority economic agency.	Image hundred maybe go week stock take. Seek hundred behavior rise small by physical. Admit car town laugh.	Bed senior movement edge. Age or since travel bank hour bed. Prove single expert professor represent environmental. Open call hit me matter wind. Happy call become service mother.	Key church east phone. Street central develop every leave beautiful. Hospital break safe table program address identify peace. Light leave plan find.	REQUIRES_APPLICATION
\.


--
-- Name: accounts accounts_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_email_key UNIQUE (email);


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
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (uuid);


--
-- Name: accounts unique_acct_emails_usernames; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT unique_acct_emails_usernames UNIQUE (email, username);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- PostgreSQL database dump complete
--
