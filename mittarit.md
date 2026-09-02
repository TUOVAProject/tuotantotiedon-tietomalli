# Tuotantotiedon mittarit

**Tietomallin versio:** 1.0

**Viimeksi päivitetty:** 2026-09-02

Tässä tiedostossa on koottuna TUOVA-hankkeessa kehitetystä tuotantotiedon tietomallista johdettavissa olevat tunnusluvut sekä mittarit.

---

## Laskennan yleiset periaatteet

Alla olevat periaatteet tulee huomioida mittareiden laskennassa.

**Huom!** Tässä kuvataan, mitä mittareita tietomallin kentistä voidaan laskea. Varsinainen käyttöönotto edellyttää yrityskohtaisten laskentasääntöjen sopimista, esimerkiksi mitä lasketaan suunnitelluksi tuotantoajaksi, miten asetukset luokitellaan, miten uudelleentyö erotetaan hylkäyksestä ja miten yleiskustannukset kohdistetaan.

**1. Päivämäärien erotukset lasketaan `dim_date`-taulun kautta.** Faktataulujen päivämääräkentät ovat semanttisia avaimia muodossa `YYYYMMDD`, joten niiden suora vähennyslasku antaa väärän tuloksen kuukauden vaihtuessa. Käytä joko `date_index`-kenttien erotusta tai `date_iso`-kenttiä:

```text
Kalenteripäivien erotus = dim_date[loppu].date_index − dim_date[alku].date_index
Työpäivien erotus       = COUNT(dim_date WHERE is_workday = TRUE AND date_index välillä)
```

**2. Konetapahtumataulun rivit on aina suodatettava `event_type_id`- ja `source_id`-kentillä.** Sama työvaihe voi olla taulussa useaan kertaan eri tarkkuustasoilla (vaiheleimaus, konedatan vaihekoonti, yksittäiset kappaleet, päiväkoonti). Ilman suodatusta ajat ja kappalemäärät kaksinkertaistuvat. Vakiintuneet suodatinjoukot kannattaa määritellä kerran ja käyttää niitä kaikissa mittareissa:

```text
Leimausperusteinen toteuma  : source_id = 1 (STAMPING)
Konedataperusteinen toteuma : source_id IN (2, 3) (MACHINE API, SENSOR)
Vaihetason koonnit          : event_type_id IN (1, 6)
Päivätason koonnit          : event_type_id = 17
Suunniteltu tuotantoaika    : event_type_id = 19
Poikkeamat                  : event_type_id IN (4, 15)
```

**3. Toteuma-arvoista on aina kaksi rinnakkaista versiota.** Tietomallissa on erikseen leimauspohjaiset (`*_stamping_*`) ja konedatapohjaiset (`*_machine_*`) toteumat. Mittarin määritelmässä on kerrottava kumpaa käytetään. Kaavoissa alla käytetään merkintää `*_actual_*`, joka tarkoittaa yrityksen valitsemaa ensisijaista lähdettä.

**4. Aikayksikkö on minuutti.** Kaikki `_min`-päätteiset kentät ovat minuutteja; tunneiksi jaetaan luvulla 60.

**5. Yleiskustannusten kohtelu on päätettävä.** Tietomalli tarjoaa kolme kustannustasoa: `prime_cost_*_sum` (välittömät), `manufacturing_cost_*` (omakustannus, sisältää yleiskustannukset) ja `profit_*` (voitto). Katemittarissa on kerrottava, mistä tasosta kate lasketaan.

**6. Tarkastelutason valinta.** Useimmat mittarit voidaan laskea esimerkiksi tilausrivi-, työ-, työvaihe-, työkeskus-, työkeskusryhmä-, nimike-, asiakas-, käyttäjä-, päivä-, viikko-, kuukausi- tai vuorotasolla.

**7. Prosenttiosuudet lasketaan summista.** Osoittaja ja nimittäjä summataan ensin koko tarkastelujoukolle ja jaetaan vasta sitten. Rivikohtaisten prosenttien keskiarvo antaa eri ja yleensä väärän tuloksen. Jos nimittäjä on nolla tai tyhjä, mittari jätetään tyhjäksi eikä aseteta nollaksi.

**8. Mittarikuvausten "Tila"-kenttä.** Jokaisella mittarilla on tila, joka kertoo mitä mittarin laskenta edellyttää:

```text
Laskettavissa suoraan          : mittari saadaan tietomallin kentistä sellaisenaan
Edellyttää yrityskohtaista
määrittelyä                    : kentät ovat olemassa, mutta laskenta vaatii yrityksen
                                 päättämän parametrin, rajauksen tai luokittelun
                                 (esim. tehollinen kapasiteetti, sähkön hinta,
                                 kiireellisyyden tunnistesääntö)
```

Tietomallin laajennusta vaativat mittarit (mittaustulokset ja prosessikyvykkyys, reklamaatiot ja palautukset, uudelleentyön ja romutuksen erottelu, materiaalihukka, huoltosuunnitelma) on jätetty tämän tiedoston ulkopuolelle. Ne on koottu lyhyesti kunkin osion loppuun.

---

## Mittareiden kuvauksia

Mittarit on numeroitu osioittain, jotta niihin voi viitata raporteista, raportointimallin mittareista ja tietomallin dokumentaatiosta. Jokaisesta mittarista kuvataan mitä se mittaa, laskentakaava sekä teknisillä että semanttisilla nimillä, mittayksikkö, tarkastelutaso, tietolähde, tila ja huomiot.

### Aikavertailujen mittarit

Aikavertailujen mittarit vertaavat toteutuneita päivämääriä ja kestoja suunniteltuihin. Ne muodostavat toimituskyvyn ja tuotannonsuunnittelun osuvuuden perusmittariston. Tietolähteenä ovat `fact_order_rows` (tilaus- ja toimitustaso) ja `fact_workphases` (työvaihetaso).

#### 1.1 Tuotannon läpimenoaika

- **Mitä mittaa:** Kuinka kauan tilausrivin tuotanto kesti ensimmäisen työvaiheen aloituksesta viimeisen työvaiheen valmistumiseen.
- **Mittayksikkö:** vrk
- **Tarkastelutaso:** tilausrivi, työ, nimike, asiakas, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
dim_date[production_end_date_actual].date_index
  − dim_date[production_start_date_actual].date_index
```

**Laskentakaava (semanttiset nimet):**
```text
Päivämääräindeksi(Tuotannon toteutunut lopetus)
  − Päivämääräindeksi(Tuotannon toteutunut aloitus)
```

**Huomiot ja rajoitteet:**
- Sisältää kaiken tuotannossa kuluneen ajan, myös jonotuksen ja odotuksen työvaiheiden välillä.
- Työpäivinä laskettuna käytä `dim_date.is_workday = TRUE` -rivien lukumäärää välillä; kalenteripäivät ja työpäivät antavat eri tuloksen etenkin lomakausina.
- Keskeneräiset työt on rajattava pois: `production_end_date_actual IS NOT NULL`.

#### 1.2 Tuotannon läpimenoajan poikkeama

- **Mitä mittaa:** Kuinka paljon toteutunut tuotannon läpimenoaika poikkeaa suunnitellusta. Kertoo tuotannonsuunnittelun osuvuudesta.
- **Mittayksikkö:** vrk
- **Tarkastelutaso:** tilausrivi, nimike, asiakas, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(date_index(production_end_date_actual) − date_index(production_start_date_actual))
  − (date_index(production_end_date_planned) − date_index(production_start_date_planned))
```

**Laskentakaava (semanttiset nimet):**
```text
Toteutunut tuotannon läpimenoaika − Suunniteltu tuotannon läpimenoaika
```

**Huomiot ja rajoitteet:**
- Positiivinen arvo tarkoittaa suunniteltua pidempää läpimenoa.
- Mittari ei erottele, johtuuko poikkeama myöhäisestä aloituksesta vai hitaasta tuotannosta. Erottelu tehdään mittareilla 1.3 ja 1.4.
- Uusilla nimikkeillä (`new_article = TRUE`) poikkeama on tyypillisesti suurempi; ryhmittely tämän kentän mukaan selittää usein hajontaa.

#### 1.3 Tuotannon aloituspoikkeama

- **Mitä mittaa:** Kuinka monta päivää tuotannon todellinen aloitus poikkesi suunnitellusta aloituspäivästä.
- **Mittayksikkö:** vrk
- **Tarkastelutaso:** tilausrivi, työkeskus, viikko, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
date_index(production_start_date_actual) − date_index(production_start_date_planned)
```

**Laskentakaava (semanttiset nimet):**
```text
Päivämääräindeksi(Tuotannon toteutunut aloitus)
  − Päivämääräindeksi(Tuotannon suunniteltu aloitus)
```

**Huomiot ja rajoitteet:**
- Erottaa aloituksen myöhästymisen tuotannon hitaudesta, mikä on olennaista syytä etsittäessä.
- Negatiivinen arvo tarkoittaa suunniteltua aikaisempaa aloitusta. Kannattaa raportoida sekä keskiarvo että jakauma, koska etu- ja jälkijättöiset arvot kumoavat toisensa keskiarvossa.

#### 1.4 Tuotannon valmistumispoikkeama

- **Mitä mittaa:** Kuinka monta päivää tuotanto valmistui suunniteltua myöhemmin tai aikaisemmin.
- **Mittayksikkö:** vrk
- **Tarkastelutaso:** tilausrivi, työ, nimike, työkeskus, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
date_index(production_end_date_actual) − date_index(production_end_date_planned)
```

**Laskentakaava (semanttiset nimet):**
```text
Päivämääräindeksi(Tuotannon toteutunut lopetus)
  − Päivämääräindeksi(Tuotannon suunniteltu lopetus)
```

**Huomiot ja rajoitteet:**
- Tuotannon valmistumisvarmuus saadaan osuutena: `COUNT(poikkeama <= 0) / COUNT(valmistuneet) * 100`.
- Mittari kertoo tuotannon sisäisestä suorituskyvystä myös silloin, kun toimituspäivä on edelleen pidossa varastossa tai logistiikassa.

#### 1.5 Tilauksesta toimitukseen kulunut aika

- **Mitä mittaa:** Asiakkaan kokema kokonaisläpimenoaika tilauksen luonnista toimitukseen.
- **Mittayksikkö:** vrk
- **Tarkastelutaso:** tilausrivi, asiakas, nimike, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
date_index(delivery_date_actual) − date_index(order_created_date)
```

**Laskentakaava (semanttiset nimet):**
```text
Päivämääräindeksi(Toteutunut toimitus) − Päivämääräindeksi(Tilauksen luontipäivä)
```

**Huomiot ja rajoitteet:**
- Sisältää myyntikäsittelyn, tuotannon odotuksen, tuotannon ja logistiikan. Logistiikan osuus saadaan erikseen: `date_index(delivery_date_actual) − date_index(dispatch_date_actual)`.
- Vertailtavuus edellyttää samankaltaisia tuotteita tai ryhmittelyä nimikeryhmittäin.

#### 1.6 Toimituspoikkeama

- **Mitä mittaa:** Toteutuneen ja luvatun toimituspäivän eron päivinä.
- **Mittayksikkö:** vrk
- **Tarkastelutaso:** tilausrivi, asiakas, nimike, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
date_index(delivery_date_actual) − date_index(delivery_date_planned)
```

**Laskentakaava (semanttiset nimet):**
```text
Päivämääräindeksi(Toteutunut toimitus) − Päivämääräindeksi(Suunniteltu toimitus)
```

**Huomiot ja rajoitteet:**
- Positiivinen arvo tulkitaan yleensä myöhästymiseksi.
- Sama kaava toimii lähetykselle kentillä `dispatch_date_actual` ja `dispatch_date_planned`, jolloin tuotannon ja logistiikan osuudet erottuvat toisistaan.
- Keskiarvon rinnalla kannattaa seurata myöhästyneiden osuutta ja pahimpia poikkeamia, koska yksittäinen suuri myöhästyminen hukkuu keskiarvoon.

#### 1.7 Tilausten toimitusvarmuus

- **Mitä mittaa:** Kuinka suuri osa toimitetuista tilausriveistä toimitettiin viimeistään luvattuna päivänä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** asiakas, nimike, tilaustyyppi, myyjä, viikko, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`, ryhmittely `dim_customer`, `dim_article`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (ajoissa-toimituksen määritelmä)

**Laskentakaava (tekniset nimet):**
```text
COUNT(order_row_id WHERE delivery_date_actual <= delivery_date_planned)
  / COUNT(order_row_id WHERE delivery_date_actual IS NOT NULL) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Ajoissa toimitetut tilausrivit / Toimitetut tilausrivit * 100
