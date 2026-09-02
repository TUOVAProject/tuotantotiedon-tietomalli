---
type: PostgreSQL Table
title: Konetapahtumataulu (fact_machine_events)
description: Töiden toteumatietoja leimauksista ja/tai konedatasta johdettuna.
resource: postgresql://TUOVA_DB/public/fact_machine_events
tags: [tietomalli, faktataulu, fact_machine_events]
status: stable
table_name: fact_machine_events
table_kind: fakta
column_count: 42
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Töiden toteumatietoja leimauksista ja/tai konedatasta johdettuna. Voi sisältää eri tarkkuustason datoja samassa taulussa, mutta pääosassa on työvaihe- tai vuorokausikohtaiset koonnit. Tarkimmaksi tasoksi on ajateltu yksittäisen kappaleen työstötapahtuma. Samalla työvaiheella voi olla useita erilaisia liittyviä tapahtumia. Keskeisenä on jakaa erilaiset tapahtumatyypit event_type_id ja source_id tiedoilla. Tapahtuman tyypistä riippuu, mitkä kentät ovat käytössä. Oleellisinta tietoa ovat aikaleimat ja aikaleimojen välissä olevan ajan jakatuminen. Konedata yhdistetään ERP-dataan tässä taulussa.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Konetahpatuma ID** | `machine_event_id` | PK / int | Konetapahtuman yksilöivä uniikki avain. |
| **Tapahtumatyyppi ID** | `event_type_id` | FK / int | Tällä erotetaan erilaiset konetapahtumat toisistaan. Yhdistyy dim_event_type dimensiotauluun, jossa tapahtumat kuvattu. |
| **Tapahtumalähde ID** | `source_id` | FK / int | Merkataan datan lähde. Yhdistyy dim_source tauluun. Oletuksena 1 = STAMPING, 2 = MACHINE API, 3 = SENSOR |
| **Työvaihe ID** | `workphase_id` | FK / int | Yhdistää konetapahtuman jonkin työtilauksen vaiheeseen eli fact_workphases taulun riviin. |
| **Työnumero** | `work_number` | char | Tuotantotilauksen tunniste. Tuotantotilauksille ei ole omaa taulua tässä tietomallissa, joten kyseessä "degenoitunut dimensio" |
| **Työ ID** | `work_id` | int | Tuotantotilauksen tunnistekoodi. Käytetään taulujen yhdistelyihin. |
| **Työkeskus ID** | `workcenter_id` | FK / int | Koneen/työkeskuksen tunniste. Yhdistyy dim_workcenter taulun konetietoihin. |
| **Nimike ID** | `article_id` | FK / int | Työstettävän nimikkeen tunniste. Yhdistyy dim_article tauluun. |
| **Käyttäjä ID** | `user_id` | FK / int | Koneen käyttäjän tunniste. |
| **Ohjelma** | `program_name` | char | Koneessa ajossa olevan ohjelman nimi. |
| **Aloituspäivä** | `start_date` | FK / int | Konetapahtuman aloituspäivä semanttisessa avainformaatissa (YYYYMMDD). |
| **Lopetuspäivä** | `end_date` | FK / int | Konetapahtuman päättymispäivä semanttisessa avainformaatissa (YYYYMMDD). |
| **Aloitusaika** | `start_time` | FK / int | Tapahtuman aloitusaika. Semanttisessa muodossa (HHMMSS). Aika on aikaleiman aikavyöhykkeessä. |
| **Lopetusaika** | `end_time` | FK / int | Tapahtuman lopetusaika. Semanttisessa muodossa (HHMMSS). Aika on aikaleiman aikavyöhykkeessä. |
| **Aloitus aikaleima** | `start_at` | datetime | Tapahtuman aloituksen aikaleima ISO8601 formaatissa. |
| **Lopetus aikaleima** | `end_at` | datetime | Tapahtuman lopetuksen aikaleima ISO8601 formaatissa. |
| **Kesto min** | `duration_min` | double | Tapahtuman kesto minuutteina. Laskettu aloitusajan ja lopetusajan erotuksesta. |
| **Kappaleaika min** | `unit_time_min` | double | Yhden kappaleen laskettu kappaleaika. Voidaan laskea esim. jakamalla duration_min / produced_qty. |
| **Kappale jaksoaika min** | `unit_cycle_time_min` | double | Yhden kappaleen keskimääräinen jaksoaika (sykliaika), jos on saatavilla.  Aika kappaleen valmistumisesta toisen kappaleen valmistumiseen. Usean kappaleen tapauksessa esim. keskiarvo. |
| **Kappale koneaika min** | `unit_processing_time_min` | double | Yhden kappaleen työstöaika. Aika kappaleen työstön aloituksesta työstön loppumiseen. Useamman kappaleen tapauksessa esim. keskiarvo. |
| **Tuotettu määrä leimausdata** | `produced_qty_stamping` | int | Tuotettujen kappaleiden määrä tapahtuman aikana leimausdatan pohjalta. |
| **Tuotettu määrä konedata** | `produced_qty_machine` | int | Konedatasta laskettu tuotettujen kappaleiden määrä tapahtuman aikana. |
| **Hylätty määrä kpl** | `rejected_qty_stamping` | int | Hylättyjen kappaleiden määrä. Mahdollisesti saatavilla leimausdatassa. |
| **Kappalelaskuri** | `part_counter` | int | Koneen kappalelaskurin arvo tapahtuman loputtua. |
| **Tehokas työstöaika min** | `efficient_production_min` | double | Koneen tehokas työstöaika tapahtuman aikana johdettuna konedatasta. |
| **Tehoton työstöaika min** | `inefficient_production_min` | double | Koneen tehoton työstöaika tapahtuman aikana johdettuna konedatasta. Kone käy mutta ei "täydellä teholla". |
| **Lastuamisaika min** | `cutting_time_min` | double | Koneen varsinainen lastuamisaika aktiivisen työn aikana. |
| **Koneen apuaika min** | `non_cutting_time_min` | double | Aktiivisen työn aikana osuus ajasta, jolloin lastu ei irtoa. Sisältää esim. työstöpäiden pikaliikkeet, työkalujen vaihdot, työstönaikaiset mittaukset jne. |
| **Syötön prosenttikytkin** | `feed_override` | double | Keskimääräinen syötön prosenttikytkimen (feed rate override) arvo työstön aikana. |
| **Karan prosenttikytkin** | `spindle_override` | double | Keskimääräinen karan nopeuden prosenttikytkimen (spindle speed override) arvo työstön aikana. |
| **Työstöaika min** | `machine_active_min` | double | Aktiivisen työstön määrä minuutteina. Voidaan laskea joko tehoton-tehokas jaosta tai lastuamis-ei lastuamisajasta, jos on jaettuna. |
| **Asetusaika min** | `setup_time_min` | double | Asetusajan määrä tapahtuman aikana. On yrityskohtaista mitä asetusaikaan sisällytetään. |
| **Vaihtoaika min** | `part_change_time_min` | double | Kappaleen vaihtoajan määrä tapahtuman aikana. Vaihtoaika on aika kappaleen työstön päättymisestä seuraavan kappaleen työstön alkuun saman työvaiheen aikana. |
| **Muu odotusaika min** | `undefined_idle_min` | double | Muun tyhjäkäyntiajan määrä tapahtuman aikana. Käytetään, jos aikaa ei voi määrittää asetusajaksi tai kappaleen vaihtoajaksi. |
| **Odotusaika min** | `idle_sum_min` | double | Summattu koneen tyhjäkäynti minuutteina tapahtuman aikana (setup_time_min + part_change_time_min + undefined_idle_min) |
| **Sammutettu min** | `power_off_min` | double | Kone poissa päällä minuutteina. |
| **Muu aika min** | `other_min` | double | Aika jota ei saatu kohdistettua mihinkään tapahtuman aikana. Esimerkiksi erotus duration_min ja eri tila-aikojen summasta. |
| **Poikkeama min** | `exception_min` | double | Poikkeustilan (koneessa esim. virhetila päällä) kesto minuutteina. |
| **Poikkeama ID** | `exception_id` | FK / int | Poikkeustilan yksilöivä tunniste. Yhdistyy dim_exception tauluun, jossa tarkemmat tiedot. Voidaan käyttää vaikka koneen ilmoittamien virhetilojen seurantaan. |
| **Aikojen summa min** | `time_sum_min` | double | Tapahtumarivillä tarkasteltavien aikojen summa. Käytetään tarkistamaan, että saadaan sama kuin aikaleimoista laskettu kesto (duration_min). |
| **Energiankulutus kWh** | `power_consumption_kwh` | double | Tapahtuman aikana kulutettu energiamäärä kWh, jos on saatavilla esim. konedatassa. |
| **Lisätiedot** | `notes` | char | Kuvauksia, huomautuksia tai muuta tapahtumaan liittyvää tietoa. Voidaan käyttää myös lisädatan säilömiseen, jos kentät eivät riitä. |

