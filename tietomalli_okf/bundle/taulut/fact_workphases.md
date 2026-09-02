---
type: PostgreSQL Table
title: Työvaihetaulu (fact_workphases)
description: Työvaihetaulu.
resource: postgresql://TUOVA_DB/public/fact_workphases
tags: [tietomalli, faktataulu, fact_workphases]
status: stable
table_name: fact_workphases
table_kind: fakta
column_count: 53
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Työvaihetaulu. Tiedot pääosin ERP/MES järjestelmästä, mutta voi sisältää johdettua tietoa myös muista lähteistä, kuten konedatasta. Työt voivat koostua useista työvaiheista ja liittyä suoraan tilausriveille, mutta se ei ole välttämätöntä. Työvaihetaulun osalta kiinnostaa erityisesti toteutuneiden aikojen vertailu suunniteltuihin.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Työvaihe ID** | `workphase_id` | PK / int | Työvaiherivin yksilöivä uniikki avain. |
| **Työvaihe raportti** | `workphase_number` | char | Työvaiherivin raportin tunniste. |
| **Tilausrivi ID** | `order_row_id` | FK / int | Liittää työvaiheen tilausrivitauluun. Monesta-yhteen tyyppinen yhteys. |
| **Työnumero** | `work_number` | char | Tuotantotilauksen tunniste. Tuotantotilauksille ei ole omaa taulua tässä tietomallissa, joten kyseessä "degenoitunut dimensio" |
| **Työ ID** | `work_id` | int | Tuotantotilauksen uniikki tunniste helpottamaan taulujen yhdistelyjä. |
| **Työkeskus ID** | `workcenter_id` | FK / int | Yksittäisen koneen/kuormitusryhmän/muun työkeskuksen tunniste (koneet, alihankkijat, muut työvaiheet). Tässä tietomallissa erilaiset työkeskukset tulevat samalla tavalla. Yhdistyy dim_workcenter ulottuvuustauluun. Vaatii tarkempaa määritystä mm. tilanteessa, jossa työ on toteutettu eri koneella kuin alkujaan suunniteltu tai työvaihe on jaettu usean koneen kesken. |
| **Työkeskusryhmä ID** | `workcenter_group_id` | FK / int | Työkeskuksen tyypin tunniste. Yhdistyy dim_workcenter_group tauluun. |
| **Nimike ID** | `article_id` | FK / int | Nimikkeen/tuotteen tunniste. Yhdistyy dim_article ulottuvuustauluun. |
| **Vaihenumero** | `phase_number` | int | Työvaiheen numero. Tyypillisesti järjestyksessä, jos useampi vaihe työssä. |
| **Vaihekuvaus** | `phase_description` | char | Työvaiheen kuvaus, jos saatavilla. Voidaan käyttää erottamaan eri tyyppisiä työvaiheita toisistaan (työstö, alihankinta, kokoonpano…) |
| **Vaihetila** | `phase_status` | char | Työvaiheen tila. Yrityksen määritettävissä. |
| **Alihankintavaihe** | `subcontracting_phase` | boolean | Tieto siitä, onko kyseessä alihankintatyövaihe. |
| **Aloituspäivä alkuperäinen** | `start_date_original_planned` | FK / int | Työvaiheen ensimmäinen määritetty aloituspäivä ERP/MES järjestelmästä. |
| **Aloituspäivä suunniteltu** | `start_date_latest_planned` | FK / int | Työvaiheen viimeisin suunniteltu aloituspäivä ERP/MES järjestelmästä. Ensimmäinen ajankohta, jos on pilkottu useaan osaan vaihe. |
| **Aloituspäivä toteutunut** | `start_date_actual` | FK / int | Työvaiheen toteutunut aloituspäivä (yleensä leimausdatasta). |
| **Lopetuspäivä alkuperäinen** | `end_date_original_planned` | FK / int | Työvaiheen ensimmäinen määritetty lopetuspäivä ERP/MES järjestelmästä. |
| **Lopetuspäivä suunniteltu** | `end_date_latest_planned` | FK / int | Työvaiheen viimeisin suunniteltu lopetuspäivä ERP/MES järjestelmästä. Viimeinen ajankohta, jos on pilkottu useaan osaan vaihe. |
| **Lopetuspäivä toteutunut** | `end_date_actual` | FK / int | Työvaiheen toteutunut lopetuspäivä (yleensä leimausdatasta). |
| **Aloitusaika suunniteltu** | `start_time_planned` | FK / int | Työvaiheen viimeisin suunniteltu aloitusaika ERP/MES järjestelmästä (jos saatavilla). Semanttisessa muodossa (HHMMSS). Aika on aikaleiman aikavyöhykkeessä. |
| **Aloitusaika toteutunut** | `start_time_actual` | FK / int | Työvaiheen toteutunut aloitusaika (yleensä leimaustiedoista). Semanttisessa muodossa (HHMMSS). Aika on aikaleiman aikavyöhykkeessä. |
| **Lopetusaika suunniteltu** | `end_time_planned` | FK / int | Työvaiheen viimeisin suunniteltu lopetusaika ERP/MES järjestelmästä (jos saatavilla). Semanttisessa muodossa (HHMMSS). Aika on aikaleiman aikavyöhykkeessä. |
| **Lopetusaika toteutunut** | `end_time_actual` | FK / int | Työvaiheen toteutunut lopetusaika (yleensä leimaustiedoista). Semanttisessa muodossa (HHMMSS). Aika on aikaleiman aikavyöhykkeessä. |
| **Aloitus aikaleima suunniteltu** | `start_timestamp_planned` | datetime | Työvaiheen suunnitellun aloitusajan aikaleima ISO8601-formaatissa. |
| **Lopetus aikaleima suunniteltu** | `end_timestamp_planned` | datetime | Työvaiheen suunnitellun lopetusajan aikaleima ISO8601-formaatissa. |
| **Aloitus aikaleima toteutunut** | `start_timestamp_actual` | datetime | Työvaiheen toteutuneen aloitusajan aikaleima ISO8601-formaatissa. |
| **Lopetus aikaleima toteutunut** | `end_timestamp_actual` | datetime | Työvaiheen toteutuneen lopetusajan aikaleima ISO8601-formaatissa. |
| **Suunniteltu määrä** | `planned_qty` | int | Vaiheessa tuotettavaksi suunniteltujen kappaleiden määrä. Huom! Voi olla eri määrä kuin yksittäisellä tilausrivillä. |
| **Tehty määrä** | `produced_qty` | int | Vaiheessa kaikkiaan tuotettu kappalemäärä. |
| **Hylätty määrä** | `rejected_qty` | int | Hylättyjen kappaleiden määrä. |
| **Tuntihinta** | `workcenter_hour_rate` | double | Työkeskuksen tuntihinta. Yleensä käytännössä koneelle määritetty konetuntihinta kyseisen työn ajankohtana. |
| **Vaihekustannus suunniteltu** | `phase_cost_planned` | double | Työvaiheen suunnitellut suoran työn kustannukset. Voi olla laskettu myös workcenter_hour_rate pohjalta, jos se on kustannusmallina. |
| **Vaihekustannus leimaukset** | `phase_cost_actual_stamping` | double | Työvaiheen toteutuneet suoran työn kustannukset leimausten perusteella. Voi olla laskettu myös konetuntihinnan pohjalta suhteutettuna toteutuneeseen aikaan, jos se on kustannusmallina. |
| **Vaihekustannus konedata** | `phase_cost_actual_machine` | double | Työvaiheen toteutuneet suoran työn kustannukset. Voi olla laskettu myös konetuntihinnan pohjalta suhteutettuna toteutuneeseen aikaan, jos se on kustannusmallina. |
| **Asetusaika suunniteltu** | `setup_time_planned_min` | double | Suunniteltu asetustyön kesto minuuteissa. |
| **Asetusaika leimattu** | `setup_time_stamping_min` | double | Toteutunut asetustyön kesto minuuteissa leimausdatan pohjalta (jos saatavilla) |
| **Asetusaika konedata** | `setup_time_machine_min` | double | Toteutunut asetustyön kesto minuuteissa konedatan pohjalta (jos saatavilla) |
| **Tuotantoaika suunniteltu** | `production_time_planned_min` | double | Vaiheen suunniteltu työstöaika minuutteina. |
| **Tuotantoaika leimattu** | `production_time_stamping_min` | double | Vaiheen toteutunut työstöaika leimausdatan pohjalta. |
| **Tuotantoaika konedata** | `production_time_machine_min` | double | Vaiheen toteutunut työstöaika konedatan pohjalta. |
| **Vaiheaika suunniteltu** | `phase_duration_planned_min` | double | Suunniteltu yhteenlaskettu vaiheaika sisältäen asetustyön ja työstöajan. |
| **Vaiheaika leimattu** | `phase_duration_stamping_min` | double | Toteutunut leimauksista yhteenlaskettu vaiheaika sisältäen asetustyön ja työstöajan. Kaikkien erillisten työstökertojen summa. |
| **Vaiheaika konedata** | `phase_duration_machine_min` | double | Toteutunut konedatasta yhteenlaskettu vaiheaika sisältäen asetustyön ja työstöajan. Kaikkien erillisten työstökertojen summa. |
| **Kappaleaika suunniteltu** | `unit_time_planned_min` | double | Yhden kappaleen suunniteltu kappaleaika. Saadaan jakamalla suunniteltu vaiheaika (phase_duration_planned_min) suunniteltujen kappaleiden määrällä. |
| **Kappaleaika leimattu** | `unit_time_stamping_min` | double | Yhden kappaleen leimausten perusteella kappaleaika. Saadaan jakamalla leimattu vaiheaika tuotettujen kappaleiden määrällä. |
| **Kappaleaika konedata** | `unit_time_machine_min` | double | Yhden kappaleen konedatan perusteella kappaleaika. Saadaan jakamalla laskettu vaiheaika tuotettujen kappaleiden määrällä. |
| **Kappale jaksoaika tavoite** | `cycle_time_ideal_min` | double | Yhden kappaleen paras mahdollinen tavoiteltu sykliaika/jaksoaika = aika kahden valmistuneen kappaleen välillä. Voi olla eri kuin mitä suunnittelussa käytetään. Käytetään OEE laskennassa, jos saatavilla. |
| **Kappale jaksoaika suunniteltu** | `cycle_time_planned_min` | double | Yhden kappaleen suunniteltu sykliaika/jaksoaika = aika kahden valmistuneen kappaleen välillä. |
| **Kappale jaksoaika leimattu** | `cycle_time_stamping_min` | double | Yhden kappaleen leimausten perusteella sykliaika/jaksoaika = aika kahden valmistuneen kappaleen välillä. Paras arvio, jos on erikseen mitattu ja leimattu. |
| **Kappale jaksoaika konedata** | `cycle_time_machine_min` | double | Yhden kappaleen konedatan perusteella laskettu sykliaika/jaksoaika. Laskettu keskimääräinen tai mediaaniaika kappaleen valmistumisesta seuraavan kappaleen valmistumiseen. |
| **Koneaika tavoite** | `processing_time_ideal_min` | double | Yhden kappaleen tavoiteltu koneistusaika = aika kappaleen koneistuksen alkamisesta päättymiseen. Voi olla eri asia kuin suunniteltu tai toteutunut koneistusaika. |
| **Koneaika suunniteltu** | `processing_time_planned_min` | double | Yhden kappaleen suunniteltu koneistusaika = aika kappaleen koneistuksen alkamisesta päättymiseen. |
| **Koneaika leimattu** | `processing_time_stamping_min` | double | Leimausdatan perusteella yhden kappaleen koneistusaika = aika kappaleen koneistuksen alkamisesta päättymiseen. |
| **Koneaika konedata** | `processing_time_machine_min` | double | Konedatan perusteella yhden kappaleen koneistusaika = aika kappaleen koneistuksen alkamisesta päättymiseen. |

