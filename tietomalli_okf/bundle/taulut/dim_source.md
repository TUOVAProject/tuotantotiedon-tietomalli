---
type: PostgreSQL Table
title: Tietolähteen hakutaulu (dim_source)
description: Konetapahtumien tietolähteiden hakutaulu.
resource: postgresql://TUOVA_DB/public/dim_source
tags: [tietomalli, ulottuvuustaulu, dim_source]
status: stable
table_name: dim_source
table_kind: ulottuvuus
column_count: 3
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Konetapahtumien tietolähteiden hakutaulu. Auttaa mm. erottamaan leimausdatoja ja konedatoja toisistaan.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Tapahtumalähde ID** | `source_id` | PK / int | Tietolähteen yksilöivä avain. |
| **Lähteen nimi** | `source_name` | char | Konetapahtuman tietolähteen nimi. Esimerkkejä: leimausdata, koneen rajapinta tai anturidata. |
| **Lähteen kuvaus** | `source_description` | char | Kuvaus tietolähteestä. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_source (
    source_id integer NOT NULL,
    source_name text,
    source_description text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
