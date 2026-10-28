# Mittaustiedon tietomalli

**Tietomallin versio:** 1.1
**Viimeksi päivitetty:** 2026-10-23

Tässä tiedostossa kuvataan tuotantotiedon tietomallin laajennus kappaleiden mittaustiedolle. Malli on tarkoitettu eri lähteistä tulevien mittaustulosten yhdistämiseen, laadun seurantaan ja tilastolliseen prosessinohjaukseen. Malli täydentää tuotantotiedon tietomallia ja käyttää sen olemassa olevia työ-, työvaihe-, nimike-, työkeskus-, käyttäjä-, päivämäärä- ja aikarakenteita.

Mittaustiedon ydinketju on:

Mittausraportti → Mittaustulokset → Mittauskohde

Yksi mittausraportti kuvaa yhtä mittauskertaa, mittausajoa tai mittauspöytäkirjaa. Yhdellä mittausraportilla voi olla useita yksittäisiä mittaustuloksia. Jokainen mittaustulos liittyy yhteen mittauskohteeseen.

## Faktataulut

### Mittausraporttitaulu (`fact_measurement_reports`)

**Taulun kuvaus:**  
Mittauskerran, mittausajon tai mittauspöytäkirjan yhteiset tiedot. Taulu yhdistää mittaustulokset tuotannon kontekstiin. Mittaus voi liittyä yksittäiseen kappaleeseen, työhön tai työvaiheeseen. Kaikki tunnisteet eivät ole aina saatavilla, joten osa viiteavaimista voi olla tyhjiä.

Taulun rakeisuus on yksi mittauskerta tai mittausraportti.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
|---|---|---|---|
| Mittausraportti ID | `measurement_report_id` | PK / bigint | Mittausraportin yksilöivä avain. |
| Mittauslähde ID | `measurement_source_id` | FK / bigint | Mittaustiedon lähde. Yhdistyy `dim_measurement_source`-tauluun. |
| Lähteen raporttitunnus | `source_report_identifier` | text | Lähdejärjestelmän raportti-, tiedosto- tai mittausajotunnus. |
| Kappaleen sarjanumero | `part_serial_number` | text | Mitatun kappaleen sarjanumero, jos kappaleella on pysyvä tunniste. |
| Kappaleen lähdetunniste | `part_source_identifier` | text | Lähteen käyttämä kappaletunniste, esimerkiksi koneen kappalelaskuri tai mittausjärjestelmän kappalenumero. |
| Työvaihe ID | `workphase_id` | FK / bigint | Yhdistää mittauksen `fact_workphases`-tauluun, jos työvaihe tunnetaan. |
| Työ ID | `work_id` | bigint | Tuotantotilauksen yksilöivä tunniste yhdistelyä varten. |
| Työnumero | `work_number` | text | Tuotantotilauksen liiketoimintatunniste. |
| Tilausrivi ID | `order_row_id` | FK / bigint | Yhdistää mittauksen `fact_order_rows`-tauluun, jos yhteys tunnetaan. |
| Nimike ID | `article_id` | FK / bigint | Mitatun nimikkeen tunniste. Yhdistyy `dim_article`-tauluun. |
| Työkeskus ID | `workcenter_id` | FK / bigint | Valmistuksessa tai mittauksessa käytetty pääasiallinen kone tai työpiste. Yhdistyy `dim_workcenter`-tauluun. |
| Käyttäjä ID | `user_id` | FK / bigint | Mittauksen suorittajan tunniste, jos saatavilla. Yhdistyy `dim_user`-tauluun. |
| Mittaväline ID | `measurement_instrument_id` | FK / bigint | Mittauskerralla käytetty ensisijainen mittaväline. Yhdistyy `dim_measurement_instrument`-tauluun. |
| Mittauspäivä | `measurement_date` | FK / integer | Mittauspäivä muodossa YYYYMMDD. Yhdistyy `dim_date`-tauluun. |
| Mittausaika | `measurement_time` | FK / integer | Mittausaika muodossa HHMMSS. Yhdistyy `dim_time`-tauluun. |
| Mittauksen aikaleima | `measured_at` | timestamptz | Mittaushetki aikavyöhykkeellisenä aikaleimana. |
| Valmistuksen aikaleima | `manufactured_at` | timestamptz | Kappaleen valmistumishetki, jos saatavilla. Tukee mittausten järjestämistä valmistusjärjestykseen. |
| Kappaleen järjestysnumero | `part_sequence_number` | integer | Kappaleen järjestysnumero työn tai tuotantosarjan sisällä, jos saatavilla. |
| Mittausmenetelmä | `measurement_method` | text | Esimerkiksi manuaalimittaus, mittakone tai työstökoneen mittapää. |
| Mittauksen tarkoitus | `inspection_type` | text | Esimerkiksi ensikappale, prosessinäyte, lopputarkastus tai uusintamittaus. |
| Raaka-aineaihion eränumero | `raw_material_lot_number` | text | Aihion tai materiaalierän jäljitettävyystunnus. Ei muodosta erillistä BatchID-rakennetta. |
| NC-ohjelman nimi | `nc_program_name` | text | Kappaleen valmistuksessa käytetyn NC-ohjelman nimi tai tunnus. |
| NC-ohjelman versio | `nc_program_version` | text | NC-ohjelman versionumero, jos saatavilla. |
| NC-ohjelmaa muokattu | `nc_program_modified_at` | timestamptz | Ohjelman edellinen muokkausajankohta, jos versionumeroa ei ole. |
| Työvaiheistuksen versio | `routing_version` | text | ERP:n työvaiheistuksen versionumero, jos saatavilla. |
| Työvaiheistusta muokattu | `routing_modified_at` | timestamptz | Työvaiheistuksen edellinen muokkausajankohta. |
| Piirustusnumero | `drawing_number` | text | Valmistuksessa ja mittauksessa käytetyn piirustuksen tunniste. |
| Piirustusrevisio | `drawing_revision` | text | Käytetyn piirustuksen revisio. |
| Päämiehen ostotilausnumero | `principal_purchase_order_number` | text | Päämiehen ostotilausnumero, jos sitä tarvitaan jäljitettävyyteen. |
| Toimittajan viite | `supplier_order_reference` | text | Toimittajan viite päämiehen ostotilaukselle. |
| Raportin tila | `report_status` | text | Mittausraportin tila, esimerkiksi hyväksytty, hylätty, keskeneräinen tai arvioimatta. |
| Lähdetiedoston nimi | `source_file_name` | text | Alkuperäisen tiedoston nimi jäljitettävyyttä ja duplikaattien tunnistamista varten. |
| Latauksen aikaleima | `loaded_at` | timestamptz | Tiedon lataushetki tietovarastoon. |
| Lisätiedot | `notes` | text | Mittauskertaan liittyvät huomautukset. |