# Suhteet

- [`fact_order_rows`](/taulut/fact_order_rows.md) — Työvaiheen yhdistäminen tilausriviin sekä asiakkaaseen, myyntiin ja toimituksiin liittyviin tietoihin. (N:1)
- [`fact_machine_events`](/taulut/fact_machine_events.md) — Konetapahtumien liittäminen työvaiheisiin. (1:N)
- [`dim_workcenter`](/taulut/dim_workcenter.md) — Kone-, työpiste-, alihankkija- tai muun resurssikohtaisen suorituskyvyn analysointi. (N:1)
- [`dim_workcenter_group`](/taulut/dim_workcenter_group.md) — Työkeskusten ryhmäkohtainen kapasiteetti-, kuormitus- ja tehokkuusraportointi. (N:1)
- [`dim_article`](/taulut/dim_article.md) — Nimike-/tuotekohtaisten valmistusaikojen, kustannusten ja laadun analysointi. (N:1)
- [`dim_date`](/taulut/dim_date.md) — Aikataulujen, läpimenoaikojen, myöhästymisten ja toimitusvarmuuden analysointi. (N:1)
- [`dim_time`](/taulut/dim_time.md) — Vuoro-, tunti- ja kellonaikakohtaisten tapahtumien analysointi. (N:1)
- Degenerate Dimensions — Työnumero ja työ-ID säilytetään faktataulussa ilman erillisiä dimensiotauluja. (1:1)

