---
type: PostgreSQL Table
title: Tilausrivitaulu (fact_order_rows)
description: Tilausrivit koottuna pääosin ERP datasta.
resource: postgresql://TUOVA_DB/public/fact_order_rows
tags: [tietomalli, faktataulu, fact_order_rows]
status: stable
table_name: fact_order_rows
table_kind: fakta
column_count: 50
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Tilausrivit koottuna pääosin ERP datasta. Sisältää jonkin verran laskettuja arvoja tuotannosta ja toimituksesta. Tilausriveittäin kiinnostuksen kohteena ovat pääosin suunnitellut ja toteutuneet päivämäärät sekä suunniteltujen kustannusten vertailu toteumiin.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Tilausrivi ID** | `order_row_id` | PK / int | Tilausrivin uniikki tunniste. Voi olla sijaisavain tai yhdistelmä tilausnumerosta ja rivistä. |
| **Tilausnumero** | `order_number` | char | Tilauksen uniikki tunniste. Tilauksille ei ole omaa taulua tässä tietomallissa, joten kyseessä "degenoitunut dimensio" |
| **Työnumero** | `work_number` | char | Tuotantotilauksen nimi. Tuotantotilauksille ei ole omaa taulua tässä tietomallissa, joten kyseessä "degenoitunut dimensio" |
| **Työ ID** | `work_id` | int | Tuotantotilauksen uniikki tunniste helpottamaan taulujen yhdistelyjä. Tuotantotilauksille ei ole omaa taulua tässä tietomallissa, joten kyseessä "degenoitunut dimensio" |
| **Asiakkaan ID** | `customer_id` | FK / int | Asiakastaulun viiteavain. Yhdistyy dim_customer tauluun. |
| **Myyjä ID** | `seller_id` | FK / int | Myyjän tunniste. Voi olla tyhjä. Yhdistyy dim_user dimensiotauluun. |
| **Nimike ID** | `article_id` | FK / int | Nimikkeen/tuotteen tunniste. Yhdistyy dim_article dimensiotauluun. |
| **Tilauksen luontipäivä** | `order_created_date` | FK / int | ERP-järjestelmässä tilauksen luontipäivä. Käyttää semanttista avainformaattia (YYYYMMDD). |
| **Tuotannon suunniteltu aloitus** | `production_start_date_planned` | FK / int | Suunniteltu tuotannon aloituspäivä, jos kyseiseen tilaukseen liittyy tuotantotilaus. |
| **Tuotannon toteutunut aloitus** | `production_start_date_actual` | FK / int | Tuotannon toteutunut aloituspäivä. Ensimmäisen tuotantovaiheen aikaleimasta. |
| **Tuotannon suunniteltu lopetus** | `production_end_date_planned` | FK / int | Suunniteltu tuotannon päättymispäivä ennen tuotantoa. |
| **Tuotannon toteutunut lopetus** | `production_end_date_actual` | FK / int | Tuotannon toteutunut päättymispäivä. Viimeisen tuotantovaiheen aikaleimasta. |
| **Suunniteltu lähetys** | `dispatch_date_planned` | FK / int | Alustava lähetyspäivä, joka asetettu tilauksen luonnin tai työn suunnittelun yhteydessä. |
| **Toteutunut lähetys** | `dispatch_date_actual` | FK / int | Toteutunut lähetyspäivä. |
| **Suunniteltu toimitus** | `delivery_date_planned` | FK / int | Alustava toimituspäivä asiakkaalle, joka asetettu tilauksen luonnin tai työn suunnittelun yhteydessä. |
| **Toteutunut toimitus** | `delivery_date_actual` | FK / int | Toteutunut toimituspäivä. |
| **Lasku lähetyspäivä** | `invoice_date_actual` | FK / int | Laskun lähetyksen päivä laskutustiedoista. |
| **Lasku maksupäivä** | `payment_date_actual` | FK / int | Laskun maksupäivä päivä laskutustiedoista. |
| **Tilauksen tilan ID** | `order_state_id` | FK / int | Tilauksen tila. Yhdistyy dim_order_state tauluun. Yritys voi päättää itse mitä tiloja käytetään. |
| **Tilauksen tyyppi** | `order_type` | char | Tilauksen tyyppi. Voi olla esimerkiksi "myyntitilaus" tai "takuutyö". |
| **Tilattu määrä** | `ordered_qty` | int | Tilattu määrä tuotetta. Eri työvaiheissa tuotetut määrät fact_workphases taulussa. |
| **Toimitettu määrä** | `delivered_qty` | int | Toimitettu määrä tuotetta. Eri työvaiheissa tuotetut määrät fact_workphases taulussa. |
| **Kappalehinta** | `unit_price` | double | Tilausrivin tuotteen yhden kappaleen hinta. |
| **Tilausrivi hinta** | `total_price` | double | Tilausrivin arvo valuutassa ilman arvonlisäveroa. Saadaan yleensä kertomalla unit_price * ordered_qty |
| **Suorat työkustannukset suunniteltu** | `direct_work_cost_planned` | double | Suunniteltu suoran työn kustannus valmistuskustannuksissa. On eri tapoja laskea. Voidaan summata eri vaiheiden konetuntihinnoista laskettuja arvoja tai jyvittämällä henkilöiden työn osuutta (jos konekustannukset yleiskustannuksissa). |
| **Suorat työkustannukset toteutunut** | `direct_work_cost_actual` | double | Toteutunut suoran työn kustannus valmistuskustannuksissa. |
| **Materiaalikustannukset suunniteltu** | `material_cost_planned` | double | Valmistuksen suunnitellut suorat materiaalikulut. Voidaan laskea esim. materiaalien alkuvaraston arvo + ostot - loppuvaraston arvo. |
| **Materiaalikustannukset toteutunut** | `material_cost_actual` | double | Valmistuksen toteutuneet suorat materiaalikulut. |
| **Alihankintakustannukset suunniteltu** | `subcontracting_cost_planned` | double | Alihankinnan suunnitellut suorat kulut. Voi sisältää myös alihankintaan liittyvät logistiikkakulut. |
| **Alihankintakustannukset toteutunut** | `subcontracting_cost_actual` | double | Alihankinnan toteutuneet suorat kulut. Voi sisältää myös alihankintaan liittyvät logistiikkakulut. |
| **Muut suorat kustannukset** | `other_direct_costs_planned` | double | Muut muuttuvat kustannukset, kuten rahti, pakkaus, menetelmälisät… |
| **Muut suorat kustannukset toteutunut** | `other_direct_costs_actual` | double | Toteutuneet muut muuttuvat kustannukset, kuten rahti, pakkaus, menetelmälisät… |
| **Suorat tuotantokustannukset suunniteltu** | `prime_cost_planned_sum` | double | Tuotannon suunnitellut suorat tuotantokustannukset (välittömät kustannukset) ilman yleiskustannuslisää eli summattuna suora työ + materiaalit + alihankinta + muut suorat kustannukset. |
| **Suorat tuotantokustannukset toteutunut** | `prime_cost_actual_sum` | double | Tuotannon toteutuneet suorat tuotantokustannukset (välittömät kustannukset) ilman yleiskustannuslisää eli summattuna suora työ + materiaalit + alihankinta + muut suorat kustannukset. |
| **Kappalekustannukset suunniteltu** | `unit_prime_cost_planned` | double | Suunnitellut suorat tuotantokustannukset kappaletta kohti. |
| **Kappalekustannukset toteutunut** | `unit_prime_cost_actual` | double | Toteutuneet suorat tuotantokustannukset kappaletta kohti. |
| **Myyntikate suunniteltu** | `sales_margin_planned` | double | Tarjousvaiheessa laskettu myyntikate sisältäen yleiskustannuslisän ja voitto-osuuden. Voidaan laskea esim. total_price - prime_cost_planned_sum |
| **Myyntikate toteutunut** | `sales_margin_actual` | double | Toteutunut myyntikate sisältäen yleiskustannuslisän ja voitto-osuuden. Voidaan laskea esim. total_price - prime_cost_actual_sum |
| **Yleiskustannuslisä suunniteltu** | `overhead_costs_planned` | double | Hintaan laskettu yleiskustannuslisä eli tilaukselle määritetty  välillisten kustannusten osuus. Yleensä laskettu jonain lisäprosenttina tuotantokustannusten päälle. |
| **Yleiskustannuslisä toteutunut** | `overhead_costs_actual` | double | Toteutunut yleiskustannuslisä eli tilaukselle määritetty välillisten kustannusten osuus. |
| **Valmistuskustannukset suunniteltu** | `manufacturing_cost_planned` | double | Suunnitellut täydet valmistuskustannukset yhteensä. Sisältää suorat tuotantokustannukset ja yleiskustannukset. Synonyyminä usein "omakustannehinta" |
| **Valmistuskustannukset toteutunut** | `manufacturing_cost_actual` | double | Toteutuneet täydet valmistuskustannukset yhteensä. Sisältää suorat tuotantokustannukset ja yleiskustannukset. Synonyyminä usein "omakustannehinta" |
| **Kappale valmistuskustannukset suunniteltu** | `unit_manufacturing_cost_planned` | double | Suunnitellut valmistuskustannukset kappaletta kohti. |
| **Kappale valmistuskustannukset toteutunut** | `unit_manufacturing_cost_actual` | double | Toteutuneet valmistuskustannukset kappaletta kohti. |
| **Voittolisä suunniteltu** | `profit_planned` | double | Suunniteltu voittolisä kaikkien kustannusten vähennyksen jälkeen. Lasketaan vähentämällä myyntihinnasta kaikki kulut. Lasketaan yleensä jonain prosenttina omakustannehinnan päälle. |
| **Voittolisä toteutunut** | `profit_actual` | double | Toteutunut voittolisä kaikkien kustannusten vähennyksen jälkeen. Lasketaan vähentämällä myyntihinnasta kaikki kulut. Lasketaan yleensä jonain prosenttina omakustannehinnan päälle. |
| **Yksikkö** | `unit` | char | Tilattu yksikkö. |
| **Valuutta** | `currency` | char | Käytetty valuutta. |
| **Uusi nimike** | `new_article` | boolean | Tieto siitä onko kyseessä uusi nimike. |
| **Tilaus valmis** | `order_complete` | boolean | Tilaus on hoidettu ja laskutettu (ei välttämättä maksettu). |