#### Tärkeimmät johdetut arvot

Mittausraportin tiedoista voidaan johtaa seuraavia arvoja:

- **Mittauksen viive valmistuksesta** = `measured_at - manufactured_at`
- **Mittausraportin tulosten määrä** = raporttiin liittyvien `fact_measurements`-rivien lukumäärä
- **Hyväksyttyjen tulosten määrä** = tulokset, joilla `is_within_specification = TRUE`
- **Toleranssin ulkopuolisten tulosten määrä** = tulokset, joilla `is_within_specification = FALSE`
- **Raportin hyväksyntä** = hyväksytty, jos kaikki arvioitavat mittaustulokset ovat toleranssissa, ellei yritys käytä muuta sääntöä
- **SPC-järjestys** = ensisijaisesti `part_sequence_number` tai `manufactured_at`, toissijaisesti `measured_at`

SPC-laskennassa mittausten järjestys tulee valita prosessin mukaan. Mittausjärjestys ei aina vastaa valmistusjärjestystä, jos kappaleet mitataan myöhemmin mittahuoneessa.

#### Taulun riippuvuudet

| Taulu | Riippuvuus | Suhde | Tarkoitus |
|---|---|---|---|
| `FactMeasurementReports` | `FactMeasurements` | 1:N | Mittausraporttiin kuuluvat yksittäiset mittaustulokset. |
| `FactMeasurementReports` | `FactWorkPhases` | N:1 | Mittauksen yhdistäminen työvaiheeseen. |
| `FactMeasurementReports` | `FactOrderRows` | N:1 | Mittauksen yhdistäminen tilausriviin ja asiakaskontekstiin. |
| `FactMeasurementReports` | `DimArticle` | N:1 | Nimikekohtainen analyysi. |
| `FactMeasurementReports` | `DimWorkcenter` | N:1 | Kone- tai työpistekohtainen analyysi. |
| `FactMeasurementReports` | `DimUser` | N:1 | Mittauksen suorittajaan liittyvä analyysi. |
| `FactMeasurementReports` | `DimMeasurementSource` | N:1 | Mittaustiedon lähteen tunnistaminen. |
| `FactMeasurementReports` | `DimMeasurementInstrument` | N:1 | Mittavälinekohtainen analyysi. |
| `FactMeasurementReports` | `DimDate` | N:1 | Mittauspäivän analyysi. |
| `FactMeasurementReports` | `DimTime` | N:1 | Mittausajan ja työvuoron analyysi. |

#### Taulun luontilause

```sql
CREATE TABLE public.fact_measurement_reports (
    measurement_report_id bigint NOT NULL,
    measurement_source_id bigint,
    source_report_identifier text,
    part_serial_number text,
    part_source_identifier text,
    workphase_id bigint,
    work_id bigint,
    work_number text,
    order_row_id bigint,
    article_id bigint,
    workcenter_id bigint,
    user_id bigint,
    measurement_instrument_id bigint,
    measurement_date integer,
    measurement_time integer,
    measured_at timestamp with time zone,
    manufactured_at timestamp with time zone,
    part_sequence_number integer,
    measurement_method text,
    inspection_type text,
    raw_material_lot_number text,
    nc_program_name text,
    nc_program_version text,
    nc_program_modified_at timestamp with time zone,
    routing_version text,
    routing_modified_at timestamp with time zone,
    drawing_number text,
    drawing_revision text,
    principal_purchase_order_number text,
    supplier_order_reference text,
    report_status text,
    source_file_name text,
    loaded_at timestamp with time zone,
    notes text,
    CONSTRAINT pk_fact_measurement_reports
        PRIMARY KEY (measurement_report_id)
);
```

### Mittaustulostaulu (`fact_measurements`)

