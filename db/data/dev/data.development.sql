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
    _primary_email_identifier_uuid uuid,
    _primary_phone_number_identifier_uuid uuid
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
    uuid uuid NOT NULL,
    channel public.notificationchannel NOT NULL,
    recipient text NOT NULL,
    title text,
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
    account_uuid uuid,
    verified boolean NOT NULL,
    slack_workspace_id text
);


ALTER TABLE public.personal_identifiers OWNER TO admin;

--
-- Name: verification_tokens; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.verification_tokens (
    uuid uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    already_used boolean NOT NULL,
    counter bigint NOT NULL,
    personal_identifier_uuid uuid
);


ALTER TABLE public.verification_tokens OWNER TO admin;

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

COPY public.accounts (uuid, username, first_name, last_name, _primary_email_identifier_uuid, _primary_phone_number_identifier_uuid) FROM stdin;
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
9181734156469	2021-04-03 23:32:40.41549	2021-04-06 23:32:40.41549	f	765ef0ea-975f-45b0-9090-d898ac36b763	Let open your name eat science away throughout.	{}	https://www.olson.com/login.htm	2021-04-13 23:32:40.41549	2021-04-17 23:32:40.41549	Mother since threat yeah if customer may. Ball fish land need standard interest cup.
9133694445589	2021-04-09 23:32:40.416249	2021-04-13 23:32:40.416249	f	eb7a529d-6e71-49f8-b7b1-fe62ce903e20	Way on guess candidate walk goal.	{}	https://short.com/tags/blog/blog/homepage/	2021-04-20 23:32:40.416249	2021-04-22 23:32:40.416249	Adult age lead military morning race car fall. When fund themselves north new.
2581979348006	2021-04-03 23:32:40.416702	2021-04-08 23:32:40.416702	f	06488894-74f2-4f80-ab70-b56bcd04bb35	Lawyer soldier number tough.	{}	https://mcdowell.info/blog/tag/list/author.php	2021-04-15 23:32:40.416702	2021-04-23 23:32:40.416702	Material most seven field art. Long along serious suggest thought. Company well window concern friend teacher body.
1596770131338	2021-04-06 23:32:40.416943	2021-04-10 23:32:40.416943	f	4d9be9a1-3468-4add-a41e-f29fea9e5c9b	Wear whom fish mission assume home.	{}	http://erickson.biz/	2021-04-16 23:32:40.416943	2021-04-17 23:32:40.416943	Take state which day bill organization stage respond. Recently attack total rise.
3504292223866	2021-04-04 23:32:40.417239	2021-04-09 23:32:40.417239	f	11b69a0f-82ac-4192-a92d-8b2b4fc96aa9	First pass specific treatment.	{"{\\"url\\": \\"https://placekitten.com/625/700\\"}"}	http://moore.com/explore/faq.asp	2021-04-15 23:32:40.417239	2021-04-19 23:32:40.417239	Us son least little able democratic. Cultural pass quality those reflect accept certainly measure. Under sure discuss main next activity. Article right up.
4399040967623	2021-03-30 23:32:40.423314	2021-04-03 23:32:40.423314	f	7e8689a5-f16c-4640-8f4f-d8f3af6e0652	State one sign next my.	{"{\\"url\\": \\"https://dummyimage.com/999x119\\"}"}	https://jimenez-hughes.net/	2021-04-11 23:32:40.423314	2021-04-20 23:32:40.423314	Send will page start moment. Impact speech the over score available. Real check choose.
5815602681619	2021-03-26 23:32:40.42362	2021-03-29 23:32:40.42362	f	b1e01c06-e944-46bf-8954-7d875bc41150	Responsibility boy responsibility forward consumer stage.	{"{\\"url\\": \\"https://www.lorempixel.com/338/247\\"}"}	https://fields-zimmerman.net/main.php	2021-04-06 23:32:40.42362	2021-04-14 23:32:40.42362	Skill couple would consider set method threat. School culture last work. Room though issue top military pull. Our since relationship and now.
9935535402078	2021-04-03 23:32:40.423928	2021-04-09 23:32:40.423928	f	db76aa87-17ed-4956-af9a-2d554deec219	Mother trade station actually sign.	{}	https://fields.info/terms.php	2021-04-15 23:32:40.423928	2021-04-22 23:32:40.423928	Bank develop may should road consumer analysis. Something responsibility friend kind tax toward successful. Fall what lot onto north.
6347556701017	2021-03-29 23:32:40.425924	2021-04-01 23:32:40.425924	f	ca5028f0-3345-452d-ac64-ff3eaf3f95ef	It campaign example increase argue.	{"{\\"url\\": \\"https://www.lorempixel.com/801/496\\"}"}	https://martinez.com/search/	2021-04-09 23:32:40.425924	2021-04-13 23:32:40.425924	Sea hospital let especially campaign quickly. Impact should them. Improve believe magazine as a around available.
1588888179784	2021-03-22 23:32:40.426222	2021-03-24 23:32:40.426222	f	248f610f-e21c-41bf-882b-0ea82bd9d0fc	Firm pay nation situation onto.	{"{\\"url\\": \\"https://www.lorempixel.com/180/660\\"}"}	https://www.morales.com/search/tags/tag/terms.html	2021-04-01 23:32:40.426222	2021-04-05 23:32:40.426222	Forward even car force bring. Require cup case million hour must. Prove nation knowledge fall.
7089376165035	2021-04-06 23:32:40.426676	2021-04-11 23:32:40.426676	f	05019869-de6d-4882-b3bd-ff1da189de79	Create half market.	{}	http://www.jackson-lopez.com/homepage.php	2021-04-17 23:32:40.426676	2021-04-21 23:32:40.426676	These small stand around. Involve bank hundred black sell as rate. Ago hold if Mr hair call seat.
6705104007682	2021-04-07 23:32:40.428805	2021-04-12 23:32:40.428805	f	91dc8419-3bcb-47f4-ac5a-f80692a1ca08	Yard special sign compare provide trade.	{"{\\"url\\": \\"https://placeimg.com/166/607/any\\"}"}	https://www.todd-lewis.com/terms/	2021-04-19 23:32:40.428805	2021-04-20 23:32:40.428805	Military sign everything where table his machine. Live oil human dark put customer personal animal. Game service indeed picture about attention suddenly lose.
5215914462768	2021-04-06 23:32:40.429143	2021-04-08 23:32:40.429143	f	20894885-bfae-4076-b607-79215f6a8c72	Able community raise situation yes nation.	{"{\\"url\\": \\"https://dummyimage.com/577x820\\"}"}	http://www.phillips.net/	2021-04-16 23:32:40.429143	2021-04-26 23:32:40.429143	Today describe support involve right. Clear kid agreement life very standard include between. Entire sure walk hand town game edge street.
8246697447168	2021-04-01 23:32:40.429502	2021-04-05 23:32:40.429502	f	2b2fc679-9f14-4e61-8bfe-9610682bc85e	From theory interesting various.	{}	https://www.curry-garcia.com/index/	2021-04-13 23:32:40.429502	2021-04-17 23:32:40.429502	Baby of heart street. Mrs choose south hope price since. Stay hand character single local director civil.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
0397370105740	2021-03-27 23:32:40.424212	2021-04-01 23:32:40.424212	f	0a472acc-6430-4c3b-ac31-b9b72b55cf90	Noah Williams	1	http://fleming.com/explore/main/tag/homepage.htm	{"{\\"url\\": \\"https://www.lorempixel.com/558/1004\\"}"}	Eight traditional break decide produce anything. Tv thought together yard sister voice plant. Authority view yeah according station.	{4826765665621,6286439111737}	{4399040967623,5815602681619,9935535402078}
2822606960599	2021-04-10 23:32:40.426966	2021-04-13 23:32:40.426966	f	5ea19b96-d676-4ad9-896f-ab98ab0ac351	Eduardo Manning	2	http://www.alvarez.com/tags/category/search/	{"{\\"url\\": \\"https://www.lorempixel.com/725/880\\"}"}	Final spend each start put each drug. Forget system country know personal wife. Practice senior us rule. Option front must on.	{3089101928878,4245214338129}	{6347556701017,1588888179784,7089376165035}
3235400700169	2021-03-31 23:32:40.429836	2021-04-04 23:32:40.429836	f	5858e172-776e-4f3e-b049-ad7aba7c35ee	Mary Arellano	3	http://nash.com/posts/app/tag/home.php	{}	Treat require everyone near ground dark suddenly. Listen statement not itself contain program.	{8584738251375,3541688610077}	{6705104007682,5215914462768,8246697447168}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (uuid, channel, recipient, title, message, scheduled_send_date, status, send_date) FROM stdin;
\.


--
-- Data for Name: personal_identifiers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.personal_identifiers (uuid, type, value, account_uuid, verified, slack_workspace_id) FROM stdin;
\.


--
-- Data for Name: verification_tokens; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.verification_tokens (uuid, created_at, already_used, counter, personal_identifier_uuid) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
6753523204564	2021-04-02 23:32:40.40516	2021-04-07 23:32:40.40516	f	f6108601-c08a-4f21-9f81-1168b2027acf	Degree attention bag over.	{"{\\"url\\": \\"https://www.lorempixel.com/381/862\\"}"}	https://johnson.com/terms.htm	https://gilbert.com/categories/tags/login/	MEDIUM	{8725400549875}	{}	6	2	8	Seem use involve news. Report risk writer growth class shoulder ahead general. Ten father professor mouth visit state artist.	Discuss report half stock dark pick. Cultural will laugh box guess country leader media. Human thought remember strategy time.	Audience by second likely purpose since. Task face can. Direction couple step wait on. Half how size general. Character war large eye.	Ask do occur form matter test. Red blue choice ok. Management camera body decision.	REQUIRES_APPLICATION
3780349975791	2021-03-26 23:32:40.406024	2021-03-29 23:32:40.406024	f	c9b16171-e712-4995-8f3d-cefc1f833952	Sense guy need candidate.	{"{\\"url\\": \\"https://dummyimage.com/795x587\\"}"}	https://www.price-hayden.com/wp-content/wp-content/explore/search.html	http://www.smith.com/	MEDIUM	{9389107162714}	{3532321164606}	6	8	4	Finally term capital during one. Race floor wear member nature cell rock. Better and conference million. Investment peace on home year during coach. Expect move center both enough director.	Bring poor by sound name common. Want foreign reason fast which. Instead production hit morning low short tree him. Identify skill couple base inside pretty difficult study. Tough above important or exactly deep through.	Thus wait finish during our smile. Player popular deep baby. Professional they success eight. Be team wait rock color.	Truth fish paper great. Face likely amount former happen your daughter. Important despite act recently hold type TV. Red score mention step mention include would.	OPEN_TO_ALL
9006898382939	2021-03-27 23:32:40.40686	2021-03-29 23:32:40.40686	f	2b52707b-c84e-4dee-ad7c-1dae4d1b96f0	Ball himself beautiful brother word respond lead interesting.	{"{\\"url\\": \\"https://placekitten.com/462/550\\"}"}	https://hogan.biz/app/faq.htm	http://yoder.net/home.jsp	MEDIUM	{2370183504663}	{}	3	8	7	Window beautiful thank need stop onto partner. Set nation general.	Will more western bank here easy. Of mission participant. Prove law hand result. Everyone price church sit win after certainly. Mission threat government remember idea.	Bill state might main. Perhaps late economic put bank. Sell teach beautiful side organization.	Environmental experience mouth instead tree letter operation. Loss trade leg seven. Fast join tonight blue remember college past. Sing throw prevent writer see set administration.	REQUIRES_APPLICATION
0609833533626	2021-04-05 23:32:40.407609	2021-04-09 23:32:40.407609	f	848e8854-64a5-455f-a903-ff575472ba9b	Together professor almost impact central thousand teach somebody.	{"{\\"url\\": \\"https://dummyimage.com/331x283\\"}"}	https://morrison.com/register/	https://www.rios.info/search/	MEDIUM	{9371874618594}	{7276105513803}	2	5	3	Arm skin interest organization away ago teach. Approach information write good data forget sign. He business arm should call face wife phone.	Top adult rule forward. Air sport right five figure capital.	Church lawyer argue who such key million. Day upon either better. That form true decision meeting. Prepare about goal say ball music drug east.	Fight office organization month without. Rate work thought yet. Garden prevent manager such play even. Determine against wide gun return majority prove. Our them determine total money.	OPEN_TO_ALL
6217013592956	2021-04-01 23:32:40.408163	2021-04-04 23:32:40.408163	f	4e1a1e64-33a4-4bca-a5cf-420146ec19b6	Pressure soldier each there good.	{"{\\"url\\": \\"https://placekitten.com/791/909\\"}"}	https://wilson.com/explore/app/wp-content/homepage.html	https://eaton.com/categories/faq/	MEDIUM	{4464737391231}	{}	5	9	9	Later mouth mean. Impact character along.	Pattern together ok resource. Measure trade team treat boy hand memory. Us himself investment brother student low foreign much. She same score like.	Group partner job audience. Never surface west law manager though. Bar less store note same. Agent site none little imagine state official.	Mission then blood white site situation down. Address PM property ago commercial which not. Society hand phone radio bag suggest last.	REQUIRES_APPLICATION
4826765665621	2021-04-01 23:32:40.421698	2021-04-05 23:32:40.421698	f	a909a1d1-b1fc-4b3b-bed7-c32907795222	Traditional man collection special type clearly between.	{"{\\"url\\": \\"https://placekitten.com/799/423\\"}"}	https://hernandez.com/	http://lopez-pope.biz/	MEDIUM	{8960643281254}	{1231520782520}	3	9	6	Computer conference result. Trial admit me single yes conference contain there. Money red goal begin he professor range. She walk mind black. Candidate on everything bit reveal who anyone language.	It hear attention white. Visit poor front.	Too about budget mouth this commercial two. Consumer card general marriage less whose agreement.	Want brother important remember data receive. Sometimes picture security training big. Form if forward career. Better environmental region business others consider.	OPEN_TO_ALL
6286439111737	2021-04-05 23:32:40.422563	2021-04-09 23:32:40.422563	f	5b473aa8-db81-4ebe-9d2e-b8146229e446	Major relate name contain.	{"{\\"url\\": \\"https://dummyimage.com/787x147\\"}"}	https://www.davis.com/	https://www.hammond-hurley.com/tag/register/	MEDIUM	{8346826433793}	{}	2	4	4	Tend decision of couple country chance find. Action data fight. Support billion soldier cover. West executive skill commercial.	Hair form notice upon suddenly. Fine good rule foreign or point. Population fish these anything.	Marriage brother partner rest represent. Eight decide chair development challenge. Compare particular against on note successful pressure.	Practice guy laugh the whether miss camera. Movie head last early long. Character ball garden indicate pattern. Agreement defense firm ability he budget.	OPEN_TO_ALL
3089101928878	2021-03-24 23:32:40.424585	2021-03-29 23:32:40.424585	f	418bdde9-8132-4a47-b4eb-84c157852c68	Party actually movie knowledge particular whom.	{"{\\"url\\": \\"https://placeimg.com/750/831/any\\"}"}	https://www.boyd.info/category/search/search/login.htm	http://www.diaz-reyes.org/faq.html	MEDIUM	{4761654764644}	{0286775226917}	3	9	5	Tv score direction down else. Back low Mr. Central follow system will. Resource word open let director care some.	Institution black require those imagine after. Smile case should choose kind how party.	Difficult manage future. Stand unit learn avoid onto. Unit whose official door before station surface.	Education away perhaps mother. And someone pull college teach report ability. Job piece ago foot world. Set baby similar. Old because quickly.	REQUIRES_APPLICATION
4245214338129	2021-03-25 23:32:40.425323	2021-03-28 23:32:40.425323	f	a53a6481-5567-4c9b-b2a7-7d19d64b9dce	Spend myself behavior property.	{"{\\"url\\": \\"https://placekitten.com/156/231\\"}"}	https://www.lawson.com/tags/index.php	http://www.dunn.com/tags/posts/list/search/	MEDIUM	{0696447362483}	{4959417060328}	3	3	6	Thought few assume show rate candidate. Region main land agency laugh on draw. Chance right country often very Democrat. Degree back source various work full you chance. Step a consumer politics reality capital none remember.	Pattern perform never. Star hour white outside yet own general red. Allow newspaper recently operation discussion.	Item some yeah. Card walk tonight important hand discover choose consumer. Agent hope air contain.	Across learn some on. Top agree listen section. American PM blue various. Discussion today whom hair include activity man wait.	REQUIRES_APPLICATION
8584738251375	2021-04-10 23:32:40.427514	2021-04-13 23:32:40.427514	f	2bf3e55f-93ad-4138-b982-3b0fa1807546	Artist main sure itself strategy with.	{"{\\"url\\": \\"https://placekitten.com/836/200\\"}"}	https://www.davidson.org/posts/main/categories/author/	http://andrews-thompson.info/home/	MEDIUM	{3733355392946}	{}	2	8	5	Short already Mrs raise floor. Ground claim admit cup several guy rule street. Lose ok table several tonight. Forward field maintain table. Change information exactly crime send.	Trial smile sister know baby two fine her. Republican state budget. Better friend fact pretty resource peace maintain. Figure general officer treatment account.	Crime Congress sing may. Energy successful land. Success source white. Indeed building citizen yet good.	Once group feel seek. Population land realize despite. Difficult no dream travel method.	REQUIRES_APPLICATION
3541688610077	2021-03-25 23:32:40.428149	2021-03-29 23:32:40.428149	f	65e09669-f1d6-4720-836c-aadaa40af24a	Indeed would character well energy.	{}	http://terrell-rodriguez.net/main/search/	http://www.sanchez.com/tags/explore/list/author.asp	MEDIUM	{4246232485420}	{9084155520089}	6	4	6	Billion among by. Sense use with line lose item camera.	Keep serious skin job deal. General any chair discuss child particular specific. Job leg least record base do project seem.	Allow foreign pull sound themselves majority why. Number some fly stuff bank difficult five. Entire thing tree step structure sure cold. Present feeling very.	Radio light much total money even spring. Trip teacher blue structure oil. Organization lawyer say not human south store. With court region career.	REQUIRES_APPLICATION
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
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (uuid);


--
-- Name: personal_identifiers personal_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_pkey PRIMARY KEY (uuid);


--
-- Name: verification_tokens verification_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (uuid);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- Name: accounts accounts__primary_email_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts__primary_email_identifier_uuid_fkey FOREIGN KEY (_primary_email_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: accounts accounts__primary_phone_number_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts__primary_phone_number_identifier_uuid_fkey FOREIGN KEY (_primary_phone_number_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: personal_identifiers personal_identifiers_account_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_account_uuid_fkey FOREIGN KEY (account_uuid) REFERENCES public.accounts(uuid);


--
-- Name: verification_tokens verification_tokens_personal_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_personal_identifier_uuid_fkey FOREIGN KEY (personal_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- PostgreSQL database dump complete
--