# Suhteet

- [`fact_workphases`](/taulut/fact_workphases.md) — Työvaiheiden tapahtumakohtainen seuranta. (N:1)
- [`fact_order_rows`](/taulut/fact_order_rows.md) — Konetapahtumat voidaan yhdistää tilausriveihin FactWorkPhases-taulun kautta. (N:1 (epäsuora))
- [`dim_event_type`](/taulut/dim_event_type.md) — Tapahtumalajien luokittelu. (N:1)
- [`dim_source`](/taulut/dim_source.md) — Datalähteiden hallinta ja laadun seuranta. (N:1)
- [`dim_workcenter`](/taulut/dim_workcenter.md) — Kone- ja työkeskuskohtainen analytiikka. (N:1)
- [`dim_article`](/taulut/dim_article.md) — Nimikekohtainen analytiikka. (N:1)
- [`dim_user`](/taulut/dim_user.md) — Käyttäjäkohtainen analytiikka. (N:1)
- [`dim_exception`](/taulut/dim_exception.md) — Poikkeama- ja häiriöanalytiikka. (N:1)
- [`dim_date`](/taulut/dim_date.md) — Päiväkohtainen analytiikka. (N:1)
- [`dim_time`](/taulut/dim_time.md) — Vuoro- ja tuntikohtainen analytiikka. (N:1)
- Degenerate Dimensions — Työnumero, työ-ID ja ohjelman nimi säilytetään faktataulussa ilman erillisiä dimensiotauluja. (1:1)