# Suhteet

- [`fact_workphases`](/taulut/fact_workphases.md) — Työvaiheiden kustannus- ja tuotantotietojen yhdistäminen tilausriveihin (1:N)
- [`fact_machine_events`](/taulut/fact_machine_events.md) — Konetapahtumat voidaan yhdistää tilausriveihin epäsuorasti työvaihetaulun kautta. (1:N (epäsuora))
- [`dim_customer`](/taulut/dim_customer.md) — Asiakastiedot (N:1)
- [`dim_user`](/taulut/dim_user.md) — Myyjätiedot (N:1)
- [`dim_article`](/taulut/dim_article.md) — Tuote-/nimiketiedot (N:1)
- [`dim_order_state`](/taulut/dim_order_state.md) — Tilauksen tilatiedot (N:1)
- [`dim_date`](/taulut/dim_date.md) — Tilaus-, tuotanto-, toimitus-, lähetys-, laskutus- ja maksupäivien analysointi (N:1)
- Degenerate Dimensions — Tilausnumero, työnumero ja työ-ID säilytetään faktataulussa ilman omia dimensioita helpottamaan suodatusta ja yhdistelyjä (1:1)

# Mittarit

Taulun tiedoista laskettavat mittarit. Merkintä (+) tarkoittaa, että mittari tarvitsee myös toisen faktataulun tietoja.

