--
-- adminQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

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

CREATE DATABASE hf_volunteer_portal_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


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
    event_graphics json,
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
    hero_image_urls json,
    description character varying(255),
    roles character varying[],
    events character varying[]
);


ALTER TABLE public.initiatives OWNER TO admin;

--
-- Name: link_requests; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.link_requests (
    request_uuid uuid NOT NULL,
    email character varying(255),
    request_sent timestamp without time zone,
    link_delivered boolean
);


ALTER TABLE public.link_requests OWNER TO admin;

--
-- Name: volunteer_openings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.volunteer_openings (
    role_uuid uuid NOT NULL,
    id character varying(255),
    position_id character varying(255),
    more_info_link text,
    team_photo json,
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
35934947-f6c1-4a8e-8b1a-c47fb0370496	Kristopher Smith III	Energy school into occur court past.	[]	https://www.hammond.biz/tag/category.asp	https://www.romero.com/	2020-12-13 11:00:23.647566	2020-12-15 11:00:23.647566	Improve green young off whatever. Call human production. Executive station among compare fact pattern prove. Cultural wife since.	Charles Benson
38d252b7-9416-4dab-9cfe-25e09c230f99	James Barber	Draw one model large upon issue.	[]	http://young-daniels.com/search/	https://www.rice.com/home.php	2020-12-15 10:23:23.650171	2020-12-20 10:23:23.650171	During represent must go. Which stay level model loss moment. Never dinner interest director. Open get leader age make marriage work. Season fact thank attorney blue poor in society.	Mrs. Rebekah Peterson
610cbd9b-0f96-4d4e-b7df-a63379322d93	Joshua Freeman	Four matter standard consider even low.	[]	https://nelson.net/search/author/	http://wagner.com/search.html	2020-12-11 11:33:23.652227	2020-12-17 11:33:23.652227	With which including experience represent particularly find. Hour record at run. Night sometimes apply treat. Usually design boy break news some old.	Joseph Perez
0c2836ef-25c0-4d1f-9f72-7393c6319aa6	Teresa Blake	Service child relate baby where industry include.	[]	http://www.bryant.com/author/	https://www.smith-schwartz.info/tag/explore/wp-content/post.jsp	2020-12-12 11:50:23.653978	2020-12-14 11:50:23.653978	Agree affect blue but sure author. Bring anything heavy no floor enough. Process suddenly above fight. American ask cost.	\N
1755a0e5-6fcf-402a-8cd9-89ac697c01d8	Andrew Fleming	Recognize measure value total.	[]	http://mccarthy-potter.info/index.html	https://mclaughlin.biz/categories/list/terms.htm	2020-12-17 12:16:23.655853	2020-12-25 12:16:23.655853	Truth behavior like from fish teacher. Certainly important attorney help seven. Trip physical among way key buy step.	\N
b871337d-d1b5-4c5e-b392-b06a29534152	Samantha Allen	They discussion letter actually unit significant career church.	[]	https://alexander-fields.com/category.php	https://smith-dean.com/tag/about/	2020-12-11 10:53:23.66821	2020-12-17 10:53:23.66821	Nor effort such hard tonight two role. Couple Congress scientist follow I explain. Knowledge figure yet. Home exactly people account. Although act art away three.	\N
46538868-5a22-4453-8e63-cba55cdb744e	Christina Ryan	Head movie boy population.	[]	https://www.smith-grant.net/index/	http://www.ellis.com/privacy/	2020-12-14 13:33:23.670102	2020-12-18 13:33:23.670102	Bring claim medical far only nature reason. Financial true condition under project.	\N
635dce48-ebe8-4fa7-9886-d964f75c3562	Sabrina Morgan	So also yes place different million build.	[{"url": "https://www.lorempixel.com/510/767"}]	https://bradley.org/	http://norman-duran.com/	2020-12-07 11:16:23.671765	2020-12-12 11:16:23.671765	Dream factor main anyone every open. Low hot under whatever improve. In inside never building.	\N
3deeddb8-24d9-42c9-b344-0380989ee7ec	Courtney Mitchell	Hospital simply evidence concern agent become ago.	[{"url": "https://placeimg.com/205/789/any"}]	http://roberts.com/	http://smith.com/tags/about/	2020-12-08 11:46:23.682655	2020-12-11 11:46:23.682655	Show really major keep least. Knowledge news responsibility five road record recognize.	Mark Peterson
dd2d2475-74c6-473d-9074-b28fb151e765	Wayne Johnson	Both year high money despite serve.	[]	https://joseph.com/search.asp	https://www.jones.net/app/wp-content/register/	2020-12-07 10:53:23.684985	2020-12-11 10:53:23.684985	Even talk trip. Republican yard middle continue heavy effect. Measure single both.	\N
408872e2-d959-4795-8270-5c500ff6e8a1	Patricia Bond	Buy full five image collection language imagine.	[{"url": "https://placekitten.com/903/662"}]	http://www.holmes.net/posts/categories/search/main/	https://summers.info/author/	2020-12-08 13:25:23.687165	2020-12-09 13:25:23.687165	Impact against why. Because win too field before. Catch try upon guess full you focus. Leave success worry customer arm trade cause into.	Brandon Johnson
fbd78d90-5a72-4e7b-9a4c-4be42cf0d111	Pam Herrera	Medical data decision hospital night gas song.	[{"url": "https://placeimg.com/338/747/any"}]	https://nguyen-rivera.com/category.html	https://www.clark-barrett.com/	2020-12-12 12:21:23.696882	2020-12-17 12:21:23.696882	Term rock news wonder. Health participant real. Low whom season reality example this local reality. Series structure break knowledge age get only. Pick oil north usually yes program.	\N
aa19e671-0f1f-4ed7-b13e-b6028893ba81	Cynthia Rodriguez	Experience those effort image these laugh floor.	[{"url": "https://placekitten.com/774/874"}]	http://www.cortez-hardy.com/app/main.php	https://gaines-baldwin.com/login/	2020-12-05 13:06:23.698744	2020-12-13 13:06:23.698744	Movie play attorney change half off. Low store figure our past none. Together able employee tough black factor foreign. Mouth network attorney.	Kerri Johnson
fadf79e0-3c93-4316-920b-82d7494a69b5	Timothy Duncan	Red character series hotel turn thank us.	[]	http://www.allen.org/terms.htm	http://www.turner-wagner.biz/login/	2020-12-17 10:36:23.700764	2020-12-22 10:36:23.700764	Office water himself yes claim behavior. Now voice soon type together. Half case whose manage wonder sea.	James Hickman Jr.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (initiative_uuid, id, initiative_name, details_link, hero_image_urls, description, roles, events) FROM stdin;
a9157e4f-4226-45f7-bce9-8d7730a3fee5	Standard series executive practice education player.	John Davis	https://flores-wise.com/faq/	[{"url": "https://www.lorempixel.com/817/630"}]	Military nor exist feel security beyond. Add foreign mention herself enough level. Hotel road magazine field manager. Meeting like theory environmental us. Perform score listen director week.	{"Mr. Alan Nelson","Jacqueline Anderson"}	{"Samantha Allen","Christina Ryan","Sabrina Morgan"}
4ed70f05-2fc7-4998-86bd-d6767b20d0b8	Pattern least big generation benefit win democratic.	Jeffrey Mendoza	https://www.ruiz.org/	[{"url": "https://dummyimage.com/311x747"}]	Most marriage it participant year usually. Forget run give apply back bank body.	{"Anthony Moyer","Carol Mercer"}	{"Courtney Mitchell","Wayne Johnson","Patricia Bond"}
6d2747fa-a9eb-4112-8e7f-ed3f1789faa6	Poor decide box position performance south stay.	Christopher Barajas	http://osborne.com/list/blog/about.php	[{"url": "https://dummyimage.com/300x46"}]	Continue stage throw your benefit reach. Thank than after clearly. Discuss study family part. Challenge agree head answer forget society office.	{"Valerie Valentine","Mary Wilson"}	{"Pam Herrera","Cynthia Rodriguez","Timothy Duncan"}
\.


--
-- Data for Name: link_requests; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.link_requests (request_uuid, email, request_sent, link_delivered) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (role_uuid, id, position_id, more_info_link, team_photo, application_signup_form, priority_level, point_of_contact_name, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
d9d1de0a-6797-468e-8702-aa052a46ba1f	Mr. Philip Simpson	All policy large market wait place.	http://www.mata.com/	[]	http://barber.org/category.asp	MEDIUM	Erika Nelson	7	6	2	Learn check doctor minute with reality. How from particular to stuff time film.	Peace assume management black. Show statement PM thus car line. Hundred story bring color free bag.	Deal determine either rest. Participant present leader yeah memory music. Too year increase performance. Fund scene yard religious seem yeah option. Report American describe speech mention good see.	Power population decade some PM price whose. Occur receive doctor capital trial institution weight media. Relate guess explain thus attack.	OPEN_TO_ALL
818f3b42-9e89-44a9-b23b-c6734ca8391d	Nicole Bauer	Analysis whom six level.	http://www.flynn.com/main/	[{"url": "https://www.lorempixel.com/496/802"}]	https://www.tyler.net/posts/blog/category/privacy/	MEDIUM	\N	3	4	4	Strong this may develop. Series miss prevent true fly bring. Buy language worker bag each. Technology seven middle property.	Evidence particularly least range. Ability tough military land million institution magazine either. Vote change sell far cell into range. Practice region surface including political my add.	Each kitchen budget long me poor. Film clearly action six. Trial board recently figure structure why drop. Recent bar peace trade force current area.	Ago fear second physical medical charge. Become your serious set.	OPEN_TO_ALL
605cabc7-c0e0-4238-911c-12d1dfff5f45	John Roberts	Follow law serious such story political.	http://wright-miller.net/search/homepage.html	[]	http://mueller.net/	MEDIUM	Karen Khan	6	4	8	At new police Republican. Sport model budget push just one total. Owner bed away decide current economy.	Sense medical ask forget magazine into. Become issue address against social always return. Opportunity office music attention including level wife. Relate blood degree own sometimes life. Picture develop put care program.	Book war involve site. Financial whole determine about. Sister sign per ever article. Natural able do toward rock.	Job throw citizen pretty almost. Eye mother peace crime window above idea. Know company paper group fear win church better. Society former instead.	REQUIRES_APPLICATION
64258b88-e4ce-4c66-92d8-56f98288fd99	Dominique Maldonado	Beat reveal fall follow condition.	https://thomas-peters.com/category/	[{"url": "https://www.lorempixel.com/59/667"}]	http://www.nunez-johnston.com/app/categories/author.html	MEDIUM	\N	3	8	7	Quickly human long room ball will news. Big food compare free. Including away near various.	Reflect manager third agent so behind. Ready bad sort technology radio system. Where remember movie fall find rather standard require.	Color much bar resource. Detail exist become water add until along.	Treatment single contain. Stay executive left establish increase time piece. Care word court give president. Message I month task.	REQUIRES_APPLICATION
b1c90d1f-c1f4-4af1-a508-f259425dc9ad	Lisa King	Hotel rich whom test particular agreement still natural.	http://www.webster-butler.com/	[{"url": "https://www.lorempixel.com/700/573"}]	https://www.castro.com/terms/	MEDIUM	\N	4	9	3	Something enter six green name. Fly commercial race. Six these ask why mean. Study individual sound issue option great.	Generation almost collection body mission. Policy home TV the. Establish open rock ground any single.	Yet media address meet run accept. Someone meeting language actually capital research relationship. View pass range bill character set.	According policy herself fast. Former so image call between yes. Why court car voice turn. Player loss former.	REQUIRES_APPLICATION
d920963e-d5e9-421f-ba8a-3400f68e3bea	Mr. Alan Nelson	Finally recently successful far inside significant put.	https://watkins.com/post.html	[]	https://www.reyes.com/explore/search/categories/search.php	MEDIUM	\N	1	1	3	Final beyond hear wide who why. Itself run because trouble oil dinner court.	With sport condition environment human make available. Subject parent issue. Nature everything himself certainly activity. Hundred discussion trial effort serious concern civil.	Wear open good mind member weight clear. Still laugh writer discuss bill a turn maybe. Expert scientist hot operation do night time. Sister party accept computer. Wide call strong area.	Military whatever opportunity fight matter school. Whether fall allow day. Gun meeting ask adult true fine finish. Book early need here central hope third. Coach short information usually few.	OPEN_TO_ALL
b638d41a-30b2-4574-b912-1e0b8992caf1	Jacqueline Anderson	Start seat general ten mean issue.	http://www.strong-gregory.org/home.jsp	[{"url": "https://dummyimage.com/214x967"}]	https://www.clark.biz/app/category/posts/about.jsp	MEDIUM	Jill Downs	5	1	6	Who staff get risk physical probably. Entire senior there on everything level. Matter others a activity later black which. War explain wind many environment hear price.	Improve scene study guy reflect guess. Lay wall win out hot clear everyone. Season growth purpose share wish phone tend.	Body land doctor. Everybody agent performance exactly deep star.	Movement dog lose chair benefit fight owner. Memory live resource ability produce staff or plan. Baby baby know.	REQUIRES_APPLICATION
c20b80f7-390e-4c57-a220-155f29b0153b	Anthony Moyer	Watch truth quickly member.	https://smith.com/search/post.php	[]	http://www.owens.net/login/	MEDIUM	\N	10	8	7	Why rise large assume dark fly system. Father lot close company election step door. Enjoy tell ready bit personal very.	Conference education right station under. After section rock attorney style. Read skill lay these save work sister new. Republican grow matter continue wide do positive. Spring toward western fund wind store reveal action.	She himself different above exist expert box listen. Imagine itself matter risk. From leader we soon parent. Son might issue training hotel. Force clear strategy best store often.	Sort maybe method simply maintain prove. Significant cover if. Others able gas old space. Ever value court music suddenly current.	OPEN_TO_ALL
3156eee1-4efa-426b-a74a-44fe14ba5bbb	Carol Mercer	Part various person everyone catch everybody describe.	https://www.mercer.com/category/tag/register.html	[{"url": "https://www.lorempixel.com/360/850"}]	https://pollard.com/	MEDIUM	\N	1	1	4	Wrong group skin trade. Expert rich bed check. Off evening cell international.	Day similar speech deep rock parent meet. Choice claim performance heavy available step. Race tonight cause work. Into prevent Congress career. Hit here smile individual law identify.	Knowledge while learn though give believe save know. Act season trade place. Effort drug hair machine along but analysis.	New million region plant what. Sing budget almost perhaps she leave least occur. Power party black unit realize animal state space.	REQUIRES_APPLICATION
9331d34b-e52d-4fe2-a506-15ad45fa94bf	Valerie Valentine	Full think bank relate of politics.	http://david.net/tags/app/posts/privacy.jsp	[]	https://www.browning-briggs.com/	MEDIUM	\N	4	4	5	Anything red same health support similar. Day hard water could pass mother. Indeed article structure dream mother child writer. Believe especially as five.	Site president close structure avoid hot hand. Attorney morning themselves baby. Guess yourself region. Much off your control thing though head.	Green country somebody color movement. Bar director free special result ask. Be maintain Democrat executive. Woman do grow good consider relate.	Have successful side least easy me check. Push west sound institution throughout. If available end figure mind.	REQUIRES_APPLICATION
1bcab939-1cda-4999-af88-6ab4d1fb5965	Mary Wilson	More present staff fund campaign instead.	http://www.williams.info/	[{"url": "https://placekitten.com/421/791"}]	http://www.white-green.com/	MEDIUM	Brian Neal	3	10	9	Professor entire change. Identify popular movie military. He you stock media society reflect sea.	Ask our produce good son spend. Reach computer result imagine term expert thank Republican. Four player little within again move huge. Only trip finish.	Spring sea everything member. Top man beyond red about. Remember throughout may quickly reality executive score.	Sister century race impact form gas road. Help two happy language idea thought.	OPEN_TO_ALL
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
-- Name: link_requests link_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.link_requests
    ADD CONSTRAINT link_requests_pkey PRIMARY KEY (request_uuid);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (role_uuid);


--
-- adminQL database dump complete
--
