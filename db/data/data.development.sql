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
    uuid uuid NOT NULL,
    id character varying(255) NOT NULL,
    event_name character varying(255) NOT NULL,
    event_graphics json[],
    signup_link text,
    start timestamp without time zone,
    "end" timestamp without time zone,
    description text,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL
);


ALTER TABLE public.events OWNER TO admin;

--
-- Name: initiatives; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.initiatives (
    uuid uuid NOT NULL,
    id character varying(255) NOT NULL,
    initiative_name character varying(255) NOT NULL,
    "order" integer NOT NULL,
    details_link character varying(255),
    hero_image_urls json[],
    description text,
    roles character varying[],
    events character varying[],
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL
);


ALTER TABLE public.initiatives OWNER TO admin;

--
-- Name: volunteer_openings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.volunteer_openings (
    uuid uuid NOT NULL,
    id character varying(255) NOT NULL,
    role_name character varying(255) NOT NULL,
    hero_image_urls json[],
    application_signup_form text,
    more_info_link text,
    priority public.priority,
    team character varying(255)[],
    team_lead_ids character varying(255)[],
    num_openings integer,
    minimum_time_commitment_per_week_hours integer,
    maximum_time_commitment_per_week_hours integer,
    job_overview text,
    what_youll_learn text,
    responsibilities_and_duties text,
    qualifications text,
    role_type public.roletype,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL
);


ALTER TABLE public.volunteer_openings OWNER TO admin;

