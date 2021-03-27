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
-- Name: account_settings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.account_settings (
    uuid uuid NOT NULL,
    show_name boolean NOT NULL,
    show_email boolean NOT NULL,
    show_location boolean NOT NULL,
    organizers_can_see boolean NOT NULL,
    volunteers_can_see boolean NOT NULL,
    initiative_map json NOT NULL
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
    zip_code character varying(32),
    roles character varying[] NOT NULL
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

COPY public.account_settings (uuid, show_name, show_email, show_location, organizers_can_see, volunteers_can_see, initiative_map) FROM stdin;
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, email, username, first_name, last_name, password, oauth, profile_pic, city, state, roles) FROM stdin;
\.

--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
9795666069348	2021-03-02 18:44:42.954726	2021-03-05 18:44:42.954726	f	e60d7b04-a9e5-4bc3-917a-d89628947068	Rather different as paper sense.	{}	http://reed.com/	2021-03-12 18:44:42.954726	2021-03-16 18:44:42.954726	Bring agency than face reason no true garden. Somebody official after family site.
0076436257394	2021-03-08 18:44:42.95551	2021-03-12 18:44:42.95551	f	82a69456-ea11-4186-b743-0514d9786ee6	Officer job environmental only dark stop.	{}	https://www.brown.com/categories/category/homepage.jsp	2021-03-19 18:44:42.95551	2021-03-21 18:44:42.95551	Thank approach voice yeah movement before. Size affect low give.
9077627904074	2021-03-02 18:44:42.956161	2021-03-07 18:44:42.956161	f	14b1de7e-240b-4e35-ab63-8115fd8b7bfd	Example serve whose hear.	{}	https://coleman-reyes.com/	2021-03-14 18:44:42.956161	2021-03-22 18:44:42.956161	The cultural fire low thus late. Nation question occur source word guy.
5146185244459	2021-03-05 18:44:42.956674	2021-03-09 18:44:42.956674	f	01975997-01d5-4742-a6ed-c1d0178b1304	Close walk who.	{}	http://www.allen.com/login/	2021-03-15 18:44:42.956674	2021-03-16 18:44:42.956674	He food describe improve. Follow between item official. South reduce for week across start.
1862625240334	2021-03-03 18:44:42.95724	2021-03-08 18:44:42.95724	f	a45df793-553d-4527-978d-6bf5acdf12d4	Tonight herself home likely stage into.	{"{\\"url\\": \\"https://www.lorempixel.com/498/151\\"}"}	http://www.nash.com/main/	2021-03-14 18:44:42.95724	2021-03-18 18:44:42.95724	Force step public win government beautiful economy spend. Training over force science American natural travel. Maybe guy beat economy direction.
8118871313838	2021-02-26 18:44:42.965278	2021-03-02 18:44:42.965278	f	ec95361a-7c14-4458-ba2c-3201333aedef	Physical along phone child economic arm.	{"{\\"url\\": \\"https://dummyimage.com/815x923\\"}"}	https://www.crawford.org/blog/tags/privacy/	2021-03-10 18:44:42.965278	2021-03-19 18:44:42.965278	Factor society time. Side laugh a impact.
4273169487982	2021-02-22 18:44:42.965637	2021-02-25 18:44:42.965637	f	a21ea0c2-bedc-47e5-86ff-0bcb6e81976f	Your military society he another million.	{"{\\"url\\": \\"https://placekitten.com/113/404\\"}"}	http://thompson.net/about.php	2021-03-05 18:44:42.965637	2021-03-13 18:44:42.965637	Return model prevent free data tell address. Begin television authority oil.
8135052026196	2021-03-02 18:44:42.966102	2021-03-08 18:44:42.966102	f	7071b824-4980-4cd9-a569-b6b855319796	Inside responsibility sound.	{}	https://www.wilson.info/faq.htm	2021-03-14 18:44:42.966102	2021-03-21 18:44:42.966102	Director spring then pay. Serious time right coach.
7326305020493	2021-02-25 18:44:42.968999	2021-02-28 18:44:42.968999	f	1d4736bc-2114-402d-a608-72d1f8f0a230	Listen near eye degree law suddenly stop.	{"{\\"url\\": \\"https://placeimg.com/993/260/any\\"}"}	https://dodson-dodson.net/tag/main/privacy/	2021-03-08 18:44:42.968999	2021-03-12 18:44:42.968999	Record hit sign room. Live source then staff. Voice after hope could physical none. Buy western operation between although foot. Step scientist show green trade behavior.
5681041905711	2021-02-18 18:44:42.969477	2021-02-20 18:44:42.969477	f	b8234d40-01a1-4e2c-a871-034c715d9039	Art chance resource alone.	{"{\\"url\\": \\"https://www.lorempixel.com/114/424\\"}"}	https://www.kim-west.com/	2021-02-28 18:44:42.969477	2021-03-04 18:44:42.969477	Go quickly light detail nice send. Arrive them miss commercial value step. Great fast brother issue run structure. Of make meet small whole choice. Career pass both plant several must remember over.
8242114729190	2021-03-05 18:44:42.969913	2021-03-10 18:44:42.969913	f	eb6674d5-9033-409b-bcc2-786e3ef60c81	Season dog color point serious city kitchen.	{}	http://stokes-mills.com/	2021-03-16 18:44:42.969913	2021-03-20 18:44:42.969913	Arrive race Democrat husband article away office by. He be recently type parent. Lot company ground shake difference. Black site let. Ahead sport avoid industry participant.
8117927086726	2021-03-06 18:44:42.972698	2021-03-11 18:44:42.972698	f	1d4736b5-d40f-4237-8f4c-f6c2e0020dfd	Word son great morning model ok court.	{"{\\"url\\": \\"https://placeimg.com/852/676/any\\"}"}	http://sullivan-evans.com/category/posts/faq/	2021-03-18 18:44:42.972698	2021-03-19 18:44:42.972698	Something same animal else shoulder third evening. Most buy environment important glass whole. Blue ten town little. Within either provide keep help woman.
9881720466588	2021-03-05 18:44:42.973197	2021-03-07 18:44:42.973197	f	c32b61d3-d343-4183-b963-1e30380dcc47	Skin happy same send information will detail.	{"{\\"url\\": \\"https://placeimg.com/150/577/any\\"}"}	https://www.dean-ponce.com/	2021-03-15 18:44:42.973197	2021-03-25 18:44:42.973197	Stage whom leader design production according tax. Seat just world control. Parent question value push oil figure.
4041284538489	2021-02-28 18:44:42.973595	2021-03-04 18:44:42.973595	f	3da9d443-dd09-4f3c-b007-18a0e7024b2b	Water head fire few actually.	{}	http://www.ballard-quinn.com/blog/wp-content/register.jsp	2021-03-12 18:44:42.973595	2021-03-16 18:44:42.973595	Place amount kind talk. Your often possible treat. Necessary discover tell husband.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
7694087271960	2021-02-23 18:44:42.966604	2021-02-28 18:44:42.966604	f	451ab264-262d-44f6-ab0d-e2b119f2bdd4	Danielle Thomas	1	http://www.white-chavez.com/	{"{\\"url\\": \\"https://placeimg.com/901/15/any\\"}"}	Camera system research personal personal here. Something finish receive study partner both field.	{6861749069949,8629011159341}	{8118871313838,4273169487982,8135052026196}
6539241697181	2021-03-09 18:44:42.97032	2021-03-12 18:44:42.97032	f	41adc192-b75a-44d7-8690-6a84deb01300	Seth Pollard	2	http://evans.com/app/tags/list/search.htm	{"{\\"url\\": \\"https://placekitten.com/724/714\\"}"}	Matter short man mean detail. Street end represent whole century between eye good. One most only voice story.	{9718652962058,5888786203885}	{7326305020493,5681041905711,8242114729190}
5192579170613	2021-02-27 18:44:42.974004	2021-03-03 18:44:42.974004	f	c7f42e7b-960c-4b52-8956-3e330550e5ee	Matthew Smith	3	https://www.wade-pearson.org/tags/login/	{}	Her single hot security. Nearly two among figure piece.	{8482888789772,6976112891741}	{8117927086726,9881720466588,4041284538489}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (notification_uuid, channel, recipient, subject, message, scheduled_send_date, status, send_date) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
3789843573991	2021-03-01 18:44:42.940183	2021-03-06 18:44:42.940183	f	faed777a-0fa1-4b5e-8505-4699bb5820e4	Boy their quickly happy here usually.	{"{\\"url\\": \\"https://dummyimage.com/346x275\\"}"}	http://barnes.com/category.jsp	http://huang-gentry.com/	MEDIUM	{2718121039455}	{}	6	2	8	Challenge entire have day source. Only mouth guess color leader hear out find. Stand drug teach do. Notice perform population wait many movement table. Congress if beyond son guy quickly as.	Reach finish know lawyer way day effort set. Lead including machine detail finish. Question stock picture sense pay commercial race.	Much letter job course. Senior show purpose news.	Quickly market some none. Drive back let place young. Cost south make seem glass east candidate positive.	REQUIRES_APPLICATION
2121939418945	2021-02-22 18:44:42.942335	2021-02-25 18:44:42.942335	f	c69580fe-5c4a-4ddd-bf2e-653ddf4b1872	Hard page outside fall series risk the key.	{"{\\"url\\": \\"https://placekitten.com/869/186\\"}"}	http://www.brooks.com/search.php	http://www.jackson.com/category.asp	MEDIUM	{6234554738889}	{6751039497227}	6	8	4	Series seek adult better Mr able firm. Media view face arm war fly factor red. Add likely difficult arm require heavy.	Weight different discuss list while memory true. Forget mission mouth church piece whole. Science girl last. Yet sit certainly enter only any.	Picture give sure personal. Wide material four about number. Physical economy mention.	President early investment however blue rather all. Trouble computer us issue. Third industry option early. To trip owner fine back past international. Only media stage big early performance.	OPEN_TO_ALL
8391000678507	2021-02-23 18:44:42.943569	2021-02-25 18:44:42.943569	f	cb7ebf91-51d8-4f60-b7ff-f55996c16229	Relationship professor draw.	{"{\\"url\\": \\"https://dummyimage.com/496x376\\"}"}	http://hale.net/index.html	https://www.campbell.com/categories/author.asp	MEDIUM	{9975241998021}	{}	3	8	7	Follow hotel bad yet. In apply hear listen. Spend special over care. Energy him create.	Heart matter guess. Study quickly model share heavy none piece.	Yet memory within. Middle forget pay already relationship mouth activity. Pick unit able home become page tonight back.	Responsibility today scientist. Window politics southern certain suffer now. South me ball chance over. Score relate and subject claim conference four sell.	REQUIRES_APPLICATION
4519749187218	2021-03-04 18:44:42.945254	2021-03-08 18:44:42.945254	f	da1a0569-48db-45a3-b020-51f2315e6fc5	Town almost travel have against minute college.	{"{\\"url\\": \\"https://placekitten.com/949/40\\"}"}	http://www.mercado.com/home/	https://www.figueroa-owens.biz/	MEDIUM	{7162335465350}	{1974356976427}	2	5	3	Kind far another eight gun. Ok she feeling service after. Ability not enter.	Reflect financial authority beautiful defense throw dinner offer. Treatment what concern. Deal significant day. Without easy our account popular. Science ball bank purpose.	Whatever class high we. Remember design music particular. Coach despite truth camera simply store. Join like show for do middle television size.	Just than arrive social not learn development remain. Manager employee reality institution newspaper. Smile foreign near street three thank.	OPEN_TO_ALL
7802722656724	2021-02-28 18:44:42.946582	2021-03-03 18:44:42.946582	f	304cfdb6-1ee9-4760-816c-c955366fcef7	Animal last own personal.	{"{\\"url\\": \\"https://placekitten.com/21/124\\"}"}	http://www.alvarado-anderson.net/search/terms/	http://lawrence.com/	MEDIUM	{3820308479295}	{}	5	9	9	Adult learn financial simple however space. Professional machine drug choice. Weight safe indicate prove share through can key.	Bit recently war perhaps final. Only key establish various class foreign laugh. Finish character instead list impact arm. Upon require focus small. Week worker firm ask try put.	Strong speech bill serve phone unit company. Mouth speech above think any well often. Become beat ball human here give possible capital. Almost join first answer. Professor personal else whole some people.	Physical contain media against add degree. Difference successful production age generation work. See compare enough name. Poor stand technology likely your office market blood.	REQUIRES_APPLICATION
6861749069949	2021-02-28 18:44:42.963114	2021-03-04 18:44:42.963114	f	41a97395-8cfa-4815-946e-c26d3254acb7	Guy cultural usually.	{"{\\"url\\": \\"https://dummyimage.com/653x659\\"}"}	http://maxwell-brooks.org/	https://www.morris.com/terms/	MEDIUM	{0321621824883}	{1840260907393}	3	9	6	Partner citizen box itself effort learn. Especially market up boy feeling best during collection.	Book Democrat college. Exist understand authority Mrs dream product.	Few ready court item hundred catch. Car record up career. Fear piece this agency room. Kitchen treatment third main discussion. Participant company appear shake read policy area.	Set foreign analysis often peace toward. Camera election relate reflect tax different who. Executive only see religious. Program them court ball.	OPEN_TO_ALL
8629011159341	2021-03-04 18:44:42.964267	2021-03-08 18:44:42.964267	f	63ad1538-8b64-4e96-80ed-4d27a43b92d8	Institution believe day.	{"{\\"url\\": \\"https://placekitten.com/234/241\\"}"}	https://torres.net/terms.html	https://cain.com/	MEDIUM	{2046077188423}	{}	2	4	4	Ever like high several site. Value now certain century staff make. Southern knowledge health movement cultural play those.	Site city down. Throughout space while blue. Exactly however result.	Community appear animal scientist. General right risk investment. Join eye three room several. Low career idea range treat individual. Million off attorney tough company.	Eye ahead build show arrive generation. Available beautiful television fill PM example into. Somebody foot paper population.	OPEN_TO_ALL
9718652962058	2021-02-20 18:44:42.967331	2021-02-25 18:44:42.967331	f	1af1ee8d-2d5f-4762-837b-1c707bab8eb7	Him really walk loss.	{"{\\"url\\": \\"https://dummyimage.com/525x205\\"}"}	https://steele-choi.biz/main/register.htm	https://gibson.org/wp-content/posts/post/	MEDIUM	{9932248566929}	{2980888233296}	3	9	5	Light class pressure. How loss easy again. Coach late about old.	Prepare agreement guy billion certainly practice. Agency bill series certain mother us. Military quickly opportunity Mrs.	Plant because part economy. Own center develop customer majority clearly. That pretty firm make threat. Light religious toward scientist arrive.	Guess baby citizen focus night personal than. Practice once continue prepare job. Sense believe increase.	REQUIRES_APPLICATION
5888786203885	2021-02-21 18:44:42.968146	2021-02-24 18:44:42.968146	f	5a089f6b-7f93-483e-8505-ecba54c0ac40	American type international upon campaign someone court.	{"{\\"url\\": \\"https://placekitten.com/693/564\\"}"}	http://hicks-glass.com/	https://www.harris-cox.org/search/blog/search.php	MEDIUM	{9395828032083}	{4413681294020}	3	3	6	Rule manage these suggest forget page community. Into ahead deal second town wind. Threat person treatment every inside your.	Statement lead land box. Analysis room forget miss. American shoulder family truth one.	We current first relate once. Relate general hold tend almost. Enjoy recently suffer too. Start or what build kitchen statement. Build bag bag.	Amount condition many. Need next hot focus.	REQUIRES_APPLICATION
8482888789772	2021-03-09 18:44:42.970948	2021-03-12 18:44:42.970948	f	6bb8630c-125a-4b78-8607-ce2a058345d7	Language gun strategy way choice identify.	{"{\\"url\\": \\"https://placeimg.com/137/711/any\\"}"}	https://lam.com/	https://franklin.com/home.htm	MEDIUM	{2670047923242}	{}	2	8	5	Statement several year more little star teach. News decision especially manager former listen yeah.	Century former small never action serious. Actually executive hand likely. Break share act win identify market. Wrong establish by now.	American war challenge matter. Much turn develop.	Leader economic billion key. Need material way sort attorney local subject. Market indeed wait floor soon miss. Spend simply return position determine south. Dark talk phone.	REQUIRES_APPLICATION
6976112891741	2021-02-21 18:44:42.971768	2021-02-25 18:44:42.971768	f	15e0ce96-ace7-483e-90c9-5dc64d5d95e6	Attention network believe nothing guess occur.	{}	https://www.beck.info/	http://west-garcia.com/tags/privacy/	MEDIUM	{1737251692591}	{9580274498686}	6	4	6	Beat despite traditional performance gas lead. Member article series describe mother. Human method different hair discover line.	Always production wish book eat card never will. Itself trouble letter rule live. International international most close former condition. Sense at kitchen many degree.	May address bank civil indeed trade remember event. Whatever here reveal challenge property by range. Score ever dog can pull effect. Perhaps TV ever himself health. Upon old red create try.	Five car health conference serve. Economic particularly interesting material prepare wide drop inside.	REQUIRES_APPLICATION
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

