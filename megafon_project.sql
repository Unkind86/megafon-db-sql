--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

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
-- Name: add_employee(text, text, text, numeric); Type: FUNCTION; Schema: public; Owner: amin1
--

CREATE FUNCTION public.add_employee(e_first_name text, e_last_name text, e_middle_name text, e_permission_level numeric) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO employees (first_name, last_name, middle_name, permission_level) 
VALUES (e_first_name, e_last_name, e_middle_name, e_permission_level) $$;


ALTER FUNCTION public.add_employee(e_first_name text, e_last_name text, e_middle_name text, e_permission_level numeric) OWNER TO amin1;

--
-- Name: add_passports(text, character varying, character varying, character varying, character varying, date, character varying, date, date, numeric); Type: FUNCTION; Schema: public; Owner: amin1
--

CREATE FUNCTION public.add_passports(p_first_name text, p_last_name character varying, p_middle_name character varying, p_gender character varying, p_nationality character varying, p_date_of_birth date, p_place_of_birth character varying, p_date_of_issue date, p_date_of_expiry date, p_national_numb numeric) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO passports (first_name, last_name , middle_name, gender, nationality, date_of_birth, place_of_birth, date_of_issue, date_of_expiry, national_numb) 
VALUES (p_first_name, p_last_name, p_middle_name, p_gender, p_nationality, p_date_of_birth, p_place_of_birth, p_date_of_issue, p_date_of_expiry, p_national_numb) $$;


ALTER FUNCTION public.add_passports(p_first_name text, p_last_name character varying, p_middle_name character varying, p_gender character varying, p_nationality character varying, p_date_of_birth date, p_place_of_birth character varying, p_date_of_issue date, p_date_of_expiry date, p_national_numb numeric) OWNER TO amin1;

--
-- Name: add_user(text, text, text, text, numeric, integer); Type: FUNCTION; Schema: public; Owner: amin1
--

