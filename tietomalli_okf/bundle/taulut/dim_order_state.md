---
type: PostgreSQL Table
title: Tilauksen tilan hakutaulu (dim_order_state)
description: Tilausten tilojen hakutaulu.
resource: postgresql://TUOVA_DB/public/dim_order_state
tags: [tietomalli, ulottuvuustaulu, dim_order_state]
status: stable
table_name: dim_order_state
table_kind: ulottuvuus
column_count: 2
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Tilausten tilojen hakutaulu. Tiedot voivat olla yrityksen raportointitarpeiden mukaan.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Tilauksen tilan ID** | `order_state_id` | PK / int | Tilauksen tilan yksilöivä avain. |
| **Tilauksen tilan nimi** | `order_state_name` | char | Tilauksen tila. Esimerkkejä: vastaanotettu, käsittelyssä, valmis tai peruttu. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_order_state (
    order_state_id bigint NOT NULL,
    order_state_name text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
