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

--
-- Name: subscriptionentity; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.subscriptionentity AS ENUM (
    'INITIATIVE'
);


ALTER TYPE public.subscriptionentity OWNER TO admin;

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
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.subscriptions (
    uuid uuid NOT NULL,
    entity_type public.subscriptionentity NOT NULL,
    entity_uuid uuid,
    verified boolean NOT NULL,
    identifier_uuid uuid,
    account_uuid uuid
);


ALTER TABLE public.subscriptions OWNER TO admin;

--
-- Name: verification_tokens; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.verification_tokens (
    uuid uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    already_used boolean NOT NULL,
    counter bigint NOT NULL,
    personal_identifier_uuid uuid,
    subscription_uuid uuid
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
0089708771580	2021-05-18 17:26:58.164194	2021-05-21 17:26:58.164194	f	56af3c72-7bcd-4a92-8f46-15517a110594	Case boy page commercial.	{}	https://www.smith-singh.info/categories/blog/list/category.html	2021-05-28 17:26:58.164194	2021-06-01 17:26:58.164194	Which hear skill eat reality create. Reduce itself strong tree politics far describe. Though claim strong. Majority end who seven author open.
5669482044619	2021-05-24 17:26:58.164807	2021-05-28 17:26:58.164807	f	f5a4afa3-fe20-4ecc-8a24-5018aabdde90	Should write song life civil into against performance.	{}	https://www.young-thomas.biz/	2021-06-04 17:26:58.164807	2021-06-06 17:26:58.164807	Tend peace evidence seem after bed. Officer main do system know billion. Commercial wind add free compare sense wind.
2896371178930	2021-05-18 17:26:58.165264	2021-05-23 17:26:58.165264	f	22982155-8427-4b2d-bac3-29496d2e3594	Probably worker program no real agent.	{}	https://www.guerrero.com/app/wp-content/search/faq/	2021-05-30 17:26:58.165264	2021-06-07 17:26:58.165264	Learn feel bad itself control tree serious. Try court member foreign. Fill film brother range who early fill. Final also price number large. Top culture child traditional cell open.
8928453277447	2021-05-21 17:26:58.165654	2021-05-25 17:26:58.165654	f	81025425-9249-440e-a0ac-13d4fb18f09a	Change wish manager than pass image likely.	{}	http://www.davis-smith.com/author/	2021-05-31 17:26:58.165654	2021-06-01 17:26:58.165654	See more real future pretty in improve. Bill mother material daughter employee. Deep white far field Mrs only. Break under table into so money weight. Safe system election pull senior the.
5092551066463	2021-05-19 17:26:58.166171	2021-05-24 17:26:58.166171	f	607ad7c5-15ae-42b8-958f-90988d7ea7d8	Time radio positive foot green effort with.	{"{\\"url\\": \\"https://placekitten.com/348/154\\"}"}	https://www.harris-foster.net/home/	2021-05-30 17:26:58.166171	2021-06-03 17:26:58.166171	Second quality why. No he performance next. Player someone carry occur organization concern.
9852420663034	2021-05-14 17:26:58.174209	2021-05-18 17:26:58.174209	f	21a45b6b-9e3c-4609-9b77-428f536808b2	Carry rock response mouth fund.	{"{\\"url\\": \\"https://dummyimage.com/627x968\\"}"}	http://www.riley.com/	2021-05-26 17:26:58.174209	2021-06-04 17:26:58.174209	Our quite young away his. Under consider similar animal employee defense reason.
8262500915983	2021-05-10 17:26:58.174666	2021-05-13 17:26:58.174666	f	c45bcac1-bf66-49b3-8243-dbf42b9cbe1c	Book cold hotel best full what fund.	{"{\\"url\\": \\"https://www.lorempixel.com/603/471\\"}"}	https://robinson.biz/home/	2021-05-21 17:26:58.174666	2021-05-29 17:26:58.174666	Morning contain traditional course. Possible sell into less represent.
4158275419310	2021-05-18 17:26:58.174984	2021-05-24 17:26:58.174984	f	29f42ddd-7e83-4256-a9e0-e74162497a7f	Game keep management.	{}	http://munoz-malone.com/categories/explore/about.jsp	2021-05-30 17:26:58.174984	2021-06-06 17:26:58.174984	Middle character month fly. Appear yes think cell college ago. Large smile enough challenge.
1661294578201	2021-05-13 17:26:58.177689	2021-05-16 17:26:58.177689	f	8faf2894-131c-4226-8f1b-1a7823d905ee	Include drive street source her professional decide.	{"{\\"url\\": \\"https://placeimg.com/319/844/any\\"}"}	https://www.jones-jacobs.com/register.php	2021-05-24 17:26:58.177689	2021-05-28 17:26:58.177689	Thought seem from message small race. Foreign probably garden ask meeting hold. Project relationship responsibility evening house still cost. Little yard turn show. Prove figure spend explain small.
9788434033962	2021-05-06 17:26:58.178142	2021-05-08 17:26:58.178142	f	07496801-6437-4008-b83b-b3a3b2129454	Poor training head make company.	{"{\\"url\\": \\"https://placekitten.com/318/56\\"}"}	https://www.buck.com/posts/posts/main/main/	2021-05-16 17:26:58.178142	2021-05-20 17:26:58.178142	Hospital new region wish computer. Must garden fall treat north heavy. People provide ever standard professional ground. Which clearly visit throughout full agent standard.
0300229020170	2021-05-21 17:26:58.178495	2021-05-26 17:26:58.178495	f	2f6e5cb6-53ea-4910-8a18-155fb74e44d5	Take again state successful account.	{}	https://ramos.com/	2021-06-01 17:26:58.178495	2021-06-05 17:26:58.178495	Relationship grow raise fear brother. Control hand drug fact eat. Current team throw during type positive civil suggest. Address serious together population administration surface do over. Marriage another his media wall.
7336146610425	2021-05-22 17:26:58.181235	2021-05-27 17:26:58.181235	f	873b66d9-4a70-4ce7-97b7-e247116a321e	Debate list relate which human step.	{"{\\"url\\": \\"https://placekitten.com/235/31\\"}"}	http://www.lawson-campbell.com/main/search/homepage/	2021-06-03 17:26:58.181235	2021-06-04 17:26:58.181235	Act suggest military. Care ahead often adult century. Point company thing table final live drop.
3654956379221	2021-05-21 17:26:58.181661	2021-05-23 17:26:58.181661	f	64836cd9-0a85-4f8c-906a-cece1b8f110b	Notice line begin explain.	{"{\\"url\\": \\"https://dummyimage.com/124x831\\"}"}	http://www.wilson.com/	2021-05-31 17:26:58.181661	2021-06-10 17:26:58.181661	Eat ready local cup. School effect boy suggest report while. Job manage simple.
8293905211455	2021-05-16 17:26:58.182115	2021-05-20 17:26:58.182115	f	183aa859-af22-492b-a665-bb0616f93de4	Site left back reveal face.	{}	https://www.king.com/about/	2021-05-28 17:26:58.182115	2021-06-01 17:26:58.182115	Break rich build yes set. Difficult ahead recently. Accept evening resource.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
7013119390828	2021-05-11 17:26:58.175389	2021-05-16 17:26:58.175389	f	07d7326b-4e7c-4cf9-8701-6e0b2fb03bdd	Allison Leach	1	https://bush-mccormick.com/search/	{"{\\"url\\": \\"https://placeimg.com/972/483/any\\"}"}	Wonder first participant remember and every despite. Record century fact pick behind. According ok either yourself positive. By office for choice guess media. Source Republican goal beyond unit style carry.	{7944288130291,2285481395342}	{9852420663034,8262500915983,4158275419310}
7722216576119	2021-05-25 17:26:58.178827	2021-05-28 17:26:58.178827	f	8002e4cd-035f-4cc4-812a-a62eb774669d	Bryan Bennett	2	https://www.henderson.net/register/	{"{\\"url\\": \\"https://dummyimage.com/820x647\\"}"}	Indeed now tend similar star relationship mind. Without item ball ahead direction. Yeah pass call which show local.	{5093358040212,5928183478575}	{1661294578201,9788434033962,0300229020170}
0183229555688	2021-05-15 17:26:58.182426	2021-05-19 17:26:58.182426	f	11819f72-e963-48e9-96f3-cb4bfe7ba2b7	Joshua Morris	3	https://price.com/explore/author.php	{}	Low follow teach. Everyone avoid concern difficult. Couple police local conference may in notice.	{2630823891028,8362995132015}	{7336146610425,3654956379221,8293905211455}
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
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.subscriptions (uuid, entity_type, entity_uuid, verified, identifier_uuid, account_uuid) FROM stdin;
\.


--
-- Data for Name: verification_tokens; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.verification_tokens (uuid, created_at, already_used, counter, personal_identifier_uuid, subscription_uuid) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
2572219665823	2021-05-17 17:26:58.152187	2021-05-22 17:26:58.152187	f	d9e69e87-32ef-4308-8379-3951d4e0bd70	Nor maintain continue idea line themselves whole.	{"{\\"url\\": \\"https://www.lorempixel.com/640/539\\"}"}	https://nelson.com/	https://www.carr-perkins.biz/app/privacy/	MEDIUM	{3146857346742}	{}	6	2	8	Marriage public third tonight significant if purpose. Skin chair any institution wide use throw. Respond step prove attention concern success court thought. Stay common manager understand within near.	Play get art city week side model. Authority agency include. Especially its suffer agency almost address.	Option upon time hair small. Medical day clearly heart eight policy. Share fear book focus employee.	Down just television summer dog meet. Wait see family democratic.	REQUIRES_APPLICATION
4595571636582	2021-05-10 17:26:58.153203	2021-05-13 17:26:58.153203	f	f0b9f14f-e00b-45ec-8d03-877c4903cc23	Magazine relationship will.	{"{\\"url\\": \\"https://placekitten.com/475/528\\"}"}	http://www.mcconnell.org/categories/search/tag/homepage.html	http://www.williams.biz/search.jsp	MEDIUM	{0534673435550}	{8811815094755}	6	8	4	Onto yeah interesting now amount eat look goal. Within television college have. Mr heavy reflect rich ago. Wait staff tell choose industry stuff risk.	Music wait body. Party billion dream parent. But south institution analysis democratic.	Just scene recognize into. Step herself left focus. Else business medical would.	Require central national forget above detail. Skill wind wonder team mention whether. Recognize four dinner learn late.	OPEN_TO_ALL
9737650780914	2021-05-11 17:26:58.154339	2021-05-13 17:26:58.154339	f	15504b28-aa36-4fc6-b2fe-10f1435f83a7	Well data name suggest focus ball may age.	{"{\\"url\\": \\"https://placekitten.com/310/770\\"}"}	http://www.oconnor.com/blog/tags/post/	http://www.smith.com/register/	MEDIUM	{6988450393719}	{}	3	8	7	Support make case follow him left economy. Reason professional discover keep computer when spend. Have prevent machine learn visit choice.	Picture provide figure force election. Majority child whose beautiful. Street agreement today degree century. Me own heavy report. Bill interest read occur staff television.	Positive civil easy fund unit house lawyer political. Not course base play meet think. Agent add but scene each car hard.	Let single six here. Part difficult color sign. Author term less exactly firm. True play specific environmental.	REQUIRES_APPLICATION
7510591358259	2021-05-20 17:26:58.155102	2021-05-24 17:26:58.155102	f	8c3f27e9-6d09-4a75-8bc0-c3018504b993	Director possible able style.	{"{\\"url\\": \\"https://placekitten.com/221/839\\"}"}	http://www.miller.info/main/search/explore/faq/	http://www.scott-vasquez.com/search/	MEDIUM	{5104370801061}	{3284383678156}	2	5	3	Successful explain like. Too quickly stay as record.	Political approach continue big. Market approach vote for carry senior. Course full central reflect wonder scene finally.	After debate visit prove deal. They challenge movement bank while course skill. Carry kid no last church medical dark fight. Training happen town before local.	Sport usually would old authority front. Produce analysis something last also act performance case. Rich director most interview popular consumer phone piece. News trial part cut. Everything relationship hundred of social middle door.	OPEN_TO_ALL
9649052399109	2021-05-16 17:26:58.156144	2021-05-19 17:26:58.156144	f	9d590d11-215f-480b-b1cf-e9b2334f4310	Without fear energy perhaps ground seven poor thousand.	{"{\\"url\\": \\"https://placekitten.com/428/916\\"}"}	https://mckenzie.com/posts/wp-content/home/	http://short-harrison.net/	MEDIUM	{2644547116534}	{}	5	9	9	Several attention level standard already. Use let edge style able everyone. Crime each upon sign my. Against smile beautiful site soon recently color. Land past camera act our.	Fact animal because white behind hospital story. Return lot section likely. Sometimes movement newspaper product speech also describe. Room term factor his same.	Space act send education line task old course. Produce eight church task teach two. Ask career walk well performance call. Hear hand woman reflect last. Baby well similar for manager hold within.	Eight leader true evening must catch job. Newspaper vote that civil top. Pull industry performance maybe several which.	REQUIRES_APPLICATION
7944288130291	2021-05-16 17:26:58.172389	2021-05-20 17:26:58.172389	f	474efba3-8952-4080-92cf-a7ce30600949	Early win remain get everybody for under recognize.	{"{\\"url\\": \\"https://dummyimage.com/901x682\\"}"}	http://armstrong.biz/author/	http://webb-montoya.com/terms.html	MEDIUM	{8330759658873}	{2302900360085}	3	9	6	Short pick paper to situation affect senior. Election left few consider computer child. Idea generation out. Budget pick hit same actually myself day. Learn economy present child only kitchen social.	Him whether always return doctor financial budget. Not may down oil west ability tend provide. Tell bill song pretty fly its.	Available resource same. Usually day think once form country animal huge. Senior administration deal help similar program. Majority call nature establish as.	Short bad security. Reality economic ever agreement than. Here positive any. Shake science book.	OPEN_TO_ALL
2285481395342	2021-05-20 17:26:58.173427	2021-05-24 17:26:58.173427	f	492a4474-3606-4e59-808d-8e0947aec464	Final its indeed hundred.	{"{\\"url\\": \\"https://dummyimage.com/323x266\\"}"}	http://anderson-murray.com/post/	http://www.huerta-holt.info/	MEDIUM	{6717600033799}	{}	2	4	4	Writer dark amount. Decide available challenge. Draw cover official under cell left. Only change well much prepare wind.	Once ability film become. Everybody doctor everyone writer.	Machine show cup figure good. Now beyond choice close especially blood education so.	Attorney environment cup power soldier you always nature. Ten side according effect environmental may great.	OPEN_TO_ALL
5093358040212	2021-05-08 17:26:58.176011	2021-05-13 17:26:58.176011	f	45255a48-ad91-4b36-b67a-b99e2342865f	Budget together seem once democratic kind cause now.	{"{\\"url\\": \\"https://placeimg.com/545/569/any\\"}"}	https://arnold.com/tag/explore/wp-content/register.jsp	https://www.martin-jones.com/	MEDIUM	{4748482523919}	{6128975918916}	3	9	5	Movie doctor ago line once body. Peace community fear model.	Fine four win activity. Heart amount side area even.	Draw behind security last. Guy marriage develop school. International stage morning machine.	Learn thing thus attack trouble Republican fast. Home maintain three stuff. Edge so none. Woman safe question challenge fast meeting attention. Way rich American body contain per.	REQUIRES_APPLICATION
5928183478575	2021-05-09 17:26:58.176772	2021-05-12 17:26:58.176772	f	bd7a0bb4-57e4-45ea-b6a9-0e91b218796e	Law trouble voice nation couple this.	{"{\\"url\\": \\"https://www.lorempixel.com/868/662\\"}"}	https://williams.com/terms.html	http://www.lopez.com/categories/post.asp	MEDIUM	{3355490055809}	{4107175005710}	3	3	6	Pass quite goal identify team book simply. Travel court mouth general top south. Six history affect level recently than glass these. Staff doctor change husband leave compare control.	Four either next drive bag public fact. Enjoy seven ahead job to somebody factor. Source executive fund. Beat performance over. Result year significant industry trouble imagine.	Station get eye safe. Himself senior lead often drug discuss require. Stage thus campaign food.	Trouble player light tree quickly. Miss company behind agency late. Rule wide owner letter newspaper. See can off. Leg attention for size.	REQUIRES_APPLICATION
2630823891028	2021-05-25 17:26:58.179335	2021-05-28 17:26:58.179335	f	ef7bcf6a-bc40-4ff7-8994-fbde2152f4e2	Show letter wear cold type show.	{"{\\"url\\": \\"https://placeimg.com/208/107/any\\"}"}	https://www.weber-crawford.com/posts/login/	http://www.wilson-strong.org/main/posts/terms/	MEDIUM	{2794804163358}	{}	2	8	5	Receive tell here respond explain base explain. Major police message south and certain. Throw admit last important radio eat thing.	Leave herself street decade art hospital. Quickly why available particularly reduce no put citizen. Point different recognize sense section box weight treat. Kind center strategy act why design student.	Letter most thousand usually old year rise. Staff run total ask read.	Center answer beyond like. Time blue will under yet natural range. Far remember heart major side. Wish machine sport article eye this. Factor much brother end race our consider white.	REQUIRES_APPLICATION
8362995132015	2021-05-09 17:26:58.180249	2021-05-13 17:26:58.180249	f	1af30882-645c-4546-b8b9-483526f87eb0	Democrat herself idea.	{}	http://www.garza.com/	http://www.greene.net/tags/home.html	MEDIUM	{9141664533938}	{8033760954391}	6	4	6	Teacher music stuff. Federal reality song memory too I. Help something wonder down discover reduce would. Example stay piece action hand because.	Glass because my themselves bank decision health. Eye window maybe environmental performance. Before course lose first indeed war lay. Relationship operation specific. Fish culture voice show western create.	Friend among appear get I become also. Parent could paper act. Know expert trial sign. Daughter everything probably serve.	Star behind could best too explain current for. Agent value sort see indicate. Behavior second truth spring. Stay pull sit front determine risk. Its choose paper common woman above rise position.	REQUIRES_APPLICATION
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
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (uuid);


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
-- Name: ix_sub_account_uuid; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_sub_account_uuid ON public.subscriptions USING hash (account_uuid);


--
-- Name: ix_sub_id_uuid; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_sub_id_uuid ON public.subscriptions USING hash (identifier_uuid);


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
-- Name: subscriptions subscriptions_account_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_account_uuid_fkey FOREIGN KEY (account_uuid) REFERENCES public.accounts(uuid);


--
-- Name: subscriptions subscriptions_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_identifier_uuid_fkey FOREIGN KEY (identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: verification_tokens verification_tokens_personal_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_personal_identifier_uuid_fkey FOREIGN KEY (personal_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: verification_tokens verification_tokens_subscription_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_subscription_uuid_fkey FOREIGN KEY (subscription_uuid) REFERENCES public.subscriptions(uuid);


--
-- PostgreSQL database dump complete
--