**Taulun kuvaus:**  
Yksittäiset mittaustulokset. Yksi rivi kuvaa yhden mittauskohteen yhtä tulosta yhdellä mittauskerralla. Saman mittauskohteen uusinta- ja toistomittaukset tallennetaan erillisiksi riveiksi.

Taulun rakeisuus on yksi mittaustulos.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
|---|---|---|---|
| Mittaus ID | `measurement_id` | PK / bigint | Mittaustuloksen yksilöivä avain. |
| Mittausraportti ID | `measurement_report_id` | FK / bigint | Yhdistää tuloksen `fact_measurement_reports`-tauluun. |
| Mittauskohde ID | `measurement_feature_id` | FK / bigint | Yhdistää tuloksen `dim_measurement_feature`-tauluun. |
| Koneistustyökalu ID | `manufacturing_tool_id` | FK / bigint | Mittauskohteen valmistukseen ensisijaisesti liittyvän koneistustyökalun tunniste. Yhdistyy dim_manufacturing_tool-tauluun. Arvo voi olla tyhjä, jos mittauskohdetta ei voida luotettavasti yhdistää yhteen työkaluun. |
| Työstön käyttötarkoitus | `machining_purpose` | text | Mittauskohteeseen liittyvän koneistustyökalun käyttötarkoitus kyseisen kappaleen valmistuksessa. Sallitut arvot ovat `ROUGHING`, `SEMI_FINISHING`, `FINISHING` ja `GENERAL`. Arvo jätetään tyhjäksi, jos käyttötarkoitusta ei tunneta luotettavasti. |
| Mittausjärjestys | `measurement_sequence_number` | integer | Tuloksen järjestys mittausraportilla tai toistomittausten sarjassa. |
| Mitattu numeroarvo | `measured_value_numeric` | double precision | Numeerinen mittaustulos. |
| Mitattu tekstiarvo | `measured_value_text` | text | Teksti-, luokittelu- tai hyväksyntäarvo, jos tulos ei ole numeerinen. |
| Mittayksikkö | `unit` | text | Mittaustuloksen yksikkö. |
| Nimellisarvo mittaushetkellä | `nominal_value_snapshot` | double precision | Mittauksen arvioinnissa käytetty nimellisarvo. |
| Alempi spesifikaatioraja mittaushetkellä | `lower_specification_limit_snapshot` | double precision | Mittauksen arvioinnissa käytetty alempi hyväksymisraja. |
| Ylempi spesifikaatioraja mittaushetkellä | `upper_specification_limit_snapshot` | double precision | Mittauksen arvioinnissa käytetty ylempi hyväksymisraja. |
| Toleranssialueen keskipiste mittaushetkellä | `tolerance_center_snapshot` | double precision | Mittaushetken alemman ja ylemmän spesifikaatiorajan keskipiste. |
| Poikkeama nimellisarvosta | `deviation_from_nominal` | double precision | Mitatun arvon poikkeama nimellisarvosta. |
| Poikkeama toleranssialueen keskeltä | `deviation_from_tolerance_center` | double precision | Mitatun arvon poikkeama toleranssialueen keskipisteestä. |
| Toleranssissa | `is_within_specification` | boolean | Tieto siitä, onko tulos spesifikaatiorajojen sisällä. |
| Työkalukorjaimen arvo | `tool_offset_value` | double precision | Koneistustyökalulle asetettu korjausarvo kappaleen valmistushetkellä. Arvo voi kuvata esimerkiksi työkalun pituus- tai sädekorjausta. Arvon merkitys ja yksikkö tulee määrittää lähdejärjestelmäkohtaisesti. |
| Työkalukorjaimen muutos | `tool_offset_change` | double precision | Työkalukorjaimen muutos suhteessa työkalun alkuperäiseen, edelliseen tai muuhun määriteltyyn vertailuarvoon. Vertailuperuste tulee dokumentoida. |
| Työkalun käyttöaika mittaushetkellä | `tool_usage_min_snapshot` | double precision | Työkalulle kertynyt käyttöaika minuutteina kappaleen valmistushetkellä. Snapshot-arvo säilyttää työkalun historiallisen käyttötilanteen. |
| Työkalun kappalemäärä mittaushetkellä | `tool_part_count_snapshot` | integer | Työkalulla valmistettujen kappaleiden kumulatiivinen määrä kappaleen valmistushetkellä. |
| Työkalun käyttöikäraja mittaushetkellä | `tool_life_limit_snapshot` | double precision | Koneelle, ohjelmalle tai työkalulle asetettu käyttöikäraja kappaleen valmistushetkellä. Käyttöikärajan yksikkö tulee määrittää erikseen, esimerkiksi minuutteina tai kappaleina. |
| Käytetty osuus työkalun käyttöiästä | `tool_life_used_pct` | double precision | Johdettu prosenttiosuus työkalun käyttöikärajasta. Lasketaan käyttöajan tai kappalemäärän perusteella sen mukaan, kummalla tavalla työkalun käyttöikä on määritelty. |
| Karan kierrosnopeus | `spindle_speed_rpm` | double precision | Työstössä käytetty karan kierrosnopeus kierroksina minuutissa. Jos arvo muuttuu työstön aikana, kenttään tallennetaan erikseen sovitun säännön mukainen arvo, esimerkiksi keskiarvo tai ohjelman asetusarvo. |
| Syöttönopeus | `feed_rate` | double precision | Työstössä käytetty syöttönopeus. Yksikkö tulee määrittää lähdejärjestelmäkohtaisesti, esimerkiksi millimetriä minuutissa tai millimetriä kierrosta kohti. |
| Prosessiparametrit | `process_parameters` | jsonb | Harvemmin käytettävät tai konekohtaiset työstöparametrit avain-arvo-muodossa. Kenttään voidaan tallentaa esimerkiksi lastuamisnopeus, lastuamissyvyys, syöttö kierrosta kohti ja jäähdytysnesteen paine. |
| Tuloksen tila | `result_status` | text | Esimerkiksi kelvollinen, virheellinen, uusittu tai analyysistä poistettu. |
| Poissulkemisen syy | `exclusion_reason` | text | Syy, miksi tulosta ei käytetä analyysissä. |
| Lähteen mittauskohdetunnus | `source_feature_identifier` | text | Lähdejärjestelmän käyttämä mittauskohteen tunniste kohdistuksen tarkistamista varten. |
| Lähteen tulostunnus | `source_measurement_identifier` | text | Lähdejärjestelmän yksittäisen tuloksen tunniste. |
| Lisätiedot | `notes` | text | Mittaustulokseen liittyvät huomautukset. |

