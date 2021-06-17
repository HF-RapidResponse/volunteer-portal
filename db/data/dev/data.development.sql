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
    external_id character varying(255) NOT NULL,
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
    external_id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    initiative_name character varying(255) NOT NULL,
    "order" integer NOT NULL,
    details_url character varying(255),
    hero_image_urls json[],
    content text NOT NULL,
    role_ids character varying[] NOT NULL,
    event_ids character varying[] NOT NULL
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
    external_id character varying(255) NOT NULL,
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

COPY public.account_settings (uuid, account_uuid, show_name, show_email, show_location, organizers_can_see, volunteers_can_see, password_reset_hash, password_reset_time) FROM stdin;
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, username, first_name, last_name, password, profile_pic, city, state, roles, zip_code, _primary_email_identifier_uuid, _primary_phone_number_identifier_uuid) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (external_id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
4972791426238	2021-06-08 15:50:49.115156	2021-06-11 15:50:49.115156	f	b1bb7bfa-142f-4bfd-af48-08e6c9585c31	Moment employee visit southern west yard everyone.	{}	http://clark.org/search/	2021-06-18 15:50:49.115156	2021-06-22 15:50:49.115156	Federal industry whatever that move realize real wish. Including southern song strong blood knowledge. Water anyone out. Manage budget series none draw. New write month.
6352519357422	2021-06-14 15:50:49.115665	2021-06-18 15:50:49.115665	f	e69a677a-cc66-40ab-94a4-14b0611fa3f7	Radio strategy reflect population he visit throughout.	{}	https://johnson.com/app/about/	2021-06-25 15:50:49.115665	2021-06-27 15:50:49.115665	Action three want quickly about few. General son keep sport site. Responsibility consider poor she. Senior thing wear a occur institution property.
2682074295933	2021-06-08 15:50:49.116164	2021-06-13 15:50:49.116164	f	de1a0813-93b3-4749-b995-98939f87d963	My management fight.	{}	http://www.wilson.biz/register.php	2021-06-20 15:50:49.116164	2021-06-28 15:50:49.116164	Alone few particularly. Recognize lot low but and. War result example think believe. If director let particularly paper reduce result choice. Happy third close himself.
5651968150082	2021-06-11 15:50:49.116495	2021-06-15 15:50:49.116495	f	38ddfef0-6e24-4ec0-bc98-eace7aa79fb7	Put business anything need.	{}	https://hunter.com/explore/categories/main/author.htm	2021-06-21 15:50:49.116495	2021-06-22 15:50:49.116495	Begin my give myself you effect. Less bit score work two. Idea often care best office student machine.
8176252214075	2021-06-09 15:50:49.116958	2021-06-14 15:50:49.116958	f	1d610e7a-0e33-4e94-a50a-c436d3de9d52	President fact chance base enough body wait.	{"{\\"url\\": \\"https://dummyimage.com/649x504\\"}"}	http://howell-williams.com/tags/categories/explore/homepage.htm	2021-06-20 15:50:49.116958	2021-06-24 15:50:49.116958	Story nation lose product include system data last. Television appear join food skill line.
7622243241083	2021-06-04 15:50:49.123327	2021-06-08 15:50:49.123327	f	33c72e24-1a2f-4ece-bdbe-0f26be495461	Cover ready want middle land shoulder.	{"{\\"url\\": \\"https://placekitten.com/703/427\\"}"}	http://www.stone.info/author.php	2021-06-16 15:50:49.123327	2021-06-25 15:50:49.123327	Stay himself however design must that. Pretty individual believe technology practice. Hundred effort property government example enter father. During already expert arrive model of key employee. Wind property believe cultural do per.
7020144363154	2021-05-31 15:50:49.123671	2021-06-03 15:50:49.123671	f	a6efcf75-058a-4f99-b51d-ca1bdf25f29a	Hope ever central kid finish to decade drive.	{"{\\"url\\": \\"https://placeimg.com/341/704/any\\"}"}	https://thornton-carter.com/list/search.jsp	2021-06-11 15:50:49.123671	2021-06-19 15:50:49.123671	Animal material size become religious television. Why how would authority while book. For who budget like.
3980221953422	2021-06-08 15:50:49.12407	2021-06-14 15:50:49.12407	f	5dace4e6-f6b3-4ef2-aa81-e9271f16e3e7	Everything skin total clearly.	{}	https://www.moran.net/login.html	2021-06-20 15:50:49.12407	2021-06-27 15:50:49.12407	Image water benefit respond mention. No think worry turn product civil life. Officer after brother set million force.
8700965961430	2021-06-03 15:50:49.126892	2021-06-06 15:50:49.126892	f	9500aab7-2e95-4d55-b562-98b5837699aa	Present girl interest possible commercial toward wait director.	{"{\\"url\\": \\"https://dummyimage.com/408x750\\"}"}	https://www.smith-ortiz.net/category/search/category/	2021-06-14 15:50:49.126892	2021-06-18 15:50:49.126892	Outside knowledge mother north themselves study kind. Challenge thing down month. Suddenly him forward truth.
7543958367571	2021-05-27 15:50:49.127346	2021-05-29 15:50:49.127346	f	f7b3e731-29b2-43d3-9043-4c882e660b41	So situation reach lawyer reduce notice child.	{"{\\"url\\": \\"https://www.lorempixel.com/166/655\\"}"}	http://www.fowler-singleton.com/index/	2021-06-06 15:50:49.127346	2021-06-10 15:50:49.127346	Key ok degree. Development involve of piece can reason.
0799248058231	2021-06-11 15:50:49.127723	2021-06-16 15:50:49.127723	f	4d906f75-f03e-435e-b1f6-98c092c6e5e9	Wife social unit number give enough sell.	{}	https://www.williams-hughes.com/list/terms/	2021-06-22 15:50:49.127723	2021-06-26 15:50:49.127723	Will ability here sport. Care defense language. Indicate probably open beat especially magazine standard.
3426454609670	2021-06-12 15:50:49.130471	2021-06-17 15:50:49.130471	f	144580fa-ebeb-48d8-8450-98fecd31f3a7	Thing hand real director.	{"{\\"url\\": \\"https://www.lorempixel.com/235/632\\"}"}	http://chen-conway.com/search/terms/	2021-06-24 15:50:49.130471	2021-06-25 15:50:49.130471	Time painting one surface. Huge house memory red picture social purpose. Mr light already picture country per bring.
9546636491153	2021-06-11 15:50:49.130858	2021-06-13 15:50:49.130858	f	3b88867d-fe53-457c-9f5b-81a429aa46b3	Production commercial information body be agent enter lay.	{"{\\"url\\": \\"https://placeimg.com/739/165/any\\"}"}	http://perry.com/tags/post/	2021-06-21 15:50:49.130858	2021-07-01 15:50:49.130858	Else spend summer unit idea many when. Their picture various when thus a.
0101458731055	2021-06-06 15:50:49.131306	2021-06-10 15:50:49.131306	f	9463bea5-dd60-43af-9fc7-b5367eecbd00	Detail ago Republican wife.	{}	https://www.vega-carter.com/	2021-06-18 15:50:49.131306	2021-06-22 15:50:49.131306	Pull goal deep technology difficult family. Improve current lot. Camera time push score bar trial attack. Leave think western brother.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (external_id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_url, hero_image_urls, content, role_ids, event_ids) FROM stdin;
8527283167951	2021-06-01 15:50:49.124525	2021-06-06 15:50:49.124525	f	4b3de86b-16c3-4bac-8c08-c2bf8fa7d1ec	Raymond Lopez	1	http://clarke.info/search.htm	{"{\\"url\\": \\"https://placeimg.com/681/192/any\\"}"}	Defense general environmental likely very us wonder. May voice very leader drop rest. Write door sign article south know tonight.	{4754508321186,7436241968619}	{7622243241083,7020144363154,3980221953422}
8954315508183	2021-06-15 15:50:49.128107	2021-06-18 15:50:49.128107	f	e2a064fd-a51c-40a6-9b76-6698634b1eea	Peter Vazquez	2	http://wallace-mueller.org/search/wp-content/category/about/	{"{\\"url\\": \\"https://placeimg.com/169/613/any\\"}"}	Perform practice admit finally between should. Police current throughout all character science role. Fine front would society care.	{3023038552508,4487274086217}	{8700965961430,7543958367571,0799248058231}
6556677882219	2021-06-05 15:50:49.131682	2021-06-09 15:50:49.131682	f	97cccaf0-1bc1-4e2a-b495-c0ed05fc46c4	Andrew Brown	3	http://collins-fischer.com/blog/terms/	{}	Seat light management doctor television recent glass through. Someone positive such concern machine.	{2725413428538,9610933942738}	{3426454609670,9546636491153,0101458731055}
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

COPY public.volunteer_openings (external_id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
1926029956021	2021-06-07 15:50:49.104019	2021-06-12 15:50:49.104019	f	0f7ec39d-7651-4cd9-93c1-75e956014ce5	Huge compare range card money.	{"{\\"url\\": \\"https://dummyimage.com/745x870\\"}"}	https://thomas.org/register.htm	https://www.wells-tate.com/tags/category.html	MEDIUM	{6665680702879}	{}	6	2	8	Their campaign well against not door. Force career while. Industry generation two writer.	But enough fly front scientist amount student. It yes station spend approach. Look bed common along compare final official. Method want thing walk accept skill figure.	Life feel sport challenge recent. Difficult low during teacher evidence attack. Break myself various compare practice. Election on price keep glass often ground. Table develop power half.	Heart change near size listen. Force eat throw there group five strategy wait. Paper number successful message city reflect.	REQUIRES_APPLICATION
5682642933172	2021-05-31 15:50:49.105189	2021-06-03 15:50:49.105189	f	87ab1d34-632b-41f0-9d25-aba55194fbfd	Become amount system defense keep focus amount.	{"{\\"url\\": \\"https://placeimg.com/638/718/any\\"}"}	https://www.martinez.com/category/	http://hansen.net/posts/about.jsp	MEDIUM	{9876996863223}	{7233997775061}	6	8	4	Personal between size sure. Third special per. Pretty various relate government community figure the.	Process maybe charge wife interesting enjoy respond race. That investment often both. Brother painting leave risk. Want involve southern their.	Face become agency recent level. News wide director less. Seek level section us.	Tax court heavy even. Democrat make painting blue make remain scientist east. War through begin until baby. Time eight popular drive very point wall.	OPEN_TO_ALL
3152606922228	2021-06-01 15:50:49.106323	2021-06-03 15:50:49.106323	f	9d5544f5-27f5-4ebe-949a-60c8bd8db9e7	Particular turn again simple.	{"{\\"url\\": \\"https://placekitten.com/500/80\\"}"}	http://rogers-powell.com/app/login.html	http://sherman-green.org/author/	MEDIUM	{1216794529231}	{}	3	8	7	Give little anything tell decade central. Against share firm just challenge. Around coach go produce somebody bag. Father reality especially state.	Center fact each loss. Hand decade son add amount. Prepare protect memory next the increase.	Citizen pay itself. Base account prevent. Apply give pass generation thousand. Who want bar our agent her. Dinner seek investment several black senior which activity.	Hundred still hair catch almost world time. Blue price Democrat party past time career later. Medical not yard include including debate benefit really. Long common executive no score.	REQUIRES_APPLICATION
2848073064943	2021-06-10 15:50:49.10725	2021-06-14 15:50:49.10725	f	44d17551-787e-41f5-a181-84d01810dced	Nor amount fire senior.	{"{\\"url\\": \\"https://dummyimage.com/573x119\\"}"}	https://www.austin-miles.com/login.htm	http://www.haas-howell.com/wp-content/categories/list/home.htm	MEDIUM	{9421630955354}	{5448266904154}	2	5	3	Activity for many mention. Senior myself the finally. Box push than parent tough effect visit. Nothing coach them news to. Follow risk reality language.	Realize film event stage. Win collection middle service take rise almost.	Behind vote this agency avoid opportunity. Republican spend commercial travel coach. Five decade air do line simple kind authority. Whole history for bad need. West yet assume.	Agree really need trouble. Term each different save green finish product north.	OPEN_TO_ALL
8705332080653	2021-06-06 15:50:49.108173	2021-06-09 15:50:49.108173	f	f9215693-fb40-45b8-b303-8192de55a462	Break many strong back.	{"{\\"url\\": \\"https://placekitten.com/92/958\\"}"}	http://dalton-dawson.com/faq/	http://kemp.com/main/	MEDIUM	{1920080229988}	{}	5	9	9	Control prepare change ago woman age down. Certain away single marriage. Interest fire hope.	Friend tell member poor town because. Any task anyone will international while. Than help reveal speech down end. Where national easy a air example will.	New war consider over entire. Service market else letter. Pay area reality plan police show practice. Song too test.	Join water truth fine able class difference. Suffer this them recent respond.	REQUIRES_APPLICATION
4754508321186	2021-06-06 15:50:49.121622	2021-06-10 15:50:49.121622	f	e96b488a-9e67-4c4f-a62b-799f1cbf95c1	Interesting result today sell young recently.	{"{\\"url\\": \\"https://dummyimage.com/274x87\\"}"}	https://fleming.com/	https://smith-nguyen.com/tag/index.htm	MEDIUM	{3130328211042}	{2026320570922}	3	9	6	Voice model PM job. Pattern good section relationship. Without but yard economic experience. Watch matter reflect the exist probably until.	Challenge service art their measure nearly. Service behind its police anything scene sport. Those learn cultural attorney. Me Mrs project.	Billion build ground example hard wall. Ground difference during right around sign benefit.	Product style go consider. Wife simple and recognize training project.	OPEN_TO_ALL
7436241968619	2021-06-10 15:50:49.122434	2021-06-14 15:50:49.122434	f	718802d8-2993-4236-af68-7c628575fcb0	War minute traditional your.	{"{\\"url\\": \\"https://dummyimage.com/470x903\\"}"}	https://www.clark-welch.com/index.html	https://www.chambers.com/posts/search/faq.asp	MEDIUM	{2035205788406}	{}	2	4	4	Suffer book stay decade listen. Author possible cost send usually car serious. Science military both painting everything indicate each. Book south nature.	Perhaps general become. Agree list network outside system chance.	Modern simple then race why. Forward body floor resource show quickly institution. Challenge sort drug issue perhaps music security. Power type sister environmental support. Account tree cultural but.	Man message recent drop. Industry close nation generation goal. Information hotel democratic laugh bit. Play range forward most billion in support.	OPEN_TO_ALL
3023038552508	2021-05-29 15:50:49.125039	2021-06-03 15:50:49.125039	f	9629e472-c129-490c-adc4-cb0675111881	Road if none never where.	{"{\\"url\\": \\"https://dummyimage.com/319x452\\"}"}	https://www.adkins.net/category.html	https://harris-owen.com/posts/terms/	MEDIUM	{5511420076681}	{6529727846691}	3	9	5	Agency whole sea theory foreign door different. Reality bad pick news ahead seat. Store hotel purpose economic. Everybody yes institution data. Hit summer here voice health fund feeling customer.	Find easy save. Which of agent resource into great open. Section cost Mrs. Could arrive face technology.	Smile section long design trouble sign PM support. Relationship truth board everyone determine behavior. Look simply both conference day grow trade. State unit actually serve. Admit like treatment child hair.	All to art thousand fill change. Seek above group choice personal. Specific budget show both well necessary. Again employee person serve but question movement. True its three day might.	REQUIRES_APPLICATION
4487274086217	2021-05-30 15:50:49.125988	2021-06-02 15:50:49.125988	f	74557dec-c57d-4d11-9578-76390871611a	Interesting fast group grow ten likely.	{"{\\"url\\": \\"https://placekitten.com/963/786\\"}"}	http://roman.com/	https://edwards-robinson.com/homepage/	MEDIUM	{6667351916035}	{9665267450701}	3	3	6	Model much attack painting. Act trouble rich. Science future economic fly think.	Increase management receive especially send. Federal while mother bit fall once by former. Sign society store north. Prepare off when. Wish available anyone my be good.	Identify build whether threat. Last worry open role fight amount action. Story effort success rich. Business write simple deal.	Blood bar usually participant much right respond. Street anything wrong skill. Evidence father reveal air course attack newspaper. Catch difficult develop color Democrat half seat scientist. Ten true human rich father.	REQUIRES_APPLICATION
2725413428538	2021-06-15 15:50:49.128654	2021-06-18 15:50:49.128654	f	2fc78ce2-a71b-4af4-9357-f11c9ebee6cc	Career kind in house.	{"{\\"url\\": \\"https://dummyimage.com/889x693\\"}"}	https://www.huffman.org/	https://www.white.org/homepage.php	MEDIUM	{7079554419999}	{}	2	8	5	Government gas who example garden. Often land majority change effect not significant. New early father you five. Fund property however fight prove take.	Property image budget determine particularly coach. Effect oil ok few only gun. Build until along sound sport military. On they range above phone wall tax.	Level safe game whom brother. Agency always make into. White sign seven season you not.	Eye up address against. Its truth within pattern film himself whatever. To decide keep card. Surface church long politics increase.	REQUIRES_APPLICATION
9610933942738	2021-05-30 15:50:49.12958	2021-06-03 15:50:49.12958	f	f966f8d5-3b5f-4d3f-a4e0-77009b85201b	Light director most determine concern attack.	{}	http://flores-armstrong.com/categories/blog/categories/about/	http://bowen.biz/categories/terms.htm	MEDIUM	{2430161680977}	{2058935846062}	6	4	6	Itself toward maybe. Yet customer art by else. Treat trial where last paper act. True despite individual rather.	Recent mouth travel face include pretty cell. Contain recently why say could since put. Week head most woman majority financial. Image second property clearly news suddenly.	Member say exist account. Suddenly brother believe hold of. Look herself stage there commercial cell ground. Property both military discussion learn federal.	Traditional body college room may institution. Painting movement among focus.	REQUIRES_APPLICATION
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
-- Name: events events_external_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_external_id_key UNIQUE (external_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (uuid);


--
-- Name: initiatives initiatives_external_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.initiatives
    ADD CONSTRAINT initiatives_external_id_key UNIQUE (external_id);


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
-- Name: volunteer_openings volunteer_openings_external_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_external_id_key UNIQUE (external_id);


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

CREATE INDEX ix_event_id ON public.events USING hash (external_id);


--
-- Name: ix_role_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_role_id ON public.volunteer_openings USING hash (external_id);


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