```

**Huomiot ja rajoitteet:**
- On päätettävä, lasketaanko etuajassa toimitettu ajoissa toimitetuksi ja sallitaanko toleranssi (esim. yksi työpäivä).
- On päätettävä, verrataanko alkuperäiseen vai viimeisimpään luvattuun toimituspäivään. Tietomallissa tilausrivillä on vain yksi suunniteltu toimituspäivä, joten uudelleensovitut päivät eivät erotu; työvaihetasolla alkuperäinen ja viimeisin suunnitelma sen sijaan säilyvät.
- Vastaava lähetysvarmuus lasketaan kentillä `dispatch_date_*`.

#### 1.8 OTIF, ajallaan ja täysimääräisenä toimitetut

- **Mitä mittaa:** Kuinka suuri osa toimituksista oli sekä ajallaan että täysimääräisiä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** asiakas, nimike, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(order_row_id WHERE delivery_date_actual <= delivery_date_planned
                     AND delivered_qty >= ordered_qty)
  / COUNT(order_row_id WHERE delivery_date_actual IS NOT NULL) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Ajallaan ja täysimääräisenä toimitetut tilausrivit / Toimitetut tilausrivit * 100
```

**Huomiot ja rajoitteet:**
- Edellyttää, että `delivered_qty` täytetään. Jos kenttä jätetään tyhjäksi, mittari palautuu toimitusvarmuudeksi (1.7).
- Tietomallissa on yksi rivi tilausriviä kohti, joten osatoimitukset eivät erotu omiksi tapahtumikseen. Osatoimitetun rivin täysimääräisyys näkyy vasta viimeisen toimituserän jälkeen.
- Jos ylitoimitus on mahdollinen, ehto kannattaa määritellä muotoon `delivered_qty >= ordered_qty` eikä tasan yhtä suureksi.

#### 1.9 Työvaiheen toteutunut kesto

- **Mitä mittaa:** Kuinka kauan yksittäinen työvaihe kesti aloituksesta valmistumiseen kalenteriaikana.
- **Mittayksikkö:** min tai h
- **Tarkastelutaso:** työvaihe, työkeskus, työkeskusryhmä, nimike, käyttäjä
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
end_timestamp_actual − start_timestamp_actual
```

**Laskentakaava (semanttiset nimet):**
```text
Lopetus aikaleima toteutunut − Aloitus aikaleima toteutunut
```

**Huomiot ja rajoitteet:**
- Ero vaiheaikaan (`phase_duration_*_min`) on olennainen: kesto sisältää tauot ja keskeytykset, vaiheaika vain tehdyn työn. Näiden suhde kertoo, kuinka pirstoutunutta työ on.
- Jos aikaleimat puuttuvat, karkeampi arvio saadaan päiväavaimista `end_date_actual` ja `start_date_actual`.
- Alihankintavaiheiden läpimenoaika saadaan rajaamalla `subcontracting_phase = TRUE`, jolloin alihankkijoita voi vertailla `workcenter_id`:n avulla.

#### 1.10 Vaiheajan poikkeama

- **Mitä mittaa:** Kuinka paljon työvaiheeseen todella kulunut työaika poikkeaa suunnitellusta. Yksi käytännöllisimmistä suunnitelma vastaan toteuma -mittareista.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työvaihe, työkeskus, työkeskusryhmä, nimike, käyttäjä, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(SUM(phase_duration_actual_min) − SUM(phase_duration_planned_min))
  / SUM(phase_duration_planned_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
(Vaiheaika leimattu − Vaiheaika suunniteltu) / Vaiheaika suunniteltu * 100
```

**Huomiot ja rajoitteet:**
- Valitse toteumalähde johdonmukaisesti: `phase_duration_stamping_min` tai `phase_duration_machine_min`. Lähteiden ero on itsessään datan laadun mittari (6.3).
- Laske vain riveille, joilla suunniteltu aika on suurempi kuin nolla.
- Erittely asetusaikaan ja tuotantoaikaan tehdään samalla kaavalla kentillä `setup_time_*` (1.11) ja `production_time_*`.

#### 1.11 Asetusajan poikkeama

- **Mitä mittaa:** Kuinka paljon toteutunut asetustyö poikkeaa suunnitellusta asetusajasta.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, nimike, nimikeryhmä, käyttäjä, vuoro
- **Tietolähde:** `fact_workphases`, tarkempi toteuma `fact_machine_events` (`event_type_id = 7`)
- **Tila:** Edellyttää yrityskohtaista määrittelyä (asetusajan sisältö)

**Laskentakaava (tekniset nimet):**
```text
(SUM(setup_time_actual_min) − SUM(setup_time_planned_min))
  / SUM(setup_time_planned_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
(Asetusaika leimattu − Asetusaika suunniteltu) / Asetusaika suunniteltu * 100
```

**Huomiot ja rajoitteet:**
- On sovittava, mitä asetusaikaan lasketaan: työkalujen haku, ohjelman lataus, koeajo ja ensimmäisen kappaleen tarkastus voidaan kirjata joko asetukseen tai tuotantoon.
- Konedatasta johdettu asetusaika on yleensä tarkempi kuin leimattu, koska leimaus tehdään usein jälkikäteen pyöristettynä.
- Käyttäjäkohtaisessa tarkastelussa tulokset on käsiteltävä ryhmätasolla, ei yksittäisen henkilön arviointiin.

#### 1.12 Työvaiheiden aikataulupitävyys

- **Mitä mittaa:** Kuinka suuri osa valmistuneista työvaiheista valmistui viimeistään suunniteltuna päivänä. Paikantaa tuotannon sisäisen virtauksen häiriöt.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, vaihenumero, nimike, viikko
- **Tietolähde:** `fact_workphases` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(workphase_id WHERE end_date_actual <= end_date_latest_planned)
  / COUNT(workphase_id WHERE end_date_actual IS NOT NULL) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Ajoissa valmistuneet työvaiheet / Valmistuneet työvaiheet * 100
```

**Huomiot ja rajoitteet:**
- Vertailu viimeisimpään suunnitelmaan (`end_date_latest_planned`) mittaa toteutusta, vertailu alkuperäiseen (`end_date_original_planned`) mittaa suunnitelman pitävyyttä. Molemmat kannattaa laskea, koska pelkkä jälkimmäinen suunnitelma voi kaunistaa tuloksen.
- Työkeskuskohtainen tarkastelu paljastaa pullonkaulat nopeammin kuin tilaustason toimitusvarmuus.

#### 1.13 Uudelleenaikataulutettujen työvaiheiden osuus

- **Mitä mittaa:** Kuinka usein tuotantosuunnitelmaa on jouduttu muuttamaan alkuperäisen suunnittelun jälkeen.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, viikko, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(workphase_id WHERE start_date_original_planned <> start_date_latest_planned
                      OR end_date_original_planned <> end_date_latest_planned)
  / COUNT(workphase_id) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Siirretyt työvaiheet / Suunnitellut työvaiheet * 100
```

**Huomiot ja rajoitteet:**
- Tietomalli tallentaa erikseen alkuperäisen ja viimeisimmän suunnitelman, mikä tekee mittarista suoraan laskettavan.
- Siirtymän suuruus saadaan erikseen: `date_index(end_date_latest_planned) − date_index(end_date_original_planned)`.
- Korkea arvo ei aina ole huono: se voi kertoa myös aktiivisesta hienokuormituksesta. Mittaria tulkitaan yhdessä aikataulupitävyyden (1.12) kanssa.

#### 1.14 Odotusaika työvaiheiden välillä

- **Mitä mittaa:** Kuinka kauan työ seisoi kahden peräkkäisen työvaiheen välissä. Paljastaa jonot ja siirrot, jotka eivät näy vaiheaikojen summassa.
- **Mittayksikkö:** h
- **Tarkastelutaso:** työ, työvaihepari, työkeskus, työkeskusryhmä
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
start_timestamp_actual(phase_number = n+1) − end_timestamp_actual(phase_number = n)
  saman work_id:n sisällä
```

**Laskentakaava (semanttiset nimet):**
```text
Aloitus aikaleima toteutunut (seuraava vaihe)
  − Lopetus aikaleima toteutunut (edellinen vaihe)
```

**Huomiot ja rajoitteet:**
- Edellyttää, että vaiheet voidaan järjestää `phase_number`-kentän mukaan ja että aikaleimat on täytetty.
- Vaiheiden osittainen limittyminen tuottaa negatiivisia arvoja; ne kannattaa käsitellä erikseen eikä suodattaa pois, koska ne kertovat rinnakkaisesta tekemisestä.
- Odotusajan summa suhteessa läpimenoaikaan (1.1) antaa arvion arvoa lisäämättömästä ajasta.

**Tietomallin laajennusta vaativat aikamittarit:** kiiretilausten osuus ja kiirekuorman osuus edellyttävät kiireellisyys- tai prioriteettikenttää. Ne ovat johdettavissa vain, jos yritys koodaa kiireellisyyden `order_type`-kenttään.

### OEE ja sen osat

OEE eli kokonaistehokkuus kuvaa, kuinka suuri osa suunnitellusta tuotantoajasta käytetään hyväksyttyjen kappaleiden valmistamiseen tavoitenopeudella. Tietolähteenä on `fact_machine_events`, ihannesykliaika `fact_workphases`-taulusta.

Määritellään ensin OEE:n perussuureet, joita alla olevat mittarit käyttävät:

```text
Suunniteltu tuotantoaika (min) = SUM(duration_min) WHERE event_type_id = 19
Käyntiaika (min)               = SUM(machine_active_min) WHERE event_type_id IN (6, 8, 17)
Seisokkiaika (min)             = SUM(idle_sum_min + exception_min + power_off_min)
Valmistettu määrä (kpl)        = SUM(produced_qty_machine) tai SUM(produced_qty_stamping)
Hyväksytty määrä (kpl)         = Valmistettu määrä − SUM(rejected_qty_stamping)
```

#### 2.1 Suunniteltu tuotantoaika

- **Mitä mittaa:** Ajan, jonka kone oli tarkoitus olla tuotannossa. OEE:n ja seisokkimittareiden vertailuaika.
- **Mittayksikkö:** min tai h
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, vuoro, päivä, viikko
- **Tietolähde:** `fact_machine_events` (`event_type_id = 19`) + `dim_date`, `dim_time`
- **Tila:** Edellyttää yrityskohtaista määrittelyä

**Laskentakaava (tekniset nimet):**
```text
SUM(duration_min) WHERE event_type_id = 19
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Kesto min) rajattuna tapahtumatyyppiin Suunniteltu tuotantoaika
```

**Huomiot ja rajoitteet:**
- Edellyttää, että tapahtumatyypin 19 rivejä tuotetaan vuorokausikohtaisesti koneittain. Ilman niitä koko OEE-mittaristo jää laskematta määritelmän mukaisesti.
- Vaihtoehtoisesti aika voidaan johtaa työvuorokalenterista yhdistämällä `dim_date.is_workday` ja `dim_time.shift_id`, mutta silloin suunnitellut seisokit (huollot, koulutukset, lomautukset) eivät vähene automaattisesti.
- On päätettävä, sisältyvätkö suunnitellut huollot ja tauot suunniteltuun tuotantoaikaan. Päätös vaikuttaa suoraan käytettävyyteen ja siten koko OEE:hen.

#### 2.2 Käyntiaika

- **Mitä mittaa:** Ajan, jonka kone oli aktiivisessa työstössä.
- **Mittayksikkö:** min tai h
- **Tarkastelutaso:** työkeskus, kone, vuoro, päivä
- **Tietolähde:** `fact_machine_events`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (käyntiajan rajaus)

**Laskentakaava (tekniset nimet):**
```text
SUM(machine_active_min) WHERE event_type_id IN (6, 8, 17)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Työstöaika min) vaihe- tai päiväkoonneilta
```

**Huomiot ja rajoitteet:**
- Rajaus tapahtumatyyppeihin on tehtävä kerran ja käytettävä samana kaikissa OEE-osissa, muuten osatekijät eivät ole keskenään vertailukelpoisia.
- Vaihtoehtoinen laskentatapa on `Suunniteltu tuotantoaika − Seisokkiaika`; tulokset eroavat, jos aikojen kohdistus ei ole täydellinen. Ero näkyy mittarissa 6.1.
- Ilman suodatusta sama työ lasketaan useaan kertaan, koska konetapahtumataulussa on eri tarkkuustason rivejä.

#### 2.3 Seisokkiaika ja seisokkiaste

- **Mitä mittaa:** Ajan, jonka kone ei ollut tuotannossa suunnitellun tuotantoajan sisällä, sekä sen osuuden suunnitellusta ajasta.
- **Mittayksikkö:** min tai h; osuus %
- **Tarkastelutaso:** työkeskus, kone, vuoro, päivä, viikko
- **Tietolähde:** `fact_machine_events`, syyerittely `dim_exception`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (seisokkiluokittelu)

**Laskentakaava (tekniset nimet):**
```text
Seisokkiaika  = SUM(idle_sum_min + exception_min + power_off_min)
Seisokkiaste  = Seisokkiaika / Suunniteltu tuotantoaika * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Seisokkiaika = SUMMA(Odotusaika min + Poikkeama min + Sammutettu min)
Seisokkiaste = Seisokkiaika / Suunniteltu tuotantoaika * 100
```

**Huomiot ja rajoitteet:**
- Kaikkia tyhjäkäynti- tai sammutusaikoja ei välttämättä lueta OEE-seisokiksi; luokittelu on sovittava.
- Erittely tehdään suoraan omista kentistään: `setup_time_min`, `part_change_time_min`, `undefined_idle_min`, `exception_min`, `power_off_min`.
- Häiriösyiden Pareto-analyysi saadaan liittämällä `exception_id` tauluun `dim_exception`.

#### 2.4 Käytettävyys

- **Mitä mittaa:** Kuinka suuren osan suunnitellusta tuotantoajasta kone oli käynnissä. OEE:n ensimmäinen osatekijä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, kone, työkeskusryhmä, vuoro, päivä, viikko
- **Tietolähde:** `fact_machine_events` + `dim_workcenter`, `dim_date`, `dim_time`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (perustuu mittareihin 2.1 ja 2.2)

**Laskentakaava (tekniset nimet):**
```text
Käyntiaika / Suunniteltu tuotantoaika * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Käyntiaika / Suunniteltu tuotantoaika * 100
```

**Huomiot ja rajoitteet:**
- Käytettävyys ja koneen käyttöaste (2.9) eivät ole sama asia: käytettävyydessä vertailuaika on suunniteltu tuotantoaika, käyttöasteessa kalenteriaika.
- Yli 100 %:n arvot ovat merkki siitä, että käyntiaikaa on kirjattu suunnitellun tuotantoajan ulkopuolelta, esimerkiksi miehittämättömästä yöajosta. Tämä on määrittelykysymys, ei virhe.

#### 2.5 Nopeus

- **Mitä mittaa:** Toteutuneen tuotantonopeuden suhteen tavoitenopeuteen. Paljastaa hitaat syklit, pienpysähdykset ja alennetun työstönopeuden. OEE:n toinen osatekijä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, nimike, ohjelma, vuoro
- **Tietolähde:** `fact_machine_events` + `fact_workphases` (`cycle_time_ideal_min`)
- **Tila:** Edellyttää yrityskohtaista määrittelyä (ihannesykliajan asettaminen)

**Laskentakaava (tekniset nimet):**
```text
SUM(cycle_time_ideal_min * Valmistettu määrä) / Käyntiaika * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Kappale jaksoaika tavoite * Valmistettu määrä) / Käyntiaika * 100
```

**Huomiot ja rajoitteet:**
- Valmistettuun määrään lasketaan myös hylätyt kappaleet, koska ne ovat vieneet koneaikaa. Hylkyjen vaikutus tulee mukaan vasta laatukertoimessa.
- Ihannesykliaika (`cycle_time_ideal_min`) on täytettävä nimikkeittäin. Jos se puuttuu, `cycle_time_planned_min` antaa tavoitepohjaisen mutta ei OEE-määritelmän mukaisen arvon.
- Kentän kattavuutta kannattaa seurata mittarilla 6.8, koska puuttuvat ihannesykliajat vääristävät nopeutta ja siten koko OEE:tä.

#### 2.6 Laatukerroin

- **Mitä mittaa:** Hyväksyttyjen kappaleiden osuuden kaikista valmistetuista. OEE:n kolmas osatekijä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, nimike, työvaihe, vuoro, käyttäjä
- **Tietolähde:** `fact_machine_events`, työvaihetasolla `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(SUM(produced_qty_machine) − SUM(rejected_qty_stamping))
  / SUM(produced_qty_machine) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
