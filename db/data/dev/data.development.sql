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
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
3209675034946	2021-02-24 22:23:15.855841	2021-02-27 22:23:15.855841	f	97865a1a-dd87-4c36-9980-cb16535515fb	Stuff decision member such avoid.	{}	http://www.bailey.com/	2021-03-06 22:23:15.855841	2021-03-10 22:23:15.855841	Eat performance herself discuss reach. Assume somebody worker meet no method decade almost. Simple worker set board factor.
6405187353682	2021-03-02 22:23:15.857044	2021-03-06 22:23:15.857044	f	18f5451f-6686-4499-ae17-e5ec4de72801	Practice score across write vote collection.	{}	http://www.howell-swanson.com/app/main/	2021-03-13 22:23:15.857044	2021-03-15 22:23:15.857044	Step clearly base thousand rich kitchen oil wonder. Film full despite including none mention run tough. Kid nice have real bit.
4897472791743	2021-02-24 22:23:15.858081	2021-03-01 22:23:15.858081	f	635d9834-ff29-48aa-91da-59ce28f4d773	Eight perhaps police vote challenge score responsibility.	{}	https://www.meyers.com/app/tags/privacy/	2021-03-08 22:23:15.858081	2021-03-16 22:23:15.858081	Long support style life process. Will best itself beat. Ready apply century fear.
1944170978228	2021-02-27 22:23:15.859222	2021-03-03 22:23:15.859222	f	4bc69871-b3fc-4e73-aff6-aa2efa403497	Voice three old some walk everyone think.	{}	http://www.solis.biz/homepage/	2021-03-09 22:23:15.859222	2021-03-10 22:23:15.859222	Public perhaps when military themselves. According since upon what investment break.
4919716513192	2021-02-25 22:23:15.860103	2021-03-02 22:23:15.860103	f	ef1d7dab-4eb9-48a7-83f2-07b80cce485b	Key rock contain charge.	{"{\\"url\\": \\"https://placeimg.com/135/116/any\\"}"}	https://garcia.com/terms.html	2021-03-08 22:23:15.860103	2021-03-12 22:23:15.860103	Act over film federal goal mother still. Democratic student control poor try certainly idea between.
1522587603799	2021-02-20 22:23:15.8705	2021-02-24 22:23:15.8705	f	7daf4bb0-9a16-45ea-a307-399defd23411	Office wife painting bag one small theory.	{"{\\"url\\": \\"https://placeimg.com/447/181/any\\"}"}	https://www.ware-holt.biz/login/	2021-03-04 22:23:15.8705	2021-03-13 22:23:15.8705	Kind tend hard. Body likely hear early movement particularly themselves. Town back reach unit number science thus because.
0310295543374	2021-02-16 22:23:15.871297	2021-02-19 22:23:15.871297	f	e35e42b0-546b-47c3-840b-972416b967a2	Her we particularly step why size past.	{"{\\"url\\": \\"https://dummyimage.com/334x317\\"}"}	https://www.thomas.com/app/posts/wp-content/home.htm	2021-02-27 22:23:15.871297	2021-03-07 22:23:15.871297	Life benefit so sometimes star. Despite open professor debate goal. List finally ever need city.
8407740427234	2021-02-24 22:23:15.872311	2021-03-02 22:23:15.872311	f	e3d3dca4-84e9-472b-bec1-ab263475639c	Traditional open suggest stuff.	{}	http://www.bird-taylor.info/login/	2021-03-08 22:23:15.872311	2021-03-15 22:23:15.872311	Success themselves possible source. Next single phone fear car mean.
1106407802953	2021-02-19 22:23:15.877522	2021-02-22 22:23:15.877522	f	6ffa5d7b-c251-4513-81cf-3ade79826cca	Right send push gun beat seat player.	{"{\\"url\\": \\"https://www.lorempixel.com/455/963\\"}"}	http://www.robertson.org/category.html	2021-03-02 22:23:15.877522	2021-03-06 22:23:15.877522	Culture political just standard model as. Many name interesting four exist certain radio. Dog notice finally start green.
2805818806169	2021-02-12 22:23:15.878477	2021-02-14 22:23:15.878477	f	de8b3a9d-7028-44f8-877a-b90d87b1da9f	Set product real.	{"{\\"url\\": \\"https://placekitten.com/724/906\\"}"}	http://miller-contreras.com/tags/main/category/privacy.html	2021-02-22 22:23:15.878477	2021-02-26 22:23:15.878477	Occur ground become late claim vote stage. Measure me significant left fast dog this attack. With career media analysis such.
3794754186215	2021-02-27 22:23:15.8793	2021-03-04 22:23:15.8793	f	42a060fd-f642-49b3-a097-90b7aa13a896	Ever bed other be performance.	{}	http://parker.org/	2021-03-10 22:23:15.8793	2021-03-14 22:23:15.8793	Computer attorney campaign manage himself. Mission civil information. Physical moment involve may. Bar choice fast chair. Avoid season tell know.
8863416929790	2021-02-28 22:23:15.88395	2021-03-05 22:23:15.88395	f	3047b6e4-04b2-4349-bd66-297425ab844d	Born building medical much often seat.	{"{\\"url\\": \\"https://placekitten.com/873/456\\"}"}	https://estrada.org/posts/faq.htm	2021-03-12 22:23:15.88395	2021-03-13 22:23:15.88395	Policy there again mother check note. Section natural moment sport result billion. Kind fly life perform manage heavy stop. Save Mrs religious why. Vote song draw story.
9266058486406	2021-02-27 22:23:15.884566	2021-03-01 22:23:15.884566	f	7304a046-96af-4ff9-9d73-25484de4d1ea	Character now management.	{"{\\"url\\": \\"https://placeimg.com/305/370/any\\"}"}	https://pena.org/	2021-03-09 22:23:15.884566	2021-03-19 22:23:15.884566	Brother but candidate per society. Maintain just risk food say there.
1079641432173	2021-02-22 22:23:15.885369	2021-02-26 22:23:15.885369	f	e3e66bdf-7959-495b-9b98-40c460be35d8	Enter property cultural event.	{}	https://www.jones.info/post.asp	2021-03-06 22:23:15.885369	2021-03-10 22:23:15.885369	Financial begin should friend among draw question. Civil article look radio full anyone. Phone reduce draw carry thought a scientist.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
6552796419978	2021-02-17 22:23:15.873063	2021-02-22 22:23:15.873063	f	a6b88897-87b4-45ad-81bd-6b0e4f9dc3a0	Kristie Olson	1	http://www.nguyen.info/index/	{"{\\"url\\": \\"https://www.lorempixel.com/396/545\\"}"}	Mr late view green theory husband to. Better finish international officer free develop manage operation. Sort way vote like control return. Require blue reality discussion cold yet technology.	{0924638825500,5738194029778}	{1522587603799,0310295543374,8407740427234}
4075731717004	2021-03-03 22:23:15.879932	2021-03-06 22:23:15.879932	f	7aa99a52-6f27-4ad4-8287-ee00023e3637	Michael Lee	2	http://harmon.org/search.htm	{"{\\"url\\": \\"https://www.lorempixel.com/450/765\\"}"}	Same church boy new down land. Near tell deal be pattern. Fish through play ten here century exactly.	{3487399704561,3428841842691}	{1106407802953,2805818806169,3794754186215}
9102088655200	2021-02-21 22:23:15.886166	2021-02-25 22:23:15.886166	f	7aa91703-3e1c-4362-9fa4-1b368eb9ce46	Gabriel Colon	3	http://www.hughes.biz/register/	{}	Green not old authority one my. Watch support likely minute behind manage evening. Collection significant budget one modern stuff.	{3555529446589,6825213604548}	{8863416929790,9266058486406,1079641432173}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (notification_uuid, channel, recipient, message, scheduled_send_date, status, send_date) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
4068143260411	2021-02-23 22:23:15.834189	2021-02-28 22:23:15.834189	f	692a4177-debf-4572-964d-e253a0edec15	Memory someone speech card really decade.	{"{\\"url\\": \\"https://www.lorempixel.com/426/302\\"}"}	http://www.dunn.com/	https://may.org/register/	MEDIUM	{8980333624017}	{}	6	2	8	Meeting determine receive able firm. Throw in yourself analysis. Leader fund subject gun statement let particular. Fire garden somebody player pull even. Style father nothing line look give fill.	Federal office second concern friend. Reflect true discuss to level. Learn industry financial less little trade.	Fear tell send must house thus. Employee establish heart.	Short million hospital candidate work growth. City choose its face if meeting. Strategy here pass sort staff direction community.	REQUIRES_APPLICATION
7014408923895	2021-02-16 22:23:15.83632	2021-02-19 22:23:15.83632	f	1b8280b9-cf47-4c7f-8899-fd5a3d373550	Concern act price.	{"{\\"url\\": \\"https://placekitten.com/599/654\\"}"}	https://www.myers.com/	https://soto-kim.biz/	MEDIUM	{9017531814779}	{2745285725337}	6	8	4	Certainly become never language instead cover. Lawyer vote chance increase it attorney. Growth site say mother either.	Drug everyone near field. Mission realize with through lot. Share spring effect series.	Able behind role realize man and west. Painting although eat woman consider similar. End trouble last. Ball scene help expect meeting look perhaps here.	Word value us enough bring look next. Why everyone million against son mention. Agree billion better term method. Writer other glass place various case old space.	OPEN_TO_ALL
3503162578372	2021-02-17 22:23:15.838273	2021-02-19 22:23:15.838273	f	7befe3ee-9a0a-44a4-91d7-1ce8f7c19caf	Owner build organization cultural police staff.	{"{\\"url\\": \\"https://placekitten.com/845/696\\"}"}	http://www.berry-herman.com/wp-content/wp-content/about/	https://williams-walker.biz/explore/app/post.htm	MEDIUM	{2923891225421}	{}	3	8	7	Production call traditional single fire. Same specific area bit truth. Animal necessary approach Mrs training state. Day whose heart explain no.	Boy people apply soon. Few fund school feeling coach. Food radio now management institution. Law cover speech people.	Run thought Congress happen. Kitchen education people floor management. Report my foreign later. Writer factor eye describe view cost. Knowledge true important particular least.	Dark score fall once once together indicate. Dinner town reality line sister. Test chair late rather. He inside nothing practice turn source build. Feel human doctor on bit environmental.	REQUIRES_APPLICATION
9633914892556	2021-02-26 22:23:15.840098	2021-03-02 22:23:15.840098	f	c0e1ad67-831c-4d9b-b341-a81cb8e876cd	Crime wait analysis rich.	{"{\\"url\\": \\"https://placeimg.com/45/58/any\\"}"}	http://rodriguez-smith.org/search/home.htm	http://www.smith.biz/post/	MEDIUM	{5426580415952}	{8316964751394}	2	5	3	Able field join arrive member conference very. Second manage themselves trade upon focus nation. Maybe provide again seem what.	Leg market remain attention. His walk remain bank level particularly. Group magazine arrive final. Research major about administration exist away. Investment at can behavior step friend know.	Physical catch subject community window stand. Life author strong market. Arrive station me when hair. Skill easy term meeting anything somebody stage. Civil traditional data item and.	Skill or answer picture. Prepare officer other usually others civil figure. Gas condition dark to. Half mother later even support down exactly.	OPEN_TO_ALL
6662052109816	2021-02-22 22:23:15.842187	2021-02-25 22:23:15.842187	f	f65107aa-dfd4-4ec7-875d-ecbaf6448bf2	Yourself clearly PM.	{"{\\"url\\": \\"https://placeimg.com/525/286/any\\"}"}	https://scott.biz/main.asp	http://www.lloyd-dixon.com/register.html	MEDIUM	{0623629542500}	{}	5	9	9	Give oil thousand upon will land include. Cost second ahead large behavior all let. Risk people many purpose run cold management travel. Everybody good provide never.	Key magazine anything green significant draw. Service smile then car. Thus yourself affect serve show probably current. Significant face song walk window.	Idea yes response any want weight professional. Hope camera others control woman issue tree before. So stuff next success. Any last five adult name major knowledge American.	Smile low mouth decide record. Total perform though human almost Mrs.	REQUIRES_APPLICATION
0924638825500	2021-02-22 22:23:15.867549	2021-02-26 22:23:15.867549	f	389bbb04-d8ed-460a-a551-589225f37f94	Across reach service class.	{"{\\"url\\": \\"https://dummyimage.com/111x1008\\"}"}	https://harris-cooper.com/author/	https://www.brown.org/faq.html	MEDIUM	{2022506556599}	{0619822953533}	3	9	6	Include send man next range expert. Memory whom section watch business above offer. Cup century claim later.	Happen building good weight should. Clear author shoulder check throw develop key blue. Concern medical suggest.	Push past while bill short. Radio character current avoid. Ability describe factor. Something truth in pay food.	Have agree pattern site notice feel understand. Tend key claim out professor south cut within. Front international actually story concern prevent nature. Until require low give keep. Computer all rather pressure himself our those accept.	OPEN_TO_ALL
5738194029778	2021-02-26 22:23:15.868886	2021-03-02 22:23:15.868886	f	e95eafe0-dece-45d6-be27-1be006c106d3	Likely contain especially list.	{"{\\"url\\": \\"https://www.lorempixel.com/752/75\\"}"}	http://www.delgado.com/search/main/post.html	https://www.howard.com/	MEDIUM	{2089706301763}	{}	2	4	4	Choice be method stuff yet movement cell. Whole woman point spring follow month.	Senior operation police gas. Rest and about visit decide. Good couple star among few shake federal.	Couple describe staff six help machine. Whose accept outside knowledge then state shoulder. High goal culture trouble fund.	Since even special worker decision choice responsibility. If region well claim before animal town. First across high drug.	OPEN_TO_ALL
3487399704561	2021-02-14 22:23:15.874107	2021-02-19 22:23:15.874107	f	11cb771c-f5a5-45b4-bb38-45c5b6b883bc	Tell industry them toward current.	{"{\\"url\\": \\"https://placekitten.com/691/500\\"}"}	https://www.woods.biz/app/about/	https://robinson.com/author/	MEDIUM	{4094643678562}	{7223565260334}	3	9	5	Fact responsibility medical include live dark. Fight agency could line stop free human. Challenge product arm note win song. Bit appear move parent then.	Moment hotel goal face. However poor easy ask. City language way move.	General word see treat true myself. Answer family team later mention instead certain. Similar him rise deep of.	Material of traditional. National pull red cost where. Now effort yourself product common. Often way magazine.	REQUIRES_APPLICATION
3428841842691	2021-02-15 22:23:15.875756	2021-02-18 22:23:15.875756	f	eb42b88e-5306-484d-b117-30b60b1dd579	Mother avoid new know whole production protect kitchen.	{"{\\"url\\": \\"https://dummyimage.com/999x545\\"}"}	http://www.hoffman.com/search.html	https://www.gibson.com/index/	MEDIUM	{7080685660501}	{6961038690608}	3	3	6	White decide sport reduce reality whether. Dinner student range painting sometimes.	Present throw modern policy authority tax. Anything majority feeling call. Lawyer character everybody.	Country thank model son. About great region however thing. Me across despite western just. Ability physical hard rule.	Tax service consider attention well east become. Reflect I tough those care work degree. New medical themselves attention next.	REQUIRES_APPLICATION
3555529446589	2021-03-03 22:23:15.881067	2021-03-06 22:23:15.881067	f	df227d47-72e1-4022-8ca3-dbb6b9f94a7d	Defense others population ready act end behavior describe.	{"{\\"url\\": \\"https://dummyimage.com/598x627\\"}"}	https://www.alvarado-reynolds.com/	http://young.net/	MEDIUM	{3287223588141}	{}	2	8	5	All foot material political affect skin party. Soldier wide thus general capital. Mission cold such president put officer against car. Rock shake education often west.	Government voice list society. Huge wonder may sport.	You sense meeting always him hit. Human director travel record. Thank discuss yet improve development suggest common. Shoulder generation audience hour attorney.	Body consider drop girl prove position. Maybe door reality professional service national between. Through responsibility young blue environmental.	REQUIRES_APPLICATION
6825213604548	2021-02-15 22:23:15.882589	2021-02-19 22:23:15.882589	f	42f0c635-99d0-4ca0-b0eb-12370f806508	Sea begin agree.	{}	http://robinson-rose.info/about/	https://www.hoffman.biz/main/author/	MEDIUM	{2457449063864}	{9772853918757}	6	4	6	Clear support plant generation as foreign your. Off best operation interview these understand. In rock air book provide same. Stock help college course station. Meet child ago happen talk public.	Fine process east organization late. Leader event scientist walk another important. Interview increase cell there help huge shoulder.	Society remember toward try itself alone physical. Feel across energy customer. He risk opportunity camera kid box. Exactly prevent or manager child range.	Suddenly hit white order fire national before. Poor study idea parent. Discussion TV individual total by. Eye guess brother cold fact.	REQUIRES_APPLICATION
\.


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
-- PostgreSQL database dump complete
--

