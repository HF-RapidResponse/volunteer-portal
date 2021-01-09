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
DROP DATABASE hf_volunteer_portal_development;
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
    id character varying(255),
    event_name character varying(255),
    event_graphics json[],
    signup_link text,
    start timestamp without time zone,
    "end" timestamp without time zone,
    description text,
    airtable_last_modified timestamp without time zone,
    db_last_modified timestamp without time zone NOT NULL,
    is_deleted bool NOT NULL
);


ALTER TABLE public.events OWNER TO admin;

--
-- Name: initiatives; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.initiatives (
    initiative_uuid uuid NOT NULL,
    id character varying(255),
    initiative_name character varying(255),
    details_link character varying(255),
    hero_image_urls json[],
    description character varying(255),
    roles character varying[],
    events character varying[]
);


ALTER TABLE public.initiatives OWNER TO admin;

--
-- Name: volunteer_openings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.volunteer_openings (
    role_uuid uuid NOT NULL,
    id character varying(255),
    position_id character varying(255),
    more_info_link text,
    team_photo json[],
    application_signup_form text,
    priority_level public.priority,
    point_of_contact_name character varying(255),
    num_openings integer,
    minimum_time_commitment_per_week_hours integer,
    maximum_time_commitment_per_week_hours integer,
    job_overview text,
    what_youll_learn text,
    responsibilities_and_duties text,
    qualifications text,
    role_type public.roletype
);


ALTER TABLE public.volunteer_openings OWNER TO admin;

--
-- Data for Name: donation_emails; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.donation_emails (donation_uuid, email, request_sent_date) FROM stdin;
\.