# Mittarit

Taulun tiedoista laskettavat mittarit. Merkintä (+) tarkoittaa, että mittari tarvitsee myös toisen faktataulun tietoja.

- **2.1** [Suunniteltu tuotantoaika](/mittarit/oee/2-01-suunniteltu-tuotantoaika.md) — `SUM(duration_min) WHERE event_type_id = 19`
- **2.2** [Käyntiaika](/mittarit/oee/2-02-kayntiaika.md) — `SUM(machine_active_min) WHERE event_type_id IN (6, 8, 17)`
- **2.3** [Seisokkiaika ja seisokkiaste](/mittarit/oee/2-03-seisokkiaika-ja-seisokkiaste.md) — `Seisokkiaika = SUM(idle_sum_min + exception_min + power_off_min); Seisokkiaste = Seisokkiaika / Suunniteltu tuotantoaika * 100`
- **2.4** [Käytettävyys](/mittarit/oee/2-04-kaytettavyys.md) — `Käyntiaika / Suunniteltu tuotantoaika * 100`
- **2.5** (+) [Nopeus](/mittarit/oee/2-05-nopeus.md) — `SUM(cycle_time_ideal_min * Valmistettu määrä) / Käyntiaika * 100`
- **2.6** (+) [Laatukerroin](/mittarit/oee/2-06-laatukerroin.md) — `(SUM(produced_qty_machine) − SUM(rejected_qty_stamping)) / SUM(produced_qty_machine) * 100`
- **2.7** (+) [OEE, kokonaistehokkuus](/mittarit/oee/2-07-oee-kokonaistehokkuus.md) — `Käytettävyys * Nopeus * Laatukerroin (desimaalilukuina); tai suoraan:; SUM(Hyväksytty määrä * cycle_time_ideal_min) / Suunniteltu tuotantoaika * 100`
- **2.8** (+) [Täysin tuottava aika](/mittarit/oee/2-08-taysin-tuottava-aika.md) — `SUM(Hyväksytty määrä * cycle_time_ideal_min)`
- **2.9** [Koneen käyttöaste](/mittarit/oee/2-09-koneen-kayttoaste.md) — `SUM(machine_active_min) / (tarkastelujakson päivien määrä * 1440) * 100`
- **2.10** [Lastuamisaste](/mittarit/oee/2-10-lastuamisaste.md) — `SUM(cutting_time_min) / SUM(machine_active_min) * 100`
- **2.11** [Apuajan osuus](/mittarit/oee/2-11-apuajan-osuus.md) — `SUM(non_cutting_time_min) / SUM(machine_active_min) * 100`
- **2.12** [Asetus- ja vaihtoajan osuus](/mittarit/oee/2-12-asetus-ja-vaihtoajan-osuus.md) — `Asetusajan osuus = SUM(setup_time_min) / SUM(duration_min) * 100; Vaihtoajan osuus = SUM(part_change_time_min) / SUM(duration_min) * 100`
- **2.13** [Tehottoman ajon osuus](/mittarit/oee/2-13-tehottoman-ajon-osuus.md) — `SUM(inefficient_production_min) / (SUM(efficient_production_min) + SUM(inefficient_production_min)) * 100`
- **2.14** [Prosenttikytkinten keskiarvo](/mittarit/oee/2-14-prosenttikytkinten-keskiarvo.md) — `AVG(feed_override), AVG(spindle_override)`
- **2.15** (+) [Sykliajan poikkeama tavoitteesta](/mittarit/oee/2-15-sykliajan-poikkeama-tavoitteesta.md) — `(cycle_time_machine_min − cycle_time_ideal_min) / cycle_time_ideal_min * 100`
- **5.16** [Poikkeamien määrä ja keskimääräinen kesto](/mittarit/muut/5-16-poikkeamien-maara-ja-keskimaarainen-kesto.md) — `Määrä = COUNT(machine_event_id) WHERE event_type_id IN (4, 15); Kokonaisaika = SUM(exception_min); Keskim. kesto = SUM(exception_min) / COUNT(poikkeamat)`
- **5.17** [Suunnittelemattomien seisokkien osuus](/mittarit/muut/5-17-suunnittelemattomien-seisokkien-osuus.md) — `SUM(exception_min + undefined_idle_min) / Suunniteltu tuotantoaika * 100`
- **5.18** [Ylläpitoajan osuus](/mittarit/muut/5-18-yllapitoajan-osuus.md) — `SUM(duration_min) WHERE event_type_id = 5 / SUM(duration_min) * 100`
- **5.19** [Energiankulutus ja sen suhdeluvut](/mittarit/muut/5-19-energiankulutus-ja-sen-suhdeluvut.md) — `Kulutus yhteensä = SUM(power_consumption_kwh); Kappaletta kohti = SUM(power_consumption_kwh) / SUM(produced_qty_machine); Käyntituntia kohti = SUM(power_consumption_kwh) / (SUM(machine_active_min) / 60); Tyhjäkäynnin osuus = SUM(power_consumption_kwh) WHERE event_type_id = 14 / SUM(power_consumption_kwh) * 100`
- **5.20** [Miehittämättömän ajon osuus](/mittarit/muut/5-20-miehittamattoman-ajon-osuus.md) — `SUM(machine_active_min) ilman päällekkäistä event_type_id = 18 -jaksoa / SUM(machine_active_min) * 100`
- **5.21** [Käyttäjä- ja vuorokohtainen tarkastelu](/mittarit/muut/5-21-kayttaja-ja-vuorokohtainen-tarkastelu.md) — `Mikä tahansa edellä kuvattu mittari ryhmiteltynä; dim_time.shift_id tai fact_machine_events.user_id mukaan; esim. AVG(setup_time_min) GROUP BY user_id, article_id`
- **6.1** [Aikojen kohdistusaste](/mittarit/datan-laatu/6-01-aikojen-kohdistusaste.md) — `SUM(time_sum_min) / SUM(duration_min) * 100`
- **6.2** [Kohdistamattoman ajan osuus](/mittarit/datan-laatu/6-02-kohdistamattoman-ajan-osuus.md) — `SUM(other_min) / SUM(duration_min) * 100`
- **6.4** [Kappalemäärien ristiintarkistus](/mittarit/datan-laatu/6-04-kappalemaarien-ristiintarkistus.md) — `SUM(produced_qty_stamping) − SUM(produced_qty_machine); sekä part_counter-kentän jatkuvuuden tarkistus`
- **6.5** [Konetapahtumien kohdistusaste työvaiheisiin](/mittarit/datan-laatu/6-05-konetapahtumien-kohdistusaste-tyovaiheisiin.md) — `COUNT(machine_event_id WHERE workphase_id IS NOT NULL) / COUNT(machine_event_id) * 100`

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
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
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
