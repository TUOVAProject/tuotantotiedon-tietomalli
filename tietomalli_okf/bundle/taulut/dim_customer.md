---
type: PostgreSQL Table
title: Asiakastaulu (dim_customer)
description: Asiakastiedot.
resource: postgresql://TUOVA_DB/public/dim_customer
tags: [tietomalli, ulottuvuustaulu, dim_customer]
status: stable
table_name: dim_customer
table_kind: ulottuvuus
column_count: 4
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Asiakastiedot. Tarvittaessa voidaan laajentaa lisäkentillä.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Asiakkaan ID** | `customer_id` | PK / int | Asiakkaan yksilöivä avain. |
| **Asiakasnumero** | `customer_number` | char | Asiakasnumero ERP-järjestelmässä, esimerkiksi Y-tunnus. |
| **Asiakkaan nimi** | `customer_name` | char | Asiakkaan nimi. |
| **Sijainti** | `location` | char | Asiakkaan sijainti, kuten vaikka osoite. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_customer (
    customer_id bigint NOT NULL,
    customer_number text,
    customer_name text,
    location text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
