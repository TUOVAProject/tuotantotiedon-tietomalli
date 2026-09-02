# Tuotantotiedon tietomalli

**Tietomallin versio:** 1.0

**Viimeksi päivitetty:** 2026-09-02

Tässä tiedostossa on koottuna TUOVA-hankkeessa kehitetty tuotantotiedon tietomalli päätauluineen. Tietomallinnuksessa on käytetty dimensiopohjaista mallinnusta. Tietomalli soveltuu sellaisenaan mm. konepajojen analytiikan ja raportoinnin pohjaksi. Tietomallia on mahdollista laajentaa tarpeen mukaan.

## Faktataulut

Tietomalli koostuu kolmesta linkittyvästä transaktiomuotoisesta faktataulusta: tilausrivitaulu (fact_order_rows), työvaihetaulu (fact_workphases) ja konetapahtumataulu (fact_machine_events).

Tämä rakenne muodostaa loogisen porautumisketjun:

Tilausrivit ⭢ Työvaiheet ⭢ Työvaiheen tapahtumat

Tämän mallin avulla voidaan siirtyä tilausrivitasolta yksittäisiin työvaiheisiin ja edelleen koneen tapahtuma-, käyttöaste-, OEE-, seisokki-, virhe- ja energiatietoihin.

---

### Tilausrivitaulu (fact_order_rows)

**Taulun kuvaus:** 

Tilausrivit koottuna pääosin ERP datasta. Sisältää jonkin verran laskettuja arvoja tuotannosta ja toimituksesta. Tilausriveittäin kiinnostuksen kohteena ovat pääosin suunnitellut ja toteutuneet päivämäärät sekä suunniteltujen kustannusten vertailu toteumiin.

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


#### Esimerkki tilausrivitaulun rivin koostumisesta

