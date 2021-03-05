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
    signup_link text NOT NULL,
    start timestamp without time zone NOT NULL,
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
    description text NOT NULL,
    roles character varying[] NOT NULL,
    events character varying[] NOT NULL,
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
    role_type public.roletype NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL
);


ALTER TABLE public.volunteer_openings OWNER TO admin;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.accounts (
    uuid uuid NOT NULL,
    email text NOT NULL,
    username character varying(255),
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    "password" text,
    oauth character varying(32),
    profile_pic text,
    city character varying(32),
    "state" character varying(32),
    roles character varying[],
    initiative_map json,
    organizers_can_see boolean,
    volunteers_can_see boolean
);


ALTER TABLE public.accounts OWNER TO admin;

--
-- Data for Name: donation_emails; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.donation_emails (donation_uuid, email, request_sent_date) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (uuid, id, event_name, event_graphics, signup_link, start, "end", description, airtable_last_modified, updated_at, is_deleted) FROM stdin;
f9ea092f-4b7b-4f60-b302-abf420636744	6784424946130	Carry despite rate myself once just.	{}	http://www.mcdonald-montgomery.net/category/search/wp-content/terms/	2021-01-28 01:22:08.227006	2021-02-01 01:22:08.227006	Too great statement particularly local reason. Way include dog certainly big. Because bar money garden lose away set. Consider black risk weight change phone they. Fine quite rule kind identify including.	2021-01-18 01:22:08.227006	2021-01-21 01:22:08.227006	f
eb798a7d-cb76-408f-b0ea-919b1bd755d9	7910624948868	Let serve lead practice however station on.	{}	https://chandler.com/	2021-02-04 01:22:08.22788	2021-02-06 01:22:08.22788	Decision national management card live nothing. Over clear off help analysis education federal cause. Several partner any chair.	2021-01-24 01:22:08.22788	2021-01-28 01:22:08.22788	f
29374c7c-9899-4da0-81fc-d04e9dcb66b3	8885771340645	Though nearly statement money window present surface.	{}	https://www.smith.net/search.html	2021-01-30 01:22:08.22858	2021-02-07 01:22:08.22858	Reflect above heart perform. Put thus common back financial partner.	2021-01-18 01:22:08.22858	2021-01-23 01:22:08.22858	f
4cdb546b-b190-4650-a13b-f89d2b6e1505	6175373760975	Or relate trial job.	{}	http://www.cunningham.com/tags/blog/post.htm	2021-01-31 01:22:08.229213	2021-02-01 01:22:08.229213	Weight manage time just visit market commercial. Play contain case executive leg. Wall eight price.	2021-01-21 01:22:08.229213	2021-01-25 01:22:08.229213	f
bb1b70ac-29c3-431e-8c31-51346c181e85	7282714554731	Unit police phone economy arm beat.	{"{\\"url\\": \\"https://placeimg.com/923/732/any\\"}"}	https://www.knight-drake.com/wp-content/explore/search.html	2021-01-30 01:22:08.229795	2021-02-03 01:22:08.229795	Actually apply not pay bar indeed difficult. Should it very mean stand during. Itself trouble follow magazine run year. Pull us study environmental same shake various ability.	2021-01-19 01:22:08.229795	2021-01-24 01:22:08.229795	f
92027070-7362-4932-b651-5383a4cfc511	5395507750158	Early possible popular actually discuss Congress those quality.	{"{\\"url\\": \\"https://dummyimage.com/843x606\\"}"}	http://johnson-murillo.com/author.html	2021-01-26 01:22:08.237768	2021-02-04 01:22:08.237768	Might reveal realize interesting happen minute. Democrat despite eat help character.	2021-01-14 01:22:08.237768	2021-01-18 01:22:08.237768	f
c2eb853a-cf24-4f86-8e00-1dda6ad113cd	2566253296181	Fall wrong example.	{"{\\"url\\": \\"https://dummyimage.com/613x303\\"}"}	https://www.fleming.com/tag/category/index.html	2021-01-21 01:22:08.238205	2021-01-29 01:22:08.238205	Lay hundred parent staff. Own today organization food its. We religious professional single stay teacher.	2021-01-10 01:22:08.238205	2021-01-13 01:22:08.238205	f
c1c82fa3-1555-474e-bdc1-6c5db289819a	4815894839836	Prepare deep policy this.	{}	https://holder.biz/terms.htm	2021-01-30 01:22:08.238726	2021-02-06 01:22:08.238726	If gun attorney community true whatever create. Language choose arm population. Pressure push indicate much onto. Those section political home simple onto window. Third bring voice development card every teacher.	2021-01-18 01:22:08.238726	2021-01-24 01:22:08.238726	f
6314d2d3-8c0c-4317-b8b1-25f9ce921448	3456826216427	Fund score series goal skill happy.	{"{\\"url\\": \\"https://www.lorempixel.com/114/321\\"}"}	https://www.lamb.net/categories/homepage/	2021-01-24 01:22:08.241491	2021-01-28 01:22:08.241491	Show cultural young dinner Mrs. Guess research president. Watch dream trip nice middle decide.	2021-01-13 01:22:08.241491	2021-01-16 01:22:08.241491	f
f57b6481-fe70-4b43-a57f-9873e7a7eaa6	6467461855282	Job not part someone among example my.	{"{\\"url\\": \\"https://placekitten.com/1016/37\\"}"}	http://middleton.com/	2021-01-16 01:22:08.24199	2021-01-20 01:22:08.24199	Anyone response task. Guess hundred road me difficult tax teacher.	2021-01-06 01:22:08.24199	2021-01-08 01:22:08.24199	f
8cce40e3-bb1c-47b4-9c6a-782bf8725c5f	9357988210619	Majority world door.	{}	http://brown-morris.com/about/	2021-02-01 01:22:08.242476	2021-02-05 01:22:08.242476	Rather whose painting grow name. Usually size medical take both approach red.	2021-01-21 01:22:08.242476	2021-01-26 01:22:08.242476	f
f9ced706-21ef-425d-aa8b-ae1f0245ae92	2811940501797	Season analysis them important we.	{"{\\"url\\": \\"https://placekitten.com/57/508\\"}"}	https://www.randolph.com/search/	2021-02-03 01:22:08.245257	2021-02-04 01:22:08.245257	Law movement admit focus. Walk relationship very course serve often news. Dinner somebody room safe recently.	2021-01-22 01:22:08.245257	2021-01-27 01:22:08.245257	f
088ef2d6-13b4-4ae2-9712-7da9b26e243d	1193631247582	Left politics need class operation doctor both.	{"{\\"url\\": \\"https://dummyimage.com/648x793\\"}"}	http://www.hudson.com/	2021-01-31 01:22:08.245632	2021-02-10 01:22:08.245632	Front but girl reveal. Tax past federal offer. City indeed operation activity mention contain spend.	2021-01-21 01:22:08.245632	2021-01-23 01:22:08.245632	f
6e400065-54cf-4259-9786-e782d2496ba2	6507991929845	Threat several together land with test reality commercial.	{}	https://www.alexander.com/login/	2021-01-28 01:22:08.246001	2021-02-01 01:22:08.246001	Expect mother election become. Almost central themselves account decide apply.	2021-01-16 01:22:08.246001	2021-01-20 01:22:08.246001	f
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (uuid, id, initiative_name, "order", details_link, hero_image_urls, description, roles, events, airtable_last_modified, updated_at, is_deleted) FROM stdin;
7bafb2c7-3520-4a2d-bed9-faf5a01e906e	4106864323401	Dawn Randall	1	https://johnson.biz/main/	{"{\\"url\\": \\"https://dummyimage.com/610x539\\"}"}	Day PM seven free meet executive read. Have tough another himself possible second. Democrat training ball cell.	{7729434073444,4576902571093}	{5395507750158,2566253296181,4815894839836}	2021-01-11 01:22:08.239251	2021-01-16 01:22:08.239251	f
5ffd4b11-16dd-4a30-8c11-20eda2857044	8245341732407	Susan Harper	2	http://patterson.net/posts/main/	{"{\\"url\\": \\"https://www.lorempixel.com/985/561\\"}"}	Individual picture before may or need crime. Be analysis south recent. Tend another citizen environmental.	{4385078100651,9519619906739}	{3456826216427,6467461855282,9357988210619}	2021-01-25 01:22:08.242862	2021-01-28 01:22:08.242862	f
85eebfcb-94d3-4166-b379-202d06068eb6	2069778697803	Robin Miller	3	https://www.roberts.com/categories/post.asp	{}	School much discuss role. Senior soldier agree upon. Property fact country subject true contain truth.	{3897109175923,6553539697219}	{2811940501797,1193631247582,6507991929845}	2021-01-15 01:22:08.246323	2021-01-19 01:22:08.246323	f
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (uuid, id, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type, airtable_last_modified, updated_at, is_deleted) FROM stdin;
42b8640c-cf91-4202-adbe-a6bae0ae8fbb	8437924047187	Nature determine let identify husband.	{"{\\"url\\": \\"https://dummyimage.com/302x959\\"}"}	https://www.simmons-daniels.com/wp-content/tag/category/terms.jsp	http://www.ramirez.org/terms.html	MEDIUM	{3251374294510}	{}	6	2	8	Respond require wall ok black color few. Personal instead now position fund floor. Must them relationship student. National surface assume land three.	Career store same society. Baby energy charge dog place. Spring knowledge issue article.	Guess individual specific nation. Site series pass already remain end find type. Across million anything your statement and as.	Task recent me point successful expert war. Future rock seat company degree support. Leader a should difficult. Way moment these name approach deal else.	REQUIRES_APPLICATION	2021-01-17 01:22:08.209525	2021-01-22 01:22:08.209525	f
318ac383-c259-4b54-8ba3-033662c37f9e	9048416427678	Picture teacher still physical when.	{"{\\"url\\": \\"https://placeimg.com/571/170/any\\"}"}	http://watson.org/	http://evans-robinson.biz/faq/	MEDIUM	{5643164737358}	{4525726779734}	6	8	4	Summer all animal wish country. Carry teach method us.	Type soldier send popular. Task goal agree I. Reality either word beautiful. Main medical she. Town charge benefit couple dinner today even.	Lawyer young think. Miss officer thought conference. Level song situation fact return business.	Kitchen mission popular bit. Red television paper animal. Strategy upon memory surface guy.	OPEN_TO_ALL	2021-01-10 01:22:08.212245	2021-01-13 01:22:08.212245	f
c5ca47a1-ba2f-483c-b592-f30212620bb3	6852286956588	Member left head huge drive close.	{"{\\"url\\": \\"https://placekitten.com/384/289\\"}"}	http://stanley-green.net/blog/home/	http://lopez.org/categories/login/	MEDIUM	{9795990930727}	{}	3	8	7	Free nothing east fear. Number same either too money treatment. Reach company always third hotel.	Increase discussion central. Scene allow much simple. Present check their level leader.	Ball show machine reality whatever issue. Season poor trip could above.	Offer sure until. Song attack us write thus improve. Role however company central rest. Company him compare environment line surface. Believe community pull dog.	REQUIRES_APPLICATION	2021-01-11 01:22:08.21418	2021-01-13 01:22:08.21418	f
4f97a873-fa87-4d23-a10a-76e52336ae7e	8217528947621	Newspaper view feel beat eight.	{"{\\"url\\": \\"https://placeimg.com/1007/458/any\\"}"}	https://www.ramsey.com/explore/list/category/	https://davies-frazier.org/posts/explore/terms/	MEDIUM	{1269480519757}	{9505192625709}	2	5	3	Imagine key it dream civil watch fear. Follow certainly movement why dark least staff. Old and reveal art address people. Pressure top increase action often continue. Public pick nation environmental.	Pattern say then probably join policy reduce. Region population information interest issue could result. Walk fish goal report catch.	Few consider rule phone art. Painting although here consumer much. Together popular special news develop.	Movie seat compare item. Tax star lose save agency. Left relate few. Today summer city serve happy us each billion.	OPEN_TO_ALL	2021-01-20 01:22:08.215663	2021-01-24 01:22:08.215663	f
332421f4-2d39-4519-bb49-fa25edc1dc05	9133358114004	Perhaps food two represent business anyone research.	{"{\\"url\\": \\"https://www.lorempixel.com/710/449\\"}"}	http://mitchell.com/	https://www.howard.org/privacy.html	MEDIUM	{9451728676960}	{}	5	9	9	Evidence within head. Language garden military most life second. Score turn tend always source. Fear himself sea meet rule political.	Evening employee training sense require. Fly wind success deal field. Population others life standard real cold threat. When safe modern.	Join return follow whether free. Language animal Mr democratic.	Significant heavy site mind very. Accept east suggest.	REQUIRES_APPLICATION	2021-01-16 01:22:08.217559	2021-01-19 01:22:08.217559	f
bb52433f-cb46-4cf6-8922-965d47456990	7729434073444	Realize attention like sea difference discuss behind.	{"{\\"url\\": \\"https://placeimg.com/785/324/any\\"}"}	https://www.walker-williams.com/	https://ford-hester.com/list/search.html	MEDIUM	{9993910083229}	{2032952952296}	3	9	6	Quite away dog stock billion. Above majority involve blood beautiful.	Fill catch along tend parent set forget. Bill wrong leave garden you personal. They into ready daughter.	Image major mention election property stuff material accept. Teacher or pay great. Describe occur trade medical.	Mind baby current office. Lot each my during.	OPEN_TO_ALL	2021-01-16 01:22:08.235653	2021-01-20 01:22:08.235653	f
f06f05ce-4767-4f7d-aebf-32d5ba1529dd	4576902571093	Give peace skill pay ask.	{"{\\"url\\": \\"https://placekitten.com/17/744\\"}"}	http://www.kelly.info/login.asp	https://www.casey.biz/tags/about.php	MEDIUM	{5258420923446}	{}	2	4	4	Blood plant must shake air nor white. Eight develop recent new anything.	Heart time bag your sell. Phone four production investment. Less stay Mrs drive wall which subject. Bed man allow quite but as good.	Believe way shake remain a nothing subject role. At lead character finally. Price set throughout somebody. Writer more feel nothing hear. Bad single strong behavior thing marriage.	Sure loss on every whatever. Husband end clearly Congress cold develop well. Possible newspaper continue cultural mission.	OPEN_TO_ALL	2021-01-20 01:22:08.236816	2021-01-24 01:22:08.236816	f
8526937e-6dce-4b6e-b42d-ceb86e9e8e2c	4385078100651	See peace possible ready prevent kitchen.	{"{\\"url\\": \\"https://www.lorempixel.com/564/722\\"}"}	http://www.hancock.com/index/	https://morris-hill.com/index/	MEDIUM	{6203995579085}	{5616164701070}	3	9	5	Offer degree positive. Operation parent lay major building stand. Player side player ever across. Tend several themselves win above long piece. Owner leg often course what.	Husband one imagine teach back heart. Imagine gas new parent over direction almost. Foreign hope space bill. Itself yeah energy main. Community director strong perform camera modern now.	Movement reason finish charge show. Bring positive nearly entire own very feel forward. Memory prove include top owner. Inside enough whose boy.	His director he family resource stuff everybody. Former music fill ago market majority. Within approach room experience product than.	REQUIRES_APPLICATION	2021-01-08 01:22:08.23979	2021-01-13 01:22:08.23979	f
2511e891-88a5-4c34-9362-bf5faafb7e63	9519619906739	Media else rate Mr method resource body blue.	{"{\\"url\\": \\"https://www.lorempixel.com/142/162\\"}"}	https://taylor-smith.com/homepage/	http://bass.com/login.htm	MEDIUM	{2752450406816}	{0539596660638}	3	3	6	East him shake put common still look chair. World recently go bring. Provide maintain cold. Language summer time enter skill much.	Feel stock around budget heart type. Us not despite think mention.	Pick so house. Throw popular share eye sometimes may. Whom explain together reach there. Material speech common military.	Coach hope small second show everything billion. Professor financial more. Middle style fill raise blood note.	REQUIRES_APPLICATION	2021-01-09 01:22:08.240649	2021-01-12 01:22:08.240649	f
ac750e6d-8258-43e6-866d-c8ad86d6a1cc	3897109175923	Throw listen some much although.	{"{\\"url\\": \\"https://www.lorempixel.com/797/803\\"}"}	http://stevens.com/	https://www.fischer.com/	MEDIUM	{3747361773309}	{}	2	8	5	Voice campaign computer recently various its book. Health crime science life forget indicate feeling. Series according high life none series.	Push the push more. Might message area hit without measure. Traditional explain again big life address on.	Thing address man step. Trouble offer feel life economy yard little student. Cover body home worker feeling enjoy.	Person enjoy production. Of quite defense action claim someone hear. Allow test sea large sort different store.	REQUIRES_APPLICATION	2021-01-25 01:22:08.243512	2021-01-28 01:22:08.243512	f
2c638552-288b-49ed-a8c4-b795f8e9e0f5	6553539697219	Sister different generation successful key expect former.	{}	https://www.khan.com/tag/author.jsp	http://www.watson.com/about.jsp	MEDIUM	{0315127836938}	{7665968926651}	6	4	6	Rate wife pattern can. Least with close officer paper. Property decide test guy later. Person discover now agreement.	Level own thus several Congress seek animal. Mr quality ahead clear any star arrive. Fire civil order maybe account voice. Huge special hair hundred.	End street see. Certainly future fight yard. Pick avoid home painting face. Outside loss action report star hair most.	Political save whether world. Plan million power. Republican reality safe.	REQUIRES_APPLICATION	2021-01-09 01:22:08.244344	2021-01-13 01:22:08.244344	f
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
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (uuid);

--
-- PostgreSQL database dump complete
--

