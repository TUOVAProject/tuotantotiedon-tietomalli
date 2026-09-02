---
type: PostgreSQL Table
title: Konetapahtumatyypin hakutaulu (dim_event_type)
description: Valmiiksi määritetty konetapahtumatyyppien hakutaulu.
resource: postgresql://TUOVA_DB/public/dim_event_type
tags: [tietomalli, ulottuvuustaulu, dim_event_type]
status: stable
table_name: dim_event_type
table_kind: ulottuvuus
column_count: 4
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Valmiiksi määritetty konetapahtumatyyppien hakutaulu. Tapahtumia voi lisätä tarpeen mukaan.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Tapahtumatyyppi ID** | `event_type_id` | PK / int | Tapahtumatyypin yksilöivä avain. |
| **Tapahtumatyypin nimi englanniksi** | `event_type_name_eng` | char | Tapahtumatyypin englanninkielinen nimi analysointia ja suodatusta varten. |
| **Tapahtumatyypin nimi suomeksi** | `event_type_name_fin` | char | Tapahtumatyypin suomenkielinen nimi analysointia ja suodatusta varten. |
| **Tapahtuman kuvaus** | `event_description` | char | Kuvaus tapahtumasta tai poikkeamasta. |

# Taulun vakiosisältö

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

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_event_type (
    event_type_id bigint NOT NULL,
    event_type_name_eng text,
    event_type_name_fin text,
    event_description text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