CREATE FUNCTION public.add_user(p_phone_number text, p_balance numeric, p_tarif_id integer, p_passport_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$ BEGIN
INSERT INTO users(
phone_number, balance, tarif_id, passport_id
) VALUES (p_phone_number, p_balance, p_tarif_id, p_passport_id); END; $$;


ALTER FUNCTION public.add_user(p_phone_number text, p_balance numeric, p_tarif_id integer, p_passport_id integer) OWNER TO amin1;

--
-- Name: add_users(text, text, text, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: amin1
--

CREATE FUNCTION public.add_users(u_phone_number numeric, u_balance numeric, u_tarif_id numeric, u_passport_id integer) RETURNS void
    LANGUAGE sql
    AS $$
INSERT INTO users (phone_number, balance, tarif_id, passport_id) 
VALUES (u_phone_number, u_balance, u_tarif_id, u_passport_id) $$;


ALTER FUNCTION public.add_users(u_phone_number numeric, u_balance numeric, u_tarif_id numeric, u_passport_id) OWNER TO amin1;

--
-- Name: change_tarif(character varying, integer); Type: FUNCTION; Schema: public; Owner: amin1
--

CREATE FUNCTION public.change_tarif(t_phone_number character varying, t_new_tarif_id integer) RETURNS void
    LANGUAGE sql
    AS $$ 
UPDATE users SET tarif_id = t_new_tarif_id WHERE phone_number = t_phone_number $$;


ALTER FUNCTION public.change_tarif(t_phone_number character varying, t_new_tarif_id integer) OWNER TO amin1;

--
-- Name: update_balance(character varying, numeric); Type: FUNCTION; Schema: public; Owner: amin1
--

CREATE FUNCTION public.update_balance(b_phone_number character varying, b_amount numeric) RETURNS void
    LANGUAGE sql
    AS $$ 
UPDATE users SET balance = balance + b_amount WHERE phone_number = b_phone_number $$;


ALTER FUNCTION public.update_balance(b_phone_number character varying, b_amount numeric) OWNER TO amin1;

--
-- Name: user_info(text, text, text); Type: FUNCTION; Schema: public; Owner: amin1
--

CREATE FUNCTION public.user_info(p_first_name text, p_last_name text, p_phone_number text) RETURNS TABLE(id bigint, first_name text, last_name text, middle_name text, phone_number text, balance numeric, tarif_id integer)
    LANGUAGE sql
    AS $$ SELECT * FROM passports JOIN users ON passports.id = users.passport_id WHERE 
first_name = p_first_name 
AND p_last_name = last_name 
AND p_phone_number = phone_number; $$;


ALTER FUNCTION public.user_info(p_first_name text, p_last_name text, p_phone_number text) OWNER TO amin1;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: amin1
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    first_name character varying(16) NOT NULL,
    last_name character varying(32) NOT NULL,
    middle_name character varying(32) DEFAULT ' '::character varying,
    permission_level numeric DEFAULT '0'::numeric,
    passport_id integer
);


ALTER TABLE public.employees OWNER TO amin1;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: amin1
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_id_seq OWNER TO amin1;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amin1
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: passports; Type: TABLE; Schema: public; Owner: amin1
--

CREATE TABLE public.passports (
    id integer NOT NULL,
    serial character varying NOT NULL,
    first_name character varying(16),
    last_name character varying(32),
    middle_name character varying(32),
    gender character varying NOT NULL,
    nationality character varying(32) NOT NULL,
    date_of_birth date NOT NULL,
    place_of_birth character varying(16) NOT NULL,
    date_of_issue date NOT NULL,
    date_of_expiry date NOT NULL,
    national_numb numeric NOT NULL,
    CONSTRAINT first_name_only_letters CHECK (((first_name)::text ~ '[A-Za-zА-Яа-яЁё]+$'::text)),
    CONSTRAINT gender_check CHECK (((gender)::text = ANY ((ARRAY['Female'::character varying, 'Male'::character varying])::text[]))),
    CONSTRAINT last_name_only_letters CHECK (((last_name)::text ~ '[A-Za-zА-Яа-яЁё]+$'::text)),
    CONSTRAINT middle_name_only_letters CHECK (((middle_name)::text ~ '[A-Za-zА-Яа-яЁё]+$'::text))
);


ALTER TABLE public.passports OWNER TO amin1;

--
-- Name: passports_id_seq; Type: SEQUENCE; Schema: public; Owner: amin1
--

CREATE SEQUENCE public.passports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passports_id_seq OWNER TO amin1;

--
-- Name: passports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amin1
--

ALTER SEQUENCE public.passports_id_seq OWNED BY public.passports.id;


--
-- Name: tarifs; Type: TABLE; Schema: public; Owner: amin1
--

CREATE TABLE public.tarifs (
    id integer NOT NULL,
    tarif_name character varying(16) NOT NULL,
    megabytes numeric NOT NULL,
    minutes numeric NOT NULL,
    night_bezlimit boolean,
    price numeric NOT NULL
);


ALTER TABLE public.tarifs OWNER TO amin1;

--
-- Name: tarifs_id_seq; Type: SEQUENCE; Schema: public; Owner: amin1
--

CREATE SEQUENCE public.tarifs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tarifs_id_seq OWNER TO amin1;

--
-- Name: tarifs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amin1
--

ALTER SEQUENCE public.tarifs_id_seq OWNED BY public.tarifs.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: amin1
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    phone_number character varying(9) NOT NULL,
    balance numeric DEFAULT 0 NOT NULL,
    tarif_id integer,
    passport_id integer
);


ALTER TABLE public.users OWNER TO amin1;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: amin1
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO amin1;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amin1
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: passports id; Type: DEFAULT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.passports ALTER COLUMN id SET DEFAULT nextval('public.passports_id_seq'::regclass);