Mittaushetken nimellisarvo ja spesifikaatiorajat säilytetään tulosrivillä snapshot-arvoina. Näin historiallinen hyväksyntä ja laskenta eivät muutu, vaikka mittauskohteen nykyisiä tietoja myöhemmin korjataan tai revisio vaihtuu.

#### Tärkeimmät johdetut arvot

```text
lower_specification_limit
  = nominal_value + lower_tolerance_deviation

upper_specification_limit
  = nominal_value + upper_tolerance_deviation

tolerance_center
  = (lower_specification_limit + upper_specification_limit) / 2

deviation_from_nominal
  = measured_value_numeric - nominal_value_snapshot

deviation_from_tolerance_center
  = measured_value_numeric - tolerance_center_snapshot

is_within_specification
  = measured_value_numeric >= lower_specification_limit_snapshot
    AND measured_value_numeric <= upper_specification_limit_snapshot
```

Mittaustuloksista voidaan lisäksi laskea:

- mittauskohteen keskiarvo, mediaani ja keskihajonta
- pienin ja suurin arvo sekä vaihteluväli
- toleranssin ulkopuolisten tulosten määrä ja osuus
- liukuva keskiarvo ja liukuva vaihteluväli
- yksittäisten havaintojen ja liukuvan vaihteluvälin I-MR-ohjauskortti
- aliryhmien X̄-R- tai X̄-S-ohjauskortti, jos näytteenottotapa ja aliryhmät on määritetty
- Cp-, Cpk-, Pp- ja Ppk-tunnusluvut valitulle vertailukelpoiselle havaintojoukolle

Spesifikaatiorajat eivät ole SPC-ohjausrajoja. Spesifikaatiorajat tulevat piirustuksesta tai muusta vaatimuksesta. Ohjausrajat lasketaan prosessin toteutuneista mittaustuloksista.

SPC-laskennassa tulee käyttää vain keskenään vertailukelpoisia havaintoja, esimerkiksi samaa nimikettä, mittauskohdetta, konetta, mittausmenetelmää ja prosessiversiota. Ohjelma-, työkalu-, materiaali- tai menetelmämuutos voi edellyttää uuden tarkastelujakson aloittamista.

#### Taulun riippuvuudet

| Taulu | Riippuvuus | Suhde | Tarkoitus |
|---|---|---|---|
| `FactMeasurements` | `FactMeasurementReports` | N:1 | Mittaustuloksen yhteiset tuotanto- ja lähdetiedot. |
| `FactMeasurements` | `DimMeasurementFeature` | N:1 | Mittauskohteen nimi, tyyppi, yksikkö, nimellisarvo ja toleranssit. |
| `FactMeasurements` | `DimManufacturingTool` | N:1 | Mittaustuloksen yhteys ensisijaiseen koneistustyökaluun. |

#### Taulun luontilause

```sql
CREATE TABLE public.fact_measurements (
    measurement_id bigint NOT NULL,
    measurement_report_id bigint NOT NULL,
    measurement_feature_id bigint NOT NULL,
    manufacturing_tool_id bigint,
    machining_purpose text,
    measurement_sequence_number integer,
    measured_value_numeric double precision,
    measured_value_text text,
    unit text,
    nominal_value_snapshot double precision,
    lower_specification_limit_snapshot double precision,
    upper_specification_limit_snapshot double precision,
    tolerance_center_snapshot double precision,
    deviation_from_nominal double precision,
    deviation_from_tolerance_center double precision,
    is_within_specification boolean,
    tool_offset_value double precision,
    tool_offset_change double precision,
    tool_usage_min_snapshot double precision,
    tool_part_count_snapshot integer,
    tool_life_limit_snapshot double precision,
    tool_life_used_pct double precision,
    spindle_speed_rpm double precision,
    feed_rate double precision,
    process_parameters jsonb,
    result_status text,
    exclusion_reason text,
    source_feature_identifier text,
    source_measurement_identifier text,
    notes text,
    CONSTRAINT pk_fact_measurements
        PRIMARY KEY (measurement_id),
    CONSTRAINT chk_fact_measurements_machining_purpose
        CHECK (
            machining_purpose IS NULL
            OR machining_purpose IN (
                'ROUGHING',
                'SEMI_FINISHING',
                'FINISHING',
                'GENERAL'
            )
        )
);
```