Alla on esimerkki, miten Monitor ERP järjestelmän tiedoista voidaan johtaa tilausrivien tietoja. Monitorin [API-rajapinnan kuvaus](https://api.monitor.se/index.html).

Alla olevassa taulukossa on joitain perustiedoja ja päivämääriä, joita saadaan ERP-järjestelmän datasta melko suoraan. Taulukko ei sisällä kaikkia mahdollisia arvoja. Esimerkiksi kustannustietojen lähde pitää tarkistaa yrityskohtaisesti.

| Tietomallikenttä | Monitor ERP | Esimerkki | Huomioita |
|---|---|---|---|
| order_row_id | Sales/CustomerOrderRows.Id | 1440369807943955191 |  |
| order_number | Sales/CustomerOrders.OrderNumber | M29012 |  |
| work_number | Manufacturing/ManufacturingOrders.OrderNumber | M29012-10 |  |
| work_id | Manufacturing/ManufacturingOrders.OrderNumber | 1440370057052064986 |  |
| customer_id | Sales/CustomerOrders.CustomerId | 851824985154530947 |  |
| seller_id | Sales/CustomerOrders.SellerId | 1448508488740372636 |  |
| article_id | Sales/CustomerOrderRows.PartId | 1055548616791086481 |  |
| order_created_date | Sales/CustomerOrderRows.OrderDate | 20260617 |  |
| production_start_date_planned | Manufacturing/ManufacturingOrder.StartDate | 20260803 |  |
| production_start_date_actual | min(Manufacturing/ManufacturingOrderOperations.ActualStartDate) | 20260730 | Tyhjä, jos ei ole vielä aloittanut tuotantoa. |
| production_end_date_planned | Manufacturing/ManufacturingOrder.InitialFinishDate | 20260810 |  |
| production_end_date_actual | max(Manufacturing/ManufacturingOrderOperations.ActualFinishDate) | 20260803 | Tyhjä, jos jokin vaihe vielä suorittamatta. |
| order_state_id | Manufacturing/ManufacturingOrder.Status | 4 | Tilauksen tila voidaan ottaa monesta paikasta. Käyttötarkoituksen mukaan valinta. |
| ordered_qty | Sales/CustomerOrderRows.OrderedQuantity | 20 |  |
| unit_price | Sales/CustomerOrderRows.Price | 22.81 |  |
| total_price | Sales/CustomerOrderRows.OrderedQuantity * Sales/CustomerOrderRows.Price | 456.13 |  |
| new_article | Sales/CustomerOrderRows.PartStatus == 3 | FALSE | Voi valita säännön sopivaksi omaan dataan. |
| order_complete | Sales/CustomerOrderRows.Status == 9 | TRUE | Voi valita säännön sopivaksi omaan dataan. |


#### Tauluun liittyvät mittarit

Taulun tietojen avulla voidaan laskea alla luetellut mittarit. Tunniste viittaa mittaritiedostoon `mittarit.md`, jossa on kunkin mittarin täydellinen kuvaus: mitä mittari mittaa, kaava myös semanttisilla nimillä, mittayksikkö, tarkastelutaso ja rajoitteet. Merkintä (+) tarkoittaa, että mittari tarvitsee myös toisen faktataulun tietoja.

- **1.1 Tuotannon läpimenoaika** — `date_index(production_end_date_actual) − date_index(production_start_date_actual)`
- **1.2 Tuotannon läpimenoajan poikkeama** — `Toteutunut läpimenoaika − (date_index(production_end_date_planned) − date_index(production_start_date_planned))`
- **1.3 Tuotannon aloituspoikkeama** — `date_index(production_start_date_actual) − date_index(production_start_date_planned)`
- **1.4 Tuotannon valmistumispoikkeama** — `date_index(production_end_date_actual) − date_index(production_end_date_planned)`
- **1.5 Tilauksesta toimitukseen kulunut aika** — `date_index(delivery_date_actual) − date_index(order_created_date)`
- **1.6 Toimituspoikkeama** — `date_index(delivery_date_actual) − date_index(delivery_date_planned)`
- **1.7 Tilausten toimitusvarmuus** — `COUNT(delivery_date_actual <= delivery_date_planned) / COUNT(delivery_date_actual IS NOT NULL) * 100`
- **1.8 OTIF** — `COUNT(delivery_date_actual <= delivery_date_planned AND delivered_qty >= ordered_qty) / COUNT(delivery_date_actual IS NOT NULL) * 100`
- **3.1 Myynti** — `SUM(total_price)`
- **3.2 Toteutunut kate** — `SUM(sales_margin_actual) tai SUM(total_price) − SUM(manufacturing_cost_actual)`
- **3.3 Kate-%** — `SUM(sales_margin_actual) / SUM(total_price) * 100`
- **3.4 Katepoikkeama** — `SUM(sales_margin_actual) − SUM(sales_margin_planned)`
- **3.5 Jälkilaskennan poikkeama** — `SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum)`
- **3.6 Jälkilaskennan poikkeamaprosentti** — `(SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum)) / SUM(prime_cost_planned_sum) * 100`
- **3.7 Kustannuslajikohtainen poikkeama** — `SUM(<kustannuslaji>_actual) − SUM(<kustannuslaji>_planned)`
- **3.8 Kappalekohtainen valmistuskustannus** — `SUM(manufacturing_cost_actual) / SUM(ordered_qty)`
- **3.9 Voittolisä-%** — `SUM(profit_actual) / SUM(manufacturing_cost_actual) * 100`
- **3.10 (+) Tuntikate** — `SUM(sales_margin_actual) / (SUM(fact_workphases.phase_duration_actual_min) / 60)`
- **3.12 Asiakas-, tuote- ja myyjäkohtainen kate** — `SUM(sales_margin_actual) GROUP BY customer_id | article_id | seller_id`
- **3.14 Alihankinnan osuus kustannuksista** — `SUM(subcontracting_cost_actual) / SUM(prime_cost_actual_sum) * 100`
- **3.15 Tilauskannan arvo ja laskuttamaton valmis tuotanto** — `SUM(total_price) WHERE order_complete = FALSE`
- **3.16 Laskutusviive ja maksuaika** — `date_index(invoice_date_actual) − date_index(dispatch_date_actual); date_index(payment_date_actual) − date_index(invoice_date_actual)`
- **4.7 (+) Hylkäyksen kustannusvaikutus** — `SUM(fact_workphases.rejected_qty * unit_manufacturing_cost_actual) / SUM(manufacturing_cost_actual) * 100`
- **5.6 (+) Keskeneräisen tuotannon määrä ja arvo** — `COUNT(*) ja SUM(prime_cost_planned_sum) WHERE production_start_date_actual IS NOT NULL AND production_end_date_actual IS NULL`
- **5.22 Uusien nimikkeiden osuus ja kustannuspoikkeama** — `COUNT(new_article = TRUE) / COUNT(*) * 100`
- **6.6 (+) Kytkemättömien rivien osuus** — `COUNT(order_row_id ilman fact_workphases-riviä) / COUNT(order_row_id) * 100`
- **6.7 Toteumatietojen kattavuus** — `COUNT(kenttä IS NULL) / COUNT(*) * 100`

#### Taulun riippuvuudet

Tilausrivitaulun rivit liittyvät seuraaviin tauluihin.

| Taulu | Riippuvuus | Suhde | Tarkoitus |
|---------|---------|---------|---------|
| FactOrderRows | FactWorkPhases | 1:N | Työvaiheiden kustannus- ja tuotantotietojen yhdistäminen tilausriveihin |
| FactOrderRows | FactMachineEvents | 1:N (epäsuora) | Konetapahtumat voidaan yhdistää tilausriveihin epäsuorasti työvaihetaulun kautta. |
| FactOrderRows | DimCustomer | N:1 | Asiakastiedot |
| FactOrderRows | DimUser | N:1 | Myyjätiedot |
| FactOrderRows | DimArticle | N:1 | Tuote-/nimiketiedot |
| FactOrderRows | DimOrderState | N:1 | Tilauksen tilatiedot |
| FactOrderRows | DimDate | N:1 | Tilaus-, tuotanto-, toimitus-, lähetys-, laskutus- ja maksupäivien analysointi |
| FactOrderRows | Degenerate Dimensions | 1:1 | Tilausnumero, työnumero ja työ-ID säilytetään faktataulussa ilman omia dimensioita helpottamaan suodatusta ja yhdistelyjä |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

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

---

### Työvaihetaulu (fact_workphases)

**Taulun kuvaus:** 

Työvaihetaulu. Tiedot pääosin ERP/MES järjestelmästä, mutta voi sisältää johdettua tietoa myös muista lähteistä, kuten konedatasta. Työt voivat koostua useista työvaiheista ja liittyä suoraan tilausriveille, mutta se ei ole välttämätöntä.

Työvaihetaulun osalta kiinnostaa erityisesti toteutuneiden aikojen vertailu suunniteltuihin.

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

#### Esimerkki työvaihetaulun rivin koostumisesta

Alla on esimerkki, miten Monitor ERP järjestelmän tiedoista voidaan johtaa työvaiheiden tiedot ja laskea toteumia. Monitorin [API-rajapinnan kuvaus](https://api.monitor.se/index.html).

Alla esimerkki Monitor ERP järjestelmästä poimituista tiedoista datalähteineen.

| Tietomallikenttä | Monitor ERP | Esimerkki | Huomioita |
|---|---|---|---|
| workphase_id | Manufacturing/ManufacturingOrderOperations.Id | 1440370057052064986 |  |
| workphase_number | Manufacturing/ManufacturingOrderOperations.ReportNumber | 31394 |  |
| order_row_id | Sales/CustomerOrderRows.Id | 1440369807943955191 |  |
| work_number | Manufacturing/ManufacturingOrders.OrderNumber | M29012-10 |  |
| work_id | Manufacturing/ManufacturingOrderOperations.ManufacturingOrderId | 1440370057052064933 |  |
| workcenter_id | Manufacturing/ManufacturingOrderOperations.WorkcenterId | 864384525073424771 |  |
| article_id | Manufacturing/ManufacturingOrderOperations.PartId | 1055548616791086481 |  |
| phase_number | Manufacturing/ManufacturingOrderOperations.OperationNumber | 20 |  |
| start_date_latest_planned | Manufacturing/ManufacturingOrderOperations.PlannedStartDate | 20260804 | Tiputetaan aikaosa pois. |
| start_date_actual | Manufacturing/ManufacturingOrderOperations.PlannedStartDate | 20260731 | Tiputetaan aikaosa pois. |
| end_date_latest_planned | Manufacturing/ManufacturingOrderOperations.PlannedFinishDate | 20260804 | Tiputetaan aikaosa pois. |
| end_date_actual | Manufacturing/ManufacturingOrderOperations.ActualFinishDate | 20260803 | Tiputetaan aikaosa pois. |
| start_time_actual | Manufacturing/ManufacturingOrderOperations.ActualStartDate | 134604 | Otetaan pelkkä aikaosa ja muutetaan se. |
| end_time_actual | Manufacturing/ManufacturingOrderOperations.ActualFinishDate | 154812 | Otetaan pelkkä aikaosa ja muutetaan se. |
| start_timestamp_planned | Manufacturing/ManufacturingOrderOperations.PlannedStartDate | 2026-08-04T00:00:00+03:00 | Sellaisenaan kokonaisessa muodossa |
| end_timestamp_planned | Manufacturing/ManufacturingOrderOperations.PlannedFinishDate | 2026-08-04T23:59:00+03:00 | Sellaisenaan kokonaisessa muodossa |
| start_timestamp_actual | Manufacturing/ManufacturingOrderOperations.ActualStartDate | 2026-07-31T13:46:04+03:00 | Sellaisenaan kokonaisessa muodossa sekunnin murto-osat pyöristettyinä |
| end_timestamp_actual | Manufacturing/ManufacturingOrderOperations.ActualFinishDate | 2026-08-03T15:48:12+03:00 | Sellaisenaan kokonaisessa muodossa sekunnin murto-osat pyöristettyinä |
| planned_qty | Manufacturing/ManufacturingOrderOperations.PlannedQuantity | 20 |  |
| produced_qty | Manufacturing/ManufacturingOrderOperations.ReportedQuantity | 22 |  |
| rejected_qty | Manufacturing/ManufacturingOrderOperations.RejectedQuantity | 2 |  |
| setup_time_planned_min | Manufacturing/ManufacturingOrderOperations.PlannedSetupTime | 30 | Muunnettu minuuteiksi |
| setup_time_stamping_min | Manufacturing/ManufacturingOrderOperations.ReportedSetupTime | 30 | Muunnettu minuuteiksi |
| production_time_planned_min | Manufacturing/ManufacturingOrderOperations.PlannedUnitTime | 520 | Muunnettu minuuteiksi |
| production_time_stamping_min | Manufacturing/ManufacturingOrderOperations.ReportedUnitTime | 650 | Muunnettu minuuteiksi |
| phase_duration_planned_min | Manufacturing/ManufacturingOrderOperations.PlannedSetupTime +  Manufacturing/ManufacturingOrderOperations.PlannedUnitTime | 550 |  |
| phase_duration_stamping_min | Manufacturing/ManufacturingOrderOperations.ReportedSetupTime + Manufacturing/ManufacturingOrderOperations.ReportedUnitTime | 680 |  |
| unit_time_planned_min | ( Manufacturing/ManufacturingOrderOperations.PlannedSetupTime +  Manufacturing/ManufacturingOrderOperations.PlannedUnitTime ) / Manufacturing/ManufacturingOrderOperations.PlannedQuantity | 27.5 |  |
| unit_time_stamping_min | Manufacturing/ManufacturingOrderOperations.ReportedUnitTime / Manufacturing/ManufacturingOrderOperations.ReportedQuantity | 30.91 |  |
| cycle_time_planned_min | Manufacturing/ManufacturingOrderOperations.PlannedUnitTime / Manufacturing/ManufacturingOrderOperations.PlannedQuantity | 26 |  |
| cycle_time_stamping_min | Manufacturing/ManufacturingOrderOperations.ReportedUnitTime / Manufacturing/ManufacturingOrderOperations.ReportedQuantity | 29.55 |  |

Jos on konedatan keruuta leimausdatan lisäksi, on tauluun tarkoitus johtaa koonteja työhön liittyvistä konetapahtumista. Rajapintadatasta on mahdollista laskea mm. toteutuneita kappalekohtaisia jaksoaikoja (sykliaika) tai kappaleiden koneaikoja. Lisättäessä näitä tietoja, voidaan käyttää esim. keskiarvoa tai mediaania toteutuneista ajoista.

#### Tauluun liittyvät mittarit

Taulun tietojen avulla voidaan laskea alla luetellut mittarit. Tunniste viittaa mittaritiedostoon `mittarit.md`, jossa on kunkin mittarin täydellinen kuvaus: mitä mittari mittaa, kaava myös semanttisilla nimillä, mittayksikkö, tarkastelutaso ja rajoitteet. Merkintä (+) tarkoittaa, että mittari tarvitsee myös toisen faktataulun tietoja.

- **1.9 Työvaiheen toteutunut kesto** — `end_timestamp_actual − start_timestamp_actual`
- **1.10 Vaiheajan poikkeama** — `(SUM(phase_duration_actual_min) − SUM(phase_duration_planned_min)) / SUM(phase_duration_planned_min) * 100`
- **1.11 Asetusajan poikkeama** — `(SUM(setup_time_actual_min) − SUM(setup_time_planned_min)) / SUM(setup_time_planned_min) * 100`
- **1.12 Työvaiheiden aikataulupitävyys** — `COUNT(end_date_actual <= end_date_latest_planned) / COUNT(end_date_actual IS NOT NULL) * 100`
- **1.13 Uudelleenaikataulutettujen työvaiheiden osuus** — `COUNT(start_date_original_planned <> start_date_latest_planned OR end_date_original_planned <> end_date_latest_planned) / COUNT(*) * 100`
- **1.14 Odotusaika työvaiheiden välillä** — `start_timestamp_actual(phase_number = n+1) − end_timestamp_actual(phase_number = n)`
- **3.11 Asetuskustannus kappaletta kohti** — `(setup_time_planned_min / 60 * workcenter_hour_rate) / planned_qty`
- **3.13 Vaihekustannuksen poikkeama** — `SUM(phase_cost_actual_stamping) − SUM(phase_cost_planned)`
- **4.1 Hyväksytty ja hylätty määrä** — `SUM(produced_qty) − SUM(rejected_qty); SUM(rejected_qty)`
- **4.2 Hylkäysaste** — `SUM(rejected_qty) / SUM(produced_qty) * 100`
- **4.3 Laatukerroin ja hyväksymisaste** — `(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100`
- **4.4 PPM** — `SUM(rejected_qty) / SUM(produced_qty) * 1000000`
- **4.5 Ensimmäisen läpäisyn saanto, FPY** — `(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100 vaiheittain`
- **4.6 Kokonaisläpisaanto, RTY** — `TULO(FPY(vaihe)) GROUP BY work_id, järjestys phase_number`
- **5.1 Tuotantomäärä** — `SUM(produced_qty)`
- **5.2 Tuotantomäärä standarditunteina** — `SUM(produced_qty * unit_time_planned_min) / 60`
- **5.3 Läpäisykyky** — `(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_actual_min) / 60)`
- **5.4 Työn tuottavuus** — `(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_stamping_min) / 60)`
- **5.5 Työtuntitehokkuus** — `SUM(phase_duration_planned_min) / SUM(phase_duration_actual_min) * 100`
- **5.6 (+) Keskeneräisen tuotannon määrä ja arvo** — `SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL`
- **5.7 Työvaiheen kuormitus** — `setup_time_planned_min + planned_qty * cycle_time_planned_min`
- **5.8 Työpisteen kokonaiskuormitus** — `SUM(phase_duration_planned_min) GROUP BY workcenter_id, jakso`
- **5.9 Työjonon kuormitus** — `SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL GROUP BY workcenter_id`
- **5.10 Myöhässä olevan kuorman osuus** — `SUM(phase_duration_planned_min) WHERE end_date_latest_planned < tarkastelupäivä AND end_date_actual IS NULL / Työjonon kuormitus * 100`
- **5.11 Kuormitusaste** — `SUM(phase_duration_planned_min) / Tehollinen kapasiteetti * 100`
- **5.12 Vapaa kapasiteetti tai kapasiteettivaje** — `Tehollinen kapasiteetti − SUM(phase_duration_planned_min)`
- **5.13 Kuormitushorisontti** — `Työjonon kuormitus / päiväkohtainen tehollinen kapasiteetti`
- **5.14 Osoitettu kapasiteetti** — `AVG(SUM(produced_qty * unit_time_planned_min)) GROUP BY workcenter_id, jakso`
- **5.15 Työkeskusryhmän kuormitustasapaino** — `STDDEV(kuormitus) GROUP BY workcenter_group_id`
- **6.3 Leimaus- ja konedatan poikkeama** — `(SUM(phase_duration_stamping_min) − SUM(phase_duration_machine_min)) / SUM(phase_duration_machine_min) * 100`
- **6.8 Ihannesykliajan kattavuus** — `COUNT(cycle_time_ideal_min IS NOT NULL) / COUNT(*) * 100`

#### Taulun riippuvuudet

Työvaihetaulun rivit liittyvät seuraaviin tauluihin.

| Taulu | Riippuvuus | Suhde | Tarkoitus |
|---------|---------|---------|---------|
| FactWorkPhases | FactOrderRows | N:1 | Työvaiheen yhdistäminen tilausriviin sekä asiakkaaseen, myyntiin ja toimituksiin liittyviin tietoihin. |
| FactWorkPhases | FactMachineEvents | 1:N | Konetapahtumien liittäminen työvaiheisiin. |
| FactWorkPhases | DimWorkcenter | N:1 | Kone-, työpiste-, alihankkija- tai muun resurssikohtaisen suorituskyvyn analysointi. |
| FactWorkPhases | DimWorkcenterGroup | N:1 | Työkeskusten ryhmäkohtainen kapasiteetti-, kuormitus- ja tehokkuusraportointi. |
| FactWorkPhases | DimArticle | N:1 | Nimike-/tuotekohtaisten valmistusaikojen, kustannusten ja laadun analysointi. |
| FactWorkPhases | DimDate | N:1 | Aikataulujen, läpimenoaikojen, myöhästymisten ja toimitusvarmuuden analysointi. |
| FactWorkPhases | DimTime | N:1 | Vuoro-, tunti- ja kellonaikakohtaisten tapahtumien analysointi. |
| FactWorkPhases | Degenerate Dimensions | 1:1 | Työnumero ja työ-ID säilytetään faktataulussa ilman erillisiä dimensiotauluja. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

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

---

### Konetapahtumataulu (fact_machine_events)

**Taulun kuvaus:** 

Töiden toteumatietoja leimauksista ja/tai konedatasta johdettuna. Voi sisältää eri tarkkuustason datoja samassa taulussa, mutta pääosassa on työvaihe- tai vuorokausikohtaiset koonnit. Tarkimmaksi tasoksi on ajateltu yksittäisen kappaleen työstötapahtuma. Samalla työvaiheella voi olla useita erilaisia liittyviä tapahtumia.

Keskeisenä on jakaa erilaiset tapahtumatyypit event_type_id ja source_id tiedoilla. Tapahtuman tyypistä riippuu, mitkä kentät ovat käytössä. Oleellisinta tietoa ovat aikaleimat ja aikaleimojen välissä olevan ajan jakatuminen. Konedata yhdistetään ERP-dataan tässä taulussa.

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

#### Esimerkkejä konetapahtumataulun riveistä

Esimerkkinä Monitor ERP -järjestelmästä yhden leimausdatan rivi. Esimerkissä leimaus sisältää sekä asetustyön että tuotantoajan. Monitorin [API-rajapinnan kuvaus](https://api.monitor.se/index.html).

| Tietomallikenttä | Monitor ERP | Esimerkki | Huomioita |
|---|---|---|---|
| machine_event_id | TimeRecording/WorkInterval.Id | 1456675803694142678 |  |
| event_type_id |  | 1 | Ei tue ERP-datasta vaan tietomallista. |
| source_id |  | 1 | Ei tue ERP-datasta vaan tietomallista. |
| workphase_id | TimeRecording/WorkInterval.OperationId | 1440370057052064986 |  |
| work_number | Manufacturing/ManufacturingOrders.OrderNumber | M29012-10 |  |
| work_id | Manufacturing/ManufacturingOrderOperations.ManufacturingOrderId | 1440370057052064933 |  |
| workcenter_id | Manufacturing/ManufacturingOrderOperations.WorkCenterId | 864384525073424771 |  |
| article_id | Manufacturing/ManufacturingOrders.PartId | 1055548616791086481 |  |
| user_id | TimeRecording/WorkInterval.ReportingEmployeeId | 1338255435802546745 |  |
| start_date | TimeRecording/WorkInterval.IntervalStart | 20260803 | Otetaan pelkkä päivämäärä |
| end_date | TimeRecording/WorkInterval.IntervalEnd | 20260803 | Otetaan pelkkä päivämäärä |
| start_time | TimeRecording/WorkInterval.IntervalStart | 51900 | Otetaan pelkkä aika |
| end_time | TimeRecording/WorkInterval.IntervalEnd | 152200 | Otetaan pelkkä aika |
| start_at | TimeRecording/WorkInterval.IntervalStart | 2026-08-03T05:19:00+03:00 | Arvo suoraan |
| end_at | TimeRecording/WorkInterval.IntervalEnd | 2026-08-03T15:22:00+03:00 | Arvo suoraan |
| duration_min | TimeRecording/WorkInterval.WorkedTime | 603 | Muutetaan minuuteiksi. Vaihtoehtoisesti lasketaan end_at - start_at erotuksena. |
| unit_time_min | TimeRecording/WorkInterval.WorkedTime / TimeRecording/WorkInterval.ReportedQuantity | 33.5 | Helpompi mahdolisesti duration_min avulla laskettuna |
| produced_qty | TimeRecording/WorkInterval.ReportedQuantity | 18 |  |
| rejected_qty | TimeRecording/WorkInterval.RejectedQuantity | 0 |  |


#### Tauluun liittyvät mittarit

Taulun tietojen avulla voidaan laskea alla luetellut mittarit. Tunniste viittaa mittaritiedostoon `mittarit.md`, jossa on kunkin mittarin täydellinen kuvaus: mitä mittari mittaa, kaava myös semanttisilla nimillä, mittayksikkö, tarkastelutaso ja rajoitteet. Merkintä (+) tarkoittaa, että mittari tarvitsee myös toisen faktataulun tietoja.

- **2.1 Suunniteltu tuotantoaika** — `SUM(duration_min) WHERE event_type_id = 19`
- **2.2 Käyntiaika** — `SUM(machine_active_min) WHERE event_type_id IN (6, 8, 17)`
- **2.3 Seisokkiaika ja seisokkiaste** — `SUM(idle_sum_min + exception_min + power_off_min); osuus suunnitellusta tuotantoajasta * 100`
- **2.4 Käytettävyys** — `Käyntiaika / Suunniteltu tuotantoaika * 100`
- **2.5 (+) Nopeus** — `SUM(fact_workphases.cycle_time_ideal_min * Valmistettu määrä) / Käyntiaika * 100`
- **2.6 Laatukerroin** — `(SUM(produced_qty_machine) − SUM(rejected_qty_stamping)) / SUM(produced_qty_machine) * 100`
- **2.7 (+) OEE, kokonaistehokkuus** — `Käytettävyys * Nopeus * Laatukerroin`
- **2.8 (+) Täysin tuottava aika** — `SUM(Hyväksytty määrä * fact_workphases.cycle_time_ideal_min)`
- **2.9 Koneen käyttöaste** — `SUM(machine_active_min) / (jakson päivät * 1440) * 100`
- **2.10 Lastuamisaste** — `SUM(cutting_time_min) / SUM(machine_active_min) * 100`
- **2.11 Apuajan osuus** — `SUM(non_cutting_time_min) / SUM(machine_active_min) * 100`
- **2.12 Asetus- ja vaihtoajan osuus** — `SUM(setup_time_min) / SUM(duration_min) * 100; SUM(part_change_time_min) / SUM(duration_min) * 100`
- **2.13 Tehottoman ajon osuus** — `SUM(inefficient_production_min) / (SUM(efficient_production_min) + SUM(inefficient_production_min)) * 100`
- **2.14 Prosenttikytkinten keskiarvo** — `AVG(feed_override); AVG(spindle_override)`
- **2.15 (+) Sykliajan poikkeama tavoitteesta** — `(unit_cycle_time_min − fact_workphases.cycle_time_ideal_min) / fact_workphases.cycle_time_ideal_min * 100`
- **5.16 Poikkeamien määrä ja keskimääräinen kesto** — `COUNT(machine_event_id) WHERE event_type_id IN (4, 15); SUM(exception_min) / COUNT(poikkeamat)`
- **5.17 Suunnittelemattomien seisokkien osuus** — `SUM(exception_min + undefined_idle_min) / Suunniteltu tuotantoaika * 100`
- **5.18 Ylläpitoajan osuus** — `SUM(duration_min) WHERE event_type_id = 5 / SUM(duration_min) * 100`
- **5.19 Energiankulutus ja sen suhdeluvut** — `SUM(power_consumption_kwh); / SUM(produced_qty_machine); / (SUM(machine_active_min) / 60)`
- **5.20 Miehittämättömän ajon osuus** — `SUM(machine_active_min) ilman päällekkäistä event_type_id = 18 -jaksoa / SUM(machine_active_min) * 100`
- **5.21 Käyttäjä- ja vuorokohtainen tarkastelu** — `mittari GROUP BY user_id tai dim_time.shift_id`
- **6.1 Aikojen kohdistusaste** — `SUM(time_sum_min) / SUM(duration_min) * 100`
- **6.2 Kohdistamattoman ajan osuus** — `SUM(other_min) / SUM(duration_min) * 100`
- **6.4 Kappalemäärien ristiintarkistus** — `SUM(produced_qty_stamping) − SUM(produced_qty_machine)`
- **6.5 Konetapahtumien kohdistusaste työvaiheisiin** — `COUNT(workphase_id IS NOT NULL) / COUNT(machine_event_id) * 100`

#### Taulun riippuvuudet

Konetapahtumataulun rivit liittyvät seuraaviin tauluihin.

| Taulu | Riippuvuus | Suhde | Tarkoitus |
|---------|---------|---------|---------|
| FactMachineEvents | FactWorkPhases | N:1 | Työvaiheiden tapahtumakohtainen seuranta. |
| FactMachineEvents | FactOrderRows | N:1 (epäsuora) | Konetapahtumat voidaan yhdistää tilausriveihin FactWorkPhases-taulun kautta. |
| FactMachineEvents | DimEventType | N:1 | Tapahtumalajien luokittelu. |
| FactMachineEvents | DimSource | N:1 | Datalähteiden hallinta ja laadun seuranta. |
| FactMachineEvents | DimWorkcenter | N:1 | Kone- ja työkeskuskohtainen analytiikka. |
| FactMachineEvents | DimArticle | N:1 | Nimikekohtainen analytiikka. |
| FactMachineEvents | DimUser | N:1 | Käyttäjäkohtainen analytiikka. |
| FactMachineEvents | DimException | N:1 | Poikkeama- ja häiriöanalytiikka. |
| FactMachineEvents | DimDate | N:1 | Päiväkohtainen analytiikka. |
| FactMachineEvents | DimTime | N:1 | Vuoro- ja tuntikohtainen analytiikka. |
| FactMachineEvents | Degenerate Dimensions | 1:1 | Työnumero, työ-ID ja ohjelman nimi säilytetään faktataulussa ilman erillisiä dimensiotauluja. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

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

---

## Ulottuvuustaulut

Ulottuvuustauluja eli dimensiotauluja käytetään dimensiopohjaisessa mallinnuksessa antamaan faktataulujen riveille kontekstia. Niitä käytetään mm. suodattamaan faktatauluista haluttuja rivejä.

Ulottuvuustauluja voidaan muokata yrityksen tarpeiden mukaan. Osa ulottuvuustauluista on tarkoitettu staattisiksi, kun taas toiset päivittyvät aina tietojen päivityksen yhteydessä.

Hitaasti muuttuvien dimensioiden (SCD) historiatiedon säilytykseen on erilaisia vaihtoehtoja. Tässä käytetyssä mallissa vanhat tiedot ylikirjoitetaan tietojen muuttuessa, mutta tarvittaessa malliin voidaan lisätä historiatietojen tallentaminen.

---

### Asiakastaulu (dim_customer)

**Taulun kuvaus:** Asiakastiedot. Tarvittaessa voidaan laajentaa lisäkentillä.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Asiakkaan ID** | `customer_id` | PK / int | Asiakkaan yksilöivä avain. |
| **Asiakasnumero** | `customer_number` | char | Asiakasnumero ERP-järjestelmässä, esimerkiksi Y-tunnus. |
| **Asiakkaan nimi** | `customer_name` | char | Asiakkaan nimi. |
| **Sijainti** | `location` | char | Asiakkaan sijainti, kuten vaikka osoite. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_customer (
    customer_id bigint NOT NULL,
    customer_number text,
    customer_name text,
    location text
);
```

---

### Nimiketaulu (dim_article)

**Taulun kuvaus:** Nimike- tai tuotetiedot ERP-järjestelmästä.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Nimike ID** | `article_id` | PK / int | Nimikkeen yksilöivä avain. |
| **Nimikekoodi** | `article_code` | char | ERP-järjestelmässä käytettävä yksilöllinen nimiketunnus. |
| **Nimikkeen nimi** | `article_name` | char | Nimikkeen nimi. |
| **Nimikkeen muu nimi** | `article_name_other` | char | Vaihtoehtoinen nimi, jos saatavilla. |
| **Nimikkeen kuvaus** | `article_description` | char | Nimikkeen kuvaus. |
| **Nimikeryhmä** | `article_group` | char | Nimikeryhmä. |
| **Revisio** | `revision` | char | Nimikkeen revisio. Samalla nimikekoodilla voi olla useita revisioita, jolloin ne voivat olla erillisinä riveinä. |
| **Lisätiedot** | `notes` | char | Tähän nimikeversioon liittyvät lisätiedot. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
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
```

---

### Työkeskustaulu (dim_workcenter)

**Taulun kuvaus:** Työpisteen/työkeskuksen/tuotantoyksikön/kuormitusryhmän tarkemmat tiedot. Alihankinta, kokoonpano, laadunvarmistus ja työstökoneet menevät samaan.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Työkeskus ID** | `workcenter_id` | PK / int | Työkeskuksen yksilöivä tunniste. |
| **Työkeskuksen nimi** | `workcenter_name` | char | Työkeskuksen nimi. |
| **Työkeskuksen kuvaus** | `workcenter_description` | char | Esimerkiksi koneen valmistaja tai jotain muuta lisätietoa. |
| **Työkeskuksen tyyppi** | `workcenter_type` | char | Työkeskuksen tyyppi. Voidaan käyttää suodatuksessa. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_workcenter (
    workcenter_id bigint NOT NULL,
    workcenter_name text,
    workcenter_description text,
    workcenter_type text
);
```

---

### Työkeskusryhmätaulu (dim_workcenter_group)

**Taulun kuvaus:** Työkeskuksen tai tuotantoyksikön tyypit. Voidaan käyttää tarpeen mukaan, mutta ei välttämätön taulu.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Työkeskusryhmä ID** | `workcenter_group_id` | PK / int | Työkeskusryhmän yksilöivä avain. |
| **Työkeskusryhmän nimi** | `workcenter_group_name` | char | Työkeskusryhmän nimi. |
| **Työkeskusryhmän kuvaus** | `workcenter_group_description` | char | Kuvaus työkeskuksen tyypistä. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_workcenter_group (
    workcenter_group_id bigint NOT NULL,
    workcenter_group_name text,
    workcenter_group_description text
);
```

---

### Käyttäjätaulu (dim_user)

**Taulun kuvaus:** Käyttäjätiedot ERP-järjestelmästä.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Käyttäjä ID** | `user_id` | PK / int | Käyttäjän yksilöivä avain |
| **Käyttäjän nimi** | `user_name` | char | Käyttäjän nimi tai muu tunniste. |
| **Käyttäjän rooli** | `user_role` | char | Käyttäjän rooli organisaatiossa. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_user (
    user_id bigint NOT NULL,
    user_name text,
    user_role text
);
```

---

### Tilauksen tilan hakutaulu (dim_order_state)

**Taulun kuvaus:** Tilausten tilojen hakutaulu. Tiedot voivat olla yrityksen raportointitarpeiden mukaan.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Tilauksen tilan ID** | `order_state_id` | PK / int | Tilauksen tilan yksilöivä avain. |
| **Tilauksen tilan nimi** | `order_state_name` | char | Tilauksen tila. Esimerkkejä: vastaanotettu, käsittelyssä, valmis tai peruttu. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_order_state (
    order_state_id bigint NOT NULL,
    order_state_name text
);
```

---

### Konetapahtumatyypin hakutaulu (dim_event_type)

**Taulun kuvaus:** Valmiiksi määritetty konetapahtumatyyppien hakutaulu. Tapahtumia voi lisätä tarpeen mukaan.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Tapahtumatyyppi ID** | `event_type_id` | PK / int | Tapahtumatyypin yksilöivä avain. |
| **Tapahtumatyypin nimi englanniksi** | `event_type_name_eng` | char | Tapahtumatyypin englanninkielinen nimi analysointia ja suodatusta varten. |
| **Tapahtumatyypin nimi suomeksi** | `event_type_name_fin` | char | Tapahtumatyypin suomenkielinen nimi analysointia ja suodatusta varten. |
| **Tapahtuman kuvaus** | `event_description` | char | Kuvaus tapahtumasta tai poikkeamasta. |

**Taulun sisältö:**

| event_type_id | event_type_name_eng | event_type_name_fin | event_description |
| :--- | :--- | :--- | :--- |
| 1 | STAMPING PHASE | Vaiheleimaus | Työvaiheleimaus sisältäen sekä asetusajan että työstöajan. Leimaus voi alkaa esim. työn asetusvaiheen alussa ja päättyä työn loppuessa. |
| 2 | STAMPING SETUP | Asetustyöleimaus | Asetustyön leimaus. |
| 3 | STAMPING PRODUCTION | Tuotantovaiheleimaus | Työvaiheen varsinaisen työn leimaus. Leimaus alkaa kappaleiden työstön alkaessa ja päättyy työstön loppuessa. |
| 4 | STAMPING EXCEPTION | Poikkeamaleimaus | Poikkeaman leimaus, jos esim. kerätään käyttäjältä tietoa koneen pitkien pysähdysten syistä. |
| 5 | MAINTENANCE | Ylläpito | Koneen huolto erillisenä rivinä. Tyypillisesti esim. leimausdatan pohjalta. |
| 6 | MACHINE PHASE | Konedata työvaihe | Koko työvaihe johdettuna konedatasta. Voidaan tehdä esim. ohjelmanimen perusteella aikaa rajaamalla tai ottamalla alku- ja päätepisteet leimausdatasta. |
| 7 | MACHINE SETUP | Konedata asetustyö | Asetustyö laskettuna konedatan perusteella. Voidaan laskea esim. aika ohjelman latauksesta ensimmäisen kappaleen työstöön tai ottaa asetusajan alku edellisen työn loppumisesta tai leimauksesta. |
| 8 | MACHINE PRODUCTION | Konedata tuotanto | Työn työstövaiheen koonti alkaen ensimmäisen kappaleen työstön alusta viimeisen kappaleen työstön päättymiseen. Tyypillisesti sisältää useita kappaleita vaihtoineen. |
| 9 | MACHINE SINGLE PART | Konedata yksi kappale | Yksittäisen kappaleen työstötapahtuma. Alkaa kappaleen työstön alkaessa ja päättyy työstön loppumiseen. |
| 10 | MACHINE PART CHANGE | Konedata vaihtotyö | Kahden samanlaisen kappaleen työstön välissä oleva aika, jonka aikana mm. irrotetaan edellinen ja kiinnitetään uusi. |
| 11 | MACHINE CUTTING | Konedata työstö | Yksittäinen työstötapahtuma, jota ei ole yhdistetty kappaleeseen tai työhön. Tyypillisesti anturidatasta. |
| 12 | MACHINE MANUAL | Konedata käsiajo | Käsiajotapahtuma, jos halutaan ne erottaa erilliseksi riveiksi. Voi olla myös esim. osana asetustyötä. |
| 13 | MACHINE MEASUREMENT | Konedata mittaus | Koneen mittaustapahtuma. Voi jatkossa olla liityntää mittausdatan tauluun, jos tietomallia laajennetaan. |
| 14 | MACHINE IDLE | Konedata tyhjäkäynti | Kone on päällä, mutta ei aktiivisessa työstössä. Tätä voidaan käyttää kaikkien "ei-aktiivisten" aikojen tallentamiseen tai vaihtoehtoisesti osan riveistä voi laittaa MACHINE SETUP tai MACHINE PART CHANGE tyyppien alle. |
| 15 | MACHINE EXCEPTION | Konedata poikkeama | Koneella on häiriötila tai muu poikkeama päällä. |
| 16 | POWER OFF | Kone sammutettu | Kone on poissa päältä. |
| 17 | MACHINE DAY | Konedata päivä | Yhden päivän koontirivi konedatasta. Ajat on pilkottu samalle riville eri kenttiin. |
| 18 | USER PRESENT | Käyttäjä läsnä | Käyttäjä on koneen ääressä tekemässä työtä. Tieto voi olla jostain leimausjärjestelmästä tai antureilla tunnistettu. |
| 19 | PLANNED PRODUCTION TIME | Suunniteltu tuotantoaika | Vuorokausikohtainen suunniteltu koneen tuotantoaika. Sisältää alku- ja loppuajan sekä keston. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_event_type (
    event_type_id bigint NOT NULL,
    event_type_name_eng text,
    event_type_name_fin text,
    event_description text
);
```

---

### Tietolähteen hakutaulu (dim_source)

**Taulun kuvaus:** Konetapahtumien tietolähteiden hakutaulu. Auttaa mm. erottamaan leimausdatoja ja konedatoja toisistaan.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Tapahtumalähde ID** | `source_id` | PK / int | Tietolähteen yksilöivä avain. |
| **Lähteen nimi** | `source_name` | char | Konetapahtuman tietolähteen nimi. Esimerkkejä: leimausdata, koneen rajapinta tai anturidata. |
| **Lähteen kuvaus** | `source_description` | char | Kuvaus tietolähteestä. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_source (
    source_id integer NOT NULL,
    source_name text,
    source_description text
);
```

---

### Poikkeamataulu (dim_exception)

**Taulun kuvaus:** Poikkeamien tiedot.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Poikkeama ID** | `exception_id` | PK / int | Poikkeaman yksilöivä avain. |
| **Poikkeamatyyppi** | `exception_type` | char | Poikkeaman tyyppi. |
| **Poikkeaman kuvaus** | `exception_description` | char | Kuvaus tapahtumasta tai poikkeamasta. |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
CREATE TABLE public.dim_exception (
    exception_id bigint NOT NULL,
    exception_type text,
    exception_description text
);
```

---

### Päivämäärätaulu (dim_date)

**Taulun kuvaus:** Päivämääräulottuvuus ajallista suodatusta varten.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Päivämäärä ID** | `date_id` | PK / int | Päivämäärän semanttinen avain muodossa YYYYMMDD. |
| **Päivämääräindeksi** | `date_index` | int | Juokseva numeroarvo päivämäärille. |
| **Päivämäärä** | `date_fin` | char | Päivämäärä suomalaisittain kirjoitettuna. Esim. "31.03.2026" |
| **Päivämäärä ISO-muodossa** | `date_iso` | date | Päivämäärä ISO-formaatissa. Esim. "2026-03-31" |
| **Viikonpäivän numero** | `day_of_week` | int | Viikonpäivän järjestysnumero. Esim. maanantai == 1, sunnuntai == 7 |
| **Viikonpäivän nimi suomeksi** | `weekday_name_fin` | char | Viikonpäivän nimi suomeksi. Esim. "Maanantai" |
| **Viikonpäivän lyhenne suomeksi** | `weekday_name_short_fin` | char | Viikonpäivän lyhenne suomeksi. Esim. "ma" |
| **Viikonpäivän nimi englanniksi** | `weekday_name_eng` | char | Viikonpäivän nimi englanniksi. Esim. "Monday" |
| **Viikonpäivän lyhenne englanniksi** | `weekday_name_short_eng` | char | Viikonpäivän lyhenne englanniksi. Esim. "Mon" |
| **Päivä** | `day` | int | Kuukauden päivän numero. Esim. 31 |
| **Viikko** | `week` | int | Viikkonumero. Vuoden viikon numero. Esim. 20 |
| **Kuukausi** | `month` | int | Kuukauden numero. Esim. 6 |
| **Kvartaali** | `quarter` | int | Vuosineljännes, arvo 1-4. |
| **Vuosi** | `year` | int | Vuosi nelinumeroisena. Esim. 2026 |
| **Vuoden päivä** | `year_day` | int | Vuoden päivän järjestysnumero. Esim. "31.3.2026" on vuoden 90 päivä. |
| **Kvartaalin päivä** | `quarter_day` | int | Kvartaalin päivän järjestysnumero laskettuna kvartaalin alusta. |
| **Vuosi ja viikko** | `year_week` | char | Vuosi ja viikko yhdistettynä. Esim. "2026W20" tai "2026-20" |
| **Vuosi ja kuukausi** | `year_month` | char | Vuosi ja kuukausi yhdistettyna. Esim. "2026M06" tai "2026-06" |
| **Vuosi ja kvartaali** | `year_quarter` | char | Vuosi ja kvartaali yhdistettynä. Esim. "2026Q1" |
| **Kuukauden lyhenne suomeksi** | `month_name_short_fin` | char | Kuukauden lyhenne suomeksi. Esim. "maalis" |
| **Kuukauden nimi suomeksi** | `month_name_fin` | char | Kuukauden nimi suomeksi. Esim. "Maaliskuu" |
| **Kuukauden lyhenne englanniksi** | `month_name_short_eng` | char | Kuukauden lyhenne englanniksi. Esim. "Mar" |
| **Kuukauden nimi englanniksi** | `month_name_eng` | char | Kuukauden nimi englanniksi. Esim. "March" |
| **On viikonloppu** | `is_weekend` | boolean | Tieto siitä, osuuko päivä viikonlopulle. |
| **On työpäivä** | `is_workday` | boolean | Tieto siitä, onko kyseessä suomalaisen kalenterin mukainen työpäivä. |


#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
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
```

---

### Aikataulu (dim_time)

**Taulun kuvaus:** Aikaulottuvuus suodatuksia ja ajallista analysointia varten.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Aika ID** | `time_id` | PK / int | Ajan semanttinen avain muodossa HHMMSS. Esim. 101531. Arvoja 86 400 kpl ja arvot välillä 0-235959 |
| **Kellonaika sekunnit** | `time_hms` | char | Aika luettavassa merkkijonomuodossa. Esim. "10:15:31" |
| **Kellonaika minuutit** | `time_hm` | char | Aika ilman sekunteja. Esim. "10:15" |
| **Tunti** | `hour` | int | Ajan tuntiosa. |
| **Minuutti** | `minute` | int | Ajan minuuttiosa. |
| **Sekunti** | `second` | int | Ajan sekuntiosa. |
| **Vuorokaudenaika** | `time_of_day_str` | char | Vuorokauden osan nimi, esimerkiksi "Aamu". |
| **Vuorokaudenajan aikaväli** | `time_of_day_range` | char | Vuorokaudenosan aikaväli. Esim. "06-11". |
| **Vuorokaudenajan ID** | `time_of_day_id` | int | Vuorokaudenajan tunniste lajittelua ja ryhmittelyä varten. Esim. viiteen osaan jaetussa vuorokaudessa. 0=aamuyö, 1=aamu, 2=päivä, 3=iltapäivä, 4=ilta. |
| **Vuoro** | `shift` | char | Työvuoron nimi, jos käytössä on vuorotyö. Esim. aamuvuoro=1, iltavuoro=2, yövuoro=3 |
| **Vuoro ID** | `shift_id` | int | Työvuoron tunniste, jos käytössä on vuorotyö. Esim. aamuvuoro=1, iltavuoro=2, yövuoro=3 |

#### Taulun luontilause

Alla on esimerkkinä taulun luontilause, joka toimii vaikka PostgreSQL tietokannan kanssa. Lause sisältää vain sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa `db_create.sql`.

```sql
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
```