--
-- Name: tarifs id; Type: DEFAULT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.tarifs ALTER COLUMN id SET DEFAULT nextval('public.tarifs_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: amin1
--

COPY public.employees (id, first_name, last_name, middle_name, permission_level, passport_id) FROM stdin;
1	Amin	Bratva		0	\N
2	Maga	Bratva		1	\N
3	Amir	Bratva		1	\N
4	Abu	Bratva		1	\N
\.


--
-- Data for Name: passports; Type: TABLE DATA; Schema: public; Owner: amin1
--

COPY public.passports (id, serial, first_name, last_name, middle_name, gender, nationality, date_of_birth, place_of_birth, date_of_issue, date_of_expiry, national_numb) FROM stdin;
1	AM8076	Gunar	Lowfill	Fierman	Male	PR	2018-09-16	China	2018-04-09	1993-09-25	111908004
2	IB9227	Spense	Tonry	Hares	Male	PE	2009-03-08	Canada	2021-05-22	2024-03-11	21201503
3	AF2465	Florina	Swynley	Manville	Female	RU	2007-03-04	Brazil	2002-12-10	1997-07-06	72411025
4	KE4039	Ariana	Kach	Cord	Female	SE	2017-06-24	Madagascar	2006-12-19	2021-04-25	221471858
5	DL3314	Reuven	Christopherson	Barcke	Male	AU	1997-04-12	Indonesia	1996-07-01	2015-12-12	71922227
6	SK2032	Shadow	MacKintosh	Rosindill	Male	GY	1993-03-19	China	1990-01-28	2013-10-19	63115631
7	SQ9977	Hatty	Pistol	Chatel	Female	BR	2019-11-06	China	2009-09-08	2012-09-07	63106006
8	SK4004	Emyle	Nussii	Chavrin	Female	MX	1993-11-03	Ukraine	2018-03-25	1990-05-23	122106109
9	AC8333	Harmon	Debow	Saffe	Male	GB	1994-04-22	Indonesia	2000-03-18	2012-05-09	274970775
10	IB5615	Carolyne	McNish	Spadotto	Female	ZM	1998-09-07	Nigeria	2017-04-20	2004-03-30	62102292
11	ET3606	Eliot	Ramalho	Riggoll	Male	AU	2014-07-22	France	1993-05-06	2003-09-09	253184359
12	KE7613	Dougy	Stefanovic	Fayers	Male	AU	2024-05-25	China	2023-07-17	2010-12-09	52102590
13	SQ4852	Werner	O'Shaughnessy	Swett	Male	PK	1998-06-05	United States	1996-12-11	1998-10-26	63000047
14	AZ9769	Claudine	Linfield	Pearch	Female	MG	2003-08-05	Japan	2015-04-15	2011-09-05	271972064
15	NH4286	Lorrie	Satterfitt	Allot	Female	US	2003-08-17	Nicaragua	1994-12-19	2010-10-27	113000023
16	ET3233	Arny	MacMakin	Trail	Male	DZ	1999-05-22	Moldova	1994-02-06	2015-08-13	122201198
17	IB2768	Gayle	Rizzi	Lantuff	Male	GN	1998-03-25	Angola	2025-04-22	2015-01-03	71125587
18	LH3115	Charmine	De Pietri	Lamswood	Female	CA	1994-07-29	France	1998-03-28	2013-06-13	113105368
19	CX4778	Piper	Murford	Wynes	Female	AR	2004-07-28	Poland	1999-04-06	2021-09-05	31902766
20	BA6603	Milissent	Cranshaw	Barense	Female	GB	2010-12-26	Norway	2012-08-27	2016-01-13	267084131
21	EK2258	Elijah	Olden	Lowdham	Male	IR	2012-12-19	China	2010-09-20	2009-08-24	111901632
22	AV1831	Jasmin	Kharchinski	Hazeldene	Female	AU	2002-08-22	China	2010-07-14	2022-12-31	31300834
23	NH1887	Kerrie	Bethune	Tibalt	Female	AE	1998-01-11	Armenia	2022-02-03	1994-09-27	71922227
24	LA3981	Filbert	Narramore	Coath	Male	US	1997-05-18	China	2002-03-16	2009-10-29	21111800
25	EK9484	Alfy	Chorley	Iverson	Male	CL	2020-04-09	Malaysia	2012-05-26	2003-08-02	55002341
26	QR4551	Debor	Denkel	Balmforth	Female	US	2012-04-05	China	2018-01-14	2012-08-29	64000020
27	AI6834	Camilla	Gaynor	Hawken	Female	DK	2008-08-15	China	2001-02-26	2020-10-06	111101461
28	SQ1094	Leonardo	McFarlane	Ferras	Male	PG	2023-01-17	Malta	2017-12-31	2014-04-03	82908829
30	CX2642	Ichabod	Gingedale	Alejo	Male	AU	2020-01-07	Argentina	1995-09-16	2005-02-20	67016105
31	WN9277	Cecile	Grelka	Dowsett	Female	AU	2002-11-14	France	2016-01-05	1993-06-10	63210112
32	AA4011	Ki	Pinsent	Wingrove	Female	AO	1997-01-08	Russia	2022-09-05	2007-09-11	56004445
33	SK6204	Antonino	Airdrie	Easthope	Male	BW	1999-03-29	China	2016-12-12	2003-01-28	226078049
34	SQ7016	Windy	Garfield	Somes	Female	DZ	2024-11-17	Argentina	1990-10-28	2013-10-16	31307866
35	AZ2233	Clayborn	Blown	Cubberley	Male	FR	2023-03-31	China	2006-10-21	2022-06-06	63102259
36	SA1147	Murray	Writer	Winham	Male	US	2011-10-27	Ireland	2001-06-10	2009-07-11	42103363
37	AF4902	Lion	Tripet	Reding	Male	CN	1991-06-12	China	1998-06-15	2023-04-29	91200738
38	CX8226	Dexter	Lincke	Baly	Male	BO	2007-02-19	Philippines	2002-11-16	2012-03-31	82906258
39	KL3196	Tiffy	Alred	Kingzet	Female	US	1994-07-17	Colombia	2009-03-16	1990-12-02	51405405
40	AZ4787	Glendon	Torresi	Sealand	Male	US	2000-05-11	Poland	2014-11-26	2006-07-30	102102916
41	AM9401	Iorgos	Gabrieli	Mapham	Male	CN	1992-02-25	France	2000-05-05	2009-03-14	62202163
42	SQ1487	Reggy	Jenkins	Salters	Male	AU	2012-07-16	Yemen	1999-08-26	2003-12-07	81517907
43	SA3265	Charmine	Honniebal	Gillbey	Female	IS	2017-04-05	Argentina	2023-12-31	2002-12-14	111926112
44	QR2115	Adi	Probert	Sandercroft	Female	SD	1992-01-26	Finland	2012-10-24	2007-10-07	65106363
45	AC2322	Ali	Woof	Monery	Female	CR	2008-01-17	China	2017-03-13	2013-07-15	101106214
46	TG3356	Wernher	Willcot	Rennox	Male	AR	2020-06-06	Uruguay	1991-06-13	2007-06-21	51503938
47	CX9277	Martguerita	Lockitt	Brahan	Female	AU	1992-05-21	Cuba	1993-10-02	2006-01-25	84107055
48	LH6780	Ivie	Hanny	Brice	Female	SG	2006-01-15	Czech Republic	2013-03-04	1991-02-08	91206389
49	NZ9603	Matthaeus	Adamiak	Howling	Male	VE	2010-05-29	Indonesia	2016-12-25	2002-09-03	107005953
50	AM1425	Tammi	Clevely	Riccetti	Female	GB	2004-05-10	Italy	2018-12-17	2004-09-12	42204123
51	NZ3445	Maurizia	Sinnat	Arthy	Female	PT	2020-10-03	New Caledonia	2008-12-24	1990-11-25	61113017
52	LH4442	Blaine	Coonihan	Crumpe	Male	PH	2003-12-12	Mongolia	2025-01-20	2022-03-10	21300462
53	ET9389	Roxanne	Husher	Terren	Female	PR	2010-10-14	Russia	2013-03-13	2017-02-24	104904646
54	SK9524	Ashley	Leyson	Ruller	Male	US	2024-08-28	Portugal	2019-04-21	2023-12-15	111901946
55	AI2399	Grayce	De Atta	Towns	Female	VE	2004-09-17	Indonesia	2014-04-20	1992-11-25	72402034
56	EK4358	Erinn	Scarbarrow	McKeating	Female	US	2018-03-22	Vietnam	2025-04-01	2019-02-19	61119477
57	AC6753	Egan	Whittington	Kernocke	Male	RU	1991-08-21	Indonesia	1996-04-11	2015-09-24	63206663
58	AV5118	Rhodia	Gregorio	Chance	Female	SG	2002-06-03	Ireland	2000-07-22	2007-02-24	75906171
59	SA1377	Jacinda	Southerns	Le Conte	Female	CO	2000-03-12	Canada	1995-08-07	2021-03-21	84201139
60	BA2574	Yolanthe	Pagden	Skermer	Female	ES	1998-01-11	Poland	2003-08-07	1994-01-02	103107046
61	AF5759	Alon	McMichan	Statersfield	Male	US	1992-11-04	Kuwait	2002-02-07	2008-04-16	65306079
62	QF1128	Giacomo	Tschierasche	Skitt	Male	SA	2015-03-12	Indonesia	2013-05-28	2024-04-26	103102203
63	SK7135	Ilysa	Paolino	Brumbye	Female	US	2015-12-19	Russia	2024-06-15	2017-07-22	111311785
64	DL5432	Imojean	Koppel	Willshear	Female	US	2017-04-08	Sweden	2012-07-30	1996-01-16	67012057
65	AZ5907	Duffy	Wilson	Scown	Male	MN	2023-09-10	Portugal	1993-07-13	2022-11-12	91402905
66	UA4990	Gisela	Swoffer	Rosbotham	Female	BR	2023-02-28	China	2016-11-01	2008-10-24	71905095
67	WN6141	Frederich	Guttridge	McFeat	Male	CA	2014-10-13	Uruguay	2002-06-08	2020-09-29	121122676
68	SQ1726	Arlen	Garbutt	Kamien	Male	BR	2006-08-07	United States	2013-11-20	2002-07-04	67014194
69	NZ5021	Kirbie	Clemo	Bau	Female	US	2003-03-26	China	2004-04-26	2004-05-18	31100267
70	AV3764	Adolpho	Oldis	Skrzynski	Male	MG	1998-06-09	Armenia	1990-08-04	2002-10-27	53112110
71	IB6162	Phoebe	Hazeldene	Withnall	Female	UZ	2002-09-22	Argentina	1998-04-30	2017-05-02	53203210
72	AF9700	Cicely	Gittings	Longstaffe	Female	MX	2010-12-25	China	2015-12-20	1997-09-13	71000301
73	BA3006	Jedediah	Jills	Shave	Male	UG	2025-01-01	China	2001-03-25	1995-07-11	211170318
74	NH5825	Yance	Andrzejewski	Cellone	Male	ZW	2015-07-25	Brazil	2021-07-08	1995-07-01	255072595
75	KL5768	Calli	Gredden	Adamo	Female	DZ	2002-02-15	Japan	2021-04-30	2005-03-18	52173464
76	DL7893	Nani	Matuskiewicz	Thorndycraft	Female	PG	2022-01-18	Russia	2015-10-25	1994-08-24	42204123
77	NZ5223	Dorthea	Bulger	Korf	Female	ZA	2020-10-23	Philippines	2020-08-28	2013-08-19	21409567
78	AC7315	Sergei	Hutcheons	Ramsey	Male	AR	2019-01-05	Bulgaria	1994-10-14	2004-10-30	21909300
79	AV7927	Donnie	Shekle	Grindle	Male	LY	2023-09-08	Iran	2020-12-11	2006-12-23	61212086
80	BA1149	Elwin	Fogg	Stores	Male	ZA	1998-07-18	Luxembourg	1997-01-26	2007-12-12	251473088
81	SQ9635	Jyoti	Carrick	Westrope	Female	MM	2025-04-27	Cuba	1994-11-15	2002-01-05	112000011
83	BA2801	Pavla	Jouannot	Tingcomb	Female	AU	2013-11-10	Honduras	2020-10-30	2002-05-13	42207735
84	AV4108	Griz	Miguel	Labusquiere	Male	US	1993-12-24	Poland	2003-01-20	1995-10-27	113105478
85	NZ4752	Miguelita	Kernaghan	Woofenden	Female	IT	2006-04-18	Norway	2014-01-04	2005-08-25	81501489
86	AI1476	Levon	Holburn	Musk	Male	PG	2024-07-21	Nigeria	2019-12-19	1998-04-28	101102438
87	NH7897	Clara	Cossum	Scawn	Female	CA	1991-03-21	Brazil	2014-06-26	2004-11-18	67011294
88	AM9560	Brigg	Dealey	Ertel	Male	US	2024-05-23	Zimbabwe	2003-04-01	2019-04-02	41202540
89	SA8756	Evonne	Bremner	Dyka	Female	HR	1999-04-12	Peru	1994-10-05	1998-05-07	41203374
90	NZ7721	Tracy	Emtage	Baldick	Male	PS	2011-07-07	Bangladesh	2007-12-19	2020-11-19	73907952
91	UA9725	Cal	Chapell	Harflete	Female	PH	2004-12-24	Russia	2008-05-13	2012-11-28	264272027
92	KL5194	Larry	McMurty	Desquesnes	Male	PK	2013-01-23	Indonesia	2020-12-02	2003-07-07	122187212
93	BA9701	Ajay	Slyman	Tommei	Female	PE	2006-08-01	Russia	2001-04-12	1997-02-12	62203298
94	LH6786	Colver	Manvelle	Drewe	Male	SA	2008-03-05	Japan	2012-06-02	2015-05-23	71902629
95	AA9509	Craggy	Wooller	Yarn	Male	HU	1994-08-03	Portugal	1995-02-15	1991-03-19	71922968
96	CX7552	Samantha	Vondracek	Melan	Female	ID	2019-05-23	Indonesia	2006-05-13	2018-08-07	41000014
97	QR9258	Alvira	Malenfant	Pettie	Female	NO	2004-04-16	Uganda	2014-03-18	1993-09-05	61103153
98	CX1399	Nils	Brasher	Littrell	Male	US	2025-03-18	Tanzania	1994-09-18	2023-10-11	71214333
100	AZ5154	Luella	Schaumaker	Sumption	Female	PG	2004-07-03	Bulgaria	2013-04-10	2020-03-17	81923452
101	AI6865	Kenon	McCathay	Summons	Male	CA	2016-03-25	Ukraine	2001-03-13	2024-05-23	104902363
102	AA8700	Leslie	Tradewell	Larive	Male	PA	1993-08-28	Philippines	1993-01-19	2015-09-07	11000206
\.


--
-- Data for Name: tarifs; Type: TABLE DATA; Schema: public; Owner: amin1
--

COPY public.tarifs (id, tarif_name, megabytes, minutes, night_bezlimit, price) FROM stdin;
1	Megafon 100	20000	100	t	100
2	Megafon 200	30000	200	t	200
3	Megafon 300	40000	300	f	300
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: amin1
--

COPY public.users (id, phone_number, balance, tarif_id, passport_id) FROM stdin;
1	123fsdf	7210	3	1
101	868686868	1231.5	1	101
10	122042069	241	1	10
8	101005690	6121	3	8
15	101001089	5621	3	15
16	111900785	8798	3	16
22	323271493	7687	3	22
31	111908004	9322	3	31
40	321170444	7206	3	40
44	107006004	8961	3	44
45	102005916	5194	3	45
46	122241941	5376	3	46
18	121140823	658	3	18
56	111907445	7025	3	56
62	261270417	9249	3	62
69	211574613	5385	3	69
76	113113868	8444	3	76
81	122239814	8226	3	81
84	101202257	8571	3	84
87	211370493	9520	3	87
21	101101581	228	1	21
61	113122804	5	1	61
77	123308553	184	1	77
89	111322910	417	1	89
3	071123398	388	1	3
4	211174136	4444	2	4
7	114993906	3202	2	7
9	231971568	1505	2	9
11	122240340	2463	2	11
14	101219279	3223	2	14
25	102106857	4152	2	25
34	112000150	3070	2	34
35	111919433	4274	2	35
50	111315794	1823	2	50
54	111103524	1439	2	54
59	104000058	1202	2	59
60	114922430	2774	2	60
70	283972162	4412	2	70
71	253184472	1344	2	71
74	231371799	4387	2	74
85	112207209	2500	2	85
86	254070019	1700	2	86
94	122240489	2881	2	94
102	559000660	86	2	102
98	113122655	5860	3	98
100	271974224	6082	3	100
2	062201067	8091	3	2
5	053112217	8164	3	5
6	071000013	7364	3	6
19	084201692	873	3	19
13	063100620	5288	3	13
17	062202749	6561	3	17
24	061102617	616	3	24
20	063206663	7579	3	20
26	091810623	9864	3	26
28	073906005	8346	3	28
30	071911584	5808	3	30
32	011307077	7123	3	32
38	053112479	8157	3	38
39	082903044	8485	3	39
43	091908399	7664	3	43
48	084003191	9392	3	48
51	062206732	9102	3	51
52	081001727	5236	3	52
55	084008853	6459	3	55
57	062202367	9073	3	57
58	081504855	9062	3	58
49	041202511	819	3	49
64	062203298	6585	3	64
65	062001209	6845	3	65
68	071004158	7922	3	68
73	042103253	6275	3	73
75	031000024	9120	3	75
42	071925965	5	1	42
72	065201611	108	1	72
83	081512371	12	1	83
96	125107862	2061	2	96
97	121137506	1127	2	97
12	081518045	3807	2	12
23	074000065	3613	2	23
27	065300211	2144	2	27
33	071901604	3173	2	33
36	026007773	4567	2	36
37	082900911	1018	2	37
41	053201814	3353	2	41
47	026002927	2047	2	47
53	021272723	2286	2	53
63	063105544	2630	2	63
66	041200050	1433	2	66
67	051409184	4268	2	67
78	041002957	3447	2	78
79	031901482	1634	2	79
92	071002053	4251	2	92
93	063112605	4828	2	93
95	091302788	1741	2	95
80	071108669	9809	3	80
88	091409762	9814	3	88
90	075903226	8798	3	90
91	053003931	6591	3	91
\.


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amin1
--

SELECT pg_catalog.setval('public.employees_id_seq', 4, true);


--
-- Name: passports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amin1
--

SELECT pg_catalog.setval('public.passports_id_seq', 3, true);


--
-- Name: tarifs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amin1
--

SELECT pg_catalog.setval('public.tarifs_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amin1
--

SELECT pg_catalog.setval('public.users_id_seq', 143, true);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: passports passports_pkey; Type: CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.passports
    ADD CONSTRAINT passports_pkey PRIMARY KEY (id);


--
-- Name: passports passports_serial_key; Type: CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.passports
    ADD CONSTRAINT passports_serial_key UNIQUE (serial);


--
-- Name: users phone_numbers_unique; Type: CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT phone_numbers_unique UNIQUE (phone_number);


--
-- Name: tarifs tarifs_pkey; Type: CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.tarifs
    ADD CONSTRAINT tarifs_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: employees fk_employees_passports; Type: FK CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_passports FOREIGN KEY (passport_id) REFERENCES public.passports(id);


--
-- Name: passports fk_passport_user; Type: FK CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.passports
    ADD CONSTRAINT fk_passport_user FOREIGN KEY (id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users fk_users_passports; Type: FK CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_passports FOREIGN KEY (passport_id) REFERENCES public.passports(id);


--
-- Name: users fk_users_tarifs; Type: FK CONSTRAINT; Schema: public; Owner: amin1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_tarifs FOREIGN KEY (tarif_id) REFERENCES public.tarifs(id);


--
-- PostgreSQL database dump complete
--