## Ulottuvuustaulut

### Mittauskohdetaulu (`dim_measurement_feature`)

**Taulun kuvaus:**  
Nimikkeen mitattavan ominaisuuden eli mittauskohteen määrittely. Mittauskohde voi olla esimerkiksi halkaisija, pituus, kulma, tasomaisuus, pinnankarheus tai hyväksyntämerkintä.

Mittauskohteen tunnisteen tulee olla yksiselitteinen saman nimikkeen ja revision sisällä. Esimerkiksi `D61_01` ja `D61_02` erottavat kaksi halkaisijaltaan samanlaista mutta eri sijainnissa olevaa mittauskohdetta.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
|---|---|---|---|
| Mittauskohde ID | `measurement_feature_id` | PK / bigint | Mittauskohteen yksilöivä avain. |
| Nimike ID | `article_id` | FK / bigint | Mittauskohteen nimike. Yhdistyy `dim_article`-tauluun. |
| Mittauskohteen koodi | `feature_code` | text | Lähteiden välillä sovittu yksiselitteinen tunniste. |
| Mittauskohteen nimi | `feature_name` | text | Ihmiselle luettava nimi tai piirustusmerkintä. |
| Vaihtoehtoinen nimi | `feature_name_other` | text | Esimerkiksi mittausohjelmiston tai työstökoneen käyttämä nimi. |
| Mittauskohteen tyyppi | `feature_type` | text | Esimerkiksi halkaisija, pituus, kulma, tasomaisuus tai pinnankarheus. |
| Arvotyyppi | `value_type` | text | Numeerinen, totuusarvo, teksti tai luokittelu. |
| Mittayksikkö | `unit` | text | Esimerkiksi mm, µm tai aste. |
| Nimellisarvo | `nominal_value` | double precision | Mittauskohteen nimellisarvo. |
| Alempi toleranssipoikkeama | `lower_tolerance_deviation` | double precision | Alatoleranssin poikkeama nimellisarvosta. |
| Ylempi toleranssipoikkeama | `upper_tolerance_deviation` | double precision | Ylätoleranssin poikkeama nimellisarvosta. |
| Alempi spesifikaatioraja | `lower_specification_limit` | double precision | Absoluuttinen alempi hyväksymisraja. |
| Ylempi spesifikaatioraja | `upper_specification_limit` | double precision | Absoluuttinen ylempi hyväksymisraja. |
| Piirustusnumero | `drawing_number` | text | Piirustus, jossa mittauskohde on määritelty. |
| Piirustusrevisio | `drawing_revision` | text | Piirustuksen revisio. |
| SPC käytössä | `spc_enabled` | boolean | Tieto siitä, seurataanko mittauskohdetta SPC-analyysillä. |
| Voimassa alkaen | `valid_from` | date | Mittauskohteen määrittelyn voimassaolon alku. |
| Voimassa asti | `valid_to` | date | Määrittelyn voimassaolon loppu. |
| Nykyinen versio | `is_current` | boolean | Tieto siitä, onko kyseessä nykyinen määrittely. |
| Lisätiedot | `notes` | text | Mittausohjeet ja muut tarkennukset. |

Nominaali- tai toleranssiarvon muuttuessa vanhaa riviä ei tule ylikirjoittaa. Muutoksesta muodostetaan uusi mittauskohteen versio, jotta vanhat mittaustulokset voidaan tulkita alkuperäisiä vaatimuksia vasten.

#### Taulun luontilause

```sql
CREATE TABLE public.dim_measurement_feature (
    measurement_feature_id bigint NOT NULL,
    article_id bigint,
    feature_code text,
    feature_name text,
    feature_name_other text,
    feature_type text,
    value_type text,
    unit text,
    nominal_value double precision,
    lower_tolerance_deviation double precision,
    upper_tolerance_deviation double precision,
    lower_specification_limit double precision,
    upper_specification_limit double precision,
    drawing_number text,
    drawing_revision text,
    spc_enabled boolean,
    valid_from date,
    valid_to date,
    is_current boolean,
    notes text,
    CONSTRAINT pk_dim_measurement_feature
        PRIMARY KEY (measurement_feature_id)
);
```

### Mittauslähdetaulu (`dim_measurement_source`)

**Taulun kuvaus:**  
Mittaustiedon järjestelmä- tai integraatiolähde. Taulu on erillinen tuotantotiedon tietomallin `dim_source`-taulusta, jota käytetään konetapahtumien lähteiden luokitteluun.