- **1.1** [Tuotannon läpimenoaika](/mittarit/aikavertailut/1-01-tuotannon-lapimenoaika.md) — `dim_date[production_end_date_actual].date_index − dim_date[production_start_date_actual].date_index`
- **1.2** [Tuotannon läpimenoajan poikkeama](/mittarit/aikavertailut/1-02-tuotannon-lapimenoajan-poikkeama.md) — `(date_index(production_end_date_actual) − date_index(production_start_date_actual)) − (date_index(production_end_date_planned) − date_index(production_start_date_planned))`
- **1.3** [Tuotannon aloituspoikkeama](/mittarit/aikavertailut/1-03-tuotannon-aloituspoikkeama.md) — `date_index(production_start_date_actual) − date_index(production_start_date_planned)`
- **1.4** [Tuotannon valmistumispoikkeama](/mittarit/aikavertailut/1-04-tuotannon-valmistumispoikkeama.md) — `date_index(production_end_date_actual) − date_index(production_end_date_planned)`
- **1.5** [Tilauksesta toimitukseen kulunut aika](/mittarit/aikavertailut/1-05-tilauksesta-toimitukseen-kulunut-aika.md) — `date_index(delivery_date_actual) − date_index(order_created_date)`
- **1.6** [Toimituspoikkeama](/mittarit/aikavertailut/1-06-toimituspoikkeama.md) — `date_index(delivery_date_actual) − date_index(delivery_date_planned)`
- **1.7** [Tilausten toimitusvarmuus](/mittarit/aikavertailut/1-07-tilausten-toimitusvarmuus.md) — `COUNT(order_row_id WHERE delivery_date_actual <= delivery_date_planned) / COUNT(order_row_id WHERE delivery_date_actual IS NOT NULL) * 100`
- **1.8** [OTIF, ajallaan ja täysimääräisenä toimitetut](/mittarit/aikavertailut/1-08-otif-ajallaan-ja-taysimaaraisena-toimitetut.md) — `COUNT(order_row_id WHERE delivery_date_actual <= delivery_date_planned AND delivered_qty >= ordered_qty) / COUNT(order_row_id WHERE delivery_date_actual IS NOT NULL) * 100`
- **3.1** [Myynti](/mittarit/kannattavuus/3-01-myynti.md) — `SUM(total_price)`
- **3.2** [Toteutunut kate](/mittarit/kannattavuus/3-02-toteutunut-kate.md) — `SUM(sales_margin_actual); tai SUM(total_price) − SUM(prime_cost_actual_sum) (myyntikate); tai SUM(total_price) − SUM(manufacturing_cost_actual) (tulos yleiskustannusten jälkeen)`
- **3.3** [Kate-%](/mittarit/kannattavuus/3-03-kate.md) — `SUM(sales_margin_actual) / SUM(total_price) * 100`
- **3.4** [Katepoikkeama](/mittarit/kannattavuus/3-04-katepoikkeama.md) — `Euroina: SUM(sales_margin_actual) − SUM(sales_margin_planned); Prosenttiyksikköinä: (SUM(sales_margin_actual) / SUM(total_price) − SUM(sales_margin_planned) / SUM(total_price)) * 100`
- **3.5** [Jälkilaskennan poikkeama](/mittarit/kannattavuus/3-05-jalkilaskennan-poikkeama.md) — `SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum)`
- **3.6** [Jälkilaskennan poikkeamaprosentti](/mittarit/kannattavuus/3-06-jalkilaskennan-poikkeamaprosentti.md) — `(SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum)) / SUM(prime_cost_planned_sum) * 100`
- **3.7** [Kustannuslajikohtainen poikkeama](/mittarit/kannattavuus/3-07-kustannuslajikohtainen-poikkeama.md) — `SUM(direct_work_cost_actual) − SUM(direct_work_cost_planned); SUM(material_cost_actual) − SUM(material_cost_planned); SUM(subcontracting_cost_actual) − SUM(subcontracting_cost_planned); SUM(other_direct_costs_actual) − SUM(other_direct_costs_planned); SUM(overhead_costs_actual) − SUM(overhead_costs_planned)`
- **3.8** [Kappalekohtainen valmistuskustannus](/mittarit/kannattavuus/3-08-kappalekohtainen-valmistuskustannus.md) — `SUM(manufacturing_cost_actual) / SUM(ordered_qty); tai AVG(unit_manufacturing_cost_actual)`
- **3.9** [Voittolisä-%](/mittarit/kannattavuus/3-09-voittolisa.md) — `SUM(profit_actual) / SUM(manufacturing_cost_actual) * 100`
- **3.10** (+) [Tuntikate](/mittarit/kannattavuus/3-10-tuntikate.md) — `SUM(sales_margin_actual) / (SUM(fact_workphases.phase_duration_actual_min) / 60)`
- **3.12** [Asiakas-, tuote- ja myyjäkohtainen kate](/mittarit/kannattavuus/3-12-asiakas-tuote-ja-myyjakohtainen-kate.md) — `SUM(sales_margin_actual) GROUP BY customer_id | article_id | seller_id; SUM(sales_margin_actual) / SUM(total_price) * 100 samalla ryhmittelyllä`
- **3.14** [Alihankinnan osuus kustannuksista](/mittarit/kannattavuus/3-14-alihankinnan-osuus-kustannuksista.md) — `SUM(subcontracting_cost_actual) / SUM(prime_cost_actual_sum) * 100`
- **3.15** [Tilauskannan arvo ja laskuttamaton valmis tuotanto](/mittarit/kannattavuus/3-15-tilauskannan-arvo-ja-laskuttamaton-valmis-tuotanto.md) — `Tilauskanta = SUM(total_price) WHERE order_complete = FALSE; Laskuttamaton valmis = SUM(total_price) WHERE order_complete = FALSE AND production_end_date_actual IS NOT NULL`
- **3.16** [Laskutusviive ja maksuaika](/mittarit/kannattavuus/3-16-laskutusviive-ja-maksuaika.md) — `Laskutusviive = date_index(invoice_date_actual) − date_index(dispatch_date_actual); Maksuaika = date_index(payment_date_actual) − date_index(invoice_date_actual)`
- **4.7** (+) [Hylkäyksen kustannusvaikutus](/mittarit/laatu/4-07-hylkayksen-kustannusvaikutus.md) — `SUM(rejected_qty * unit_manufacturing_cost_actual) / SUM(manufacturing_cost_actual) * 100`
- **5.6** (+) [Keskeneräisen tuotannon määrä ja arvo](/mittarit/muut/5-06-keskeneraisen-tuotannon-maara-ja-arvo.md) — `Määrä = COUNT(order_row_id) WHERE production_start_date_actual IS NOT NULL AND production_end_date_actual IS NULL; Arvo = SUM(prime_cost_planned_sum) samalla ehdolla; Jäljellä oleva työ = SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL`
- **5.22** [Uusien nimikkeiden osuus ja kustannuspoikkeama](/mittarit/muut/5-22-uusien-nimikkeiden-osuus-ja-kustannuspoikkeama.md) — `Osuus = COUNT(order_row_id WHERE new_article = TRUE) / COUNT(order_row_id) * 100; Poikkeamaero = Jälkilaskennan poikkeama-% (new_article = TRUE) − Jälkilaskennan poikkeama-% (new_article = FALSE)`
- **6.6** (+) [Kytkemättömien rivien osuus](/mittarit/datan-laatu/6-06-kytkemattomien-rivien-osuus.md) — `COUNT(order_row_id ilman fact_workphases-riviä) / COUNT(order_row_id) * 100; COUNT(workphase_id ilman fact_machine_events-riviä) / COUNT(workphase_id) * 100`
- **6.7** [Toteumatietojen kattavuus](/mittarit/datan-laatu/6-07-toteumatietojen-kattavuus.md) — `COUNT(rivit joilla kenttä IS NULL) / COUNT(rivit) * 100; esim. start_timestamp_actual, end_timestamp_actual,; prime_cost_actual_sum, delivered_qty`

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
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
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