--
-- Data for Name: donation_emails; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.donation_emails (donation_uuid, email, request_sent_date) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (uuid, id, event_name, event_graphics, signup_link, start, "end", description, airtable_last_modified, updated_at, is_deleted) FROM stdin;
b0ddd0e4-230c-4f73-8493-e7f4a0f31e02	5164901015947	Three matter space.	{}	http://mcdonald.com/tag/post.jsp	2021-01-24 07:41:14.654502	2021-01-28 07:41:14.654502	Stay share politics forward politics spend really. Available much sound and. Interview enjoy most him building road opportunity. Benefit majority bar thought thing major. Financial race type.	2021-01-14 07:41:14.654502	2021-01-17 07:41:14.654502	f
3ffda0ac-90a7-4bca-8d64-5af2b08d4309	9444004092653	Skin first positive so.	{}	https://www.wagner.org/	2021-01-31 07:41:14.655432	2021-02-02 07:41:14.655432	Machine remember realize stay forget join generation. Officer big state source more everyone how inside. Little network modern treat.	2021-01-20 07:41:14.655432	2021-01-24 07:41:14.655432	f
868317ad-0fa1-4a70-8e45-8abee50c691e	2163805277850	Law later fund sense true.	{}	http://www.baldwin.org/author.php	2021-01-26 07:41:14.656385	2021-02-03 07:41:14.656385	Evidence game political live. Who start after effort live prove. Six different his possible common behind write.	2021-01-14 07:41:14.656385	2021-01-19 07:41:14.656385	f
af828008-3446-400c-980f-0e617c3c8024	1987225619691	Office today heavy thousand attorney television.	{}	https://choi-walsh.com/	2021-01-27 07:41:14.657312	2021-01-28 07:41:14.657312	He notice walk relate term buy. Media late occur than decade central.	2021-01-17 07:41:14.657312	2021-01-21 07:41:14.657312	f
581df67f-3e8b-4a9c-a8b4-4eaead95e21c	3461899807489	Visit job together lawyer clear me.	{"{\\"url\\": \\"https://placeimg.com/449/379/any\\"}"}	http://morse.com/category/	2021-01-26 07:41:14.65807	2021-01-30 07:41:14.65807	Laugh what whose situation same old mind former. Within house add try media despite shoulder.	2021-01-15 07:41:14.65807	2021-01-20 07:41:14.65807	f
c7df636d-23ba-4e01-a72b-b906c369b34e	0716018137545	Skin cover guy five.	{"{\\"url\\": \\"https://dummyimage.com/333x596\\"}"}	http://garza-wilson.com/category/	2021-01-22 07:41:14.66837	2021-01-31 07:41:14.66837	Decision area whether officer benefit. Wife project by strong civil. Off very week. Chance tonight carry friend much term.	2021-01-10 07:41:14.66837	2021-01-14 07:41:14.66837	f
0bc64b78-4c8c-4fef-b1ae-9581bec95603	6945428880862	Window measure various himself young item.	{"{\\"url\\": \\"https://placekitten.com/988/439\\"}"}	http://logan.org/homepage.html	2021-01-17 07:41:14.66893	2021-01-25 07:41:14.66893	Write exist return relate partner modern authority. Easy book seven design fine international.	2021-01-06 07:41:14.66893	2021-01-09 07:41:14.66893	f
ff410400-7c38-4266-a765-342420554a86	1973815444217	Tonight Congress even resource thought.	{}	http://www.sanchez.biz/	2021-01-26 07:41:14.669499	2021-02-02 07:41:14.669499	Economy wait show provide garden director fast response. Soon particular every now memory hospital expert record.	2021-01-14 07:41:14.669499	2021-01-20 07:41:14.669499	f
fa4a0036-5ab8-416d-8015-999e70e9a8ff	2119576966622	Wish within heart into.	{"{\\"url\\": \\"https://www.lorempixel.com/535/521\\"}"}	http://nelson-bell.com/author/	2021-01-20 07:41:14.67263	2021-01-24 07:41:14.67263	Election evening group. Room it image news beautiful about. Issue born stuff Democrat. Control ever where outside animal.	2021-01-09 07:41:14.67263	2021-01-12 07:41:14.67263	f
d9d1341b-741d-4d8e-84fa-229f1f67821a	4276300316349	Notice best allow turn create your quickly.	{"{\\"url\\": \\"https://www.lorempixel.com/154/491\\"}"}	http://www.rivas.biz/	2021-01-12 07:41:14.673138	2021-01-16 07:41:14.673138	Lot put throughout resource tonight entire yeah. Behavior in on too increase eight use develop. Say old little magazine. Stock development personal month laugh eight edge state.	2021-01-02 07:41:14.673138	2021-01-04 07:41:14.673138	f
8a7562ee-5b91-4c24-8e4a-23347eb496d0	3118402204623	Attack dream against get pick billion.	{}	http://banks.com/author.php	2021-01-28 07:41:14.673559	2021-02-01 07:41:14.673559	Today could foreign sign. Knowledge special subject age drive listen. Risk music whose minute argue wide lead.	2021-01-17 07:41:14.673559	2021-01-22 07:41:14.673559	f
32a57446-c613-41ad-8430-1f2f36c491d8	5218601201787	Second under listen cup ready.	{"{\\"url\\": \\"https://dummyimage.com/886x873\\"}"}	http://www.williams-anderson.com/explore/search/category.html	2021-01-30 07:41:14.676398	2021-01-31 07:41:14.676398	Southern nature modern few vote. Stop thus respond high capital number. Her her down human four method between. Miss school him strategy east imagine lay.	2021-01-18 07:41:14.676398	2021-01-23 07:41:14.676398	f
cf319919-c6ae-4ca6-926b-c2a5fb58febb	4974051139940	Job article money cold than.	{"{\\"url\\": \\"https://placeimg.com/825/336/any\\"}"}	https://www.daniels.com/terms.html	2021-01-27 07:41:14.676856	2021-02-06 07:41:14.676856	Nor organization difficult world recent. Success leader current election whether. New per yes fire. Provide floor read store half at thank act.	2021-01-17 07:41:14.676856	2021-01-19 07:41:14.676856	f
95e678f7-72d2-4b6a-acc0-7bcb435d5fbd	8272003321419	Cover writer church focus last fish successful.	{}	http://www.hammond.com/category/posts/main.php	2021-01-24 07:41:14.677216	2021-01-28 07:41:14.677216	Concern draw every writer about generation me. Reflect represent somebody skin each study. Edge arm minute our perhaps check. Onto pretty personal director.	2021-01-12 07:41:14.677216	2021-01-16 07:41:14.677216	f
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (uuid, id, initiative_name, "order", details_link, hero_image_urls, description, roles, events, airtable_last_modified, updated_at, is_deleted) FROM stdin;
68fef41e-af51-497e-83de-5315caec19ad	0826073970244	Rebecca Kelly	1	https://boyer-herrera.com/wp-content/blog/privacy/	{"{\\"url\\": \\"https://dummyimage.com/909x704\\"}"}	Some project specific agree choose if. Major evidence rate matter never public store matter. Both defense despite arm tell. Relationship indicate south sing like include.	{2855967521314,6782655208256}	{0716018137545,6945428880862,1973815444217}	2021-01-07 07:41:14.670048	2021-01-12 07:41:14.670048	f
efd17ccc-01ae-4376-9e6d-84be77a8cda7	9492217764317	Jonathon Daugherty	2	http://www.baird.com/	{"{\\"url\\": \\"https://dummyimage.com/218x118\\"}"}	Former level very arrive structure. Provide national until decade source. Cell child allow exist their. Available term chance start market describe stock. Word seem officer whole me product meeting.	{6144154398720,4718672335424}	{2119576966622,4276300316349,3118402204623}	2021-01-21 07:41:14.674081	2021-01-24 07:41:14.674081	f
6f792e92-80cc-4532-9fc4-19557aa2475b	4963161331979	Natasha Ward	3	http://williams.com/search/	{}	Soldier name better. Focus structure major doctor wait age edge last. Million these course participant nearly.	{9468701189843,4159713281896}	{5218601201787,4974051139940,8272003321419}	2021-01-11 07:41:14.677579	2021-01-15 07:41:14.677579	f
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (uuid, id, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type, airtable_last_modified, updated_at, is_deleted) FROM stdin;
04667315-9c80-4349-a0e0-301afb95ee7c	0347577254642	Cause eye home avoid crime.	{"{\\"url\\": \\"https://placeimg.com/805/993/any\\"}"}	http://www.webster.org/register.php	https://wood-torres.net/index/	MEDIUM	{7578707466830}	{}	6	2	8	Time professional along thank. Similar attack of hand. Ten deal understand degree environmental. Head shoulder sure debate challenge short people executive. Back message both have where sport lose.	Response since campaign market. Person this magazine not whether against prevent. According south always still everyone far heavy. Level four form provide office push. Yard create nothing.	Other operation itself. Feeling level hot baby. Brother system new key. Side will particular keep. Much loss official but.	Hand gas too level run radio health participant. Kind senior seven police media.	REQUIRES_APPLICATION	2021-01-13 07:41:14.635416	2021-01-18 07:41:14.635416	f
aa342f67-e633-4660-85cf-f00bfc00f267	3006814935337	Store service coach tax already hard step.	{"{\\"url\\": \\"https://dummyimage.com/645x625\\"}"}	https://hall.com/list/posts/faq/	http://hamilton-simpson.biz/main/search/explore/post/	MEDIUM	{7713685028834}	{3998599791393}	6	8	4	Evening share check will gun. Direction culture or arrive occur raise protect. Least tax life very run respond focus arm. Current study sort here experience share.	Democratic sister return not everybody sign positive. Open rule serious another read. The admit land plant. Act identify society little forward see out.	Under speak marriage board game matter. Which hand let score relationship if.	Rate design education prevent. Character political summer. Assume article popular exist.	OPEN_TO_ALL	2021-01-06 07:41:14.637904	2021-01-09 07:41:14.637904	f
e570a730-6c06-4bff-9844-d16b447db5a2	7908373006441	Voice level will rule team candidate.	{"{\\"url\\": \\"https://www.lorempixel.com/859/664\\"}"}	https://www.daniels.com/tags/blog/tags/about/	https://www.simmons.com/	MEDIUM	{3665287348862}	{}	3	8	7	Data voice perhaps require step such serve. Left house even agent bag. Station school environmental stuff.	Wide the sell. Month small box share. His friend eat open election husband. Election section whether score fight bag hair us.	Stage when carry. Various garden support training stop production memory.	Thus call city pull property fire. Without allow democratic defense environmental sit my. Week provide feeling business.	REQUIRES_APPLICATION	2021-01-07 07:41:14.639751	2021-01-09 07:41:14.639751	f
5e99904d-ca68-449e-97cf-7acc4bf1ac75	5566313071175	Offer example push represent likely plan.	{"{\\"url\\": \\"https://placekitten.com/624/155\\"}"}	http://gray.com/category/	https://jackson.biz/home.asp	MEDIUM	{5107957319201}	{2855081863970}	2	5	3	Base service again contain attorney. Notice mention choose political. Development sometimes start new single. Perhaps sit season author Mrs chair camera.	Moment take candidate region door friend. Congress young body yes beat perhaps. Miss gas strong season ahead war.	Want best perform glass far glass. Air know middle line. Company view science positive. Carry positive general leave.	Piece leg kid member only. Meeting commercial catch remember. Bag room church so during rather appear.	OPEN_TO_ALL	2021-01-16 07:41:14.641328	2021-01-20 07:41:14.641328	f
100b9fab-4f7b-41fc-bf56-db86ce006fa2	2126629963712	Democrat line organization mean war nation enter detail.	{"{\\"url\\": \\"https://placeimg.com/283/291/any\\"}"}	http://www.riley-freeman.com/	http://brooks-bennett.com/wp-content/tags/posts/main.php	MEDIUM	{0876523346914}	{}	5	9	9	Law chance specific degree reflect exactly. Team early write huge billion again. Door after color general true add. Radio present should prepare. Drop movie him allow particular.	After sign leg piece difference significant. Assume politics couple character teacher class my. Together rule establish society majority too value. Stop toward city same such their.	Boy political suddenly me. Street station remember fine.	Successful war tonight although admit at. Inside dinner institution sing agency.	REQUIRES_APPLICATION	2021-01-12 07:41:14.642967	2021-01-15 07:41:14.642967	f
55fab5c9-2ba5-47cc-9f36-6983a2968d73	2855967521314	Teach cultural system door film.	{"{\\"url\\": \\"https://placekitten.com/126/226\\"}"}	https://robbins.com/posts/wp-content/homepage/	http://barton.com/	MEDIUM	{9556520258885}	{8051022360193}	3	9	6	Upon fine serious experience write. Leg any mother avoid land. Member read day discussion its. Human later whom talk the state. Member action feel notice pull fast.	Send state line staff yet always. Analysis important require course where. Life quickly upon wait trip billion drop yourself.	Into structure various parent large oil every. Present natural cold indeed smile. Sell offer just how control entire opportunity. Newspaper meet watch likely high.	Yes serve report over level. Identify sing first stuff wall idea choice. Increase place look those. Line he usually activity design.	OPEN_TO_ALL	2021-01-12 07:41:14.665768	2021-01-16 07:41:14.665768	f
b76cf09c-7a7c-4833-a618-380ec7e07b53	6782655208256	Guy time sister education star instead dinner ahead.	{"{\\"url\\": \\"https://dummyimage.com/144x534\\"}"}	https://www.weber.com/register/	http://parker.com/about.php	MEDIUM	{5162406469425}	{}	2	4	4	Fight television grow fact. Yes both land seven read. Camera surface party value. Staff president night from.	Them give international under case figure style voice. News region specific attack policy. Situation wide return successful kid though yourself. Specific continue hand information carry. Happen executive protect.	Feel participant yourself. Discover support age with subject. Several edge small western property we. Tough real by firm commercial argue form grow. Like reach room shoulder statement main meet bad.	Writer think director line year former. Those will bring eight. Quite organization car mother. Almost personal young explain away.	OPEN_TO_ALL	2021-01-16 07:41:14.666967	2021-01-20 07:41:14.666967	f
06d1be2d-945c-4f21-8a4e-baa60035dacd	6144154398720	Say example professional report easy area education too.	{"{\\"url\\": \\"https://placeimg.com/703/936/any\\"}"}	http://www.duncan-brown.net/app/wp-content/list/faq/	http://thompson.com/search/	MEDIUM	{2414597454715}	{1036341114136}	3	9	5	Six much voice and myself anyone new. Key three yard clear same. Out possible instead letter material. Campaign seven pass baby trial check drive.	Pay dream can. Sit often language political fund who couple leave. By local half sit knowledge growth. Lose fire range past high way physical. Region president read our use kind dinner.	Similar side training cause door sea. Hand drop nothing rich raise. Industry it account create close explain purpose.	International gun on. Local arm adult bring born recently. Certain central condition maintain.	REQUIRES_APPLICATION	2021-01-04 07:41:14.670802	2021-01-09 07:41:14.670802	f
40c1e20a-edc4-43ec-bc16-69c3a219f87d	4718672335424	He third claim early.	{"{\\"url\\": \\"https://placeimg.com/166/82/any\\"}"}	https://lewis.com/blog/categories/search/	http://www.scott.org/	MEDIUM	{0671919180659}	{0673771141229}	3	3	6	Traditional receive development care three occur ahead. Skin will meeting money church play relationship.	Let team father big Congress. Let have writer ok wall religious approach. Bring answer bed as throw. Appear culture worker that.	Foreign magazine more deal determine provide. Style window program. Take number of. Prove health if ball.	Total travel attention. Drop front center idea question ball.	REQUIRES_APPLICATION	2021-01-05 07:41:14.671778	2021-01-08 07:41:14.671778	f
81cf3d99-ace8-463b-ab69-1ddab27e1d04	9468701189843	Trip section article yes teacher.	{"{\\"url\\": \\"https://www.lorempixel.com/9/168\\"}"}	https://www.hopkins.com/register.php	https://www.coleman.org/app/faq.html	MEDIUM	{2345039772862}	{}	2	8	5	Car behind century sell again statement home professor. Significant myself economic benefit various. Represent despite produce mean test son police population.	Whole reality north deal daughter. Necessary admit describe. Gas perform though water. News human scene recent.	Down design type those store. Physical into any carry marriage adult. Answer media usually to.	This offer growth every. Begin idea teach reach about deal both. Several explain my black reduce.	REQUIRES_APPLICATION	2021-01-21 07:41:14.674628	2021-01-24 07:41:14.674628	f
4e266910-9ba9-42d9-8dcd-39557cda6216	4159713281896	Page design know very charge.	{}	https://www.james-burch.com/categories/explore/wp-content/homepage/	https://lynch-robinson.com/author.php	MEDIUM	{0677329472025}	{2232120090991}	6	4	6	Three factor through left suggest over. Focus else bank own available hope. Understand score line law hundred environmental behind.	Operation difficult cup any position. Serve take determine food people. Machine issue himself. Speak choice year piece finish according push.	However cut mother including east risk everybody. Though visit across also. House share expert may. Off off start themselves sometimes worker.	Authority drug final soon issue. Behavior now item song. Personal arm southern.	REQUIRES_APPLICATION	2021-01-05 07:41:14.67551	2021-01-09 07:41:14.67551	f
\.


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
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- PostgreSQL database dump complete
--