--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (initiative_uuid, id, initiative_name, details_link, hero_image_urls, description, roles, events) FROM stdin;
d889fb55-da38-426a-b802-fee00ae05769	Sort building spend mind person decade store.	Some by eight standard heavy.	http://www.garza-garrison.net/posts/explore/login.htm	{}	Magazine man education film. Price policy policy them start bit. Question two vote action base far against level. Ready fill prevent former. Eight quality born film response whole.	{"Charles Reese","Albert Cook"}	{"Adam Strickland","Christina West","Vincent Marks"}
8d9dc959-6da9-4e7b-bd0f-2827dcc51aaf	Green ground build professor.	Success worry research five security education.	https://www.wilson.net/	{"{\\"url\\": \\"https://dummyimage.com/918x898\\"}"}	Rise network artist nature. Card professor evidence management majority candidate explain. Sense religious mother authority too husband which. Heavy glass woman interview. Building mother down newspaper show expect.	{"Brandi Schroeder","Emily Rocha"}	{"Gerald Reynolds","Caleb Ayers","Diane Jimenez"}
3d666d2b-862c-4672-ac96-807db24cd8f2	Top add response professor American.	Billion some skill rich.	https://www.anderson-brown.com/categories/blog/index/	{"{\\"url\\": \\"https://dummyimage.com/668x308\\"}"}	Through stock election cut. Ready need player. Least relationship everything activity a soon. Action I nice key attention hit what.	{"Jordan Mcconnell","Paul Underwood"}	{"Michael Black","Courtney Clark","Joan Thompson"}
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (role_uuid, id, position_id, more_info_link, team_photo, application_signup_form, priority_level, point_of_contact_name, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
79dcc099-8b34-45c0-8491-9cd1405f75e3	Daniel Stewart	Should arm site yard.	http://campbell.com/	{}	https://www.harris.com/list/app/app/register.asp	MEDIUM	Jennifer Whitehead DDS	7	6	2	Spend support cultural run trial. Wide pull operation strategy occur. In probably true issue through film. However sometimes seem develop.	Myself view write maybe activity morning trip. True lawyer account describe. Although now crime history sing office.	Writer certain bank whose. Six should here thank. Respond where wear some air.	War direction by relationship medical model moment. Find seem hotel thing woman. Most general industry resource field dream really. Serve grow modern hand lay see focus.	OPEN_TO_ALL
28ffd2ec-1653-4a47-9852-32a74709fb53	Ashley Schmidt	Perform business tax to method memory according.	http://www.horn.com/blog/app/app/post/	{"{\\"url\\": \\"https://dummyimage.com/108x565\\"}"}	https://www.martin.org/home/	MEDIUM	\N	3	4	4	Traditional bank section probably piece economic the. Analysis someone just paper Mr happy. Instead his certain step. Exactly former second tax west get while according. Lose bar company run discuss language indeed.	Mission receive perform rock finish become include. Start out young rise. Wait summer wrong anything bring. Reveal natural strong night bank teach school. Though line hope late threat ever.	How message strong southern some long cover play. Activity save hit able audience. Minute measure should national.	Inside consider each rule during rate. Team food white beautiful including family manage.	OPEN_TO_ALL
5577f0d8-8165-4874-b735-7d5d28d38a7b	Karen Long	Standard or argue while movement.	http://www.craig-rodriguez.com/post/	{}	http://www.rodriguez.info/blog/app/list/homepage.php	MEDIUM	Patrick Miller	6	4	8	Population market always media participant ground forward friend. Most account join president need Republican. Son sense even health big than.	Grow we suffer start. Plan write should big admit improve other idea. When recent perform performance certainly his meet other. Rest left close as partner.	Away report ahead. Step central project price network energy actually. Four of general campaign bad soon.	Capital fish color gun. Group same fine indicate better church. Whose because ask deep. Share resource author head edge ever.	REQUIRES_APPLICATION
135e86e4-7045-4597-af32-4a7da2f2e385	Shane Bridges	Important world role rate idea until appear.	https://www.wallace.com/categories/app/author.html	{"{\\"url\\": \\"https://placekitten.com/1018/524\\"}"}	https://www.rivera.com/faq.jsp	MEDIUM	\N	3	8	7	Sit physical store one if. Better animal hear seem clearly less. Better tend capital security economic.	Spring social coach much. Various spend drug effort.	Threat everything accept city assume. Land pretty only he guy whether might.	Practice sometimes smile under student. See pretty reduce decision. Walk many live or whatever water attack. Dog chance room standard act.	REQUIRES_APPLICATION
0b6d3c6d-25a9-4923-ac90-1317e1852b56	Steve Chaney	Sell lead someone sell room final.	http://www.glover.com/home.asp	{"{\\"url\\": \\"https://placekitten.com/963/376\\"}"}	http://vega.com/	MEDIUM	\N	4	9	3	Everyone coach body build. Professional bill kind detail. Team firm himself country care know suffer pay.	Explain program coach high must talk. Word how purpose discuss well how. Pretty money cultural age if. Court day fact where.	Citizen administration wide may. Exactly quality dark history she often. Assume much level on hundred head service that.	Beautiful especially decade get skin line yourself. Together nice save. House beat hotel tend where something.	REQUIRES_APPLICATION
7613ff5c-0673-40d3-b911-92a316fc7582	Charles Reese	During job education from myself customer rather.	http://www.vance-nixon.com/	{}	http://jackson.com/faq.htm	MEDIUM	\N	6	8	10	Well big trip painting. Picture week himself daughter movement minute material owner. Admit career member pull stage financial.	First nothing shoulder push bag. Doctor reality outside way. Almost economy too address three seem bar.	Support model about plant article always. Memory medical eight season natural. Bring happen perform against note.	Somebody moment edge daughter western. Term nice evidence thought around.	OPEN_TO_ALL
bd051ca1-8c34-47b5-8a5f-f2c8b051e423	Albert Cook	Mouth program no someone.	https://jones.org/faq/	{}	http://www.ford.com/main.php	MEDIUM	\N	1	1	3	At exist before. Beautiful sort five special recognize by. Help staff small nothing know or which focus. House environmental everything today. Easy phone box different strategy opportunity.	Scene from gun her woman heavy I. Talk success news group event save. Truth important travel at produce environmental full. If blue person need sign. Poor goal arm raise worker season reflect mind.	Sort continue eight. His consider system hand experience be. Structure letter amount education. Risk six miss over purpose. Law teacher reduce network describe if instead.	Trade field truth focus skin large. Door executive reduce summer. Wait live project push west good. Series positive like specific note event large. Purpose pull nature sit feel example fact chance.	OPEN_TO_ALL
eedbc66d-f740-409d-abff-ac48c8fa2d7d	Brandi Schroeder	Single decade eat meeting fight sense.	http://www.hartman-kramer.com/	{"{\\"url\\": \\"https://dummyimage.com/11x30\\"}"}	http://buchanan.com/homepage.php	MEDIUM	Seth Davis	4	5	5	Every animal positive agency describe little ever. Herself message write common create example surface. View anyone discuss because our.	Car range fund author around. Season rest leader situation including within teacher.	Hand develop organization rise police he baby. Admit concern anyone key check place. Product phone evidence significant ask everybody.	Gun tell simply industry. Detail deep know check increase summer.	OPEN_TO_ALL
6de817ed-20b6-4385-8c69-57bc00f8c28f	Emily Rocha	Rather tonight society mother base detail.	http://www.rosales.info/	{}	http://martin.com/terms.htm	MEDIUM	Jason Fernandez	9	10	3	Include wait prevent discussion. Him despite wear. Thing certainly consumer soldier that. Reduce cup remain scene.	Board blue much bank view majority alone. Difference result modern they realize shoulder white. Hold upon how chair wife. Official even probably up role class ever. Single whose wall owner group choose yourself.	Still huge as personal machine. Figure its next kitchen. Case moment local nice agent. Write him city family edge war offer.	Himself structure work nearly adult. South customer director speak mind. Agency best quite trouble think man.	REQUIRES_APPLICATION
a1b79cac-a484-44c4-a04d-47b71b5190e3	Jordan Mcconnell	Suffer glass discussion business marriage relate.	http://tucker.com/	{"{\\"url\\": \\"https://placekitten.com/878/493\\"}"}	http://collins.com/tag/main/search.php	MEDIUM	Stephanie Swanson	3	9	5	Strategy capital senior describe hundred already. Subject finish court itself if after home.	Material why ago doctor send page short. Care same score note. Protect parent seek about article world age.	Southern me themselves assume class hit set. Expect make against fund scientist. Free whom result protect into hope report. Face president investment which.	Carry nor back turn already account image. Common source necessary national. Physical service somebody husband more billion never.	REQUIRES_APPLICATION
625451d9-d6c3-4de9-b00e-db9dd223f917	Paul Underwood	Stay vote family candidate.	http://www.mahoney.com/	{}	https://www.allen-martinez.com/register/	MEDIUM	Carl Hamilton	4	1	3	Brother newspaper watch. By old style describe watch risk. Anyone pull main dog. Across when accept wear.	Sing already kind dog expect though bad white. Hospital risk spring ready begin. Time activity approach receive go compare. Figure administration different son chair apply.	Build force could score cold history improve. Practice style spring. Project only agreement test career easy movie. Activity pay ball capital.	Lawyer everything mind more skin wife thousand. Above car family cup. Candidate necessary partner prevent few attack country. Simply subject race future wind oil. Though choice answer base involve safe very.	REQUIRES_APPLICATION
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
    ADD CONSTRAINT initiatives_pkey PRIMARY KEY (initiative_uuid);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (role_uuid);


--
-- PostgreSQL database dump complete
--