(Tuotettu määrä konedata − Hylätty määrä kpl) / Tuotettu määrä konedata * 100
```

**Huomiot ja rajoitteet:**
- Tietomalli ei erottele korjattuja kappaleita hyväksytyistä, joten arvo on lievästi optimistinen suhteessa OEE:n suositeltuun määritelmään, jossa hyväksytty on ensimmäisellä kerralla onnistunut kappale.
- Jos tuotantomäärä ja hylkäysmäärä tulevat eri lähteestä (konedata ja leimaus), niiden rajausten on vastattava toisiaan. Muuten kerroin vääristyy.

#### 2.7 OEE, kokonaistehokkuus

- **Mitä mittaa:** Käytettävyyden, nopeuden ja laadun yhteisvaikutuksen yhtenä lukuna.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, työkeskusryhmä, nimike, vuoro, päivä, viikko
- **Tietolähde:** `fact_machine_events` + `fact_workphases` + `dim_workcenter`, `dim_time`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (perustuu mittareihin 2.4–2.6)

**Laskentakaava (tekniset nimet):**
```text
Käytettävyys * Nopeus * Laatukerroin        (desimaalilukuina)

tai suoraan:
SUM(Hyväksytty määrä * cycle_time_ideal_min) / Suunniteltu tuotantoaika * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Hyväksytty määrä * Kappale jaksoaika tavoite) / Suunniteltu tuotantoaika * 100
```

**Huomiot ja rajoitteet:**
- Yksittäinen OEE-luku ei kerro, mistä häviö syntyy. Osatekijät on raportoitava aina yhdessä kokonaisluvun kanssa.
- OEE soveltuu parhaiten toistuvaan konekohtaiseen tuotantoon. Piensarjatuotannossa, jossa asetusten osuus on suuri, se antaa systemaattisesti matalia arvoja eikä kerro toiminnan laadusta.
- OEE ei sovi työkeskusten keskinäiseen vertailuun, ellei ihannesykliaikoja ole asetettu samalla periaatteella.

#### 2.8 Täysin tuottava aika

- **Mitä mittaa:** Ajan, joka olisi tavoitenopeudella tarvittu hyväksyttyjen kappaleiden valmistamiseen. OEE:n aikatulkinta.
- **Mittayksikkö:** min tai h
- **Tarkastelutaso:** kone, nimike, päivä, viikko
- **Tietolähde:** `fact_machine_events` + `fact_workphases`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (ihannesykliaika)

**Laskentakaava (tekniset nimet):**
```text
SUM(Hyväksytty määrä * cycle_time_ideal_min)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Hyväksytty määrä * Kappale jaksoaika tavoite)
```

**Huomiot ja rajoitteet:**
- Erotus suunniteltuun tuotantoaikaan on menetetty aika minuutteina, mikä on usein havainnollisempi luku kuin OEE-prosentti.
- Sopii hyvin OEE:n visualisointiin vesiputouskaaviona: suunniteltu aika, seisokkihäviö, nopeushäviö, laatuhäviö, jäljelle jäävä tuottava aika.

#### 2.9 Koneen käyttöaste

- **Mitä mittaa:** Kuinka suuren osan tarkastelujakson kalenteriajasta kone oli käynnissä. Kapasiteetti- ja investointitarkastelun mittari.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, työkeskus, työkeskusryhmä, kuukausi, vuosi
- **Tietolähde:** `fact_machine_events` + `dim_date`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (vertailuajan rajaus)

**Laskentakaava (tekniset nimet):**
```text
SUM(machine_active_min) / (tarkastelujakson päivien määrä * 1440) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Työstöaika min) / (Jakson päivät * 1440) * 100
```

**Huomiot ja rajoitteet:**
- Vertailuaika on valittava: koko kalenteriaika, työpäivät (`is_workday = TRUE`) tai vuorojen mukainen aika. Luvut eivät ole vertailukelpoisia keskenään.
- Matala käyttöaste ei sinänsä ole ongelma, jos konetta ei ole tarkoitettukaan käytettäväksi ympärivuorokautisesti. Mittari kertoo investoinnin hyödyntämisestä, ei tuotannon sujuvuudesta.
- Sammutusajan osuus saadaan vastaavasti kentästä `power_off_min`; se kertoo miehittämättömän ajon potentiaalista.

#### 2.10 Lastuamisaste

- **Mitä mittaa:** Kuinka suuri osa aktiivisesta koneajasta on todellista lastuamista. Yksi konedatan tuomista merkittävimmistä lisistä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, nimike, ohjelma, työvaihe
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(cutting_time_min) / SUM(machine_active_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Lastuamisaika min) / SUMMA(Työstöaika min) * 100
```

**Huomiot ja rajoitteet:**
- Edellyttää, että lastuamisaika saadaan koneen rajapinnasta tai anturidatasta. Leimausdatasta sitä ei voi johtaa.
- Ohjelmakohtainen tarkastelu (`program_name`) kohdistaa NC-ohjelmien optimointia suoraan sinne, missä hyöty on suurin.

#### 2.11 Apuajan osuus

- **Mitä mittaa:** Aktiivisen työstön aikana kuluneen ei-lastuavan ajan osuuden. Sisältää pikaliikkeet, työkalunvaihdot ja työstönaikaiset mittaukset.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, nimike, ohjelma, työvaihe
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(non_cutting_time_min) / SUM(machine_active_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Koneen apuaika min) / SUMMA(Työstöaika min) * 100
```

**Huomiot ja rajoitteet:**
- Täydentää lastuamisastetta (2.10): niiden summa on määritelmän mukaan 100 %, jos aktiivinen aika on jaettu täysin näihin kahteen.
- Poikkeuksellisen suuri apuaika samalla nimikkeellä eri koneilla viittaa ohjelmointieroon, ei koneen ominaisuuteen.

#### 2.12 Asetus- ja vaihtoajan osuus

- **Mitä mittaa:** Kuinka suuri osa tapahtuma-ajasta kuluu asetustyöhön ja kappaleen vaihtoihin. Paljastaa eräkoon vaikutuksen tuotannon rakenteeseen.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, nimike, nimikeryhmä, eräkoko, vuoro
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Asetusajan osuus = SUM(setup_time_min) / SUM(duration_min) * 100
Vaihtoajan osuus = SUM(part_change_time_min) / SUM(duration_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Asetusajan osuus = SUMMA(Asetusaika min) / SUMMA(Kesto min) * 100
Vaihtoajan osuus = SUMMA(Vaihtoaika min) / SUMMA(Kesto min) * 100
```

**Huomiot ja rajoitteet:**
- Ryhmittely eräkoon mukaan (`planned_qty` työvaihetaulusta) tekee näkyväksi, missä eräkoossa asetusten osuus muuttuu kohtuuttomaksi. Tämä kytkeytyy suoraan kannattavuusmittariin 3.11.
- Vaihtoaika on kohdistettavissa kiinnitin- ja automaatiokehitykseen; asetusaika taas SMED-tyyppiseen kehitystyöhön.

#### 2.13 Tehottoman ajon osuus

- **Mitä mittaa:** Kuinka suuri osa koneen käyntiajasta ajetaan alennetulla teholla. Kone käy, mutta ei tavoitenopeudella.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, nimike, ohjelma, vuoro
- **Tietolähde:** `fact_machine_events`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (tehokkaan ajon raja)

**Laskentakaava (tekniset nimet):**
```text
SUM(inefficient_production_min)
  / (SUM(efficient_production_min) + SUM(inefficient_production_min)) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Tehoton työstöaika min)
  / (SUMMA(Tehokas työstöaika min) + SUMMA(Tehoton työstöaika min)) * 100
```

**Huomiot ja rajoitteet:**
- Tehokkaan ja tehottoman ajon raja on määriteltävä konekohtaisesti, esimerkiksi karan kuormituksen tai syöttönopeuden perusteella. Ilman yhtenäistä sääntöä koneita ei voi verrata keskenään.
- Selittää usein OEE:n nopeushäviön syyn tarkemmin kuin nopeuskomponentti yksinään.

#### 2.14 Prosenttikytkinten keskiarvo

