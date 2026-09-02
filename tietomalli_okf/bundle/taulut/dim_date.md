---
type: PostgreSQL Table
title: Päivämäärätaulu (dim_date)
description: Päivämääräulottuvuus ajallista suodatusta varten.
resource: postgresql://TUOVA_DB/public/dim_date
tags: [tietomalli, ulottuvuustaulu, dim_date]
status: stable
table_name: dim_date
table_kind: ulottuvuus
column_count: 25
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Päivämääräulottuvuus ajallista suodatusta varten.

# Schema

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

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

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

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
