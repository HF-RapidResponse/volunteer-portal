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
    'GOOGLE_ID',
    'GITHUB_ID'
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
-- Name: account_settings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.account_settings (
    uuid uuid NOT NULL,
    account_uuid uuid,
    show_name boolean NOT NULL,
    show_email boolean NOT NULL,
    show_location boolean NOT NULL,
    organizers_can_see boolean NOT NULL,
    volunteers_can_see boolean NOT NULL,
    initiative_map json NOT NULL,
    password_reset_hash text,
    password_reset_time timestamp without time zone
);


ALTER TABLE public.account_settings OWNER TO admin;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.accounts (
    uuid uuid NOT NULL,
    username character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    password text,
    profile_pic text,
    city character varying(32),
    state character varying(32),
    roles character varying[] NOT NULL,
    zip_code character varying(32),
    _primary_email_identifier_uuid uuid,
    _primary_phone_number_identifier_uuid uuid
);


ALTER TABLE public.accounts OWNER TO admin;

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
-- Data for Name: account_settings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.account_settings (uuid, account_uuid, show_name, show_email, show_location, organizers_can_see, volunteers_can_see, initiative_map, password_reset_hash, password_reset_time) FROM stdin;
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, username, first_name, last_name, password, profile_pic, city, state, roles, zip_code, _primary_email_identifier_uuid, _primary_phone_number_identifier_uuid) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
6056219346990	2021-05-16 16:35:22.898536	2021-05-19 16:35:22.898536	f	da791fbc-f890-4980-83cd-6baac00b08d8	Special site see determine pattern.	{}	http://www.oliver.info/tags/terms.html	2021-05-26 16:35:22.898536	2021-05-30 16:35:22.898536	To source notice cut rich. Raise situation gas audience. Figure early reveal yes unit see despite dark. Raise arm paper teacher product care.
8182178994052	2021-05-22 16:35:22.899278	2021-05-26 16:35:22.899278	f	48c6dfee-f50b-41e3-a299-3388b3440890	Area which dream certainly only fund high.	{}	http://www.hayes.com/main/category/explore/login/	2021-06-02 16:35:22.899278	2021-06-04 16:35:22.899278	Down have ever laugh player market. Cost often during group. Husband morning matter issue interview month great. Nature game once.
0395096938253	2021-05-16 16:35:22.900084	2021-05-21 16:35:22.900084	f	d3439319-47f2-4726-9ead-ffaec017eb97	Money court part message mind green.	{}	https://www.tapia-reed.com/author/	2021-05-28 16:35:22.900084	2021-06-05 16:35:22.900084	Education organization senior mind argue anyone hair. Heart compare discover memory provide. True respond nor apply would western. Kind air local he player watch.
4494023330521	2021-05-19 16:35:22.90069	2021-05-23 16:35:22.90069	f	6f70b97a-2c64-49b1-96d7-237f39f8a904	Reality middle young south think wrong.	{}	https://cochran.com/	2021-05-29 16:35:22.90069	2021-05-30 16:35:22.90069	Give his traditional key traditional over. Return small fast operation. Campaign individual certain here. Program sound day employee education level glass.
3388510052694	2021-05-17 16:35:22.901494	2021-05-22 16:35:22.901494	f	e10ef625-d3c9-4c6b-93e0-d6c767afd52b	Pretty yard public country when.	{"{\\"url\\": \\"https://placeimg.com/38/667/any\\"}"}	http://krueger.com/faq.html	2021-05-28 16:35:22.901494	2021-06-01 16:35:22.901494	Energy woman sea ready. List price most exist. Five yes boy these hard guess man by.
4551178791970	2021-05-12 16:35:22.911349	2021-05-16 16:35:22.911349	f	d5545420-5a1c-4dfb-91b0-39aa9afd7c22	Candidate four read public describe stay.	{"{\\"url\\": \\"https://placeimg.com/973/930/any\\"}"}	http://kim-boyd.org/category/about/	2021-05-24 16:35:22.911349	2021-06-02 16:35:22.911349	Cup growth race move. Black author ok build money. Figure professional serious eye.
5665975233416	2021-05-08 16:35:22.911948	2021-05-11 16:35:22.911948	f	d4e11969-b49a-4e4a-9245-c6fd9e1f42d3	Movement pull administration some share knowledge left first.	{"{\\"url\\": \\"https://placeimg.com/767/866/any\\"}"}	https://www.ortiz.com/main/	2021-05-19 16:35:22.911948	2021-05-27 16:35:22.911948	Role wife wife myself team along. Compare there few whatever must before. Social road story several few. Trade tonight program trial beyond democratic.
2047234397443	2021-05-16 16:35:22.912565	2021-05-22 16:35:22.912565	f	683f49ae-76ad-4311-a0b1-c276d5aa1a31	Yeah reason individual road center.	{}	https://lewis.info/terms/	2021-05-28 16:35:22.912565	2021-06-04 16:35:22.912565	Suddenly six discover relate trial stock. Be specific give life debate name. Argue else need long. Building offer task ready mother soon.
1109967297412	2021-05-11 16:35:22.916334	2021-05-14 16:35:22.916334	f	a194e421-59b6-49a7-b066-3518908cd1b9	Around start after north.	{"{\\"url\\": \\"https://placeimg.com/591/382/any\\"}"}	https://wood.org/categories/list/search.php	2021-05-22 16:35:22.916334	2021-05-26 16:35:22.916334	Need to will throw speech charge. Hit among six push compare. Sell else bag country artist later bar with. Walk stand true reality provide. Author shake phone answer I.
1670048705213	2021-05-04 16:35:22.917011	2021-05-06 16:35:22.917011	f	528c906c-e590-46cb-9a24-b35bb5527865	Simple mission dog good thousand indicate.	{"{\\"url\\": \\"https://dummyimage.com/805x613\\"}"}	https://miranda.info/tags/search/post/	2021-05-14 16:35:22.917011	2021-05-18 16:35:22.917011	Structure hundred concern which item buy. Short once son throughout light sure art. Side I specific might.
5270547114286	2021-05-19 16:35:22.917639	2021-05-24 16:35:22.917639	f	01b2ad96-5459-442d-aa63-66dc34cabaf7	Even past without much.	{}	https://collins.com/	2021-05-30 16:35:22.917639	2021-06-03 16:35:22.917639	Suddenly public evidence he hundred rest. Determine establish wear piece. Entire forward land common remember mouth.
5303929509216	2021-05-20 16:35:22.921126	2021-05-25 16:35:22.921126	f	5373562a-c806-445f-90c3-c8c0096b5235	Training north bill if control in lot strategy.	{"{\\"url\\": \\"https://dummyimage.com/212x98\\"}"}	http://www.mills.com/homepage.html	2021-06-01 16:35:22.921126	2021-06-02 16:35:22.921126	Deal education shake from address leave. Summer democratic half station. Her focus billion employee.
5347920879275	2021-05-19 16:35:22.921504	2021-05-21 16:35:22.921504	f	2f0c2668-df72-4435-adad-0848f552103f	Figure establish month outside trouble job.	{"{\\"url\\": \\"https://www.lorempixel.com/867/495\\"}"}	http://franklin.com/faq/	2021-05-29 16:35:22.921504	2021-06-08 16:35:22.921504	Structure whether political decision. Care company seat six fly number model. Buy police base. Travel side morning yeah protect third. Far gas art available add on meeting.
9183419837625	2021-05-14 16:35:22.922247	2021-05-18 16:35:22.922247	f	fa8f236b-bbb9-4461-a795-38faa6211e0d	Really sort simply culture.	{}	http://www.jones-blanchard.com/about/	2021-05-26 16:35:22.922247	2021-05-30 16:35:22.922247	White claim blood chance bad writer. Simply discussion all though he meeting worker suggest. Way myself mother strong gun national policy. East thus method TV season. Truth resource road down man.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
2361157123140	2021-05-09 16:35:22.913257	2021-05-14 16:35:22.913257	f	9c04e10e-7b4d-4ac5-9873-dd4cc8b6217a	Logan Clark	1	http://white.org/blog/categories/explore/homepage/	{"{\\"url\\": \\"https://dummyimage.com/663x132\\"}"}	Score tough later card push couple become. Another heavy half site area keep. Bag whole possible century. Particular price represent expect program least fast great. Student bill she economy old discuss turn.	{7275824548264,4533740455879}	{4551178791970,5665975233416,2047234397443}
6672516079838	2021-05-23 16:35:22.918049	2021-05-26 16:35:22.918049	f	f20e5ea2-e80a-4674-9a1b-2d34e5375d50	Deborah Carr	2	http://www.jackson-warren.com/explore/author/	{"{\\"url\\": \\"https://dummyimage.com/304x959\\"}"}	Plan name skill method wall result manager argue. Law hold medical her after per nothing. Bad plan letter pressure example onto. Piece tough always for away.	{1136740998334,8346566011824}	{1109967297412,1670048705213,5270547114286}
4507130976640	2021-05-13 16:35:22.92272	2021-05-17 16:35:22.92272	f	6eb4b797-e5ea-49c6-940b-a1a879210d3b	Jaime Beard	3	https://www.ingram-brown.info/register/	{}	Skin century religious bag reality worker. Word reveal share score modern on. Letter whose shoulder. Evening action example reach old serious center.	{8232648857346,0617474511095}	{5303929509216,5347920879275,9183419837625}
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
2785068837741	2021-05-15 16:35:22.878967	2021-05-20 16:35:22.878967	f	fa75a2b0-9b65-4cae-b9a4-f1f40d0ec47d	Push when group still.	{"{\\"url\\": \\"https://dummyimage.com/279x171\\"}"}	https://www.johnson.com/posts/categories/faq/	https://www.larson-gonzalez.info/wp-content/posts/terms/	MEDIUM	{6603679841727}	{}	6	2	8	Food make attention baby season ago anyone. Vote better life indicate. Environment ever after full state. Work debate for his garden benefit than.	Newspaper PM opportunity couple though where century. Present ready west indeed capital. Happy indeed parent perform onto.	Each cultural nearly. Middle two common magazine marriage case. Affect apply summer.	Can force consumer view worry international. Benefit total chair alone skin agree.	REQUIRES_APPLICATION
1649026518916	2021-05-08 16:35:22.881509	2021-05-11 16:35:22.881509	f	4fd94e0f-4fca-43ce-99a9-0d291ae58017	Size star point mention yes special.	{"{\\"url\\": \\"https://www.lorempixel.com/334/300\\"}"}	https://oliver.com/login/	https://www.grant-johnson.com/search/wp-content/tag/faq/	MEDIUM	{7861764326637}	{8825280504190}	6	8	4	Security policy experience front. News understand people improve generation. Charge special discover here whose tree child.	Enough role popular. Man may Congress later seat. Since develop soon how before author range day. Deal red and join. Others important building maybe toward short.	Quality item idea. Support per never culture. Street professional opportunity level anyone simply remember. Couple officer maintain occur election address. Model affect go still over worry onto concern.	One Republican their hand. Training play per quickly factor in listen camera. Always great pass leave dinner. Real weight become develop chair open itself moment.	OPEN_TO_ALL
1790771619455	2021-05-09 16:35:22.883984	2021-05-11 16:35:22.883984	f	3961be18-8b87-4d6f-9a9c-95316bf94f51	Response require Republican.	{"{\\"url\\": \\"https://placekitten.com/348/81\\"}"}	http://www.reed.com/	https://www.reed.org/privacy.asp	MEDIUM	{9649998472935}	{}	3	8	7	From mean arm again live I. Hair tax general apply trade concern director. Send reality there report much participant style. Recently certainly then production sea politics enter.	Spend letter turn around especially or happen. Change mind up radio reflect. Recently establish region difficult unit. While quality or cell training. Budget serious hundred machine during recent.	Forward lay recent recognize among. Medical kind chance marriage but research. Worry why note improve contain never strong air. Week morning language western bad think.	Example world suddenly president dream. Group establish reality may power federal. Door north task society conference sign. Cultural join do attorney natural.	REQUIRES_APPLICATION
3745135781253	2021-05-18 16:35:22.885707	2021-05-22 16:35:22.885707	f	25caaae4-079c-4442-ad29-ae847d2bcd8f	Drive hundred half fall tell dark.	{"{\\"url\\": \\"https://placeimg.com/523/841/any\\"}"}	http://leon-jones.com/search/	https://rogers.net/app/terms/	MEDIUM	{7427255189855}	{0075992420624}	2	5	3	Yes Mrs probably see. Hand already hear other hand attack quickly next. When mean computer.	Election election usually source sit eight. Threat loss employee not gun. Within pick including provide.	Area environment artist focus especially yet. Risk rise treat decide. Campaign father note visit six. Notice compare form tend career memory as. Anything law term send.	Night those national off. Center cultural baby. Walk bit beyond move wear best. Exactly source break history.	OPEN_TO_ALL
4801442564091	2021-05-14 16:35:22.888027	2021-05-17 16:35:22.888027	f	e44221e0-66fb-4311-bf3e-3758b9506e4d	Painting likely rock weight though perform later.	{"{\\"url\\": \\"https://placekitten.com/1014/50\\"}"}	http://anderson.com/post.htm	https://www.sanchez.com/categories/tags/blog/index.php	MEDIUM	{8522433979088}	{}	5	9	9	Manager science play person. Bill why page woman local quality listen.	Tree policy southern difficult chair. Behind and fund sing prevent skin. Store member sport resource.	Happy decision must wonder son form yes. Better party size conference college factor. Throw quality reduce century. Red catch yes add.	More drug worker grow. Family call case eye its summer. Ability full finish hard place condition return fast. Usually appear sister produce evidence. Chair the ok action could.	REQUIRES_APPLICATION
7275824548264	2021-05-14 16:35:22.908151	2021-05-18 16:35:22.908151	f	d50a2a7c-90ea-4607-836f-87351d7889d5	No administration politics friend send.	{"{\\"url\\": \\"https://www.lorempixel.com/209/103\\"}"}	http://jones.net/index/	http://www.mullins.info/home.asp	MEDIUM	{1918247850878}	{3651371264026}	3	9	6	Various although style option program of. Everyone head matter let somebody different window alone. Someone add general where what hand discover. History citizen fill test home team plan. Wish carry chair indeed resource indicate.	Outside himself space gas send above hand cultural. Investment include face high hundred me add.	Significant paper might or art hold. Rock top face scientist.	Material bit bit month yeah. Join mother eye stop involve begin about. Trip into material collection cold thought list. Author herself before computer person move cup. Be follow history class bit.	OPEN_TO_ALL
4533740455879	2021-05-18 16:35:22.909937	2021-05-22 16:35:22.909937	f	04eb5388-227c-4849-9eb6-3a4aab55a653	About point sign her but.	{"{\\"url\\": \\"https://www.lorempixel.com/39/786\\"}"}	http://www.mcdonald.com/post/	http://www.curtis-rice.com/terms.htm	MEDIUM	{7223832721612}	{}	2	4	4	Radio never our gun hot. Call nor late reach single. Impact already exist individual security political. Goal catch friend entire surface sing somebody. Think really story floor show city allow.	Development more system determine listen Congress teach. Bank already level seven. Their five have floor perform share. Executive eat personal smile. Order lay science trade address reduce energy.	Attack list relate oil. Perhaps take mouth myself guess sure I rather. Television mission project enjoy.	Get wrong specific participant best after. Represent yeah easy kind. Space theory determine during voice sure. Rise expert parent amount entire themselves.	OPEN_TO_ALL
1136740998334	2021-05-06 16:35:22.914007	2021-05-11 16:35:22.914007	f	bfc5d39e-44f0-4b24-961e-95a3c144ebf0	Company how I laugh half marriage.	{"{\\"url\\": \\"https://www.lorempixel.com/728/766\\"}"}	http://www.wolfe.net/index.htm	http://www.ayala.info/	MEDIUM	{3863036736353}	{0382987838662}	3	9	5	They relate think dinner public space live edge. Save media one alone end foot total. Simple health agree wife these fly of. Suffer couple travel discover. Do thought chair finally.	Water state expert what individual several table. Score establish want vote enjoy become last. Dark only quality kind group sound.	Really when news protect if card defense college. Buy sister property contain record lead. Time through store.	National side center activity. Whose contain various field sign.	REQUIRES_APPLICATION
8346566011824	2021-05-07 16:35:22.915084	2021-05-10 16:35:22.915084	f	cd871d12-ebb3-435c-a2e6-e0aeb004bbce	Responsibility outside billion politics.	{"{\\"url\\": \\"https://www.lorempixel.com/726/667\\"}"}	https://perez.com/blog/main/list/terms/	https://olson-thomas.com/index/	MEDIUM	{5091666129063}	{6069177930828}	3	3	6	Involve manager investment us big. Turn country second us evening compare. Whether green my ask investment society. Someone ground pressure.	Soon put school appear. Put morning dark. World get enter animal college once fear positive. Activity wonder outside current worry action old.	Only themselves water last establish indeed phone arm. Reach design go. Major remain cell structure high her low career. Conference out thousand magazine challenge under page.	First short present cell sit know present huge. Focus people weight.	REQUIRES_APPLICATION
8232648857346	2021-05-23 16:35:22.918859	2021-05-26 16:35:22.918859	f	795bc192-cd71-4b91-8ef8-b9929b8c5dfb	These case heavy play necessary next.	{"{\\"url\\": \\"https://placeimg.com/837/894/any\\"}"}	https://www.pierce.org/homepage.php	https://www.henderson-gomez.org/	MEDIUM	{6245872965468}	{}	2	8	5	Order cell move yeah hundred particularly American. Least just when hold Mrs mind today. Build never hand already partner wish. Recent really work still.	Off then building art such. Involve spring clearly return sign. Rather table quite sense since. Church sense thought memory week PM.	Really because list both. Fine though artist land paper name. Popular month analysis mind. All source parent both hit.	Exactly kitchen explain. Compare federal crime any real when really. National others from central daughter maintain still. Actually next fish compare behind politics. Southern source easy become.	REQUIRES_APPLICATION
0617474511095	2021-05-07 16:35:22.920104	2021-05-11 16:35:22.920104	f	fa08f289-5d95-4985-9cda-a7bcab476846	Simply gas growth art remember article direction.	{}	http://www.carter-walters.com/explore/post.html	http://www.payne.com/author.html	MEDIUM	{1106300763887}	{0838137848123}	6	4	6	Cultural natural seven he. Despite their hold paper remember reveal natural thing. Family guy type success call.	Speech shake go table easy good. Whole bit reason husband wear character eye. Size always describe. Cell spring less music gun worry. Evening try Mrs dream process.	Behavior question front federal bar commercial newspaper each. Official level can lot arm share health. Agent great large remain than reality. Pass body baby reason nothing.	Talk effect prepare candidate among upon together. Scientist wonder recent push inside price order. Order check television lay side.	REQUIRES_APPLICATION
\.


--
-- Name: account_settings account_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_settings
    ADD CONSTRAINT account_settings_pkey PRIMARY KEY (uuid);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (uuid);


--
-- Name: accounts accounts_username_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_username_key UNIQUE (username);


--
-- Name: events events_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_id_key UNIQUE (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (uuid);


--
-- Name: initiatives initiatives_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.initiatives
    ADD CONSTRAINT initiatives_id_key UNIQUE (id);


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
-- Name: personal_identifiers personal_identifiers_type_value_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_type_value_key UNIQUE (type, value);


--
-- Name: verification_tokens verification_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (uuid);


--
-- Name: volunteer_openings volunteer_openings_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_id_key UNIQUE (id);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- Name: ix_account_uuid; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_account_uuid ON public.personal_identifiers USING hash (account_uuid);


--
-- Name: ix_event_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_event_id ON public.events USING hash (id);


--
-- Name: ix_role_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_role_id ON public.volunteer_openings USING hash (id);


--
-- Name: ix_value; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_value ON public.personal_identifiers USING hash (value);


--
-- Name: account_settings account_settings_account_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.account_settings
    ADD CONSTRAINT account_settings_account_uuid_fkey FOREIGN KEY (account_uuid) REFERENCES public.accounts(uuid);


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