# Mittarit

Taulun tiedoista laskettavat mittarit. Merkintä (+) tarkoittaa, että mittari tarvitsee myös toisen faktataulun tietoja.

- **1.9** [Työvaiheen toteutunut kesto](/mittarit/aikavertailut/1-09-tyovaiheen-toteutunut-kesto.md) — `end_timestamp_actual − start_timestamp_actual`
- **1.10** [Vaiheajan poikkeama](/mittarit/aikavertailut/1-10-vaiheajan-poikkeama.md) — `(SUM(phase_duration_actual_min) − SUM(phase_duration_planned_min)) / SUM(phase_duration_planned_min) * 100`
- **1.11** (+) [Asetusajan poikkeama](/mittarit/aikavertailut/1-11-asetusajan-poikkeama.md) — `(SUM(setup_time_actual_min) − SUM(setup_time_planned_min)) / SUM(setup_time_planned_min) * 100`
- **1.12** [Työvaiheiden aikataulupitävyys](/mittarit/aikavertailut/1-12-tyovaiheiden-aikataulupitavyys.md) — `COUNT(workphase_id WHERE end_date_actual <= end_date_latest_planned) / COUNT(workphase_id WHERE end_date_actual IS NOT NULL) * 100`
- **1.13** [Uudelleenaikataulutettujen työvaiheiden osuus](/mittarit/aikavertailut/1-13-uudelleenaikataulutettujen-tyovaiheiden-osuus.md) — `COUNT(workphase_id WHERE start_date_original_planned <> start_date_latest_planned OR end_date_original_planned <> end_date_latest_planned) / COUNT(workphase_id) * 100`
- **1.14** [Odotusaika työvaiheiden välillä](/mittarit/aikavertailut/1-14-odotusaika-tyovaiheiden-valilla.md) — `start_timestamp_actual(phase_number = n+1) − end_timestamp_actual(phase_number = n); saman work_id:n sisällä`
- **3.11** [Asetuskustannus kappaletta kohti](/mittarit/kannattavuus/3-11-asetuskustannus-kappaletta-kohti.md) — `(setup_time_planned_min / 60 * workcenter_hour_rate) / planned_qty`
- **3.13** [Vaihekustannuksen poikkeama](/mittarit/kannattavuus/3-13-vaihekustannuksen-poikkeama.md) — `SUM(phase_cost_actual_stamping) − SUM(phase_cost_planned)`
- **4.1** [Hyväksytty ja hylätty määrä](/mittarit/laatu/4-01-hyvaksytty-ja-hylatty-maara.md) — `Hylätty määrä = SUM(rejected_qty); Hyväksytty määrä = SUM(produced_qty) − SUM(rejected_qty)`
- **4.2** [Hylkäysaste](/mittarit/laatu/4-02-hylkaysaste.md) — `SUM(rejected_qty) / SUM(produced_qty) * 100`
- **4.3** [Laatukerroin ja hyväksymisaste](/mittarit/laatu/4-03-laatukerroin-ja-hyvaksymisaste.md) — `(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100`
- **4.4** [PPM](/mittarit/laatu/4-04-ppm.md) — `SUM(rejected_qty) / SUM(produced_qty) * 1000000`
- **4.5** [Ensimmäisen läpäisyn saanto, FPY](/mittarit/laatu/4-05-ensimmaisen-lapaisyn-saanto-fpy.md) — `(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100; laskettuna työvaiheittain`
- **4.6** [Kokonaisläpisaanto, RTY](/mittarit/laatu/4-06-kokonaislapisaanto-rty.md) — `TULO(FPY(vaihe)) saman work_id:n vaiheille, järjestettynä phase_number mukaan`
- **5.1** [Tuotantomäärä](/mittarit/muut/5-01-tuotantomaara.md) — `SUM(produced_qty) rajattuna jaksoon end_date_actual kautta`
- **5.2** [Tuotantomäärä standarditunteina](/mittarit/muut/5-02-tuotantomaara-standarditunteina.md) — `SUM(produced_qty * unit_time_planned_min) / 60`
- **5.3** (+) [Läpäisykyky](/mittarit/muut/5-03-lapaisykyky.md) — `(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_actual_min) / 60)`
- **5.4** [Työn tuottavuus](/mittarit/muut/5-04-tyon-tuottavuus.md) — `(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_stamping_min) / 60)`
- **5.5** [Työtuntitehokkuus](/mittarit/muut/5-05-tyotuntitehokkuus.md) — `SUM(phase_duration_planned_min) / SUM(phase_duration_actual_min) * 100`
- **5.6** (+) [Keskeneräisen tuotannon määrä ja arvo](/mittarit/muut/5-06-keskeneraisen-tuotannon-maara-ja-arvo.md) — `Määrä = COUNT(order_row_id) WHERE production_start_date_actual IS NOT NULL AND production_end_date_actual IS NULL; Arvo = SUM(prime_cost_planned_sum) samalla ehdolla; Jäljellä oleva työ = SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL`
- **5.7** [Työvaiheen kuormitus](/mittarit/muut/5-07-tyovaiheen-kuormitus.md) — `setup_time_planned_min + planned_qty * cycle_time_planned_min; tai suoraan phase_duration_planned_min`
- **5.8** [Työpisteen kokonaiskuormitus](/mittarit/muut/5-08-tyopisteen-kokonaiskuormitus.md) — `SUM(phase_duration_planned_min) GROUP BY workcenter_id, jakso; jakso start_date_latest_planned kautta dim_date-tauluun`
- **5.9** [Työjonon kuormitus](/mittarit/muut/5-09-tyojonon-kuormitus.md) — `SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL GROUP BY workcenter_id`
- **5.10** [Myöhässä olevan kuorman osuus](/mittarit/muut/5-10-myohassa-olevan-kuorman-osuus.md) — `SUM(phase_duration_planned_min) WHERE end_date_latest_planned < tarkastelupäivä AND end_date_actual IS NULL / Työjonon kuormitus * 100`
- **5.11** (+) [Kuormitusaste](/mittarit/muut/5-11-kuormitusaste.md) — `Työpisteen kokonaiskuormitus / Tehollinen kapasiteetti * 100; Tehollinen kapasiteetti = SUM(duration_min) WHERE event_type_id = 19; tai erillinen kapasiteettiparametri`
- **5.12** [Vapaa kapasiteetti tai kapasiteettivaje](/mittarit/muut/5-12-vapaa-kapasiteetti-tai-kapasiteettivaje.md) — `Tehollinen kapasiteetti − Työpisteen kokonaiskuormitus; Puskurin osuus = (Tehollinen kapasiteetti − kuormitus) / Tehollinen kapasiteetti * 100`
- **5.13** [Kuormitushorisontti](/mittarit/muut/5-13-kuormitushorisontti.md) — `Työjonon kuormitus / (Tehollinen kapasiteetti per päivä)`
- **5.14** [Osoitettu kapasiteetti](/mittarit/muut/5-14-osoitettu-kapasiteetti.md) — `AVG(SUM(produced_qty * unit_time_planned_min)) valituilta vertailujaksoilta GROUP BY workcenter_id, jakso`
- **5.15** [Työkeskusryhmän kuormitustasapaino](/mittarit/muut/5-15-tyokeskusryhman-kuormitustasapaino.md) — `STDDEV(kuormitus) GROUP BY workcenter_group_id; tai (MAX(kuormitus) − MIN(kuormitus)) / AVG(kuormitus) * 100`
- **6.3** [Leimaus- ja konedatan poikkeama](/mittarit/datan-laatu/6-03-leimaus-ja-konedatan-poikkeama.md) — `(SUM(phase_duration_stamping_min) − SUM(phase_duration_machine_min)) / SUM(phase_duration_machine_min) * 100`
- **6.8** [Ihannesykliajan kattavuus](/mittarit/datan-laatu/6-08-ihannesykliajan-kattavuus.md) — `COUNT(workphase_id WHERE cycle_time_ideal_min IS NOT NULL) / COUNT(workphase_id) * 100`

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
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
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