- **Mitä mittaa:** Kuinka paljon koneenkäyttäjät poikkeavat ohjelmoidusta syötöstä ja karannopeudesta.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, ohjelma, nimike, käyttäjä, vuoro
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
AVG(feed_override), AVG(spindle_override)
```

**Laskentakaava (semanttiset nimet):**
```text
KESKIARVO(Syötön prosenttikytkin), KESKIARVO(Karan prosenttikytkin)
```

**Huomiot ja rajoitteet:**
- Systemaattisesti alle 100 % oleva arvo viittaa ohjelmointi-, työkalu- tai luottamusongelmaan ja kytkeytyy suoraan OEE:n nopeuskomponenttiin.
- Yli 100 % oleva arvo kertoo, että ohjelman arvot ovat varovaisia; se on ohjelman päivitystarve, ei käyttäjän poikkeama.
- Käyttäjäkohtaisia arvoja ei pidä käyttää henkilöarviointiin vaan perehdytyksen ja ohjelmien kehittämiseen.

#### 2.15 Sykliajan poikkeama tavoitteesta

- **Mitä mittaa:** Kuinka paljon toteutunut kappalekohtainen jaksoaika poikkeaa tavoitteesta. Erittelee nopeushäviön nimike- ja ohjelmatasolle.
- **Mittayksikkö:** %
- **Tarkastelutaso:** nimike, ohjelma, kone, työvaihe
- **Tietolähde:** `fact_workphases`, tapahtumatasolla `fact_machine_events.unit_cycle_time_min`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (ihannesykliaika)

**Laskentakaava (tekniset nimet):**
```text
(cycle_time_machine_min − cycle_time_ideal_min) / cycle_time_ideal_min * 100
```

**Laskentakaava (semanttiset nimet):**
```text
(Kappale jaksoaika konedata − Kappale jaksoaika tavoite)
  / Kappale jaksoaika tavoite * 100
```

**Huomiot ja rajoitteet:**
- Sama nimike eri koneilla tai eri ohjelmaversioilla on hyödyllisin vertailu; se paljastaa parhaan käytännön.
- Sykliajan hajonta `STDDEV(unit_cycle_time_min)` yksittäisten kappaletapahtumien (`event_type_id = 9`) yli kertoo prosessin vakaudesta ilman mittausdataa.

### Kannattavuuden mittarit

Kannattavuusmittarit vertaavat tilausrivin myyntihintaa siihen kohdistettuihin kustannuksiin ja suunniteltuja kustannuksia toteutuneisiin. Tietolähteenä on pääosin `fact_order_rows`, työvaihetason kustannukset `fact_workphases`-taulusta. Ryhmittelyt tehdään `dim_customer`-, `dim_article`- ja `dim_user`-taulujen kautta.

Kaikissa katemittareissa on ensin päätettävä kustannustaso, koska tietomalli tarjoaa niitä kolme:

```text
prime_cost_*_sum       : välittömät kustannukset ilman yleiskustannuslisää
manufacturing_cost_*   : omakustannus, sisältää yleiskustannukset
profit_*               : voitto kaikkien kustannusten jälkeen
```

#### 3.1 Myynti

- **Mitä mittaa:** Tilausrivien yhteenlasketun arvon ilman arvonlisäveroa.
- **Mittayksikkö:** €
- **Tarkastelutaso:** asiakas, nimike, myyjä, tilaustyyppi, kuukausi, vuosi
- **Tietolähde:** `fact_order_rows` + `dim_customer`, `dim_article`, `dim_user`, `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(total_price)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Tilausrivi hinta)
```

**Huomiot ja rajoitteet:**
- Jaksotus on valittava: tilauksen luontipäivä kuvaa myynnin kertymää, toimituspäivä liikevaihdon tuloutumista ja laskutuspäivä laskutusta. Nämä antavat eri luvut samalle kuukaudelle.
- `total_price` on tietomallissa yleensä `unit_price * ordered_qty`. Jos toimitettu määrä poikkeaa tilatusta, todellinen laskutettu arvo voi olla eri.

#### 3.2 Toteutunut kate

- **Mitä mittaa:** Tilausrivin euromääräisen kannattavuuden valitulla kustannustasolla.
- **Mittayksikkö:** €
- **Tarkastelutaso:** tilausrivi, asiakas, nimike, myyjä, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (kustannustason valinta)

**Laskentakaava (tekniset nimet):**
```text
SUM(sales_margin_actual)
tai  SUM(total_price) − SUM(prime_cost_actual_sum)       (myyntikate)
tai  SUM(total_price) − SUM(manufacturing_cost_actual)   (tulos yleiskustannusten jälkeen)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Myyntikate toteutunut)
tai  SUMMA(Tilausrivi hinta) − SUMMA(Suorat tuotantokustannukset toteutunut)
```

**Huomiot ja rajoitteet:**
- Valitse yksi laskentasääntö ja käytä sitä johdonmukaisesti. Valmiiksi johdettu `sales_margin_actual` ja itse laskettu erotus voivat poiketa toisistaan, jos ERP:n katelaskenta poikkeaa tietomallin kaavasta.
- Yleiskustannusten kohdistustapa vaikuttaa suoraan siihen, mitkä tilaukset näyttävät kannattavilta. Jos yleiskustannuslisä on kiinteä prosentti, kateprosentti ei kerro todellisesta kustannusrakenteesta.
- Suunniteltu vastine on `sales_margin_planned`.

#### 3.3 Kate-%

- **Mitä mittaa:** Katteen osuuden myyntihinnasta. Mahdollistaa erikokoisten tilausten vertailun.
- **Mittayksikkö:** %
- **Tarkastelutaso:** asiakas, nimike, nimikeryhmä, myyjä, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(sales_margin_actual) / SUM(total_price) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Myyntikate toteutunut) / SUMMA(Tilausrivi hinta) * 100
```

**Huomiot ja rajoitteet:**
- Laske vain, jos myynti on suurempi kuin nolla. Takuutöillä ja hyvityksillä `total_price` voi olla nolla tai negatiivinen.
- Prosentti lasketaan summista, ei rivikohtaisten prosenttien keskiarvona.
- Suunniteltu vastine `sales_margin_planned / total_price * 100`; näiden erotus prosenttiyksikköinä on hyödyllinen tarjouslaskennan mittari.

#### 3.4 Katepoikkeama

- **Mitä mittaa:** Toteutuneen ja suunnitellun katteen eron euroina ja prosenttiyksikköinä.
- **Mittayksikkö:** € tai %-yks.
- **Tarkastelutaso:** tilausrivi, asiakas, nimike, myyjä, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Euroina:            SUM(sales_margin_actual) − SUM(sales_margin_planned)
Prosenttiyksikköinä: (SUM(sales_margin_actual) / SUM(total_price)
                      − SUM(sales_margin_planned) / SUM(total_price)) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Myyntikate toteutunut) − SUMMA(Myyntikate suunniteltu)
```

**Huomiot ja rajoitteet:**
- Negatiivinen arvo tarkoittaa suunniteltua heikompaa katetta.
- Mittari kertoo yhtä lailla tarjouslaskennan osuvuudesta kuin tuotannon suorituskyvystä; syy erotellaan mittareilla 3.5–3.7.

#### 3.5 Jälkilaskennan poikkeama

- **Mitä mittaa:** Toteutuneiden ja suunniteltujen suorien tuotantokustannusten eron. Tarjous- ja ennakkolaskennan tarkkuuden perusmittari.
- **Mittayksikkö:** €
- **Tarkastelutaso:** tilausrivi, nimike, asiakas, myyjä, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Suorat tuotantokustannukset toteutunut)
  − SUMMA(Suorat tuotantokustannukset suunniteltu)
```

**Huomiot ja rajoitteet:**
- Positiivinen arvo tarkoittaa suunniteltua suurempaa kustannusta.
- Sama laskenta täysillä valmistuskustannuksilla: `manufacturing_cost_actual − manufacturing_cost_planned`.
- Mittari edellyttää, että sekä suunniteltu että toteutunut kustannus on täytetty. Kattavuus kannattaa tarkistaa mittarilla 6.7 ennen tulkintaa.

#### 3.6 Jälkilaskennan poikkeamaprosentti

- **Mitä mittaa:** Kustannuspoikkeaman suhteessa suunniteltuun kustannukseen. Mahdollistaa erikokoisten töiden vertailun.
- **Mittayksikkö:** %
- **Tarkastelutaso:** nimike, nimikeryhmä, asiakas, myyjä, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_article`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum))
  / SUM(prime_cost_planned_sum) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
(Suorat tuotantokustannukset toteutunut − Suorat tuotantokustannukset suunniteltu)
  / Suorat tuotantokustannukset suunniteltu * 100
```

**Huomiot ja rajoitteet:**
- Laske vain, jos suunniteltu kustannus on suurempi kuin nolla.
- Ryhmittely `new_article`-kentän mukaan kertoo, kuinka paljon heikommin tarjouslaskenta osuu uusilla nimikkeillä. Tämä on yksi hyödyllisimmistä yksittäisistä selittäjistä.

#### 3.7 Kustannuslajikohtainen poikkeama

- **Mitä mittaa:** Mistä kustannuslajista kustannuspoikkeama syntyy: työstä, materiaalista, alihankinnasta vai muista suorista kuluista.
- **Mittayksikkö:** €
- **Tarkastelutaso:** tilausrivi, nimike, asiakas, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(direct_work_cost_actual)    − SUM(direct_work_cost_planned)
SUM(material_cost_actual)       − SUM(material_cost_planned)
SUM(subcontracting_cost_actual) − SUM(subcontracting_cost_planned)
SUM(other_direct_costs_actual)  − SUM(other_direct_costs_planned)
SUM(overhead_costs_actual)      − SUM(overhead_costs_planned)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Suorat työkustannukset toteutunut) − SUMMA(Suorat työkustannukset suunniteltu)
SUMMA(Materiaalikustannukset toteutunut) − SUMMA(Materiaalikustannukset suunniteltu)
SUMMA(Alihankintakustannukset toteutunut) − SUMMA(Alihankintakustannukset suunniteltu)
```

**Huomiot ja rajoitteet:**
- Kustannuslajien summan pitäisi vastata kokonaispoikkeamaa (3.5). Ero paljastaa kohdistamattomia kustannuksia.
- Yleiskustannuslisän poikkeama on mielekäs vain, jos toteutunut yleiskustannuslisä lasketaan vertailukelpoisella tavalla; usein se on sama laskennallinen prosentti kuin suunniteltu, jolloin poikkeama on rakenteellisesti nolla.

#### 3.8 Kappalekohtainen valmistuskustannus

- **Mitä mittaa:** Yhden valmistetun kappaleen kustannuksen. Hinnoittelun ja kustannuskehityksen seurantamittari.
- **Mittayksikkö:** €/kpl
- **Tarkastelutaso:** nimike, nimikeryhmä, asiakas, eräkoko, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_article`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(manufacturing_cost_actual) / SUM(ordered_qty)
tai  AVG(unit_manufacturing_cost_actual)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Valmistuskustannukset toteutunut) / SUMMA(Tilattu määrä)
tai  KESKIARVO(Kappale valmistuskustannukset toteutunut)
```

**Huomiot ja rajoitteet:**
- Summasuhde on aggregoidussa raportissa parempi kuin rivikohtaisten kappalehintojen keskiarvo, koska jälkimmäinen painottaa pieniä eriä liikaa.
- Vastaava välittömien kustannusten mittari saadaan kentistä `prime_cost_actual_sum` ja `unit_prime_cost_actual`.
- Eräkoon mukaan ryhmiteltynä mittari näyttää, missä sarjapituudessa kappalekustannus tasaantuu.

#### 3.9 Voittolisä-%

- **Mitä mittaa:** Voiton osuuden omakustannusarvosta.
- **Mittayksikkö:** %
- **Tarkastelutaso:** tilausrivi, asiakas, nimike, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(profit_actual) / SUM(manufacturing_cost_actual) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Voittolisä toteutunut) / SUMMA(Valmistuskustannukset toteutunut) * 100
```

**Huomiot ja rajoitteet:**
- Laske vain, jos valmistuskustannus on suurempi kuin nolla.
- Mittari on mielekäs vain, jos voittolisä on johdettu luotettavasti eikä vain laskennallisena prosenttina omakustannehinnan päälle. Jälkimmäisessä tapauksessa mittari toistaa hinnoittelusäännön eikä kerro toteumasta.

#### 3.10 Tuntikate

- **Mitä mittaa:** Kuinka paljon katetta työ tuotti käytettyä tuotantotuntia kohti. Paljastaa työt, jotka näyttävät katteellisilta mutta sitovat kapasiteettia kohtuuttomasti.
- **Mittayksikkö:** €/h
- **Tarkastelutaso:** tilausrivi, nimike, asiakas, työkeskus, työkeskusryhmä
- **Tietolähde:** `fact_order_rows` + `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(sales_margin_actual) / (SUM(fact_workphases.phase_duration_actual_min) / 60)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Myyntikate toteutunut) / (SUMMA(Vaiheaika leimattu) / 60)
```

**Huomiot ja rajoitteet:**
- Edellyttää, että työvaiheet on liitetty tilausriviin `order_row_id`-kentällä. Liittämättömät vaiheet jäävät nimittäjästä pois ja nostavat tuntikatetta virheellisesti; kattavuus kannattaa tarkistaa mittarilla 6.6.
- Voidaan laskea myös vain koneajalle nimittäjänä `production_time_actual_min`, jolloin mittari vertautuu suoraan konetuntihintaan.
- Pullonkaulaksi tunnistetun työkeskuksen tuntikate on tärkein yksittäinen kannattavuusluku työn valinnassa.

