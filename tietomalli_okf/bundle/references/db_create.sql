--
-- Tuotantotiedon tietomalli - PostgreSQL-tietokannan luontilauseet
-- Vastaa tietomallin dokumentaatiota (tietomalli.md, versio 1.0)
--
-- Taulujen jarjestys noudattaa dokumentaation jarjestysta:
--   1. Faktataulut:      fact_order_rows, fact_workphases, fact_machine_events
--   2. Ulottuvuustaulut: dim_customer, dim_article, dim_workcenter,
--                        dim_workcenter_group, dim_user, dim_order_state,
--                        dim_event_type, dim_source, dim_exception,
--                        dim_date, dim_time
--
-- Huom. avaimet ovat bigint-tyyppisia, koska ERP-jarjestelmien tunnisteet
-- (esim. Monitor ERP) eivat mahdu 32-bittiseen kokonaislukuun.
-- Paivamaara- ja aika-avaimet (YYYYMMDD / HHMMSS) ovat integer-tyyppisia.
--

--
-- Tietokannan luonti. Aja tama erikseen ja ota yhteys uuteen tietokantaan
-- ennen alla olevien taulujen luontia, esim. psql:ssa:
--
--   CREATE DATABASE "TUOVA_DB" WITH TEMPLATE = template0 ENCODING = 'UTF8';
--   \connect "TUOVA_DB"
--
-- Muuten taulut syntyvat siihen tietokantaan, johon istunto on yhdistetty.
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;


-- ============================================================
-- 1. FAKTATAULUT
-- ============================================================

--
-- Tilausrivitaulu
--

CREATE TABLE public.fact_order_rows (
    order_row_id bigint NOT NULL,
    order_number text,
    work_number text,
    work_id bigint,
    customer_id bigint,
    seller_id bigint,
    article_id bigint,
    order_created_date integer,
    production_start_date_planned integer,
    production_start_date_actual integer,
    production_end_date_planned integer,
    production_end_date_actual integer,
    dispatch_date_planned integer,
    dispatch_date_actual integer,
    delivery_date_planned integer,
    delivery_date_actual integer,
    invoice_date_actual integer,
    payment_date_actual integer,
    order_state_id bigint,
    order_type text,
    ordered_qty integer,
    delivered_qty integer,
    unit_price double precision,
    total_price double precision,
    direct_work_cost_planned double precision,
    direct_work_cost_actual double precision,
    material_cost_planned double precision,
    material_cost_actual double precision,
    subcontracting_cost_planned double precision,
    subcontracting_cost_actual double precision,
    other_direct_costs_planned double precision,
    other_direct_costs_actual double precision,
    prime_cost_planned_sum double precision,
    prime_cost_actual_sum double precision,
    unit_prime_cost_planned double precision,
    unit_prime_cost_actual double precision,
    sales_margin_planned double precision,
    sales_margin_actual double precision,
    overhead_costs_planned double precision,
    overhead_costs_actual double precision,
    manufacturing_cost_planned double precision,
    manufacturing_cost_actual double precision,
    unit_manufacturing_cost_planned double precision,
    unit_manufacturing_cost_actual double precision,
    profit_planned double precision,
    profit_actual double precision,
    unit text,
    currency text,
    new_article boolean,
    order_complete boolean
);

COMMENT ON TABLE public.fact_order_rows IS 'Tilausrivit paaosin ERP-datasta. Suunnitellut ja toteutuneet paivamaarat seka kustannusten vertailu.';

--
-- Tyovaihetaulu
--