Mittauslähde kertoo, mistä järjestelmästä tai tiedonsiirtokanavasta mittaustieto saapui. Se ei välttämättä ole sama asia kuin fyysinen mittaväline.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
|---|---|---|---|
| Mittauslähde ID | `measurement_source_id` | PK / bigint | Mittauslähteen yksilöivä avain. |
| Mittauslähteen nimi | `measurement_source_name` | text | Järjestelmän, sovelluksen tai integraation nimi. |
| Mittauslähteen tyyppi | `measurement_source_type` | text | Esimerkiksi mittakone, työstökone, manuaalinen sovellus, tiedosto tai ERP. |
| Mittauslähteen kuvaus | `measurement_source_description` | text | Lähteen ja sen sisältämän tiedon kuvaus. |
| Aktiivinen | `is_active` | boolean | Tieto siitä, onko lähde käytössä. |

#### Taulun luontilause

```sql
CREATE TABLE public.dim_measurement_source (
    measurement_source_id bigint NOT NULL,
    measurement_source_name text,
    measurement_source_type text,
    measurement_source_description text,
    is_active boolean,
    CONSTRAINT pk_dim_measurement_source
        PRIMARY KEY (measurement_source_id)
);
```

### Mittavälinetaulu (`dim_measurement_instrument`)

**Taulun kuvaus:**  
Mittauksessa käytetyn fyysisen mittavälineen, mittakoneen tai koneen mittapään perustiedot. Taulua käytetään mittavälinekohtaiseen jäljitettävyyteen ja tulosten vertailuun.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
|---|---|---|---|
| Mittaväline ID | `measurement_instrument_id` | PK / bigint | Mittavälineen yksilöivä avain. |
| Mittavälineen tunnus | `instrument_code` | text | Yrityksen käyttämä laite- tai kalustotunnus. |
| Mittavälineen nimi | `instrument_name` | text | Mittavälineen nimi. |
| Mittavälineen tyyppi | `instrument_type` | text | Esimerkiksi työntömitta, mikrometri, mittakone tai koneen mittapää. |
| Valmistaja | `manufacturer` | text | Mittavälineen valmistaja. |
| Malli | `model` | text | Mittavälineen malli. |
| Sarjanumero | `serial_number` | text | Mittavälineen sarjanumero. |
| Työkeskus ID | `workcenter_id` | FK / bigint | Työkeskus, johon kiinteä mittalaite tai mittapää kuuluu. |
| Kalibrointi voimassa asti | `calibration_valid_until` | date | Kalibroinnin voimassaolon päättymispäivä, jos saatavilla. |
| Aktiivinen | `is_active` | boolean | Tieto siitä, onko mittaväline käytössä. |
| Lisätiedot | `notes` | text | Mittavälineeseen liittyvät lisätiedot. |

#### Taulun luontilause

```sql
CREATE TABLE public.dim_measurement_instrument (
    measurement_instrument_id bigint NOT NULL,
    instrument_code text,
    instrument_name text,
    instrument_type text,
    manufacturer text,
    model text,
    serial_number text,
    workcenter_id bigint,
    calibration_valid_until date,
    is_active boolean,
    notes text,
    CONSTRAINT pk_dim_measurement_instrument
        PRIMARY KEY (measurement_instrument_id)
);
```

### Koneistustyökalutaulu (`dim_manufacturing_tool`)

**Taulun kuvaus:**  
Mittauskohteen valmistukseen liittyvän ensisijaisen koneistustyökalun perustiedot. Taulu mahdollistaa mittatulosten ja työkalun kulumisen välisen tarkastelun silloin, kun mittauskohde voidaan yhdistää tiettyyn työkaluun.

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
|---|---|---|---|
| Koneistustyökalu ID | `manufacturing_tool_id` | PK / bigint | Työkalun tai työkalukokoonpanon yksilöivä avain. |
| Työkalun tunnus | `tool_code` | text | Yrityksen, koneen tai työkalunhallinnan käyttämä tunnus. |
| Työkalun nimi | `tool_name` | text | Työkalun nimi. |
| Työkalun tyyppi | `tool_type` | text | Esimerkiksi pora, jyrsin, sorvausterä tai kalvain. |
| Valmistaja | `manufacturer` | text | Työkalun valmistaja. |
| Malli | `model` | text | Työkalun malli tai tuotenumero. |
| Työkalupaikka | `tool_position` | text | Koneen työkalupaikka tai revolveripaikka, jos se on pysyvä osa tunnistusta. |
| Aktiivinen | `is_active` | boolean | Tieto siitä, onko työkalu käytössä. |
| Lisätiedot | `notes` | text | Työkaluun liittyvät lisätiedot. |

#### Taulun luontilause

```sql
CREATE TABLE public.dim_manufacturing_tool (
    manufacturing_tool_id bigint NOT NULL,
    tool_code text,
    tool_name text,
    tool_type text,
    manufacturer text,
    model text,
    tool_position text,
    is_active boolean,
    notes text,
    CONSTRAINT pk_dim_manufacturing_tool
        PRIMARY KEY (manufacturing_tool_id)
);
```

## Mittaustiedon tietolaatu ja käsittely

### Mittauskohteiden tunnistaminen

Mittauskohteelle tulee käyttää lähteiden välillä sovittua `feature_code`-tunnistetta. Lähteen oma tunniste säilytetään lisäksi `source_feature_identifier`-kentässä. Näin virheelliset kohdistukset voidaan havaita ja korjata.

Jos eri järjestelmät käyttävät samalle mittauskohteelle eri tunnisteita, niiden muunnokset kannattaa ylläpitää integraatio- tai staging-kerroksessa. Erillinen tunnisteiden vastaavuustaulu voidaan lisätä myöhemmin, jos lähteitä ja poikkeavia tunnisteita tulee paljon.

