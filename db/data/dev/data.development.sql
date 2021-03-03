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
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, username, first_name, last_name, email_identifier_id, phone_number_identifier_id) FROM stdin;
\.


--
-- Data for Name: donation_emails; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.donation_emails (donation_uuid, email, request_sent_date) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
3731028545903	2021-02-23 18:18:25.799768	2021-02-26 18:18:25.799768	f	46578ecc-d7aa-4f2d-991d-a1cfb417d411	Western against open than.	{}	https://carlson.info/home.html	2021-03-05 18:18:25.799768	2021-03-09 18:18:25.799768	Country others kitchen response president. Animal positive probably seek local president writer. Really bit decide throw phone every community.
8360642915776	2021-03-01 18:18:25.800376	2021-03-05 18:18:25.800376	f	b9d12efd-441f-4577-b8bc-ee51e6708a39	Medical rest baby feeling positive medical.	{}	http://franco-newman.com/	2021-03-12 18:18:25.800376	2021-03-14 18:18:25.800376	Certainly politics model doctor support last. Recently possible majority teacher article until partner. Car television city forget process. Soldier hair sometimes black our. Congress red among describe.
2553558186545	2021-02-23 18:18:25.800748	2021-02-28 18:18:25.800748	f	36bbe76f-00ff-40f0-8faa-accec307dadc	Usually new husband people positive this tell rest.	{}	https://www.morris-waters.com/main/categories/main/faq.php	2021-03-07 18:18:25.800748	2021-03-15 18:18:25.800748	Arrive add something level company. Fill doctor participant big food rather. Member pass eight save tell station rise air.
6197517492290	2021-02-26 18:18:25.801119	2021-03-02 18:18:25.801119	f	9a8acef7-a9e6-4e35-bd6d-c24aaa17409c	Space position southern life give support near.	{}	http://www.king.com/	2021-03-08 18:18:25.801119	2021-03-09 18:18:25.801119	Generation true last strong. Result option could. Trial job field red through message computer these. Whether accept indeed.
2491070138256	2021-02-24 18:18:25.801591	2021-03-01 18:18:25.801591	f	e7d5e21e-8b5f-4d06-9a1f-0f59f5bc6ff2	Too month military create.	{"{\\"url\\": \\"https://placeimg.com/373/768/any\\"}"}	http://bowers.com/home.htm	2021-03-07 18:18:25.801591	2021-03-11 18:18:25.801591	Move guy attorney fire section listen room. Defense toward race apply. Month loss reduce focus whether.
7234417694719	2021-02-19 18:18:25.812533	2021-02-23 18:18:25.812533	f	92a47fe4-50e9-4143-9a4e-26eb58b6ed33	Protect least factor.	{"{\\"url\\": \\"https://www.lorempixel.com/213/827\\"}"}	http://stone-garrison.net/categories/faq/	2021-03-03 18:18:25.812533	2021-03-12 18:18:25.812533	Possible spring hotel expert lawyer tend return. Respond everyone red decision hotel.
9413194666937	2021-02-15 18:18:25.812895	2021-02-18 18:18:25.812895	f	91bb2065-f9a5-4120-b68e-ff6d84974199	Two last right than.	{"{\\"url\\": \\"https://placekitten.com/245/340\\"}"}	http://turner-osborne.com/tags/search/index.php	2021-02-26 18:18:25.812895	2021-03-06 18:18:25.812895	Money term where let laugh the know interview. Effort five eye team open operation add.
8263672316288	2021-02-23 18:18:25.81333	2021-03-01 18:18:25.81333	f	782d4067-eb7e-4030-8366-46f9dfee4849	Data city military member cut phone.	{}	http://www.buchanan-rose.info/terms/	2021-03-07 18:18:25.81333	2021-03-14 18:18:25.81333	Left summer behavior third focus add identify if. Body music network nature. As win during benefit task. Need certainly along individual yourself discuss voice item.
8770776885676	2021-02-18 18:18:25.815991	2021-02-21 18:18:25.815991	f	538c3a3f-a923-4772-976c-93b10fb8f5ca	Party able line yard particularly.	{"{\\"url\\": \\"https://dummyimage.com/970x721\\"}"}	http://www.leblanc.com/faq.html	2021-03-01 18:18:25.815991	2021-03-05 18:18:25.815991	Quality which state beat minute drop defense. Leave present relate week. Soldier after last box ground most. Staff watch maybe product both important other save.
4951540856854	2021-02-11 18:18:25.816469	2021-02-13 18:18:25.816469	f	306cbb8c-bced-45f6-a405-3e0cef4338ec	Same majority speech fly friend.	{"{\\"url\\": \\"https://placekitten.com/767/952\\"}"}	http://moore.com/categories/about.php	2021-02-21 18:18:25.816469	2021-02-25 18:18:25.816469	Sing leader show home hotel statement certain. That level national day card inside. Simple my child their wear.
8816550306125	2021-02-26 18:18:25.816947	2021-03-03 18:18:25.816947	f	01bb0392-5766-4237-956e-b83f6684b694	Detail avoid send garden both then.	{}	http://www.jarvis-lawrence.org/explore/faq.php	2021-03-09 18:18:25.816947	2021-03-13 18:18:25.816947	Produce need wait nearly affect artist keep nor. Really should traditional either face market. Senior identify though method.
5784810946608	2021-02-27 18:18:25.819935	2021-03-04 18:18:25.819935	f	5a43fb5d-59fc-40a1-94da-a605733a7ac1	Fast trade heart later.	{"{\\"url\\": \\"https://placeimg.com/279/258/any\\"}"}	http://christensen-hogan.com/main/categories/register.php	2021-03-11 18:18:25.819935	2021-03-12 18:18:25.819935	Trade effect wind strategy when over security. Long some suggest home. Allow parent sound remember artist drug worry him.
7503145430495	2021-02-26 18:18:25.820334	2021-02-28 18:18:25.820334	f	ae00440d-eb2f-488c-98f7-eb0ef23aeffa	Space political protect try.	{"{\\"url\\": \\"https://www.lorempixel.com/621/138\\"}"}	http://www.wolf-webb.net/search/register.html	2021-03-08 18:18:25.820334	2021-03-18 18:18:25.820334	System effort effect catch argue he road. Under benefit place box enter. Dinner rock respond event. Me do compare model course summer.
6008144394522	2021-02-21 18:18:25.820758	2021-02-25 18:18:25.820758	f	5cc2ab97-7e4c-4fa5-9623-78d1804a0100	Entire can son then.	{}	https://castaneda.com/	2021-03-05 18:18:25.820758	2021-03-09 18:18:25.820758	Tell west cold year wrong various method discover. Four finish political want three exist any. Mind former trial much.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
3187654512732	2021-02-16 18:18:25.813696	2021-02-21 18:18:25.813696	f	fcc17a11-1be3-4b8e-adc0-0aa70dde27d1	Tracy Brown	1	https://www.smith-murphy.com/	{"{\\"url\\": \\"https://placeimg.com/695/899/any\\"}"}	Magazine customer out policy one scene everybody. Own clearly choice feel language mean. President strategy do system. Mission nature air bag.	{0309257774086,6814037236493}	{7234417694719,9413194666937,8263672316288}
0235106098716	2021-03-02 18:18:25.817326	2021-03-05 18:18:25.817326	f	9004ce62-dd99-43ed-8e98-45e714c3cb09	Erin Mathis	2	https://arnold.org/wp-content/main/posts/home/	{"{\\"url\\": \\"https://placekitten.com/490/78\\"}"}	Discover relationship draw game card Democrat explain. Law thing say heart series. Tax reflect suggest low summer morning. See military require young table because mission.	{7561627934770,7711061506174}	{8770776885676,4951540856854,8816550306125}
4911036298599	2021-02-20 18:18:25.821066	2021-02-24 18:18:25.821066	f	3352f8b6-770d-4184-b3a4-062dac5de71a	Nicole Miller	3	https://henry-nunez.com/homepage/	{}	Your cut kid ask our law people professor. See less too newspaper where require director traditional.	{4309019925905,8244452469936}	{5784810946608,7503145430495,6008144394522}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (notification_uuid, channel, recipient, message, scheduled_send_date, status, send_date) FROM stdin;
\.


--
-- Data for Name: personal_identifiers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.personal_identifiers (uuid, type, value, verified) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
0327150063328	2021-02-22 18:18:25.78335	2021-02-27 18:18:25.78335	f	d18d7a41-aaa5-4da0-9e21-850101ebb28d	Truth enough authority those wear.	{"{\\"url\\": \\"https://placekitten.com/230/769\\"}"}	https://simon-pratt.com/	https://hernandez.com/author.html	MEDIUM	{6057180566981}	{}	6	2	8	Population until together seat. Task able receive realize very. Peace north any modern no.	Tend current organization hear. Key various record ask five. Value near yard. Far ability nearly apply bit work necessary. Say record truth state money.	Article worry main item it top participant trial. Here why hope old in back. Behind law somebody air five lead. Policy recent garden notice. Stage do measure nature customer.	Lawyer eight itself beautiful. Yourself hope out value down course evidence. Expert lawyer run difficult likely country record. Government about end class.	REQUIRES_APPLICATION
8042965130509	2021-02-15 18:18:25.78438	2021-02-18 18:18:25.78438	f	adc28abe-478c-4646-8f78-dfef067273d4	Second on treat say.	{"{\\"url\\": \\"https://placekitten.com/313/409\\"}"}	https://www.solis-brown.net/wp-content/index.html	http://www.williams-davidson.net/index.html	MEDIUM	{1560884906090}	{1149620966958}	6	8	4	Several economy indicate. World including go add form nice doctor hotel. Single successful address house hard south.	Effect team value say collection onto. Partner commercial night game industry why course. Friend majority modern her focus.	Use maintain draw interest form media. Partner blue middle base pay miss. Several woman boy watch mother situation. Support article check industry seat individual itself.	System woman cover throughout TV direction fall. Just return once sort music. Someone including new page nature.	OPEN_TO_ALL
7909351854559	2021-02-16 18:18:25.785691	2021-02-18 18:18:25.785691	f	b22e53f1-dfc8-4ae6-8ead-5db6cb76cead	Information hard language.	{"{\\"url\\": \\"https://placekitten.com/663/907\\"}"}	https://www.mathis.org/main/	https://www.mckenzie-white.com/search.asp	MEDIUM	{9162596131573}	{}	3	8	7	Edge method cell season eat one general. Industry region young form. None design worry side challenge science people. From price give with air rise hundred blue.	In voice official always model deal bar trouble. Relationship better cost generation. Suggest activity receive attack power recently growth. Policy letter Republican finish. Tough information professor drug.	Within positive government reach able country tree. Former design interesting design measure skin rate how.	Technology when often nothing much. Big go suggest walk poor and usually scientist. New recent collection mind give professional. War family real reveal. World store down eye dinner wonder.	REQUIRES_APPLICATION
7585441668840	2021-02-25 18:18:25.786486	2021-03-01 18:18:25.786486	f	2e76778a-ca28-4b79-ac1e-ca9f5c4e131d	Throughout exist only drop stock price.	{"{\\"url\\": \\"https://www.lorempixel.com/246/749\\"}"}	https://scott.com/explore/blog/search.asp	https://merritt.com/tags/search/app/main/	MEDIUM	{9173991280186}	{1367184578275}	2	5	3	Group everything give arm thousand wind. Right direction mouth develop peace. Myself before whose couple left lot. Decide government knowledge daughter garden activity garden.	Reveal art deal section single natural traditional. Section prevent threat though. Ago eight take night step town leave.	Arrive subject build prevent cost. Cause low write. Agree our face he meet to. Live up growth perform doctor. Apply line claim party consumer fire.	Above local environmental. Seem director fall establish shake century some. Degree face happen that young look mean. Major level west hotel board far feel mind.	OPEN_TO_ALL
1494300312007	2021-02-21 18:18:25.787209	2021-02-24 18:18:25.787209	f	eb5a8221-7d06-4eb4-9769-0f2bd5052182	Treat lose protect without sing participant senior.	{"{\\"url\\": \\"https://placekitten.com/956/26\\"}"}	http://williams.net/main.htm	http://www.pennington.biz/	MEDIUM	{1342224347677}	{}	5	9	9	Until impact she yeah picture. Our subject those scientist cut court. Walk month guess back order form heavy personal.	Stage this effort by way keep. Thank six nothing visit common.	Compare simple name between and. Even idea watch beyond than list. Fast lead risk property himself relationship let.	Religious computer use theory. Follow out just growth similar baby. Challenge focus tell. Boy stay it into dog member wear may.	REQUIRES_APPLICATION
0309257774086	2021-02-21 18:18:25.810967	2021-02-25 18:18:25.810967	f	fd0ae129-79d5-4d11-8d46-9dc1eebe4d60	Expect case theory president none travel.	{"{\\"url\\": \\"https://dummyimage.com/44x107\\"}"}	http://www.garcia.info/list/search/login/	http://garcia.info/author.htm	MEDIUM	{8962609741215}	{4388063353353}	3	9	6	Although yourself usually have on do. Head quality collection if. First industry newspaper deal night catch. War response close practice discover rather. None know thus evidence popular firm.	Senior day week. Race list Mrs stop store we until. Family tax hotel let use husband bar. Likely forward why bar more until.	Field may because know foreign former arm. Professor thought never world audience arm stuff politics. Rate month open. Play but reality manage. Always result agent modern.	Range response how know success leg authority. Spring maintain home. Opportunity tend which smile future when sort. Beyond economy option already director member true employee.	OPEN_TO_ALL
6814037236493	2021-02-25 18:18:25.81176	2021-03-01 18:18:25.81176	f	5ab273e6-9317-4dff-ae9d-de20aa0f32c8	Quite possible may truth well.	{"{\\"url\\": \\"https://placekitten.com/182/259\\"}"}	https://jimenez-gonzalez.com/wp-content/search/category/main.html	https://www.chase-jones.com/author.html	MEDIUM	{9312544999308}	{}	2	4	4	Near people often truth chance speak. Him bar north low still police. Various food idea return staff big.	Significant quickly argue hair series particularly. Collection run moment else sign. Maintain character can two hard animal stage. Certain station state lead level run.	Stuff investment shake together responsibility smile. Play half high much group. Itself practice southern yourself onto. Concern dog gun life entire issue.	Move never at interview me. Project coach doctor husband. Explain phone truth throughout total. Throw street kind PM will decision. Foot present soon manager test quickly.	OPEN_TO_ALL
7561627934770	2021-02-13 18:18:25.814266	2021-02-18 18:18:25.814266	f	17a9e8d4-2f3f-42dd-8d9d-f64f5f36e3d7	Brother growth no quality couple.	{"{\\"url\\": \\"https://dummyimage.com/297x487\\"}"}	https://little.com/list/category/index/	http://www.fields.com/list/blog/app/faq.html	MEDIUM	{5508285044689}	{9571722631793}	3	9	5	Property successful explain data accept sister high. Agree early knowledge usually how. People rule his he score different. Move continue general should who.	Industry assume keep begin reduce lay record. American state wear machine again. Law campaign then name on suddenly friend man. Message between summer mean.	Speak eat according risk happy provide yeah. Test ahead wide as moment though. Low prove interview remember area. Spring them second stuff worry southern.	Several every kind show pass a wind follow. Friend notice industry response open mean campaign entire. Study ahead specific box student. Bit from produce political policy.	REQUIRES_APPLICATION
7711061506174	2021-02-14 18:18:25.815099	2021-02-17 18:18:25.815099	f	443ea251-18db-4a6b-9d63-9605a5591986	Already civil and floor close than professor.	{"{\\"url\\": \\"https://placekitten.com/203/311\\"}"}	http://www.smith.biz/app/homepage.asp	http://maxwell.com/	MEDIUM	{8268191972168}	{1863218780763}	3	3	6	Surface claim court of college. Poor worker expert project usually. West all big four employee weight far. Body east outside anyone give almost build.	Expert mention program. Reach senior no evidence.	Relationship thank walk mission. Same police organization however.	Fine natural exactly doctor evening since reflect explain. Sport shake young mention.	REQUIRES_APPLICATION
4309019925905	2021-03-02 18:18:25.817975	2021-03-05 18:18:25.817975	f	d00810cc-b0ef-4e20-af59-3251d799f2af	Would book administration nor.	{"{\\"url\\": \\"https://placeimg.com/432/652/any\\"}"}	http://riggs.com/register/	https://www.rodgers-caldwell.com/category/tag/wp-content/privacy.htm	MEDIUM	{6681724281445}	{}	2	8	5	Skill miss chair gun. Protect our build story. Decision sense although modern. Memory remember word later record yes situation student.	Condition pull door hit without audience last. Suffer space American card. Keep drive close travel imagine fund apply feeling.	Father air trouble song road main. Friend medical single material concern. Relate heart example compare level. Eye public simply nor green. Couple weight open agent central.	Finish score road lay wind itself. Computer whose air trouble. Join their adult. Family trouble than stuff question sell explain.	REQUIRES_APPLICATION
8244452469936	2021-02-14 18:18:25.818986	2021-02-18 18:18:25.818986	f	94901b18-ac10-4cf8-9364-6eaf45cce481	Learn paper tend deal quite none have debate.	{}	http://burch.com/posts/wp-content/blog/faq.htm	https://turner.com/search/main/	MEDIUM	{1175666414269}	{8919262080571}	6	4	6	Experience rest give town former trial air particularly. Anyone meeting TV now exist.	Window win charge information accept standard. Product on billion national keep mother so from. Eight over expect truth. Business health west deep ok may dark.	Throw article data. Lay base town manager husband. Training discussion medical large thus benefit capital.	Reveal real follow somebody should. Morning worry top design. Late where attention natural difficult. International lose man drug spring product. Drop per away message establish.	REQUIRES_APPLICATION
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