CREATE TABLE public.fact_workphases (
    workphase_id bigint NOT NULL,
    workphase_number text,
    order_row_id bigint,
    work_number text,
    work_id bigint,
    workcenter_id bigint,
    workcenter_group_id bigint,
    article_id bigint,
    phase_number integer,
    phase_description text,
    phase_status text,
    subcontracting_phase boolean,
    start_date_original_planned integer,
    start_date_latest_planned integer,
    start_date_actual integer,
    end_date_original_planned integer,
    end_date_latest_planned integer,
    end_date_actual integer,
    start_time_planned integer,
    start_time_actual integer,
    end_time_planned integer,
    end_time_actual integer,
    start_timestamp_planned timestamp with time zone,
    end_timestamp_planned timestamp with time zone,
    start_timestamp_actual timestamp with time zone,
    end_timestamp_actual timestamp with time zone,
    planned_qty integer,
    produced_qty integer,
    rejected_qty integer,
    workcenter_hour_rate double precision,
    phase_cost_planned double precision,
    phase_cost_actual_stamping double precision,
    phase_cost_actual_machine double precision,
    setup_time_planned_min double precision,
    setup_time_stamping_min double precision,
    setup_time_machine_min double precision,
    production_time_planned_min double precision,
    production_time_stamping_min double precision,
    production_time_machine_min double precision,
    phase_duration_planned_min double precision,
    phase_duration_stamping_min double precision,
    phase_duration_machine_min double precision,
    unit_time_planned_min double precision,
    unit_time_stamping_min double precision,
    unit_time_machine_min double precision,
    cycle_time_ideal_min double precision,
    cycle_time_planned_min double precision,
    cycle_time_stamping_min double precision,
    cycle_time_machine_min double precision,
    processing_time_ideal_min double precision,
    processing_time_planned_min double precision,
    processing_time_stamping_min double precision,
    processing_time_machine_min double precision
);

COMMENT ON TABLE public.fact_workphases IS 'Tyovaiheet ERP/MES-jarjestelmasta. Toteutuneiden aikojen vertailu suunniteltuihin.';

--
-- Konetapahtumataulu
--

CREATE TABLE public.fact_machine_events (
    machine_event_id bigint NOT NULL,
    event_type_id bigint,
    source_id integer,
    workphase_id bigint,
    work_number text,
    work_id bigint,
    workcenter_id bigint,
    article_id bigint,
    user_id bigint,
    program_name text,
    start_date integer,
    end_date integer,
    start_time integer,
    end_time integer,
    start_at timestamp with time zone,
    end_at timestamp with time zone,
    duration_min double precision,
    unit_time_min double precision,
    unit_cycle_time_min double precision,
    unit_processing_time_min double precision,
    produced_qty_stamping integer,
    produced_qty_machine integer,
    rejected_qty_stamping integer,
    part_counter integer,
    efficient_production_min double precision,
    inefficient_production_min double precision,
    cutting_time_min double precision,
    non_cutting_time_min double precision,
    feed_override double precision,
    spindle_override double precision,
    machine_active_min double precision,
    setup_time_min double precision,
    part_change_time_min double precision,
    undefined_idle_min double precision,
    idle_sum_min double precision,
    power_off_min double precision,
    other_min double precision,
    exception_min double precision,
    exception_id bigint,
    time_sum_min double precision,
    power_consumption_kwh double precision,
    notes text
);

COMMENT ON TABLE public.fact_machine_events IS 'Toteumatiedot leimauksista ja/tai konedatasta. Tapahtumatyyppi ja lahde erotellaan event_type_id- ja source_id-kentilla.';


-- ============================================================
-- 2. ULOTTUVUUSTAULUT
-- ============================================================

--
-- Asiakastaulu
--

CREATE TABLE public.dim_customer (
    customer_id bigint NOT NULL,
    customer_number text,
    customer_name text,
    location text
);

COMMENT ON TABLE public.dim_customer IS 'Asiakastiedot.';

--
-- Nimiketaulu
--

CREATE TABLE public.dim_article (
    article_id bigint NOT NULL,
    article_code text,
    article_name text,
    article_name_other text,
    article_description text,
    article_group text,
    revision text,
    notes text
);

COMMENT ON TABLE public.dim_article IS 'Nimike- tai tuotetiedot ERP-jarjestelmasta.';

--
-- Tyokeskustaulu
--