#### 3.11 Asetuskustannus kappaletta kohti

- **Mitä mittaa:** Eräkoon vaikutuksen yksittäisen kappaleen kannattavuuteen. Tukee sopivan valmistuserän määrittämistä.
- **Mittayksikkö:** €/kpl
- **Tarkastelutaso:** työvaihe, nimike, työkeskus, eräkoko
- **Tietolähde:** `fact_workphases` + `dim_workcenter`, `dim_article`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(setup_time_planned_min / 60 * workcenter_hour_rate) / planned_qty
```

**Laskentakaava (semanttiset nimet):**
```text
(Asetusaika suunniteltu / 60 * Tuntihinta) / Suunniteltu määrä
```

**Huomiot ja rajoitteet:**
- Summattavissa työn kaikkien vaiheiden yli kappalekohtaiseksi kokonaisasetuskustannukseksi.
- Toteumaan perustuva versio saadaan korvaamalla suunniteltu asetusaika kentällä `setup_time_stamping_min` tai `setup_time_machine_min`.
- Edellyttää, että `workcenter_hour_rate` on täytetty ja vastaa työn ajankohdan konetuntihintaa.

#### 3.12 Asiakas-, tuote- ja myyjäkohtainen kate

- **Mitä mittaa:** Mistä kate todella syntyy: mitkä asiakkaat, tuotteet ja myyjät tuovat tulosta ja mitkä sitovat kapasiteettia heikolla katteella.
- **Mittayksikkö:** € ja %
- **Tarkastelutaso:** asiakas, nimike, nimikeryhmä, myyjä
- **Tietolähde:** `fact_order_rows` + `dim_customer`, `dim_article`, `dim_user`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(sales_margin_actual) GROUP BY customer_id | article_id | seller_id
SUM(sales_margin_actual) / SUM(total_price) * 100 samalla ryhmittelyllä
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Myyntikate toteutunut) ryhmiteltynä
  Asiakkaan ID / Nimike ID / Myyjä ID mukaan
```

**Huomiot ja rajoitteet:**
- Kate ei sisällä asiakaskohtaisia palvelukustannuksia (myynti, suunnittelu, laatu, hallinto), ellei niitä ole kohdistettu kustannuskenttiin. Suuren liikevaihdon asiakas voi siksi näyttää kannattavammalta kuin on.
- Nimikeryhmätaso saadaan kentän `dim_article.article_group` kautta.
- Kate ja volyymi kannattaa esittää yhdessä, esimerkiksi hajontakuviona, koska kumpikaan yksin ei riitä asiakassalkun priorisointiin.

#### 3.13 Vaihekustannuksen poikkeama

- **Mitä mittaa:** Kuinka paljon työvaiheen toteutuneet suoran työn kustannukset poikkeavat suunnitelluista.
- **Mittayksikkö:** €
- **Tarkastelutaso:** työvaihe, työkeskus, työkeskusryhmä, nimike, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(phase_cost_actual_stamping) − SUM(phase_cost_planned)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Vaihekustannus leimaukset) − SUMMA(Vaihekustannus suunniteltu)
```

**Huomiot ja rajoitteet:**
- Käytä `phase_cost_actual_machine`-kenttää, jos konedata on ensisijainen toteumalähde.
- Vaihetason poikkeamien summa työn yli selittää tilaustason jälkilaskennan poikkeaman (3.5) siltä osin kuin kyse on suorasta työstä.
- Toteutunut tuntikustannus saadaan jakamalla vaihekustannus toteutuneella ajalla; sitä kannattaa verrata työkeskuksen tuntihintaan `workcenter_hour_rate`.

#### 3.14 Alihankinnan osuus kustannuksista

- **Mitä mittaa:** Kuinka suuri osa suorista tuotantokustannuksista ostetaan ulkoa. Taustatieto tee itse vai osta -päätöksille.
- **Mittayksikkö:** %
- **Tarkastelutaso:** nimike, nimikeryhmä, asiakas, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(subcontracting_cost_actual) / SUM(prime_cost_actual_sum) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Alihankintakustannukset toteutunut)
  / SUMMA(Suorat tuotantokustannukset toteutunut) * 100
```

**Huomiot ja rajoitteet:**
- Työvaihetasolla vastaava tarkastelu saadaan rajaamalla `subcontracting_phase = TRUE`, jolloin myös alihankinnan läpimenoajat tulevat mukaan.
- Sisältääkö alihankintakustannus siihen liittyvän logistiikan, on yrityskohtainen ratkaisu ja vaikuttaa vertailtavuuteen.

#### 3.15 Tilauskannan arvo ja laskuttamaton valmis tuotanto

- **Mitä mittaa:** Avoimen tilauskannan arvon sekä sen osan, joka on jo valmistettu mutta laskuttamatta.
- **Mittayksikkö:** €
- **Tarkastelutaso:** asiakas, nimike, suunniteltu toimituskuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Tilauskanta          = SUM(total_price) WHERE order_complete = FALSE
Laskuttamaton valmis = SUM(total_price) WHERE order_complete = FALSE
                         AND production_end_date_actual IS NOT NULL
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Tilausrivi hinta) rajattuna riveihin, joilla Tilaus valmis = EPÄTOSI
```

**Huomiot ja rajoitteet:**
- Tilauskanta kannattaa ryhmitellä suunnitellun toimituspäivän mukaan, jolloin se toimii samalla kuormitusennusteena.
- Laskuttamaton valmis tuotanto tunnistaa suoraan kassavirtaa hidastavat rivit ja on siksi yksi nopeimmin hyötyä tuottavista mittareista.
- Edellyttää, että `order_complete` päivitetään luotettavasti.

#### 3.16 Laskutusviive ja maksuaika

- **Mitä mittaa:** Kuinka monta päivää kuluu lähetyksestä laskutukseen ja laskutuksesta maksuun.
- **Mittayksikkö:** vrk
- **Tarkastelutaso:** asiakas, tilaustyyppi, kuukausi
- **Tietolähde:** `fact_order_rows` + `dim_date`, ryhmittely `dim_customer`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Laskutusviive = date_index(invoice_date_actual) − date_index(dispatch_date_actual)
Maksuaika     = date_index(payment_date_actual) − date_index(invoice_date_actual)
```

**Laskentakaava (semanttiset nimet):**
```text
Päivämääräindeksi(Lasku lähetyspäivä) − Päivämääräindeksi(Toteutunut lähetys)
Päivämääräindeksi(Lasku maksupäivä)  − Päivämääräindeksi(Lasku lähetyspäivä)
```

**Huomiot ja rajoitteet:**
- Laskutusviive on yrityksen oma sisäinen prosessi ja siten suoraan korjattavissa; maksuaika kuvaa asiakkaan maksukäyttäytymistä.
- Maksuaika ei ole sama asia kuin maksuehto: erotus näiden välillä on varsinainen ylitys. Maksuehtoa ei ole tietomallissa, joten vertailu vaatii tiedon tuomista erikseen.

**Tietomallin laajennusta vaativat kannattavuusmittarit:** laatukustannusten ja reklamaatiokustannusten osuus, asiakkaan palvelukustannukset sekä takuukustannukset erillisenä tietona. Takuutöiden osuus on karkeasti johdettavissa, jos ne kirjataan omalla `order_type`-arvolla.

### Laadun mittarit

Tietomallin laatutieto on kappalemääräistä: tuotetut ja hylätyt kappaleet työvaiheittain (`fact_workphases`) ja konetapahtumittain (`fact_machine_events`). Uudelleentyötä, romutusta ja mittaustuloksia ei erotella, joten osa oppaan laatumittareista jää mallin ulkopuolelle.

#### 4.1 Hyväksytty ja hylätty määrä

- **Mitä mittaa:** Valmistuneiden ja hylättyjen kappaleiden määrät, joista muut laatumittarit johdetaan.
- **Mittayksikkö:** kpl
- **Tarkastelutaso:** työvaihe, työkeskus, nimike, käyttäjä, vuoro, päivä
- **Tietolähde:** `fact_workphases`, konetapahtumatasolla `produced_qty_stamping` ja `rejected_qty_stamping`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Hylätty määrä    = SUM(rejected_qty)
Hyväksytty määrä = SUM(produced_qty) − SUM(rejected_qty)
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Hylätty määrä)
SUMMA(Tehty määrä) − SUMMA(Hylätty määrä)
```

**Huomiot ja rajoitteet:**
- Konetapahtumatasolla hylkäysmäärä on määritelty leimausperusteiseksi. Jos tuotantomäärä otetaan konedatasta (`produced_qty_machine`), lähteet on syytä pitää mielessä tulkinnassa.
- Työvaihetason ja konetapahtumatason määrien ero on datan laadun mittari (6.4).

#### 4.2 Hylkäysaste

- **Mitä mittaa:** Hylättyjen kappaleiden osuuden valmistetuista. Laadun perusmittari.
- **Mittayksikkö:** %
- **Tarkastelutaso:** nimike, nimikeryhmä, työvaihe, työkeskus, käyttäjä, vuoro, kuukausi
- **Tietolähde:** `fact_workphases` + `dim_article`, `dim_workcenter`, `dim_time`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(rejected_qty) / SUM(produced_qty) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Hylätty määrä) / SUMMA(Tehty määrä) * 100
```

**Huomiot ja rajoitteet:**
- Ryhmittely vaihenumeron mukaan paljastaa, missä kohtaa prosessia hylkyjä syntyy; ryhmittely nimikkeen mukaan sen, mitkä tuotteet ovat vaikeita.
- Myöhäisessä työvaiheessa hylätty kappale on huomattavasti kalliimpi kuin alkuvaiheessa hylätty. Pelkkä kappalemääräinen osuus ei kerro tätä, joten sen rinnalle sopii mittari 4.7.
- Ei erottele romutettavaa ja korjattavaa kappaletta.

#### 4.3 Laatukerroin ja hyväksymisaste

- **Mitä mittaa:** Hyväksyttyjen kappaleiden osuuden valmistetuista. Sama peruslogiikka kuin OEE:n laatukomponentissa.
- **Mittayksikkö:** %
- **Tarkastelutaso:** nimike, työvaihe, työkeskus, vuoro, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
(SUMMA(Tehty määrä) − SUMMA(Hylätty määrä)) / SUMMA(Tehty määrä) * 100
```

**Huomiot ja rajoitteet:**
- Täydentää hylkäysastetta (4.2): mittarit summautuvat sataan, joten kumpikin riittää raportille. Valinta on esitystapakysymys.
- Tarkastettujen kappaleiden määrää ei ole erikseen, joten hyväksymisaste lasketaan tuotetuista kappaleista. Jos kaikkia kappaleita ei tarkasteta, mittari kuvaa tuotantoa, ei tarkastusta.

#### 4.4 PPM

- **Mitä mittaa:** Virheellisten kappaleiden määrän miljoonaa valmistettua kappaletta kohti. Vakiintunut toimittajalaadun mittari.
- **Mittayksikkö:** ppm
- **Tarkastelutaso:** nimike, asiakas, työkeskus, kuukausi, vuosi
- **Tietolähde:** `fact_workphases` + `dim_article`, `dim_customer` (tilausrivin kautta)
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(rejected_qty) / SUM(produced_qty) * 1000000
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Hylätty määrä) / SUMMA(Tehty määrä) * 1000000
```

**Huomiot ja rajoitteet:**
- Soveltuu vain suurille tuotantomäärille. Piensarjatuotannossa yksittäinen hylky heiluttaa lukua satojatuhansia ppm-yksiköitä, jolloin mittari ei ole tulkittavissa.
- Mittari kuvaa sisäisesti havaittuja hylkyjä. Asiakkaalla havaittujen virheiden ppm edellyttäisi reklamaatiotietoa, jota mallissa ei ole.

#### 4.5 Ensimmäisen läpäisyn saanto, FPY

- **Mitä mittaa:** Kuinka suuri osa kappaleista läpäisi työvaiheen ilman korjausta. Tietomallilla laskettuna arvio.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työvaihe, vaihenumero, nimike, työkeskus
- **Tietolähde:** `fact_workphases`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (korjausten käsittely)

**Laskentakaava (tekniset nimet):**
```text
(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100
  laskettuna työvaiheittain
```

**Laskentakaava (semanttiset nimet):**
```text
(Tehty määrä − Hylätty määrä) / Tehty määrä * 100 vaiheittain
```

