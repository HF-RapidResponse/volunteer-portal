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
9623433156222	2021-02-23 18:36:50.043764	2021-02-28 18:36:50.043764	f	9c4e13b1-7df7-477d-aee6-699330ea8662	Michael Powell	1	http://banks-murray.com/search/	{"{\\"url\\": \\"https://dummyimage.com/378x213\\"}"}	Agree large record start. Adult when perhaps election. Parent catch which. Plant onto new see rock address.	{6705215452869,9431002462588}	{6733633272356,8411923398266,3878620667043}
6813628255905	2021-03-09 18:36:50.047169	2021-03-12 18:36:50.047169	f	23dea06b-aad2-4f78-a3a4-f49a1aaa350e	Sara Jackson	2	http://www.gonzalez.org/explore/tags/category.jsp	{"{\\"url\\": \\"https://www.lorempixel.com/620/817\\"}"}	Style another drug memory within. Bag surface series raise. And tend actually wish from condition. Surface bill anyone green own give. Industry bank life surface enough reason door.	{5036524670448,0038466626809}	{5413401734736,5850848843414,0645244193905}
1081843274642	2021-02-27 18:36:50.050721	2021-03-03 18:36:50.050721	f	5eb01fb7-a827-4537-aa79-a589d6dba7d6	Julie Sandoval	3	https://fernandez-norman.org/posts/posts/login/	{}	Here keep trade lot hold institution industry. Hand their generation girl conference. Vote test race until more.	{1365752135936,3758825269108}	{0942429335090,3054712074672,8341973619366}
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
6886833816612	2021-03-01 18:36:50.011397	2021-03-06 18:36:50.011397	f	56c4f7ff-8fdf-4db2-a7b5-f790e2e31fd3	Into half including itself notice back they.	{"{\\"url\\": \\"https://www.lorempixel.com/746/199\\"}"}	https://cox-stephenson.org/main/blog/about/	https://todd-wu.net/explore/privacy/	MEDIUM	{4900695289987}	{}	6	2	8	Force four people mouth wait even. Single loss forget whatever natural. Fall election include affect. And animal expect seat recently who about. Up onto ability listen.	Set wish response then his computer owner. Soldier include while service. Sing control young owner few.	President close cause Mrs. Defense subject send movement language week. No play data most raise family. Artist maybe lose test parent girl individual.	Position peace deep east event. Piece life live take blood road. Girl feel office year perform. Have possible democratic rather me writer hit.	REQUIRES_APPLICATION
3555438667730	2021-02-22 18:36:50.013565	2021-02-25 18:36:50.013565	f	d9e33cc1-44fb-40b0-94e6-9f09d0a83b4d	Follow wear book discover expect all later.	{"{\\"url\\": \\"https://placekitten.com/127/108\\"}"}	http://www.jones.com/categories/explore/category.php	https://guerrero.net/privacy.html	MEDIUM	{4660064889407}	{5826429515292}	6	8	4	Whose itself not themselves part area. Treatment sound eight why security treatment say. Affect back owner improve exactly radio. Music PM government market way trip strong hear.	Happen together part thing study raise window. Rise college ever crime figure worry. Decide issue agreement. Data official project likely.	Rest blood trip fact detail. Light like if expect health direction very condition. Just argue condition political view environmental film.	Risk beautiful we senior question central available question. So wall support save meet. Truth yourself human matter.	OPEN_TO_ALL
8094071899733	2021-02-23 18:36:50.015277	2021-02-25 18:36:50.015277	f	0d08b26b-1795-4664-b5db-772041c98a94	Others page heavy off.	{"{\\"url\\": \\"https://dummyimage.com/7x851\\"}"}	http://www.patterson.com/faq.php	http://www.beasley-jenkins.com/post/	MEDIUM	{0542798571282}	{}	3	8	7	Difference any safe heart mind air. Heavy win discover individual upon yourself executive lay.	Score little believe argue five. History report remember rise close lawyer. Per consider activity system service.	Region home another always read term either. Animal notice contain get.	Environmental whether ready eye provide identify. Me lay second group cell bad stay. Window else surface TV hospital table back.	REQUIRES_APPLICATION
0603773517982	2021-03-04 18:36:50.016678	2021-03-08 18:36:50.016678	f	a92ce408-d224-4a96-8a80-4a4efb529468	Arm idea statement speak more these ago.	{"{\\"url\\": \\"https://placekitten.com/318/195\\"}"}	http://www.anderson.com/category/explore/category/register.php	http://www.rodriguez.com/author.asp	MEDIUM	{5174910879737}	{0921342154032}	2	5	3	Sort south dark it. Through change about. Allow situation best happen office require cut. Just art another relate action.	Fall thousand quality. Sea herself area range. But bad probably audience five.	Ground in attorney later already story. Pull miss plan blue tell. Miss by girl everybody account. For treatment management together suddenly sense. Ever save American nature design its.	Artist especially dog process if reveal crime. Information across win reveal everybody leg result. Bill seek money glass learn. Side dog television morning church network popular. Quality go responsibility here society.	OPEN_TO_ALL
9726617952969	2021-02-28 18:36:50.018365	2021-03-03 18:36:50.018365	f	9c95f9a6-7f7d-4da0-8de5-c6dafd0f9a46	Cut friend stop why.	{"{\\"url\\": \\"https://dummyimage.com/364x957\\"}"}	http://www.jones-johnson.org/login.html	http://www.ray.com/main/register.jsp	MEDIUM	{8830737477637}	{}	5	9	9	Above increase camera decade. Beautiful house everyone nothing north. Side yet treat situation.	Particularly almost own. Authority campaign manage clearly everything clear.	Like item loss guess technology whether skill. Lose newspaper civil plant tax. Page leave risk meet fear security although. Sport firm build end.	Myself reflect so relationship should. Cut amount yes turn.	REQUIRES_APPLICATION
6705215452869	2021-02-28 18:36:50.038667	2021-03-04 18:36:50.038667	f	f451a040-680f-4727-9f94-f743ac2e54dc	Approach rock never land.	{"{\\"url\\": \\"https://placeimg.com/700/42/any\\"}"}	https://hanson.biz/privacy/	http://www.morgan-wright.com/main.asp	MEDIUM	{8986805122203}	{0004343917384}	3	9	6	Improve young movement clear magazine senior son. Such follow add simply.	Phone street thus stay room young air once. Chair culture big responsibility join. Wish new accept with.	Question do discover growth natural foot evidence. Recent space use. Specific law may last audience anyone left. Interest different task husband we wall site.	Loss per health debate. Know end raise thank unit contain its space.	OPEN_TO_ALL
9431002462588	2021-03-04 18:36:50.040282	2021-03-08 18:36:50.040282	f	6eb23ae9-1664-42b6-99a8-32de822b5793	Theory be Republican cup likely staff bag attack.	{"{\\"url\\": \\"https://dummyimage.com/648x152\\"}"}	http://www.flores.net/search/main/main/home/	http://www.wilson-perez.net/index.html	MEDIUM	{3391028252340}	{}	2	4	4	Account try machine water technology. One student sport must place cultural.	Treat section apply these. Alone pressure deal evening. Place business million a. Herself air shoulder before fire former strong.	Administration ever money media manage. Role middle one stock may yourself. Receive candidate write worry security future this approach. Very five century according us firm guy.	Office edge detail decision wait trial effect. Suddenly true might tough art read democratic. Pm standard population late throughout whose.	OPEN_TO_ALL
5036524670448	2021-02-20 18:36:50.044386	2021-02-25 18:36:50.044386	f	b527cf7d-a6b5-464f-bf60-f8eff2a4cd28	Population same enter five because.	{"{\\"url\\": \\"https://www.lorempixel.com/375/217\\"}"}	http://www.martinez.com/category/	https://www.mitchell-willis.com/	MEDIUM	{1038869011126}	{7764800336785}	3	9	5	People look generation concern out power. Receive theory president answer now on. Law exactly show.	Wind edge decide sit political. Yourself artist couple line many. So across sure.	Throughout individual body wish section my direction along. Republican form guy area. Natural half go development. From health scientist ask. Raise social summer chair happy think music.	News machine summer month produce relationship. Bank himself bed. Anything two three control put participant care.	REQUIRES_APPLICATION
0038466626809	2021-02-21 18:36:50.045158	2021-02-24 18:36:50.045158	f	697adbb5-d946-441b-9550-636c680f87a2	Professional someone approach letter ever.	{"{\\"url\\": \\"https://placeimg.com/821/807/any\\"}"}	http://burton-roberts.com/main/	https://www.beard-sanchez.com/posts/home/	MEDIUM	{4437776414421}	{6668242434256}	3	3	6	Result new statement everyone sense accept guess. Production significant forward education. Form note several society point city daughter. Magazine possible before television item.	Film painting experience wife away condition. Sit course director day administration model note. Too allow suddenly truth position. Foot public them certain.	Real tax try land ask cup. Professional side fish foot Republican truth still. Fund wonder understand sense democratic attention.	Fund though least none choose same type inside. Product impact smile light. Need life law try last. Everything agent student now weight chance then.	REQUIRES_APPLICATION
1365752135936	2021-03-09 18:36:50.047863	2021-03-12 18:36:50.047863	f	c6b72fc9-42e7-4177-ab53-705de45f3f58	Mouth adult whatever character boy develop.	{"{\\"url\\": \\"https://placekitten.com/316/55\\"}"}	https://cook-harper.org/privacy/	http://carroll-moreno.net/	MEDIUM	{5267830735792}	{}	2	8	5	Threat professor middle very require finally value friend. Player suffer natural at his.	What test day live make heavy. Person onto Mr peace sometimes voice. Seat far huge answer. Cultural position course gun. Small throughout up board fight partner security.	Own term blue off budget whole. Listen amount stand almost improve direction network.	Particular turn short attorney impact. Child truth organization opportunity develop as.	REQUIRES_APPLICATION
3758825269108	2021-02-21 18:36:50.048633	2021-02-25 18:36:50.048633	f	3853b286-1601-49e5-808a-775666c760e9	Clearly wonder stuff ten assume hear.	{}	http://howell.com/	https://walsh.com/index/	MEDIUM	{2752783249913}	{4169084657503}	6	4	6	Apply call country identify agreement decade protect. Bad girl course. Medical member look none reduce amount lose.	Report radio type. Treatment interesting main. Long enter nature number perform foot newspaper. Information dream area enjoy.	Partner maybe several task say along. Maintain always clearly up control not. Organization who name allow your leg consumer. Certain believe they full teacher very support. Official training fill be country.	Reason camera white campaign. President stuff coach. Lose generation participant woman maybe.	REQUIRES_APPLICATION
\.


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
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (uuid);


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
-- PostgreSQL database dump complete
--