CREATE TABLE public.dim_workcenter (
    workcenter_id bigint NOT NULL,
    workcenter_name text,
    workcenter_description text,
    workcenter_type text
);

COMMENT ON TABLE public.dim_workcenter IS 'Tyopisteen/tyokeskuksen/kuormitusryhman tarkemmat tiedot.';

--
-- Tyokeskusryhmataulu
--

CREATE TABLE public.dim_workcenter_group (
    workcenter_group_id bigint NOT NULL,
    workcenter_group_name text,
    workcenter_group_description text
);

COMMENT ON TABLE public.dim_workcenter_group IS 'Tyokeskuksen tai tuotantoyksikon tyypit. Ei valttamaton taulu.';

--
-- Kayttajataulu
--

CREATE TABLE public.dim_user (
    user_id bigint NOT NULL,
    user_name text,
    user_role text
);

COMMENT ON TABLE public.dim_user IS 'Kayttajatiedot ERP-jarjestelmasta. Kaytetaan seka myyjana etta koneen kayttajana.';

--
-- Tilauksen tilan hakutaulu
--

CREATE TABLE public.dim_order_state (
    order_state_id bigint NOT NULL,
    order_state_name text
);

COMMENT ON TABLE public.dim_order_state IS 'Tilausten tilojen hakutaulu. Sisalto yrityksen raportointitarpeiden mukaan.';

--
-- Konetapahtumatyypin hakutaulu
--

CREATE TABLE public.dim_event_type (
    event_type_id bigint NOT NULL,
    event_type_name_eng text,
    event_type_name_fin text,
    event_description text
);

COMMENT ON TABLE public.dim_event_type IS 'Konetapahtumatyyppien hakutaulu. Tapahtumia voi lisata tarpeen mukaan.';

--
-- Tietolahteen hakutaulu
--

CREATE TABLE public.dim_source (
    source_id integer NOT NULL,
    source_name text,
    source_description text
);

COMMENT ON TABLE public.dim_source IS 'Konetapahtumien tietolahteiden hakutaulu.';

--
-- Poikkeamataulu
--

CREATE TABLE public.dim_exception (
    exception_id bigint NOT NULL,
    exception_type text,
    exception_description text
);

COMMENT ON TABLE public.dim_exception IS 'Poikkeamien tiedot.';

--
-- Paivamaarataulu
--

CREATE TABLE public.dim_date (
    date_id integer NOT NULL,
    date_index integer,
    date_fin text,
    date_iso date,
    day_of_week integer,
    weekday_name_fin text,
    weekday_name_short_fin text,
    weekday_name_eng text,
    weekday_name_short_eng text,
    day integer,
    week integer,
    month integer,
    quarter integer,
    year integer,
    year_day integer,
    quarter_day integer,
    year_week text,
    year_month text,
    year_quarter text,
    month_name_short_fin text,
    month_name_fin text,
    month_name_short_eng text,
    month_name_eng text,
    is_weekend boolean,
    is_workday boolean
);

COMMENT ON TABLE public.dim_date IS 'Paivamaaraulottuvuus. Avain semanttisessa muodossa YYYYMMDD.';

--
-- Aikataulu
--

CREATE TABLE public.dim_time (
    time_id integer NOT NULL,
    time_hms text,
    time_hm text,
    hour integer,
    minute integer,
    second integer,
    time_of_day_str text,
    time_of_day_range text,
    time_of_day_id integer,
    shift text,
    shift_id integer
);

COMMENT ON TABLE public.dim_time IS 'Aikaulottuvuus. Avain semanttisessa muodossa HHMMSS.';