**Huomiot ja rajoitteet:**
- Aito FPY edellyttäisi tietoa korjatuista kappaleista. Nykymallissa korjattu kappale näkyy hyväksyttynä, joten laskettu arvo on yläraja todelliselle FPY:lle.
- Osittainen kiertotie on tunnistaa uudelleentyö siitä, että sama `work_id` ja `phase_number` esiintyy useaan kertaan. Sääntö on yrityskohtainen ja epävarma, joten se on dokumentoitava.
- Arvo ei ole vertailukelpoinen muiden yritysten FPY-lukujen kanssa.

#### 4.6 Kokonaisläpisaanto, RTY

- **Mitä mittaa:** Todennäköisyyden, että kappale läpäisee kaikki peräkkäiset työvaiheet ilman virhettä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työ, nimike, nimikeryhmä, tuotantolinja
- **Tietolähde:** `fact_workphases`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (perustuu mittariin 4.5)

**Laskentakaava (tekniset nimet):**
```text
TULO(FPY(vaihe)) saman work_id:n vaiheille, järjestettynä phase_number mukaan
```

**Laskentakaava (semanttiset nimet):**
```text
Vaihekohtaisten läpäisysaantojen tulo työn kaikkien vaiheiden yli
```

**Huomiot ja rajoitteet:**
- Tietomallin porautumisketju tukee laskentaa hyvin, koska vaiheet ovat järjestettävissä ja liitettävissä samaan työhön.
- Perii FPY:n rajoitteen: korjatut kappaleet eivät erotu, joten RTY on todellista korkeampi.
- Mittari on herkkä vaiheiden määrälle. Eri pituisten reittien tuotteita ei voi verrata suoraan keskenään.

#### 4.7 Hylkäyksen kustannusvaikutus

- **Mitä mittaa:** Hylättyjen kappaleiden valmistusarvon euroina ja sen osuuden valmistuskustannuksista.
- **Mittayksikkö:** € ja %
- **Tarkastelutaso:** nimike, asiakas, työvaihe, kuukausi
- **Tietolähde:** `fact_workphases` + `fact_order_rows`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (hylyn arvostusperiaate)

**Laskentakaava (tekniset nimet):**
```text
SUM(rejected_qty * unit_manufacturing_cost_actual)
  / SUM(manufacturing_cost_actual) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Hylätty määrä * Kappale valmistuskustannukset toteutunut)
  / SUMMA(Valmistuskustannukset toteutunut) * 100
```

**Huomiot ja rajoitteet:**
- Kattaa vain hylättyjen kappaleiden valmistusarvon, ei korjaustyötä, uusintamateriaalia eikä lajittelua. Todellinen laatukustannus on suurempi.
- Kappaleen arvo riippuu siitä, missä työvaiheessa se hylättiin. Tarkempi arvio saadaan käyttämällä hylkäyshetkeen mennessä kertyneitä vaihekustannuksia koko kappalekustannuksen sijaan.

**Tietomallin laajennusta vaativat laatumittarit:** romutusaste erillään hylkäyksestä, uudelleentyöaste ja uudelleentyön tunnit, materiaalihukka, virheiden lukumäärä ja vakavuusluokat, DPMO, prosessikyvykkyys (Cp, Cpk) sekä kaikki asiakkaalla havaitut laatumittarit. Prosessikyvykkyys edellyttää mittausdatan taulua, joka on tietomallin dokumentaatiossa tunnistettu mahdolliseksi laajennukseksi tapahtumatyypin 13 yhteydessä.

### Muut mittarit ja laskentakaavat

Tähän osioon on koottu tuottavuuden, kuormituksen ja kapasiteetin, häiriöiden ja ylläpidon, energian sekä resurssien ja vuorojen mittarit. Tietolähteinä ovat kaikki kolme faktataulua.

#### 5.1 Tuotantomäärä

- **Mitä mittaa:** Valmistuneen tuotannon määrän tarkastelujaksolla.
- **Mittayksikkö:** kpl/jakso
- **Tarkastelutaso:** työkeskus, nimike, vuoro, päivä, viikko, kuukausi
- **Tietolähde:** `fact_workphases` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(produced_qty) rajattuna jaksoon end_date_actual kautta
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Tehty määrä)
```

**Huomiot ja rajoitteet:**
- Kappalemäärät eivät ole vertailukelpoisia, jos tuotteet eroavat toisistaan paljon. Silloin käytetään standarditunteja (5.2).
- Työvaihetasolla sama kappale lasketaan jokaisessa vaiheessa uudelleen. Työn tuotantomäärä otetaan viimeisestä vaiheesta tai tilausrivin `delivered_qty`-kentästä.

#### 5.2 Tuotantomäärä standarditunteina

- **Mitä mittaa:** Valmistuneen tuotannon suunnitellun työmäärän. Tekee monituoteympäristön tuotannon vertailukelpoiseksi.
- **Mittayksikkö:** standardih/jakso
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, vuoro, viikko, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(produced_qty * unit_time_planned_min) / 60
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Tehty määrä * Kappaleaika suunniteltu) / 60
```

**Huomiot ja rajoitteet:**
- Standardiaika on tässä suunniteltu kappaleaika. Jos suunnitteluarvot ovat vanhentuneet, mittari kuvaa vanhaa standardia eikä todellista työmäärää.
- Sopii tuottavuuden aikasarjaseurantaan paremmin kuin kappalemäärä.

#### 5.3 Läpäisykyky

- **Mitä mittaa:** Kuinka nopeasti hyväksyttyjä kappaleita valmistuu.
- **Mittayksikkö:** kpl/h
- **Tarkastelutaso:** työkeskus, nimike, työvaihe, vuoro
- **Tietolähde:** `fact_workphases`, konetapahtumatasolla `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_actual_min) / 60)
```

**Laskentakaava (semanttiset nimet):**
```text
(Tehty määrä − Hylätty määrä) / (Vaiheaika leimattu / 60)
```

**Huomiot ja rajoitteet:**
- Nimittäjän valinta muuttaa merkityksen: aktiivinen työstöaika (`machine_active_min`) kuvaa koneen nopeutta, tapahtuman kokonaiskesto (`duration_min`) todellista läpäisyä odotuksineen.
- Vertailukelpoinen vain samankaltaisten nimikkeiden kesken.

#### 5.4 Työn tuottavuus

- **Mitä mittaa:** Hyväksytyn tuotannon suhteen käytettyyn työpanokseen.
- **Mittayksikkö:** kpl/työtunti tai standardih/työtunti
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, vuoro, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (työpanoksen määritelmä)

**Laskentakaava (tekniset nimet):**
```text
(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_stamping_min) / 60)
```

**Laskentakaava (semanttiset nimet):**
```text
(Tehty määrä − Hylätty määrä) / (Vaiheaika leimattu / 60)
```

**Huomiot ja rajoitteet:**
- Leimausaika vastaa työtuntia vain, jos leimaus on henkilökohtainen. Jos yksi henkilö ajaa useaa konetta tai kone käy miehittämättömänä, leimausaika ei ole työpanos.
- Osoittajana kannattaa monituoteympäristössä käyttää standarditunteja (5.2) kappaleiden sijaan.

#### 5.5 Työtuntitehokkuus

- **Mitä mittaa:** Suunnitellun ajan suhteen toteutuneeseen aikaan. Kertoo, tehdäänkö työ suunnitellussa ajassa.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, nimike, vuoro, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(phase_duration_planned_min) / SUM(phase_duration_actual_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Vaiheaika suunniteltu) / SUMMA(Vaiheaika leimattu) * 100
```

**Huomiot ja rajoitteet:**
- Yli 100 % tarkoittaa suunniteltua nopeampaa tekemistä. Jatkuvasti yli sadan oleva arvo kertoo yleensä liian väljistä suunnitteluarvoista, ei poikkeuksellisesta suorituksesta.
- Mittari on vaiheajan poikkeaman (1.10) käänteinen esitystapa. Valitse organisaatioon vain toinen, muuten samasta asiasta raportoidaan kahdella luvulla.

#### 5.6 Keskeneräisen tuotannon määrä ja arvo

- **Mitä mittaa:** Tuotannossa olevien avoimien töiden määrän, arvon ja jäljellä olevan työmäärän.
- **Mittayksikkö:** kpl, € ja h
- **Tarkastelutaso:** työkeskus, asiakas, nimike, viikko
- **Tietolähde:** `fact_order_rows` + `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Määrä  = COUNT(order_row_id) WHERE production_start_date_actual IS NOT NULL
                               AND production_end_date_actual IS NULL
Arvo   = SUM(prime_cost_planned_sum) samalla ehdolla
Jäljellä oleva työ = SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL
```

**Laskentakaava (semanttiset nimet):**
```text
Avoimien töiden lukumäärä, niiden suunniteltu kustannusarvo ja
avoimien työvaiheiden suunniteltu vaiheaika
```

**Huomiot ja rajoitteet:**
- Kustannusperusteinen arvo ei ole varsinainen varastoarvo, koska keskeneräisyyden aste ei ole tiedossa. Tarkempi arvio saadaan laskemalla valmistuneiden vaiheiden osuus työn kaikista vaiheista.
- Jäljellä olevina standarditunteina mitattuna keskeneräinen tuotanto on suoraan verrattavissa työjonon kuormitukseen (5.9).

#### 5.7 Työvaiheen kuormitus

- **Mitä mittaa:** Yksittäisen työvaiheen vaatiman kapasiteetin.
- **Mittayksikkö:** min tai h
- **Tarkastelutaso:** työvaihe, työ, tilausrivi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
setup_time_planned_min + planned_qty * cycle_time_planned_min
tai suoraan phase_duration_planned_min
```

**Laskentakaava (semanttiset nimet):**
```text
Asetusaika suunniteltu + Suunniteltu määrä * Kappale jaksoaika suunniteltu
tai Vaiheaika suunniteltu
```

**Huomiot ja rajoitteet:**
- Molempien laskentatapojen pitäisi antaa sama tulos. Ero kertoo, että `phase_duration_planned_min` on johdettu jollain muulla säännöllä; sääntö kannattaa tarkistaa.
- Kuormitus on kaikkien kapasiteettimittareiden perusta.

#### 5.8 Työpisteen kokonaiskuormitus

- **Mitä mittaa:** Työkeskukselle tarkastelujaksolla kohdistetun työmäärän.
- **Mittayksikkö:** h/jakso
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, viikko, kuukausi
- **Tietolähde:** `fact_workphases` + `dim_workcenter`, `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(phase_duration_planned_min) GROUP BY workcenter_id, jakso
  jakso start_date_latest_planned kautta dim_date-tauluun
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Vaiheaika suunniteltu) ryhmiteltynä Työkeskus ID ja jakso
```

**Huomiot ja rajoitteet:**
- Jos työvaihe on suunniteltu useammalle päivälle, se kohdistuu tässä kokonaisuudessaan aloituspäivän jaksoon. Pitkien vaiheiden jakaminen päiville vaatii erillisen säännön.
- Toteutunut kuormitus saadaan samalla kaavalla kentästä `phase_duration_stamping_min` tai `phase_duration_machine_min`; ero suunniteltuun on kuormituksen poikkeama.

#### 5.9 Työjonon kuormitus

- **Mitä mittaa:** Aloittamattomien ja keskeneräisten työvaiheiden jäljellä olevan työmäärän työkeskuksittain.
- **Mittayksikkö:** standardih
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, viikko
- **Tietolähde:** `fact_workphases` + `dim_workcenter`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL
  GROUP BY workcenter_id
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Vaiheaika suunniteltu) avoimille työvaiheille ryhmiteltynä Työkeskus ID
```

**Huomiot ja rajoitteet:**
- Osittain aloitetuista vaiheista kannattaa vähentää jo toteutunut aika, muuten jono näyttää todellista pidemmältä.
- Työjonon koko yhdessä sen kehityssuunnan kanssa ennakoi ruuhkautumista aikaisemmin kuin toimitusvarmuus.

#### 5.10 Myöhässä olevan kuorman osuus

- **Mitä mittaa:** Kuinka suuri osa työjonosta on jo myöhässä suunnitellusta valmistumisesta. Toimitusriskin ennakoiva mittari.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, asiakas
- **Tietolähde:** `fact_workphases` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(phase_duration_planned_min) WHERE end_date_latest_planned < tarkastelupäivä
                                  AND end_date_actual IS NULL
  / Työjonon kuormitus * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Myöhässä olevien avoimien työvaiheiden kuormitus / Työjonon kuormitus * 100
```

**Huomiot ja rajoitteet:**
- Mittari on tilannekuva, ei jaksomittari. Se lasketaan aina tarkasteluhetkeen nähden.
- Suuri arvo yhdellä työkeskuksella tunnistaa pullonkaulan nopeammin kuin kuormitusaste, joka vaatii kapasiteettitiedon.

