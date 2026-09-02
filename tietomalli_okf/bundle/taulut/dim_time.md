---
type: PostgreSQL Table
title: Aikataulu (dim_time)
description: Aikaulottuvuus suodatuksia ja ajallista analysointia varten.
resource: postgresql://TUOVA_DB/public/dim_time
tags: [tietomalli, ulottuvuustaulu, dim_time]
status: stable
table_name: dim_time
table_kind: ulottuvuus
column_count: 11
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Aikaulottuvuus suodatuksia ja ajallista analysointia varten.

# Schema

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

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

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

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