-- ============================================================
-- 3. PERUSAVAIMET
-- ============================================================

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_pkey PRIMARY KEY (order_row_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_pkey PRIMARY KEY (workphase_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_pkey PRIMARY KEY (machine_event_id);

ALTER TABLE ONLY public.dim_customer
    ADD CONSTRAINT dim_customer_pkey PRIMARY KEY (customer_id);

ALTER TABLE ONLY public.dim_article
    ADD CONSTRAINT dim_article_pkey PRIMARY KEY (article_id);

ALTER TABLE ONLY public.dim_workcenter
    ADD CONSTRAINT dim_workcenter_pkey PRIMARY KEY (workcenter_id);

ALTER TABLE ONLY public.dim_workcenter_group
    ADD CONSTRAINT dim_workcenter_group_pkey PRIMARY KEY (workcenter_group_id);

ALTER TABLE ONLY public.dim_user
    ADD CONSTRAINT dim_user_pkey PRIMARY KEY (user_id);

ALTER TABLE ONLY public.dim_order_state
    ADD CONSTRAINT dim_order_state_pkey PRIMARY KEY (order_state_id);

ALTER TABLE ONLY public.dim_event_type
    ADD CONSTRAINT dim_event_type_pkey PRIMARY KEY (event_type_id);

ALTER TABLE ONLY public.dim_source
    ADD CONSTRAINT dim_source_pkey PRIMARY KEY (source_id);

ALTER TABLE ONLY public.dim_exception
    ADD CONSTRAINT dim_exception_pkey PRIMARY KEY (exception_id);

ALTER TABLE ONLY public.dim_date
    ADD CONSTRAINT dim_date_pkey PRIMARY KEY (date_id);

ALTER TABLE ONLY public.dim_time
    ADD CONSTRAINT dim_time_pkey PRIMARY KEY (time_id);


-- ============================================================
-- 4. VIITEAVAIMET
-- ============================================================

--
-- fact_order_rows
--

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_customer FOREIGN KEY (customer_id) REFERENCES public.dim_customer(customer_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_seller FOREIGN KEY (seller_id) REFERENCES public.dim_user(user_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_article FOREIGN KEY (article_id) REFERENCES public.dim_article(article_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_order_state FOREIGN KEY (order_state_id) REFERENCES public.dim_order_state(order_state_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_order_created FOREIGN KEY (order_created_date) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_production_start_planned FOREIGN KEY (production_start_date_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_production_start_actual FOREIGN KEY (production_start_date_actual) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_production_end_planned FOREIGN KEY (production_end_date_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_production_end_actual FOREIGN KEY (production_end_date_actual) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_dispatch_planned FOREIGN KEY (dispatch_date_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_dispatch_actual FOREIGN KEY (dispatch_date_actual) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_delivery_planned FOREIGN KEY (delivery_date_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_delivery_actual FOREIGN KEY (delivery_date_actual) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_invoice_actual FOREIGN KEY (invoice_date_actual) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_order_rows
    ADD CONSTRAINT fact_order_rows_payment_actual FOREIGN KEY (payment_date_actual) REFERENCES public.dim_date(date_id);

--
-- fact_workphases
--

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_order_row FOREIGN KEY (order_row_id) REFERENCES public.fact_order_rows(order_row_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_workcenter FOREIGN KEY (workcenter_id) REFERENCES public.dim_workcenter(workcenter_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_workcenter_group FOREIGN KEY (workcenter_group_id) REFERENCES public.dim_workcenter_group(workcenter_group_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_article FOREIGN KEY (article_id) REFERENCES public.dim_article(article_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_start_og_planned FOREIGN KEY (start_date_original_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_start_latest_planned FOREIGN KEY (start_date_latest_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_start_actual FOREIGN KEY (start_date_actual) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_end_og_planned FOREIGN KEY (end_date_original_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_end_latest_planned FOREIGN KEY (end_date_latest_planned) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_end_actual FOREIGN KEY (end_date_actual) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_start_time_planned FOREIGN KEY (start_time_planned) REFERENCES public.dim_time(time_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_start_time_actual FOREIGN KEY (start_time_actual) REFERENCES public.dim_time(time_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_end_time_planned FOREIGN KEY (end_time_planned) REFERENCES public.dim_time(time_id);

ALTER TABLE ONLY public.fact_workphases
    ADD CONSTRAINT fact_workphases_end_time_actual FOREIGN KEY (end_time_actual) REFERENCES public.dim_time(time_id);

--
-- fact_machine_events
--

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_event_type FOREIGN KEY (event_type_id) REFERENCES public.dim_event_type(event_type_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_source FOREIGN KEY (source_id) REFERENCES public.dim_source(source_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_workphase FOREIGN KEY (workphase_id) REFERENCES public.fact_workphases(workphase_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_workcenter FOREIGN KEY (workcenter_id) REFERENCES public.dim_workcenter(workcenter_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_article FOREIGN KEY (article_id) REFERENCES public.dim_article(article_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_user FOREIGN KEY (user_id) REFERENCES public.dim_user(user_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_exception FOREIGN KEY (exception_id) REFERENCES public.dim_exception(exception_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_start_date FOREIGN KEY (start_date) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_end_date FOREIGN KEY (end_date) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_start_time FOREIGN KEY (start_time) REFERENCES public.dim_time(time_id);

ALTER TABLE ONLY public.fact_machine_events
    ADD CONSTRAINT fact_machine_events_end_time FOREIGN KEY (end_time) REFERENCES public.dim_time(time_id);


-- ============================================================
-- 5. INDEKSIT
-- ============================================================
-- PostgreSQL ei luo indeksia viiteavainsarakkeille automaattisesti.
-- Alla yleisimmin suodatuksessa ja liitoksissa tarvittavat indeksit.

CREATE INDEX idx_fact_order_rows_customer ON public.fact_order_rows (customer_id);
CREATE INDEX idx_fact_order_rows_article ON public.fact_order_rows (article_id);
CREATE INDEX idx_fact_order_rows_order_number ON public.fact_order_rows (order_number);
CREATE INDEX idx_fact_order_rows_work_id ON public.fact_order_rows (work_id);
CREATE INDEX idx_fact_order_rows_order_created ON public.fact_order_rows (order_created_date);

CREATE INDEX idx_fact_workphases_order_row ON public.fact_workphases (order_row_id);
CREATE INDEX idx_fact_workphases_workcenter ON public.fact_workphases (workcenter_id);
CREATE INDEX idx_fact_workphases_article ON public.fact_workphases (article_id);
CREATE INDEX idx_fact_workphases_work_id ON public.fact_workphases (work_id);
CREATE INDEX idx_fact_workphases_start_actual ON public.fact_workphases (start_date_actual);

CREATE INDEX idx_fact_machine_events_workphase ON public.fact_machine_events (workphase_id);
CREATE INDEX idx_fact_machine_events_workcenter ON public.fact_machine_events (workcenter_id);
CREATE INDEX idx_fact_machine_events_event_type ON public.fact_machine_events (event_type_id);
CREATE INDEX idx_fact_machine_events_source ON public.fact_machine_events (source_id);
CREATE INDEX idx_fact_machine_events_start_date ON public.fact_machine_events (start_date);
CREATE INDEX idx_fact_machine_events_start_at ON public.fact_machine_events (start_at);


-- ============================================================
-- 6. HAKUTAULUJEN VAKIOSISALTO
-- ============================================================

--
-- dim_event_type
--

INSERT INTO public.dim_event_type (event_type_id, event_type_name_eng, event_type_name_fin, event_description) VALUES
 (1,  'STAMPING PHASE',          'Vaiheleimaus',             'Työvaiheleimaus sisältäen sekä asetusajan että työstöajan. Leimaus voi alkaa esim. työn asetusvaiheen alussa ja päättyä työn loppuessa.'),
 (2,  'STAMPING SETUP',          'Asetustyöleimaus',         'Asetustyön leimaus.'),
 (3,  'STAMPING PRODUCTION',     'Tuotantovaiheleimaus',     'Työvaiheen varsinaisen työn leimaus. Leimaus alkaa kappaleiden työstön alkaessa ja päättyy työstön loppuessa.'),
 (4,  'STAMPING EXCEPTION',      'Poikkeamaleimaus',         'Poikkeaman leimaus, jos esim. kerätään käyttäjältä tietoa koneen pitkien pysähdysten syistä.'),
 (5,  'MAINTENANCE',             'Ylläpito',                 'Koneen huolto erillisenä rivinä. Tyypillisesti esim. leimausdatan pohjalta.'),
 (6,  'MACHINE PHASE',           'Konedata työvaihe',        'Koko työvaihe johdettuna konedatasta. Voidaan tehdä esim. ohjelmanimen perusteella aikaa rajaamalla tai ottamalla alku- ja päätepisteet leimausdatasta.'),
 (7,  'MACHINE SETUP',           'Konedata asetustyö',       'Asetustyö laskettuna konedatan perusteella. Voidaan laskea esim. aika ohjelman latauksesta ensimmäisen kappaleen työstöön tai ottaa asetusajan alku edellisen työn loppumisesta tai leimauksesta.'),
 (8,  'MACHINE PRODUCTION',      'Konedata tuotanto',        'Työn työstövaiheen koonti alkaen ensimmäisen kappaleen työstön alusta viimeisen kappaleen työstön päättymiseen. Tyypillisesti sisältää useita kappaleita vaihtoineen.'),
 (9,  'MACHINE SINGLE PART',     'Konedata yksi kappale',    'Yksittäisen kappaleen työstötapahtuma. Alkaa kappaleen työstön alkaessa ja päättyy työstön loppumiseen.'),
 (10, 'MACHINE PART CHANGE',     'Konedata vaihtotyö',       'Kahden samanlaisen kappaleen työstön välissä oleva aika, jonka aikana mm. irrotetaan edellinen ja kiinnitetään uusi.'),
 (11, 'MACHINE CUTTING',         'Konedata työstö',          'Yksittäinen työstötapahtuma, jota ei ole yhdistetty kappaleeseen tai työhön. Tyypillisesti anturidatasta.'),
 (12, 'MACHINE MANUAL',          'Konedata käsiajo',         'Käsiajotapahtuma, jos halutaan ne erottaa erilliseksi riveiksi. Voi olla myös esim. osana asetustyötä.'),
 (13, 'MACHINE MEASUREMENT',     'Konedata mittaus',         'Koneen mittaustapahtuma. Voi jatkossa olla liityntää mittausdatan tauluun, jos tietomallia laajennetaan.'),
 (14, 'MACHINE IDLE',            'Konedata tyhjäkäynti',     'Kone on päällä, mutta ei aktiivisessa työstössä. Tätä voidaan käyttää kaikkien ei-aktiivisten aikojen tallentamiseen tai vaihtoehtoisesti osan riveistä voi laittaa MACHINE SETUP tai MACHINE PART CHANGE tyyppien alle.'),
 (15, 'MACHINE EXCEPTION',       'Konedata poikkeama',       'Koneella on häiriötila tai muu poikkeama päällä.'),
 (16, 'POWER OFF',               'Kone sammutettu',          'Kone on poissa päältä.'),
 (17, 'MACHINE DAY',             'Konedata päivä',           'Yhden päivän koontirivi konedatasta. Ajat on pilkottu samalle riville eri kenttiin.'),
 (18, 'USER PRESENT',            'Käyttäjä läsnä',           'Käyttäjä on koneen ääressä tekemässä työtä. Tieto voi olla jostain leimausjärjestelmästä tai antureilla tunnistettu.'),
 (19, 'PLANNED PRODUCTION TIME', 'Suunniteltu tuotantoaika', 'Vuorokausikohtainen suunniteltu koneen tuotantoaika. Sisältää alku- ja loppuajan sekä keston.');

--
-- dim_source
--

INSERT INTO public.dim_source (source_id, source_name, source_description) VALUES
 (1, 'STAMPING',    'ERP-leimaus'),
 (2, 'MACHINE API', 'Koneen rajapinta'),
 (3, 'SENSOR',      'Sensori rajapinta');