### Kappaleen tunnistaminen

Ensisijainen tunniste on kappaleen pysyvä sarjanumero. Jos sitä ei ole, voidaan käyttää lähteen kappaletunnistetta, työnumeroa, kappaleen järjestysnumeroa, työkeskusta ja aikaleimaa.

Epävarmaa kappaleyhteyttä ei tule päätellä faktaksi. Mittaus voidaan tallentaa työ-, nimike- ja aikatasolle, vaikka sarjanumero tai kappaletunniste puuttuisi.

### Versiohistoria

Mittauskohteen nimellisarvot ja toleranssit tulee säilyttää versioituina. Historiallisella mittaustuloksella säilytetään lisäksi mittaushetken snapshot-arvot.

NC-ohjelman, työvaiheistuksen ja piirustuksen versiot säilytetään mittausraportilla tekstikenttinä. Tämä on perusmallissa yksinkertaisempi ratkaisu kuin erilliset versiodimensiot.

### SPC-laskenta

Perusmalli tukee erityisesti yksittäisten havaintojen I-MR-korttia. X̄-R- ja X̄-S-kortteja varten pitää ensin määritellä, miten mittaukset muodostavat vertailukelpoisia aliryhmiä.

SPC-laskennassa tulee huomioida:

- havaintojen oikea aikajärjestys
- sama mittauskohde ja mittayksikkö
- sama kone tai vertailukelpoinen prosessi
- mittausmenetelmän ja mittavälineen muutokset
- NC-ohjelman ja työvaiheistuksen muutokset
- koneistustyökalun vaihto
- materiaalierän vaihto
- analyysistä poistettujen mittausten tila ja syy

Ohjausrajat lasketaan prosessin mittaustuloksista. Niitä ei tallenneta mittauskohteen toleransseiksi eikä sekoiteta spesifikaatiorajoihin.

## Laskettavat mittarit

Mittaustiedon tauluista voidaan laskea esimerkiksi seuraavia tunnuslukuja. Laskennassa tulee käyttää vain analyysiin hyväksyttyjä tuloksia ja keskenään vertailukelpoisia havaintoja. Prosenttiosuuksissa osoittaja ja nimittäjä summataan ensin koko tarkastelujoukolle. Jos nimittäjä on nolla tai tyhjä, mittari jätetään tyhjäksi.

### Mittaustulosten määrä

- **Mitä mittaa:** Hyväksyttyjen mittaustulosten lukumäärä valitulla tarkastelutasolla.
- **Mittayksikkö:** kpl
- **Tarkastelutaso:** mittauskohde, nimike, työ, työvaihe, työkeskus, mittauslähde, ajanjakso
- **Tietolähde:** `fact_measurements` + `fact_measurement_reports`
- **Tila:** Laskettavissa suoraan
- **Laskentakaava:** `COUNT(measurement_id WHERE result_status = 'VALID')`

### Toleranssin ulkopuolisten tulosten osuus

- **Mitä mittaa:** Kuinka suuri osuus arvioitavista mittaustuloksista alittaa alemman tai ylittää ylemmän spesifikaatiorajan.
- **Mittayksikkö:** %
- **Tarkastelutaso:** mittauskohde, nimike, työkeskus, koneistustyökalu, työ, työvaihe, materiaalierä
- **Tietolähde:** `fact_measurements` + `fact_measurement_reports`
- **Tila:** Laskettavissa suoraan, jos spesifikaatiorajat ovat saatavilla
- **Laskentakaava:** `COUNT(measurement_id WHERE is_within_specification = FALSE) / COUNT(measurement_id WHERE is_within_specification IS NOT NULL) * 100`

### Keskimääräinen poikkeama toleranssialueen keskeltä

- **Mitä mittaa:** Prosessin keskimääräistä siirtymää toleranssialueen keskikohdasta. Etumerkki ilmaisee poikkeaman suunnan.
- **Mittayksikkö:** mittauskohteen yksikkö
- **Tarkastelutaso:** mittauskohde, nimike, työkeskus, koneistustyökalu, NC-ohjelma, ajanjakso
- **Tietolähde:** `fact_measurements` + `fact_measurement_reports`
- **Tila:** Laskettavissa suoraan, jos toleranssialueen keskipiste on saatavilla
- **Laskentakaava:** `AVG(deviation_from_tolerance_center)`

### Prosessikyvykkyys Cpk

- **Mitä mittaa:** Kuinka hyvin prosessin vaihtelu ja keskiarvon sijainti mahtuvat spesifikaatiorajojen sisälle.
- **Mittayksikkö:** suhdeluku
- **Tarkastelutaso:** yksi vertailukelpoinen mittauskohde, prosessi ja tarkastelujakso
- **Tietolähde:** `fact_measurements` + `fact_measurement_reports` + `dim_measurement_feature`
- **Tila:** Edellyttää yrityskohtaista määrittelyä havaintojoukosta ja hajonnan laskentatavasta
- **Laskentakaava:** `MIN((USL - AVG(x)) / (3 * s), (AVG(x) - LSL) / (3 * s))`

### Työkalun käyttöiän ja mittapoikkeaman yhteys

