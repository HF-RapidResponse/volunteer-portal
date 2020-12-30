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
    id character varying(255) NOT NULL,
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
    id character varying(255) NOT NULL,
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
    id character varying(255) NOT NULL,
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

COPY public.events (id, event_id, event_graphics, signup_link, details_url, start, "end", description, point_of_contact_name) FROM stdin;
Vickie Brown	Yes military board about.	{"{\\"url\\": \\"https://dummyimage.com/361x622\\"}"}	https://www.smith.biz/	https://mendoza.net/app/categories/post/	2020-12-28 00:21:30.52165	2021-01-02 00:21:30.52165	Raise fill top season meeting stop. Same affect gun become whom training week. Report fall training make watch store position.	Dr. Nicholas Meyer
Robin Cooper	Would range produce draw course forward.	{}	https://dixon.net/	https://www.jones-fox.com/homepage.jsp	2020-12-20 00:21:30.525343	2020-12-21 00:21:30.525343	Situation owner center next sound whole. His Democrat threat street. May listen enter time.	\N
Heather Pope	Job eat example be at hot development.	{"{\\"url\\": \\"https://dummyimage.com/377x843\\"}"}	https://kelley.org/categories/tag/author.jsp	https://smith.com/tags/main/category.php	2020-12-29 00:21:30.527589	2021-01-02 00:21:30.527589	Bad material consumer work. Represent eye far create return. Service national light two you.	\N
Mark Austin	No girl tonight.	{}	http://elliott.com/posts/categories/posts/post/	http://martin.biz/list/blog/wp-content/login/	2021-01-01 00:21:30.52938	2021-01-05 00:21:30.52938	Economy painting check decade cover economy. Piece walk right unit teach say. It say whom fish reveal. Various authority while town huge magazine. Show couple power such society Democrat.	Jeffrey Williams
Cindy Rivera	Party attorney car travel issue sport.	{}	https://www.burton.org/	http://www.foster-woods.org/category/	2020-12-31 00:21:30.531662	2021-01-02 00:21:30.531662	Doctor today science up film brother. Sort face seek whatever grow over. Public such economy pick effort.	\N
Diana Simpson	Election opportunity travel natural support civil industry.	{"{\\"url\\": \\"https://placekitten.com/238/534\\"}"}	https://nichols-barron.biz/search.asp	https://mann.net/faq/	2021-01-09 00:21:30.560841	2021-01-13 00:21:30.560841	Much every need protect far. Weight degree area condition power. Nor position appear join song among debate. Recently it worker take various line inside.	\N
Mrs. Lisa Diaz	All ready get through future mother relate.	{}	http://rodriguez.biz/	https://www.white-durham.com/app/posts/home.htm	2020-12-20 00:21:30.562765	2020-12-23 00:21:30.562765	Perhaps fly nearly care. Fly watch laugh manage small including economy.	Matthew Green
Jessica Williams	Determine especially statement oil.	{}	http://thompson.com/faq.php	https://www.sullivan.com/search/	2020-12-24 00:21:30.564281	2020-12-30 00:21:30.564281	Walk customer fact remain determine across church. Social but market brother newspaper billion forward.	\N
Carolyn Ramirez	Everything task sound vote partner option.	{}	http://norton.net/about/	https://www.smith.com/category/category/blog/home/	2021-01-04 00:21:30.573397	2021-01-14 00:21:30.573397	Whom institution question increase. Take again should such. Whose bill attention after book up something.	\N
David Burke	Other it reduce doctor toward.	{}	http://www.wells.com/main/category/category/index/	https://www.campbell-davis.info/tags/home/	2021-01-01 00:21:30.575556	2021-01-10 00:21:30.575556	Top join you region part. Space walk reach occur father then American. Forward director establish scene recent.	Daniel Thomas
Monica Rodriguez	Themselves strong test source no rate.	{"{\\"url\\": \\"https://placeimg.com/637/817/any\\"}"}	https://www.nelson.com/posts/wp-content/app/main/	http://williams.com/	2020-12-29 00:21:30.577527	2020-12-30 00:21:30.577527	Community rock talk rest. Center bad skill heart quickly able. Where capital make sense.	Amy Burns
Tara Walton MD	Particular subject catch management.	{"{\\"url\\": \\"https://placeimg.com/930/33/any\\"}"}	http://brown-knox.biz/blog/explore/blog/home.htm	https://thomas.com/author.htm	2020-12-31 00:21:30.586146	2021-01-02 00:21:30.586146	Rule wear other herself. Suddenly stop interesting she marriage so respond certainly. Everyone avoid her. Little man property out oil activity within.	\N
Brandon Miller	Wait similar everything small story piece middle suddenly.	{"{\\"url\\": \\"https://placekitten.com/468/328\\"}"}	https://www.fields.net/homepage.html	https://nielsen.com/category/blog/category/login.htm	2020-12-28 00:21:30.589864	2021-01-01 00:21:30.589864	She accept enjoy. Color as writer civil. Agent ask many dream reflect start. Wall brother Congress increase official.	\N
Joshua Watson	Information mother color value hundred argue owner foot.	{"{\\"url\\": \\"https://www.lorempixel.com/730/220\\"}"}	https://www.simmons.info/app/categories/explore/faq.htm	http://www.campbell.com/index/	2021-01-08 00:21:30.59282	2021-01-18 00:21:30.59282	As tonight institution according very career old. Learn while operation make. Million while Mrs color tax left. Itself develop his floor short. Include event newspaper a more shake.	Mrs. Sandra Williamson
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, initiative_name, details_link, hero_image_urls, description, roles, events) FROM stdin;
Expect summer even finish behind.	Shoulder before something foot main police three tree.	https://garcia-johnson.biz/login.php	{}	Service arrive investment market painting describe career. During seem cut nation. Less model be news pick. Scientist while child letter finally often.	{"Andrew Barber","Julie Ashley"}	\N
Out enter increase professional lose would mother six.	Someone join control where.	http://www.flores.info/	{"{\\"url\\": \\"https://dummyimage.com/250x28\\"}"}	Everyone compare note maintain. Account early determine class. Will finish where issue owner.	{"Cheryl Wright","Stephanie Smith"}	\N
Thought agree join claim total visit.	During deep Mrs box test green.	http://pennington.com/	{"{\\"url\\": \\"https://dummyimage.com/639x831\\"}"}	Wife most win citizen outside. Car hit continue television far themselves particularly. At indeed personal though couple whatever citizen.	{"Mary Pena","Angela Pollard"}	\N
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, position_id, more_info_link, team_photo, application_signup_form, priority_level, point_of_contact_name, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
Patrick Reid	Tv truth never drop have.	https://griffin.biz/	{}	https://evans.net/terms.php	MEDIUM	Matthew Delgado	7	6	2	Floor appear home team cold door. Themselves up war meeting. Man free range century by. Candidate environmental if mention sure true. Situation something fast week page.	Work item reason head run record. Oil relationship Republican certain fill.	Member quickly reality director program onto nature. Something quickly probably memory five trade.	Think when party reality most. Appear road past. Once explain author sea factor build.	OPEN_TO_ALL
Mia Roberson	Clear hit against whatever.	http://www.roberts-jackson.com/tags/posts/author/	{"{\\"url\\": \\"https://placekitten.com/1021/936\\"}"}	http://www.thomas.net/app/explore/index/	MEDIUM	\N	3	4	4	Write social power six. Owner beautiful dinner bill rate. Return reality sort news. Officer here today street watch film try.	Long how public lot watch total with. Different lose throughout. Voice her soldier.	Word adult music hear minute might. Amount poor you where defense two. Provide law thank along marriage along. Sea develop husband politics effort manager see.	Tonight management figure. Really including sometimes. Take back future return risk share sport.	OPEN_TO_ALL
Patrick Bradley	Someone social others.	http://www.torres.biz/posts/app/homepage/	{}	http://sherman.info/terms/	MEDIUM	Alison Ellis	6	4	8	National prove base design cost season night. Woman age party standard win. Customer police question character consider media show.	Bit suffer mission up try. Usually bar move world carry. Hard least son true mouth best.	Four fine to chance simple. People arrive rule technology follow particularly stand prevent.	Soon later feel law minute. Century method four safe show according. Method offer onto value build learn. Identify more term establish most price sea. None matter understand nice western eight music.	REQUIRES_APPLICATION
John Sims	Hard it ask organization.	https://www.thompson-higgins.com/search.jsp	{"{\\"url\\": \\"https://www.lorempixel.com/244/489\\"}"}	http://watkins.biz/main/posts/index/	MEDIUM	\N	3	8	7	Conference friend become election far. Idea recognize whose month.	Keep forward avoid word necessary. You real feeling fight. Policy wide nor community food side. Which serious figure.	Ready bit argue thousand operation. Thought marriage population over form carry and. Tv recent artist impact medical record window. Both change describe stop along read movie need. School will knowledge above.	Will family whatever physical push discussion guy. Attention certainly think administration back. Evidence degree his drop common. Authority buy article apply four. Evidence sister prove act identify computer pay.	REQUIRES_APPLICATION
Ryan Anderson	Short either bit side happen lead blood.	https://www.vasquez.info/	{"{\\"url\\": \\"https://www.lorempixel.com/950/637\\"}"}	https://moody.com/search/	MEDIUM	\N	4	9	3	Very no democratic hit organization research. Audience same sing travel. Add social leader foreign identify yourself. Explain main foot many care. These raise company on consider material.	Guess stay three itself story skin memory. Season one nation recognize concern system country. Number skin rock six realize skin mind. Reason hundred thing media space. Off southern much list through.	Move onto occur recent wait strategy everyone safe. Agency will wall Congress many war. Respond human hour tough money accept top.	Almost than others. Baby simple grow approach note. Cold rise official pay court truth his. Man miss country.	REQUIRES_APPLICATION
Andrew Barber	Under cold factor.	http://www.rogers.com/wp-content/about/	{}	http://www.charles-martin.com/about/	MEDIUM	\N	6	8	10	Positive imagine different public always throw. Also reduce specific education. Bed boy life score which. Mouth child all near ask. Pay back environment unit so.	Lawyer address back rise charge. Professor challenge thing high last artist card walk. Shake itself level feeling risk skin. Claim investment stuff choose sign either indeed.	Voice trial role energy. Crime including else wide store later. Test vote Congress well measure result according. Agent in sit need less. Detail industry answer six tough computer seven in.	Cost attention someone official. Medical half Mr. Firm down thus order water recently growth. Around art understand wife. Either condition get single.	OPEN_TO_ALL
Julie Ashley	Do store establish option skin finish.	http://silva.com/	{}	http://www.bowers.net/posts/category/login.php	MEDIUM	\N	1	1	3	Such official economic ask nation. Draw candidate special animal. His very their. Cell leave policy large behind. Room table reduce trouble.	Six me follow stay should bed read ground. Heavy after senior. Performance minute source all.	Goal toward company light. Democratic less back middle. First wide stuff. Hospital cold between nice experience. Something ready remember born far involve as third.	Check first high ability collection. Dark time ball floor upon today. Question financial exist physical born player yet war. Themselves left rest indicate data design.	OPEN_TO_ALL
Cheryl Wright	Though save mission federal necessary director improve.	http://www.morgan.com/main.jsp	{"{\\"url\\": \\"https://placekitten.com/743/589\\"}"}	https://www.savage-lopez.com/index.html	MEDIUM	Gwendolyn Powers	4	5	5	Finally individual author heart hotel. What government fact nothing article. Point music trip kid. Exactly recent central your reason man. Then opportunity shake.	Article blood actually model real. Team particularly natural total still. According have gun.	Scientist explain industry. Know sing get space ahead. Whom within economic front lay back treatment. Push almost discussion.	During stuff their various power. Close lay religious participant seek. Push outside trade effort.	OPEN_TO_ALL
Stephanie Smith	Simply five actually.	https://atkinson.net/homepage.php	{}	http://www.brown-freeman.biz/	MEDIUM	Amanda Myers	9	10	3	Drop mean type at realize. Tv cell step agency look wide loss. While such identify write others bill foot. Deal already forward office. Who likely from into.	Far model sell side pressure. Suffer describe middle across. Unit prove prepare citizen. Piece site pay.	Data interesting indeed maintain both see. Me live represent cultural image. Hope ready no others college provide bank.	Nice human someone song walk. On community others buy factor traditional make. Response both fall three player this term. Reflect television four teach key care hair.	REQUIRES_APPLICATION
Mary Pena	Natural fly as many her something now.	http://www.shaw.com/blog/tag/search/search.php	{"{\\"url\\": \\"https://www.lorempixel.com/804/50\\"}"}	http://chang.com/about.htm	MEDIUM	Tonya Gibson	3	9	5	Man trip consumer serious laugh north which. Billion side little across.	Trade station station four six among include. Individual myself give film either night. Daughter then least finish nice why go.	Win meet election science cover land skill. Laugh sense believe hundred lead. Strategy approach international hard college.	Home learn land memory big hospital. Information truth item southern. Sell once where treatment.	REQUIRES_APPLICATION
Angela Pollard	Record pattern natural will responsibility though.	http://www.mejia-copeland.com/main.asp	{}	https://www.mccarthy.org/post/	MEDIUM	Robert Sellers	4	1	3	Another or little consider military policy war model. Bill will out performance cost about.	Cup movie style town evening thus agree. Likely reach vote five eye industry last. Vote land start toward occur key street.	Any theory happen place concern marriage. Lot car professional data water trip start.	Training yourself central administration leg knowledge exactly. Mr share visit capital trouble too approach. Water rather operation relate church.	REQUIRES_APPLICATION
\.


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: initiatives initiatives_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.initiatives
    ADD CONSTRAINT initiatives_pkey PRIMARY KEY (id);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

