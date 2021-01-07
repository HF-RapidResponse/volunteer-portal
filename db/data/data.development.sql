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
-- Name: events; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events (
    event_uuid uuid NOT NULL,
    id character varying(255),
    event_id character varying(255),
    event_graphics json[],
    signup_link text,
    details_url text,
    start timestamp without time zone,
    "end" timestamp without time zone,
    description text,
    point_of_contact_name text
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
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (event_uuid, id, event_id, event_graphics, signup_link, details_url, start, "end", description, point_of_contact_name) FROM stdin;
767db14e-22c9-4735-968b-41c7a0e31d33	Eric Bean	Morning fight investment reach situation west chair.	{"{\\"url\\": \\"https://dummyimage.com/677x769\\"}"}	http://fox-bowen.org/about.jsp	https://www.waller.info/posts/explore/about.php	2021-01-05 18:50:39.939518	2021-01-10 18:50:39.939518	Rise husband stuff try finish. Always argue task hand since something old. Door situation detail agent call skill.	Curtis Myers
dcac74a4-710a-4a37-abd0-8de24a6d90d8	David Chapman	Address team go still wait.	{}	http://osborne.net/	http://www.bennett.biz/post.html	2020-12-28 18:50:39.941774	2020-12-29 18:50:39.941774	Put card subject edge trip case treatment. Agency operation relate money fact avoid.	\N
1ae7cc7b-68be-49e0-95ea-59d2d87d0d2b	Daniel Patel	Allow figure east leg.	{"{\\"url\\": \\"https://placekitten.com/656/83\\"}"}	https://lewis.net/login/	http://www.ortiz-nicholson.com/	2021-01-06 18:50:39.942975	2021-01-10 18:50:39.942975	Music consider him voice point bill with action. Upon deep much rich operation go able simply.	\N
e2fb1ece-834f-41d4-9bf1-69eedde3ec6d	Lisa Thompson	Stand course most join.	{}	https://www.edwards-gibson.biz/	https://booker.net/explore/posts/category/homepage/	2021-01-09 18:50:39.944782	2021-01-13 18:50:39.944782	Foot matter hand all member movie. Support against daughter Congress compare. Brother concern enjoy learn time. Cut mention company.	Ana Harvey
488065ac-3faf-42e6-858e-ed098193549e	Johnny Lin	Though somebody realize brother.	{}	http://smith.com/main/app/main/	https://garcia.org/search/categories/main/home/	2021-01-08 18:50:39.947127	2021-01-10 18:50:39.947127	Population way collection admit eye. Right organization according chair instead side. Even feeling somebody and. Memory hold easy believe. Dinner interest tonight always adult return unit.	\N
842a3a94-8d25-44bd-867f-2a48eee6772c	Jamie Leon	Need manager relate decade head.	{"{\\"url\\": \\"https://www.lorempixel.com/829/706\\"}"}	http://www.zuniga.com/	http://graham.net/about.html	2021-01-17 18:50:39.974374	2021-01-21 18:50:39.974374	Small response hand form quite big. Manage control fire them. Raise middle play leave. Behavior military which run city mission also drive.	\N
013c56af-41b5-400d-9039-de9f3bf12a87	Matthew Richards	Dream order technology interesting identify weight.	{}	http://www.keller.com/homepage.htm	https://west.com/	2020-12-28 18:50:39.976757	2020-12-31 18:50:39.976757	Recognize small positive interesting. President beyond even focus wrong three. Modern region consider reach idea. Send bad military tree who full.	Lauren Larsen
c6ee68f1-802d-4014-b82b-7a1b7bb492de	Michael Thompson	Song parent mother central institution according.	{}	https://page.com/app/wp-content/tags/search.asp	http://perez.biz/category/author.htm	2021-01-01 18:50:39.978427	2021-01-07 18:50:39.978427	Dinner home analysis continue everyone edge effort. Similar somebody chance where two subject. Check director century public assume near various.	\N
c942882c-6187-4c6c-b07a-66ef38f329be	Diane Brown	Car president special white two work.	{}	https://daniels.info/	https://www.hudson.com/login/	2021-01-12 18:50:39.989334	2021-01-22 18:50:39.989334	Message participant experience city role difficult even. Late newspaper professor for section every throughout. Least long now fire call ready street. Beyond any up country something.	\N
80a51717-01da-48c4-9af2-be6b1b60434d	Nathaniel Patel	Threat born she improve.	{}	http://perry-harris.com/wp-content/category/categories/login/	http://www.gutierrez.com/tags/privacy.htm	2021-01-09 18:50:39.991445	2021-01-18 18:50:39.991445	Church else church order each interesting sport big. Paper professor someone to. Actually commercial always cultural reality. Leader tend get head reveal value how must.	Maurice Little
65688642-21b5-482f-bf30-d99ad9b9117c	Anita Hall	Public wrong few various field.	{"{\\"url\\": \\"https://dummyimage.com/649x535\\"}"}	http://allen.com/about.htm	http://www.roth-johnson.com/	2021-01-06 18:50:39.993535	2021-01-07 18:50:39.993535	Throw effort sit social future. Suddenly factor space tax parent audience. Sport lay try. Level think continue. Break system else cell.	Hannah Nicholson
aa7a9839-3035-4e14-8782-e9335bc4d9bc	Ashley Jones	Ok style crime American writer.	{"{\\"url\\": \\"https://www.lorempixel.com/6/709\\"}"}	https://www.alvarez.com/login/	https://www.whitaker-page.com/	2021-01-08 18:50:40.003402	2021-01-10 18:50:40.003402	Involve adult probably everybody. Themselves sell animal garden loss. Model air care much computer wind. Century staff himself within dark get medical police.	\N
b9c6466c-c58f-4af8-bb06-0eada9fb43c7	Evan Glover	Congress before marriage improve head begin key.	{"{\\"url\\": \\"https://placeimg.com/459/243/any\\"}"}	https://elliott.biz/homepage.htm	https://thomas.info/	2021-01-05 18:50:40.006922	2021-01-09 18:50:40.006922	Ready that both another. Mean author sense these western middle. Author dark away. Glass manager ball space.	\N
2770b4c2-0ec5-4948-b8f9-3935bcda4aff	Kenneth Williams	Past than recognize culture degree.	{"{\\"url\\": \\"https://dummyimage.com/208x907\\"}"}	https://valenzuela-copeland.com/	https://www.warren-ortiz.com/search/	2021-01-16 18:50:40.009421	2021-01-26 18:50:40.009421	Spring off again boy white notice. Still improve entire husband computer. Notice generation attack day. Skill will social rather fight.	Mathew Huff
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (initiative_uuid, id, initiative_name, details_link, hero_image_urls, description, roles, events) FROM stdin;
22a8c763-ebbf-43e4-9c44-0d2faada520e	Camera seek the by spring people.	Call role away evidence like always.	http://www.robertson.biz/home/	{}	Plan near management military. Various moment loss guy. So ahead bit admit probably various. According final choice stage.	{"Robert Lucas","David Wilkinson"}	\N
284d13f7-3e5a-4257-993f-e7cc890a85d0	Continue foot time matter instead require take.	Send reason analysis office.	http://www.perez.org/main.html	{"{\\"url\\": \\"https://www.lorempixel.com/963/818\\"}"}	Before upon military. Production paper difficult total who. Else radio white not role lawyer.	{"Brooke Chan","Lindsay Baldwin"}	\N
d6985fe5-1e91-4b76-a026-d9caf9e4c244	Join hit star everyone.	Receive to easy score.	https://waters.com/explore/terms/	{"{\\"url\\": \\"https://dummyimage.com/48x608\\"}"}	Most thing instead manage already wind. Price say particular middle. Before garden instead institution raise coach usually. Recent group can doctor smile various up.	{"Tina Harper","Kayla Warren"}	\N
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (role_uuid, id, position_id, more_info_link, team_photo, application_signup_form, priority_level, point_of_contact_name, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
1b694bab-16a8-4466-acb6-2a34db43aad5	William Mcdonald	Writer owner clear table condition.	http://www.ward.org/about/	{}	https://www.garcia.info/privacy/	MEDIUM	Kelly Walker	7	6	2	Window hand former sort job child piece until. Team garden painting great use investment. Remember mother for avoid hear. Use couple audience rate do room. Condition artist in certainly whether major.	Administration media approach grow kid hair. Recently store value field off. Whatever entire place thought measure later.	Him simple close. Effect field two sound turn.	Particular itself all while. Dark father raise smile. Provide perhaps as natural security place along.	OPEN_TO_ALL
689b9a10-f6c5-461c-beb0-41923090fd3f	Henry Hayden	Sign too audience huge rise edge.	http://www.herman-smith.com/	{"{\\"url\\": \\"https://dummyimage.com/710x180\\"}"}	http://www.nolan.com/app/wp-content/tags/home.jsp	MEDIUM	\N	3	4	4	Around own perhaps enter soon. Model agree office six nature red. Health case high foreign responsibility. Finish sell entire nearly watch speak read.	Because resource a look clear happen. Floor seek mind fire instead lose coach. Television writer her weight deal. While fine say sing without lot. Child job personal rule.	Prevent simple fire class tend in think. If star purpose clearly natural wonder fall blue.	Key clear remain item blue. Office national cell policy company. More book like water this could there.	OPEN_TO_ALL
fc27a0f7-52aa-49ba-bf17-8fef09573242	Elizabeth Olson	Much small sell or common throw show know.	https://www.perez-lawson.biz/explore/main/index.asp	{}	https://smith.com/search/list/categories/homepage.php	MEDIUM	Elizabeth Adams	6	4	8	Establish too situation condition follow identify. Next deep property huge young nearly week. Foreign soldier plant. Air hard act other floor.	Tend deep believe perform foot also upon. Do action against medical campaign want. By along resource. Many though audience someone. Pressure evidence green society ability owner through total.	Rock smile rate lead. Over least another building rock society section.	War contain lot buy consider skill with. Figure close student. Interesting fire project our sure culture news. Effort ago let.	REQUIRES_APPLICATION
e3a6b537-8399-45a9-ae77-e3436d468741	Jacob Fisher	Instead college wrong throughout others.	http://www.hill.net/author.htm	{"{\\"url\\": \\"https://www.lorempixel.com/661/737\\"}"}	https://www.sutton-bradley.net/category/	MEDIUM	\N	3	8	7	Plant ok high child him around. Card little child buy response why. Health ok couple good name create improve reduce. Property develop way manage necessary way part. Book level land PM something there.	Bring rest tree north bag blood. Single modern shoulder ability visit decision. Tell small people get measure relate I.	Season hot dark will any. Exist president theory nature bring do brother issue. Structure place consider role wait beautiful network.	Sing series commercial who environment difference. More democratic order professor.	REQUIRES_APPLICATION
ae2ca31a-506a-46e4-907c-c92be87c5fc0	Kristen Rosario	Common never tell board professional such growth land.	https://www.jimenez.com/search/explore/homepage/	{"{\\"url\\": \\"https://www.lorempixel.com/749/655\\"}"}	https://williams.com/categories/category/tag/category/	MEDIUM	\N	4	9	3	Foot book after something common. Result relate them boy. Recently east say.	Though arm better. Economy some good rich grow forward. They chance system security left. Military particularly him the.	Writer health term end. Mean ground its build family quickly attorney. Son value state inside everyone player stand.	Stuff television so kind finally want whose. Friend manager sport compare interview remember region successful. Behavior behind pretty wrong half take life. System whatever happy audience benefit those per. Fly company listen benefit nor maybe who.	REQUIRES_APPLICATION
18093636-6dc6-4614-9475-79a34f99a551	Robert Lucas	Congress almost think hope.	http://jones-hendricks.com/category.htm	{}	http://jackson.com/register.jsp	MEDIUM	\N	6	8	10	Wall require past campaign key alone boy small. What hard realize Congress back effect learn half. Friend performance continue building. Director get customer significant expect.	Thousand always far ball town relate. Follow reduce black organization school. He relate resource technology building fly score.	Glass guess leg executive. Star he wear certain material budget. Enjoy up speak little.	Goal both many computer. Next scientist at college produce movement tonight. Well professor doctor public blood summer. Water over interview answer performance bad.	OPEN_TO_ALL
e4dfb875-0098-4dc3-86c0-ce0c07d419b2	David Wilkinson	Cause cell outside simply tonight.	http://kim-elliott.com/	{}	https://turner-clayton.com/list/search/search/author/	MEDIUM	\N	1	1	3	Partner population vote question commercial student company. Maybe order energy amount trouble eat yes. Quite night thousand player. True industry choose weight expect. Special someone draw if.	Knowledge head once me think. Support leg probably although. Quality contain stage evening break.	Describe join word story main capital. Ten marriage color occur return authority into. More author artist kind information a. House over blue.	Prevent themselves itself serve door. Over team day I success single. As issue control pay within.	OPEN_TO_ALL
d6cb31a7-38af-4b2a-839b-279e7b9e823f	Brooke Chan	Fast author response.	https://www.white.com/homepage/	{"{\\"url\\": \\"https://www.lorempixel.com/1015/662\\"}"}	https://graham.com/tag/privacy.htm	MEDIUM	Joyce Nichols	4	5	5	Position choose term reality relate fear keep. Clearly job though hear pattern no. Despite letter who senior.	Give sense positive leg cover rock. Until allow people pull. Themselves item thus sell. Lawyer board rise somebody.	Life page three product response might. Second television deal card. Hit able close catch. Cold her other effort could weight. Sound Mr team husband former.	Factor continue happen put local. Focus same could somebody travel. Water break appear lose where white. Spend think long customer action space lead.	OPEN_TO_ALL
b1aca86e-f201-48d3-a366-adb0aa1614d4	Lindsay Baldwin	Lay usually human page coach.	http://www.watts.com/search/	{}	https://www.price-price.com/main/category/explore/author.php	MEDIUM	David Floyd	9	10	3	Almost kitchen student us authority view. Congress small city themselves sense.	Ahead century at sit time decision. Lay cover position question. Skill party everybody enter. Assume coach leg opportunity brother figure cultural. Organization right leave for.	Doctor collection simply real again. Discussion night case impact put impact check. Ago main response head break rate part. Collection space western hot result toward effect.	Partner section give write room. Two reduce no finally I really. Assume memory child relate increase.	REQUIRES_APPLICATION
a87dc514-56aa-4efd-9614-49c492506dd5	Tina Harper	Forget east suggest foreign camera.	https://phillips.com/login/	{"{\\"url\\": \\"https://dummyimage.com/361x254\\"}"}	https://bush.net/tag/register.html	MEDIUM	Paul Bradford	3	9	5	Role run agency. Dinner until party affect weight. Source recognize strategy age sometimes order add.	Yet phone no maintain. Business fire full candidate American along worry. Thank yes cut throw seat dream. Six executive eight final black early run. Soldier vote seat course without pretty.	Someone serve loss responsibility worry clear force. Challenge oil development. Board firm successful only so perform. Country better series ever nothing star.	Morning explain when team woman. Pm with increase TV water guess already. Leg make seem large common thank.	REQUIRES_APPLICATION
79aeb245-8964-41f9-8ba7-f40147423785	Kayla Warren	Great less family summer exist trade stand.	http://www.burnett-ramirez.info/search/faq/	{}	https://austin-ramirez.com/about/	MEDIUM	Emily Watson	4	1	3	Activity move past risk phone after. Manager life thing husband drop wait read. Purpose board challenge experience moment particularly.	Choose soldier ability read. Begin available edge stage camera bill. Someone natural east brother religious.	Write state case buy force sound. Forward unit type company field early. Various small space everything statement pay meet. Imagine forget whether speech call his. Series interest long phone say according write.	Seem tend suddenly sure too. Pretty maybe race name chance style. Force drug pass. Low hear responsibility across perhaps leg produce.	REQUIRES_APPLICATION
\.


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_uuid);


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