#### 5.11 Kuormitusaste

- **Mitä mittaa:** Kuinka suuri osa käytettävissä olevasta kapasiteetista on suunniteltu käytettäväksi.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, viikko, kuukausi
- **Tietolähde:** `fact_workphases` + `fact_machine_events` (`event_type_id = 19`)
- **Tila:** Edellyttää yrityskohtaista määrittelyä (tehollinen kapasiteetti)

**Laskentakaava (tekniset nimet):**
```text
Työpisteen kokonaiskuormitus / Tehollinen kapasiteetti * 100
  Tehollinen kapasiteetti = SUM(duration_min) WHERE event_type_id = 19
                            tai erillinen kapasiteettiparametri
```

**Laskentakaava (semanttiset nimet):**
```text
Suunniteltu kuormitus / Tehollinen kapasiteetti * 100
```

**Huomiot ja rajoitteet:**
- Tietomallissa ei ole työkeskuskohtaista kapasiteetti- tai työvuorokalenteria. Kapasiteetti saadaan joko suunnitellun tuotantoajan riveistä tai tuomalla se parametrina (vuorojen määrä × vuoron pituus × koneiden määrä − suunnitellut menetykset).
- Kuormituksen ja kapasiteetin on oltava samalla aikajaksotuksella ja samassa yksikössä, muuten mittari ei ole tulkittavissa.
- Yli 100 %:n kuormitusaste ei tarkoita ylityötä vaan sitä, että suunnitelma ei mahdu kapasiteettiin. Se on suunnitteluvirhe, joka kannattaa nostaa esiin.

#### 5.12 Vapaa kapasiteetti tai kapasiteettivaje

- **Mitä mittaa:** Kapasiteetin ja kuormituksen erotuksen. Kertoo, voidaanko uusia töitä ottaa vastaan.
- **Mittayksikkö:** h tai standardih; osuus %
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, viikko
- **Tietolähde:** `fact_workphases` + kapasiteettitieto
- **Tila:** Edellyttää yrityskohtaista määrittelyä (tehollinen kapasiteetti)

**Laskentakaava (tekniset nimet):**
```text
Tehollinen kapasiteetti − Työpisteen kokonaiskuormitus
Puskurin osuus = (Tehollinen kapasiteetti − kuormitus) / Tehollinen kapasiteetti * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Tehollinen kapasiteetti − Suunniteltu kuormitus
```

**Huomiot ja rajoitteet:**
- Negatiivinen arvo on kapasiteettivaje.
- Kapasiteettipuskuri on tarkoituksellinen: täyteen kuormitettu tuotanto ei kestä häiriöitä eikä kiiretöitä. Tavoitetaso on päätettävä, tietomalli ei sitä sisällä.
- Pullonkaulaksi tunnistetun työkeskuksen marginaali on tärkein yksittäinen luku toimituskyvyn ennakoinnissa.

#### 5.13 Kuormitushorisontti

- **Mitä mittaa:** Kuinka pitkäksi ajaksi nykyinen työjono kuormittaa resurssin.
- **Mittayksikkö:** päivää tai viikkoa
- **Tarkastelutaso:** työkeskus, työkeskusryhmä
- **Tietolähde:** `fact_workphases` + kapasiteettitieto
- **Tila:** Edellyttää yrityskohtaista määrittelyä (tehollinen kapasiteetti)

**Laskentakaava (tekniset nimet):**
```text
Työjonon kuormitus / (Tehollinen kapasiteetti per päivä)
```

**Laskentakaava (semanttiset nimet):**
```text
Työjonon kuormitus / Päiväkohtainen tehollinen kapasiteetti
```

**Huomiot ja rajoitteet:**
- Havainnollisempi luku myyntikeskusteluun kuin kuormitusprosentti: se kertoo suoraan, mistä eteenpäin uusi työ voidaan luvata.
- Ei ota huomioon töiden prioriteetteja eikä myöhässä olevaa kuormaa, joten se on optimistinen arvio.

#### 5.14 Osoitettu kapasiteetti

- **Mitä mittaa:** Historiatiedon perusteella todella saavutetun kapasiteetin. Toimii tehollisen kapasiteetin realistisuustarkistuksena.
- **Mittayksikkö:** standardih/jakso
- **Tarkastelutaso:** työkeskus, työkeskusryhmä, viikko, kuukausi
- **Tietolähde:** `fact_workphases` + `dim_date`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
AVG(SUM(produced_qty * unit_time_planned_min)) valituilta vertailujaksoilta
  GROUP BY workcenter_id, jakso
```

**Laskentakaava (semanttiset nimet):**
```text
KESKIARVO(jakson toteutunut tuotanto standarditunteina)
```

**Huomiot ja rajoitteet:**
- Ei vaadi kapasiteettiparametria, joten tämä on käytännöllisin kapasiteettimittari ennen kapasiteettikalenterin lisäämistä.
- Vertailujaksot on valittava edustaviksi: lomakaudet ja poikkeukselliset ruuhkat vääristävät keskiarvoa.

#### 5.15 Työkeskusryhmän kuormitustasapaino

- **Mitä mittaa:** Kuinka tasaisesti kuorma jakautuu ryhmän koneiden kesken.
- **Mittayksikkö:** h tai %
- **Tarkastelutaso:** työkeskusryhmä, viikko, kuukausi
- **Tietolähde:** `fact_workphases` + `dim_workcenter_group`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
STDDEV(kuormitus) GROUP BY workcenter_group_id
  tai (MAX(kuormitus) − MIN(kuormitus)) / AVG(kuormitus) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Työkeskusten kuormitusten hajonta ryhmiteltynä Työkeskusryhmä ID
```

**Huomiot ja rajoitteet:**
- Mielekäs vain, jos ryhmän koneet ovat aidosti keskenään vaihtoehtoisia. Jos koneilla on eri kyvykkyydet, epätasapaino on väistämätön eikä kerro suunnittelusta.
- Kertoo hienokuormituksen toimivuudesta nopeammin kuin yksittäisen koneen kuormitusaste.

#### 5.16 Poikkeamien määrä ja keskimääräinen kesto

- **Mitä mittaa:** Kuinka usein häiriöitä esiintyy ja kuinka kauan ne kestävät.
- **Mittayksikkö:** kpl, min ja min/poikkeama
- **Tarkastelutaso:** kone, työkeskusryhmä, poikkeamatyyppi, vuoro, kuukausi
- **Tietolähde:** `fact_machine_events` + `dim_exception`, `dim_event_type`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (poikkeamien luokittelu)

**Laskentakaava (tekniset nimet):**
```text
Määrä         = COUNT(machine_event_id) WHERE event_type_id IN (4, 15)
Kokonaisaika  = SUM(exception_min)
Keskim. kesto = SUM(exception_min) / COUNT(poikkeamat)
```

**Laskentakaava (semanttiset nimet):**
```text
Poikkeamatapahtumien lukumäärä, SUMMA(Poikkeama min) ja niiden osamäärä
```

**Huomiot ja rajoitteet:**
- Konetapahtumataulun poikkeamat ovat koneen häiriötiloja, eivät kunnossapidon vikailmoituksia. Mittari kuvaa tuotannon menetettyä aikaa, ei korjausaikaa, joten se ei ole varsinainen MTBF tai MTTR.
- Kunnossapidon näkökulmasta lasketut vastineet (häiriöiden välinen käyntiaika `SUM(machine_active_min) / poikkeamien määrä`) ovat käyttökelpoisia vain, jos `dim_exception.exception_type` erottelee todelliset viat muista poikkeamista.
- Pareto-analyysi `exception_id`-kentän kautta kohdistaa kehitystyön tehokkaimmin.

#### 5.17 Suunnittelemattomien seisokkien osuus

- **Mitä mittaa:** Vikojen ja muiden ennakoimattomien häiriöiden osuuden suunnitellusta tuotantoajasta.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, työkeskusryhmä, vuoro, kuukausi
- **Tietolähde:** `fact_machine_events`
- **Tila:** Edellyttää yrityskohtaista määrittelyä (suunnittelemattoman seisokin rajaus)

**Laskentakaava (tekniset nimet):**
```text
SUM(exception_min + undefined_idle_min) / Suunniteltu tuotantoaika * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Poikkeama min + Muu odotusaika min) / Suunniteltu tuotantoaika * 100
```

**Huomiot ja rajoitteet:**
- Kohdistamaton tyhjäkäynti (`undefined_idle_min`) ei ole automaattisesti suunnittelematon seisokki. Sen sisällyttäminen on määrittelykysymys ja vaikuttaa lukuun merkittävästi.
- Häiriösyyt on kirjattava vakioluokituksella, muuten mittari ei ohjaa toimenpiteisiin.

#### 5.18 Ylläpitoajan osuus

- **Mitä mittaa:** Huoltoon ja ylläpitoon kuluneen ajan osuuden.
- **Mittayksikkö:** % (myös min tai h absoluuttisena)
- **Tarkastelutaso:** kone, työkeskusryhmä, kuukausi, vuosi
- **Tietolähde:** `fact_machine_events` + `dim_event_type`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(duration_min) WHERE event_type_id = 5
  / SUM(duration_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Kesto min) ylläpitotapahtumilta / SUMMA(Kesto min) * 100
```

**Huomiot ja rajoitteet:**
- Mittari kertoo toteutuneesta ylläpidosta. Ennakkohuollon toteutumisastetta ei voi laskea, koska tietomallissa ei ole huoltosuunnitelmaa eikä eräpäiviä.
- Laskeva ylläpitoaika yhdessä nousevan poikkeama-ajan kanssa on varoitusmerkki; mittareita kannattaa katsoa yhdessä.

#### 5.19 Energiankulutus ja sen suhdeluvut

- **Mitä mittaa:** Kulutetun energian määrän ja sen suhteen tuotantoon.
- **Mittayksikkö:** kWh, kWh/kpl, kWh/h ja %
- **Tarkastelutaso:** kone, nimike, ohjelma, työvaihe, vuoro, kuukausi
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Kulutus yhteensä   = SUM(power_consumption_kwh)
Kappaletta kohti   = SUM(power_consumption_kwh) / SUM(produced_qty_machine)
Käyntituntia kohti = SUM(power_consumption_kwh) / (SUM(machine_active_min) / 60)
Tyhjäkäynnin osuus = SUM(power_consumption_kwh) WHERE event_type_id = 14
                       / SUM(power_consumption_kwh) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Energiankulutus kWh) sekä sen suhde
  Tuotettu määrä konedata -kenttään ja Työstöaika min -kenttään
```

**Huomiot ja rajoitteet:**
- Edellyttää, että `power_consumption_kwh` on täytetty luotettavasti; kaikilla koneilla mittausta ei ole.
- Käytä leimausperusteista tuotantomäärää, jos konedatan määrä ei ole luotettava.
- Energiakustannus (`kulutus × sähkön yksikköhinta`) edellyttää hintatiedon tuomista erikseen, sitä ei ole tietomallissa.
- Tyhjäkäynnin energiaosuus tukee sammutuskäytäntöjen kehittämistä ja täydentää sammutusajan tarkastelua.

#### 5.20 Miehittämättömän ajon osuus

- **Mitä mittaa:** Kuinka suuri osa koneajasta ajetaan ilman käyttäjää. Automaatioasteen seurantamittari.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, työkeskusryhmä, vuoro, kuukausi
- **Tietolähde:** `fact_machine_events` (`event_type_id = 18` sekä työstötapahtumat)
- **Tila:** Edellyttää yrityskohtaista määrittelyä (läsnäolotiedon keruu)

**Laskentakaava (tekniset nimet):**
```text
SUM(machine_active_min) ilman päällekkäistä event_type_id = 18 -jaksoa
  / SUM(machine_active_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Työstöaika ilman käyttäjän läsnäoloa / Työstöaika yhteensä * 100
```

**Huomiot ja rajoitteet:**
- Edellyttää, että käyttäjän läsnäolo kirjataan tapahtumatyypillä 18 joko leimauksesta tai antureista. Ilman sitä mittaria ei voi laskea.
- Aikajaksojen päällekkäisyyden laskenta vaatii aikaleimapohjaisen käsittelyn (`start_at`, `end_at`), ei pelkkää summausta.

#### 5.21 Käyttäjä- ja vuorokohtainen tarkastelu

- **Mitä mittaa:** Tuottavuuden, asetusaikojen ja laadun erot vuorojen ja käyttäjäryhmien välillä.
- **Mittayksikkö:** mittarikohtainen
- **Tarkastelutaso:** vuoro, käyttäjä, käyttäjäryhmä, kuukausi
- **Tietolähde:** `fact_machine_events` + `dim_time`, `dim_user`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Mikä tahansa edellä kuvattu mittari ryhmiteltynä
  dim_time.shift_id tai fact_machine_events.user_id mukaan
