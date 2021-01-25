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
e4969ca5-accf-40c8-afa8-24ca9b6ef957	5785007780289	Attention cultural involve sound research nice.	{}	http://www.nelson.net/explore/blog/privacy.asp	2021-01-27 20:55:06.468863	2021-01-31 20:55:06.468863	Especially daughter special very others large. Foot win rock gas clear single. Claim minute great little court enjoy eye kid.	2021-01-17 20:55:06.468863	2021-01-20 20:55:06.468863	f
d97c24f5-b267-4c47-8fd5-68e3ac39ab7a	5256232208706	Fine raise important treatment push school by.	{}	http://www.orr.com/search.html	2021-02-03 20:55:06.469657	2021-02-05 20:55:06.469657	Which hour ago another choice artist. Popular state worry.	2021-01-23 20:55:06.469657	2021-01-27 20:55:06.469657	f
a30bd7e6-9b00-49a6-8417-a51f31ac53b9	8198900805121	Heavy move try product building majority.	{}	https://howard.net/register/	2021-01-29 20:55:06.470049	2021-02-06 20:55:06.470049	Better production case effect form. Staff realize task degree realize.	2021-01-17 20:55:06.470049	2021-01-22 20:55:06.470049	f
3f159a61-85d6-4369-9642-88736ea742ad	6054694600415	No billion tell hair table board.	{}	http://davidson.biz/	2021-01-30 20:55:06.470538	2021-01-31 20:55:06.470538	Positive fear history spend increase. Letter marriage radio. Quality fine another year reflect significant note. Measure place wear rather military end bar reveal. Dream hope Republican fact nature traditional share.	2021-01-20 20:55:06.470538	2021-01-24 20:55:06.470538	f
1bcf9506-bbcf-4e76-b474-0bf5cf8d9fc1	1339246506847	Fight fine off.	{"{\\"url\\": \\"https://www.lorempixel.com/771/835\\"}"}	https://www.anderson.org/tags/tags/post/	2021-01-29 20:55:06.470883	2021-02-02 20:55:06.470883	Difference hand protect social class dream case ten. While bank give its president bed.	2021-01-18 20:55:06.470883	2021-01-23 20:55:06.470883	f
814484af-52a6-411b-a563-0e499a670e9d	3516403917786	Base politics couple institution.	{"{\\"url\\": \\"https://www.lorempixel.com/216/432\\"}"}	https://brown.com/	2021-01-25 20:55:06.478916	2021-02-03 20:55:06.478916	Process view responsibility community food east expect low. Pattern young doctor brother purpose yeah create. Attack seem stay.	2021-01-13 20:55:06.478916	2021-01-17 20:55:06.478916	f
3c87aa1f-8ac9-472f-87dd-418aab2c9787	2083197152422	Candidate attorney shoulder.	{"{\\"url\\": \\"https://placekitten.com/223/417\\"}"}	https://pearson.com/search/wp-content/login/	2021-01-20 20:55:06.479249	2021-01-28 20:55:06.479249	Major hand some try organization particularly. Large study image unit show enter.	2021-01-09 20:55:06.479249	2021-01-12 20:55:06.479249	f
a7910a13-0da7-4b61-895e-fac389d56b4b	2532997457232	Citizen help effect last decide.	{}	https://green.net/	2021-01-29 20:55:06.479586	2021-02-05 20:55:06.479586	Traditional their policy him wind subject right. Involve various participant.	2021-01-17 20:55:06.479586	2021-01-23 20:55:06.479586	f
254bc894-28da-4a42-9b66-02f49b46ef17	0186708570264	Development some we church agree culture life another.	{"{\\"url\\": \\"https://dummyimage.com/564x305\\"}"}	https://www.thomas-jones.net/wp-content/main/	2021-01-23 20:55:06.482777	2021-01-27 20:55:06.482777	Should however change window interesting. Debate begin PM more order south. For page up begin black. During key less religious research. Sort development question sea.	2021-01-12 20:55:06.482777	2021-01-15 20:55:06.482777	f
209ef66d-f882-49cb-859e-3680ff8dc719	8737017619780	All sport natural executive across smile heart.	{"{\\"url\\": \\"https://www.lorempixel.com/574/371\\"}"}	https://www.snow.net/posts/category/	2021-01-15 20:55:06.483218	2021-01-19 20:55:06.483218	Agreement sign realize task affect. Who student task sit statement because make. Across good share drug standard identify dog.	2021-01-05 20:55:06.483218	2021-01-07 20:55:06.483218	f
b2c3ce30-134e-4b45-9970-14a6017d7987	1210178779106	Responsibility fact within mean be.	{}	https://payne.biz/posts/register.htm	2021-01-31 20:55:06.483562	2021-02-04 20:55:06.483562	Maintain person job because cause community usually. Study generation specific. Soon wind behavior admit successful dog prevent dinner. Do ten born so. Memory various collection American resource.	2021-01-20 20:55:06.483562	2021-01-25 20:55:06.483562	f
56fe7116-04cd-46f9-ae47-b7035296098d	4870034599445	Education nature store take loss his decision.	{"{\\"url\\": \\"https://dummyimage.com/407x522\\"}"}	http://www.scott.com/author.php	2021-02-02 20:55:06.486401	2021-02-03 20:55:06.486401	Pressure claim chair at. Total decision medical dark challenge meet even. Responsibility popular teacher.	2021-01-21 20:55:06.486401	2021-01-26 20:55:06.486401	f
164b9972-d8c3-42de-8a67-119478778601	2956664303330	Lay pick magazine six nation five Democrat.	{"{\\"url\\": \\"https://www.lorempixel.com/700/292\\"}"}	https://hunter.com/home.htm	2021-01-30 20:55:06.486902	2021-02-09 20:55:06.486902	Mrs local year cultural. Bill feel meeting much capital. Approach lay kind. Fall become push sound move eight.	2021-01-20 20:55:06.486902	2021-01-22 20:55:06.486902	f
4c074528-f92a-443d-8d92-f5caa9773e16	1384682873176	Participant happen reality crime road.	{}	https://robertson-sandoval.com/	2021-01-27 20:55:06.487241	2021-01-31 20:55:06.487241	Way trade city entire some detail. Law indicate often how mind consider part. Fund beyond policy agree tax democratic. Pick itself on officer by fund. Property oil seek billion statement expect collection.	2021-01-15 20:55:06.487241	2021-01-19 20:55:06.487241	f
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (uuid, id, initiative_name, "order", details_link, hero_image_urls, description, roles, events, airtable_last_modified, updated_at, is_deleted) FROM stdin;
8f92f944-47ad-4fce-9ae0-802d4117c3c7	3203100756052	Sharon Smith	1	https://www.smith.com/list/categories/categories/homepage/	{"{\\"url\\": \\"https://placekitten.com/62/817\\"}"}	Already we just determine lead assume. Ask growth reason. Picture kitchen argue far make whether turn. Describe mother watch everyone center they before.	{4220006034281,8278744370754}	{3516403917786,2083197152422,2532997457232}	2021-01-10 20:55:06.48003	2021-01-15 20:55:06.48003	f
29e7f623-c3c3-4ffd-8ac8-5a656bd764c9	0553023149107	Annette Mckinney	2	http://oconnor.net/post/	{"{\\"url\\": \\"https://placeimg.com/144/98/any\\"}"}	Walk possible wrong certain. Account picture other response. Glass service shoulder feeling method program now. Begin performance key yes bad.	{3358200310038,9493589691805}	{0186708570264,8737017619780,1210178779106}	2021-01-24 20:55:06.484082	2021-01-27 20:55:06.484082	f
2df189c9-b8ac-4fa5-b7ab-0d4516af224b	2167081302411	Angela Young	3	http://www.hill.com/	{}	Type enjoy hour state become direction measure. Over in man positive. Know pick fill to sport.	{7692745918509,0171776899003}	{4870034599445,2956664303330,1384682873176}	2021-01-14 20:55:06.487671	2021-01-18 20:55:06.487671	f
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (uuid, id, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type, airtable_last_modified, updated_at, is_deleted) FROM stdin;
b4fd552c-b531-46a1-8754-1d6812138611	3476224345215	Level lead state piece.	{"{\\"url\\": \\"https://placekitten.com/886/722\\"}"}	http://www.shannon.info/search/search.html	http://www.johnston.com/	MEDIUM	{7883760854662}	{}	6	2	8	Quality could act. Will until want big. Action likely loss along. Sure country how spend stop word.	Standard subject suggest word score analysis. Chance call capital reduce morning.	Very challenge form anyone could value arrive article. Least size various source. Budget him fly four. Push war trial attack. Attention late change.	Reveal phone particular program make have international. Meeting wind they democratic board number cultural.	REQUIRES_APPLICATION	2021-01-16 20:55:06.455138	2021-01-21 20:55:06.455138	f
dbf8c4e9-a4a3-41d9-b08a-b622a2e570cf	2428145526731	By analysis scientist cell she war investment.	{"{\\"url\\": \\"https://www.lorempixel.com/586/1012\\"}"}	https://krueger.biz/blog/tags/post/	http://roberts-everett.com/posts/wp-content/posts/main.html	MEDIUM	{1458296722486}	{5474554567824}	6	8	4	Realize fish site save bank meeting success. As western unit stay Congress many. Theory down training increase.	Language network whole activity response create whom. Drop along yes knowledge cause red.	Section something by already center wonder work detail. Place approach provide. Standard heart prevent safe thing ground raise although. Walk training also here big.	There really than subject great late collection money. Loss while half yard. Whom purpose worker near hard brother.	OPEN_TO_ALL	2021-01-09 20:55:06.456753	2021-01-12 20:55:06.456753	f
6f4486c9-8aa7-4c4f-9340-927b03280a79	6529269451070	Camera argue success by enter all foreign.	{"{\\"url\\": \\"https://placekitten.com/840/876\\"}"}	https://www.adams-miller.biz/faq/	http://wilson-gibbs.com/register.asp	MEDIUM	{9432057775364}	{}	3	8	7	Film own black practice rise. Pay together final better drive Mr. Read left in poor simple college. Thousand total region occur economic subject discussion.	Board to material we. Miss total surface support school look it. Long court difficult house.	Form page option finally just measure. Decision support office fear. Make trial service environmental sound national purpose east.	Political again value special. Could shoulder by behind discussion talk. Without agree writer nice team. Raise poor public well. Long better health.	REQUIRES_APPLICATION	2021-01-10 20:55:06.45825	2021-01-12 20:55:06.45825	f
6e2c2667-737b-48da-8a22-01192d7c59b3	6622723344625	Collection institution involve purpose.	{"{\\"url\\": \\"https://placekitten.com/780/569\\"}"}	https://www.patterson.com/search/index/	http://www.phillips.org/posts/list/about/	MEDIUM	{3908942200182}	{7278840336655}	2	5	3	Conference kind also figure tell brother education. Policy with girl simply fight serve stop.	Room much serious table. Member account must need act. Whatever industry term argue vote point.	These suffer indicate great space full in. Role call phone.	Baby tell brother risk. Treatment result voice read chance call some. Investment arrive fast total other seven.	OPEN_TO_ALL	2021-01-19 20:55:06.459565	2021-01-23 20:55:06.459565	f
ea4cdd0d-970d-4f6e-b04b-58e2f94b2211	4810547978559	Education collection according.	{"{\\"url\\": \\"https://www.lorempixel.com/58/15\\"}"}	https://www.flores-hunt.com/tag/category/main.jsp	https://johnson.com/explore/explore/category.html	MEDIUM	{2112993998696}	{}	5	9	9	Trial main including able plant always else. Language arm successful should individual. Conference TV particular work laugh. Officer after stuff large.	Sense between your stand sense race. Work watch pretty increase space thought. Professional mean student child home arm. Reason form government.	True world sea line tree form. Ground certain manager mind successful. Performance leg open board yeah.	All information commercial. Foot ever measure state guess.	REQUIRES_APPLICATION	2021-01-15 20:55:06.46071	2021-01-18 20:55:06.46071	f
0047835b-afcd-4d11-b3f1-63f3ee0a9af5	4220006034281	Effort suggest article history.	{"{\\"url\\": \\"https://placekitten.com/940/174\\"}"}	https://www.cox.org/	http://mayer-harrington.net/index.html	MEDIUM	{6178425654390}	{6051733984147}	3	9	6	Relate free tax allow station seat address. Personal fight few idea. When nothing cold put party.	Value during read poor she everyone. Eye coach doctor attack. Easy relate but check without. Rise early including collection find.	Begin off back red. Many million poor policy key. Down those heavy policy just now course single. Speech wind seven religious expert real.	Thought evidence stock Mrs apply and. Fall job house phone culture.	OPEN_TO_ALL	2021-01-15 20:55:06.476826	2021-01-19 20:55:06.476826	f
bc51063c-aae3-4dc2-9cea-a36613b6a7ca	8278744370754	Model three outside bad history plant old.	{"{\\"url\\": \\"https://placeimg.com/930/38/any\\"}"}	https://estrada.com/search/homepage.asp	https://williams-brown.info/terms/	MEDIUM	{6977259613098}	{}	2	4	4	Reduce table raise hit talk. Night kitchen beyond over go book message. Leave must experience exactly ready sea too. Determine into attention drive night although the.	Wrong half room culture seek religious. Design find financial difficult. Expect which his. Herself lawyer despite maybe within three.	Quite pretty blood director. First second manager our. National mention our result. Which identify defense line easy management discover. Argue process least thought.	Which individual foot form market. Someone democratic cell you. Girl commercial into name.	OPEN_TO_ALL	2021-01-19 20:55:06.477958	2021-01-23 20:55:06.477958	f
95dc4366-b080-48a4-b5b2-04a1ebbde204	3358200310038	Big former thing develop either.	{"{\\"url\\": \\"https://dummyimage.com/899x841\\"}"}	https://williamson.com/	https://brock.net/category.html	MEDIUM	{9739286727028}	{6381828677792}	3	9	5	Perhaps star own remember without. You least down administration. Room task eight where program for put. Century likely all thank phone.	Cultural technology without if wind toward. Chair possible thank east add right just. Set people part success economy whom serious source. Civil home letter agent. Fill situation administration.	Admit hard they. Discuss care happen method discussion.	Almost board career common eat option wait. Responsibility consumer according yeah. Test single put education all. Success figure lay traditional ok site. Beat away share body stuff.	REQUIRES_APPLICATION	2021-01-07 20:55:06.480747	2021-01-12 20:55:06.480747	f
5fdf49ed-5cc9-4008-bbdf-d06bf5d8c2b6	9493589691805	Paper choose station cut quickly.	{"{\\"url\\": \\"https://placekitten.com/364/76\\"}"}	http://serrano-english.com/post.html	https://johnson.com/category/blog/search/homepage/	MEDIUM	{3731274125850}	{7986807682218}	3	3	6	Song wrong with lead traditional adult. Shake when language easy sound. Education purpose chance age outside school them number. Camera build probably agency want white. Religious now agree because chance more seek.	Life born husband contain natural establish music. Ok resource loss animal think. Enter party read list history. Top study easy. Section close occur specific use take.	National pass buy stage to. Kind manager simply reality administration. Live true picture despite travel home. Including among nation tonight.	Child pay training must everything. Big soon weight huge seven bag month. Conference director choose democratic. Often sure resource affect play let work.	REQUIRES_APPLICATION	2021-01-08 20:55:06.481763	2021-01-11 20:55:06.481763	f
899b46c6-f3e5-497e-9684-e960288097bd	7692745918509	Visit black nice strategy whether book college.	{"{\\"url\\": \\"https://placekitten.com/276/754\\"}"}	http://brown.com/	https://haynes.net/search/categories/index.php	MEDIUM	{4544468188338}	{}	2	8	5	Bad law protect other sister produce. Relate enter see with. Shake team trade politics customer instead night.	Tax policy quickly bit draw. Join rate similar vote baby. Able window ability next difference. Not game performance even.	Worry seat conference or still sport mind. Event early phone skill. Father toward pressure argue away amount make. Around run unit attention.	Month area success teach fine. Investment kid recently stage group sure toward. Follow become often garden.	REQUIRES_APPLICATION	2021-01-24 20:55:06.484764	2021-01-27 20:55:06.484764	f
1d63f0d8-d770-4998-aaa3-c5c8a8f4d36e	0171776899003	Them environment similar six reach build.	{}	https://hall-jimenez.com/index.jsp	https://www.anthony.info/	MEDIUM	{1451293035818}	{5808872966982}	6	4	6	Hope development whatever game. Loss time director strong to. Me win most.	Wait politics country scientist machine anything. Assume better skin nearly. Order early threat someone. Indicate ability ability share need goal. From apply economic drug policy.	Effort plant Republican none month those want. Animal commercial today ten show.	Technology billion study staff. Certainly maybe force beautiful community condition reason.	REQUIRES_APPLICATION	2021-01-08 20:55:06.485458	2021-01-12 20:55:06.485458	f
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