- **Mitä mittaa:** Muuttuuko mittaustuloksen poikkeama työkalun käyttöajan, kappalemäärän tai käytetyn käyttöikäosuuden kasvaessa.
- **Mittayksikkö:** mittauskohteen yksikkö, min, kpl tai %
- **Tarkastelutaso:** koneistustyökalu, mittauskohde, työkeskus ja työstön käyttötarkoitus
- **Tietolähde:** `fact_measurements` + `dim_manufacturing_tool` + `fact_measurement_reports`
- **Tila:** Edellyttää työkalun tunnisteen ja käyttötietojen saatavuutta
- **Laskentaesimerkki:** `AVG(ABS(deviation_from_tolerance_center))` ryhmiteltynä kentän `tool_life_used_pct`, `tool_part_count_snapshot` tai `tool_usage_min_snapshot` mukaan

Mittareita voidaan tarkastella myös tuotantotiedon muun mallin kautta esimerkiksi nimikkeittäin, työkeskuksittain, töittäin, työvaiheittain, materiaalierittäin, käyttäjittäin ja ajanjaksoittain. Mittausdata voidaan yhdistää työvaiheiden aika-, määrä- ja kustannustietoihin, kun yhteiset avaimet ovat saatavilla.

## Tietomallin laajennusehdotukset

Seuraavat laajennukset eivät kuulu mittaustiedon perusmalliin. Ne voidaan lisätä myöhemmin todellisen käyttötarpeen perusteella.

### Kappaletaulu (`dim_part`)

Erillinen kappaletaulu voidaan lisätä, jos yksittäisillä kappaleilla on luotettavat ja pysyvät sarjanumerot tai jos sama kappale pitää yhdistää useiden mittauslähteiden välillä. Perusmallissa kappaleen tunnisteet säilytetään mittausraportilla, jotta malliin ei muodostu tyhjiä tai epävarmoja kappalerivejä.

### Piirustustaulu (`dim_drawing`)

Erillinen piirustustaulu voidaan lisätä, jos piirustusten revisioita, dokumenttiviitteitä ja voimassaoloa pitää hallita laajemmin. Perusmallissa piirustusnumero ja revisio säilytetään mittauskohteella ja mittausraportilla.

### Valmistusohjelmataulu (`dim_manufacturing_program`)

Erillinen ohjelmataulu voidaan lisätä, jos NC-ohjelmista ja ERP-työvaiheistuksista syntyy paljon versioita tai samoja ohjelmia käytetään useilla koneilla ja nimikkeillä. Perusmallissa ohjelman nimi, versio ja muokkausajankohta säilytetään mittausraportilla.

### Mittaussuunnitelmataulu (`dim_control_plan`)

Mittaussuunnitelma voidaan mallintaa omaksi versioitavaksi taulukseen, jos nimikkeille hallitaan virallisia mittauskohteiden kokonaisuuksia, näytteenottovälejä, menetelmiä ja vastuita. Perusmallissa mittauskohteet kuvataan suoraan `dim_measurement_feature`-taulussa.

### Mittauskohteen lähdetunnusten vastaavuustaulu

Erillinen vastaavuustaulu voidaan lisätä, jos samalle mittauskohteelle käytetään useita tunnisteita eri mittausjärjestelmissä. Taulu voisi yhdistää `measurement_source_id`, lähteen oman tunnisteen ja `measurement_feature_id`-avaimen.

### Koneistustyökalun tapahtumataulu

Erillinen työkalutapahtumataulu voidaan lisätä, jos halutaan seurata työkalun vaihtoja, korjausarvoja, käyttöaikaa ja valmistettuja kappaleita tapahtumatasolla. Perusmalli tallentaa mittaustulokselle vain ensisijaisen koneistustyökalun.

### Mittavälineen kalibrointihistoria

Erillinen kalibrointitaulu voidaan lisätä, jos jokaisen kalibroinnin ajankohta, tulos, todistus ja voimassaoloaika täytyy säilyttää. Perusmallissa mittavälineellä on vain nykyisen kalibroinnin voimassaolopäivä.

### SPC-aliryhmät ja ohjausrajat

Erilliset SPC-taulut voidaan lisätä, jos aliryhmät, hyväksytyt ohjausrajat ja SPC-signaalit pitää säilyttää tietokannassa toistettavasti. Mahdollisia tauluja ovat:

- `fact_spc_subgroups`, muodostettujen aliryhmien tiedot
- `fact_spc_control_limits`, hyväksyttyjen ohjausrajojen versiot
- `fact_spc_signals`, havaittujen SPC-poikkeamien tiedot

Perusmallissa nämä arvot lasketaan raportointi- tai analyysikerroksessa.

### Attribuuttimuotoinen laadunvalvonta

Erillinen tarkastustaulu voidaan lisätä, jos halutaan käyttää p-, np-, c- tai u-ohjauskortteja. Tällöin tarvitaan muun muassa tarkastettu määrä, virheellisten kappaleiden määrä, virheiden määrä ja tarkastusmahdollisuuksien määrä.

### Mittausolosuhteet

Lämpötila, kosteus ja muut ympäristöolosuhteet voidaan lisätä mittausraportille tai erilliseen tapahtumatauluun, jos niiden vaikutusta mittaustuloksiin pitää analysoida.