esim. AVG(setup_time_min) GROUP BY user_id, article_id
```

**Laskentakaava (semanttiset nimet):**
```text
Mittari ryhmiteltynä Vuoro ID tai Käyttäjä ID mukaan
```

**Huomiot ja rajoitteet:**
- Käyttäjätason tuloksia käsitellään ryhmätasolla ja perehdytyksen kohdentamiseen, ei henkilöarviointiin. Tämä on syytä sopia ennen mittarin käyttöönottoa.
- Vuorojen väliset erot selittyvät usein työn sisällöstä, eivät suorituksesta. Vertailu edellyttää samankaltaista työkantaa, esimerkiksi rajausta samaan nimikkeeseen.
- Vuorotieto on käytettävissä vain, jos `dim_time.shift_id` on täytetty.

#### 5.22 Uusien nimikkeiden osuus ja kustannuspoikkeama

- **Mitä mittaa:** Kuinka suuri osa tuotannosta on uustuotantoa ja kuinka paljon heikommin kustannusarviot osuvat siinä.
- **Mittayksikkö:** % ja %-yks.
- **Tarkastelutaso:** nimike, asiakas, myyjä, kuukausi
- **Tietolähde:** `fact_order_rows`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
Osuus       = COUNT(order_row_id WHERE new_article = TRUE) / COUNT(order_row_id) * 100
Poikkeamaero = Jälkilaskennan poikkeama-% (new_article = TRUE)
                 − Jälkilaskennan poikkeama-% (new_article = FALSE)
```

**Laskentakaava (semanttiset nimet):**
```text
Uusien nimikkeiden tilausrivit / Kaikki tilausrivit * 100
```

**Huomiot ja rajoitteet:**
- Uustuotannon osuus selittää usein kustannus- ja aikataulupoikkeamia paremmin kuin mikään yksittäinen tehokkuusmittari. Kannattaa ottaa käyttöön muiden poikkeamamittareiden selittäjänä.
- `new_article`-kentän määrittelysääntö on yrityskohtainen ja se on dokumentoitava, jotta aikasarja pysyy vertailukelpoisena.

**Tietomallin laajennusta vaativat mittarit tässä ryhmässä:** ennakkohuollon toteutumisaste (huoltosuunnitelma ja eräpäivät), kapasiteetin palautumisaika (tieto käytettävissä olevasta lisäkapasiteetista), kiirekuorman osuus (kiireellisyyskenttä) sekä työkeskuskohtainen kapasiteettikalenteri, joka poistaisi tarpeen tuoda tehollinen kapasiteetti parametrina.

## Datan laadun tarkastus

Datan laadun ja kattavuuden arviointiinkin voidaan määrittää omia mittareitaan.

Nämä mittarit eivät kuvaa tuotantoa vaan mittariston luotettavuutta. Ne kannattaa ottaa käyttöön ensimmäisten joukossa, koska ilman niitä ei tiedetä, onko muiden mittareiden tulos oikea vai puuttuvasta datasta johtuva. Jokaiselle kannattaa asettaa hälytysraja, jonka alittuessa siihen perustuvia mittareita ei julkaista.

#### 6.1 Aikojen kohdistusaste

- **Mitä mittaa:** Kuinka suuri osa konetapahtuman kestosta on saatu kohdistettua tila-aikoihin. Tietomalliin on rakennettu tätä varten oma tarkistuskenttä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, tietolähde, tapahtumatyyppi, päivä
- **Tietolähde:** `fact_machine_events` + `dim_source`, `dim_event_type`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(time_sum_min) / SUM(duration_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Aikojen summa min) / SUMMA(Kesto min) * 100
```

**Huomiot ja rajoitteet:**
- Tavoitearvo on 100 %. Poikkeama alaspäin tarkoittaa puuttuvaa aikaa, poikkeama ylöspäin päällekkäin laskettua aikaa.
- Ryhmittely tietolähteen ja tapahtumatyypin mukaan paikantaa ongelman lähteen nopeasti.
- Tämä on koko konedataan perustuvan mittariston edellytys: jos kohdistusaste on heikko, käytettävyys, seisokkiaste ja koneajan rakenne ovat epäluotettavia.

#### 6.2 Kohdistamattoman ajan osuus

- **Mitä mittaa:** Kuinka suuri osa ajasta jää luokittelematta mihinkään tilaan.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, tietolähde, tapahtumatyyppi, kuukausi
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(other_min) / SUM(duration_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Muu aika min) / SUMMA(Kesto min) * 100
```

**Huomiot ja rajoitteet:**
- Täydentää mittaria 6.1: kohdistusaste kertoo kokonaisuuden, tämä kertoo tunnistetun mutta luokittelemattoman ajan.
- Osuuden pienentyminen ajan myötä on merkki siitä, että tiedonkeruun luokittelusäännöt paranevat.

#### 6.3 Leimaus- ja konedatan poikkeama

- **Mitä mittaa:** Kuinka paljon leimausperusteinen ja konedataperusteinen toteuma eroavat toisistaan. Auttaa valitsemaan ensisijaisen tietolähteen.
- **Mittayksikkö:** %
- **Tarkastelutaso:** työkeskus, käyttäjä, vuoro, nimike, kuukausi
- **Tietolähde:** `fact_workphases`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
(SUM(phase_duration_stamping_min) − SUM(phase_duration_machine_min))
  / SUM(phase_duration_machine_min) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
(Vaiheaika leimattu − Vaiheaika konedata) / Vaiheaika konedata * 100
```

**Huomiot ja rajoitteet:**
- Systemaattinen ero kertoo leimauskurin tasosta: leimaus aloitetaan tai lopetetaan väärään aikaan tai pyöristetään.
- Mittari on laskettavissa vain työvaiheille, joilla molemmat lähteet ovat käytössä. Kattavuus on hyvä raportoida rinnalla.
- Suuri hajonta on merkittävämpi ongelma kuin tasainen poikkeama, koska jälkimmäinen on korjattavissa laskennallisesti.

#### 6.4 Kappalemäärien ristiintarkistus

- **Mitä mittaa:** Vastaavatko leimattu ja konedatasta laskettu tuotantomäärä toisiaan.
- **Mittayksikkö:** kpl
- **Tarkastelutaso:** kone, työvaihe, nimike, päivä
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
SUM(produced_qty_stamping) − SUM(produced_qty_machine)
sekä part_counter-kentän jatkuvuuden tarkistus
```

**Laskentakaava (semanttiset nimet):**
```text
SUMMA(Tuotettu määrä leimausdata) − SUMMA(Tuotettu määrä konedata)
```

**Huomiot ja rajoitteet:**
- Ero paljastaa raportointivirheitä molempiin suuntiin: unohtuneita leimauksia tai koneen laskurin laskemia koeajokappaleita.
- Kappalelaskurin (`part_counter`) nollaukset ja vaihtumiset on käsiteltävä erikseen, muuten erotus antaa virheellisiä arvoja.

#### 6.5 Konetapahtumien kohdistusaste työvaiheisiin

- **Mitä mittaa:** Kuinka suuri osa konedatasta on saatu liitettyä työvaiheeseen. Rajoittaa suoraan nimike- ja tilauskohtaisen analytiikan luotettavuutta.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kone, tietolähde, tapahtumatyyppi, kuukausi
- **Tietolähde:** `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(machine_event_id WHERE workphase_id IS NOT NULL)
  / COUNT(machine_event_id) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Työvaiheeseen liitetyt konetapahtumat / Kaikki konetapahtumat * 100
```

**Huomiot ja rajoitteet:**
- Sama voidaan laskea ajan suhteen (`SUM(duration_min)`), mikä on usein havainnollisempi kuin rivimäärä.
- Osa tapahtumatyypeistä, kuten anturidatan yksittäiset työstötapahtumat (11) ja sammutusajat (16), ei ole tarkoituskaan liittää työhön. Rajaus on tehtävä tapahtumatyypeittäin.

#### 6.6 Kytkemättömien rivien osuus

- **Mitä mittaa:** Kuinka suuri osa tilausriveistä on ilman työvaiheita ja työvaiheista ilman konetapahtumia. Paljastaa katkokset porautumisketjussa.
- **Mittayksikkö:** %
- **Tarkastelutaso:** asiakas, nimike, työkeskus, kuukausi
- **Tietolähde:** `fact_order_rows`, `fact_workphases`, `fact_machine_events`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(order_row_id ilman fact_workphases-riviä) / COUNT(order_row_id) * 100
COUNT(workphase_id ilman fact_machine_events-riviä) / COUNT(workphase_id) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Työvaiheettomat tilausrivit / Kaikki tilausrivit * 100
Konetapahtumattomat työvaiheet / Kaikki työvaiheet * 100
```

**Huomiot ja rajoitteet:**
- Osa tilausriveistä on aidosti ilman tuotantoa, esimerkiksi kauppatavara. Ne on rajattava pois, muuten mittari näyttää jatkuvasti huonolta.
- Vaikuttaa suoraan tuntikatteeseen (3.10) ja kaikkiin mittareihin, joissa yhdistetään tilausrivin arvo ja tuotannon aika.

#### 6.7 Toteumatietojen kattavuus

- **Mitä mittaa:** Kuinka suuri osa keskeisistä toteumakentistä on täytetty.
- **Mittayksikkö:** %
- **Tarkastelutaso:** kenttä, taulu, kuukausi, tietolähde
- **Tietolähde:** kaikki faktataulut
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(rivit joilla kenttä IS NULL) / COUNT(rivit) * 100
  esim. start_timestamp_actual, end_timestamp_actual,
        prime_cost_actual_sum, delivered_qty
```

**Laskentakaava (semanttiset nimet):**
```text
Puuttuvat arvot / Kaikki rivit * 100 kentittäin
```

**Huomiot ja rajoitteet:**
- Tee erikseen suunnitelluille ja toteutuneille kentille; suunnittelupuoli on yleensä kattava ja toteumapuoli puutteellinen.
- Keskeneräiset työt tuottavat luonnollisesti tyhjiä toteumakenttiä, joten laskenta on rajattava valmistuneisiin riveihin.
- Puuttuvien arvojen osuus kannattaa raportoida jokaisen kustannus- ja aikamittarin yhteydessä, jotta lukija tietää, mihin osaan aineistosta luku perustuu.

#### 6.8 Ihannesykliajan kattavuus

- **Mitä mittaa:** Kuinka suurelle osalle työvaiheista tavoitesykliaika on määritelty. OEE:n nopeuskomponentin laskettavuus riippuu suoraan tästä.
- **Mittayksikkö:** %
- **Tarkastelutaso:** nimike, nimikeryhmä, työkeskus, kuukausi
- **Tietolähde:** `fact_workphases` + `dim_article`
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(workphase_id WHERE cycle_time_ideal_min IS NOT NULL)
  / COUNT(workphase_id) * 100
```

**Laskentakaava (semanttiset nimet):**
```text
Työvaiheet, joilla Kappale jaksoaika tavoite on täytetty / Kaikki työvaiheet * 100
```

**Huomiot ja rajoitteet:**
- Kannattaa painottaa tuotantoajalla, ei rivimäärällä: tärkeintä on, että eniten kapasiteettia vievillä nimikkeillä tavoiteaika on määritelty.
- Kattavuuden nosto on käytännössä edellytys sille, että OEE:n nopeus (2.5) ja koko OEE (2.7) ovat määritelmän mukaisia.

#### 6.9 Ristiriitaiset kirjaukset

- **Mitä mittaa:** Rivien määrän, joissa data on loogisesti mahdotonta.
- **Mittayksikkö:** kpl
- **Tarkastelutaso:** taulu, kone, tietolähde, kuukausi
- **Tietolähde:** kaikki faktataulut
- **Tila:** Laskettavissa suoraan

**Laskentakaava (tekniset nimet):**
```text
COUNT(end_at < start_at)
COUNT(produced_qty = 0 AND duration_min > 0)
COUNT(rejected_qty > produced_qty)
COUNT(end_date_actual < start_date_actual)
```

**Laskentakaava (semanttiset nimet):**
```text
Rivit, joilla lopetus on ennen aloitusta, hylkyjä enemmän kuin tuotantoa
  tai aikaa ilman tuotantomäärää
```

**Huomiot ja rajoitteet:**
- Nämä tarkistukset kannattaa ajaa osana latausprosessia, ei vasta raportilla.
- Nollatuotantomäärälliset tuotantotapahtumat eivät aina ole virheitä: ne voivat olla keskeytyneitä töitä tai koeajoja. Tapaukset on syytä käydä läpi ennen sääntöjen kiristämistä.
  