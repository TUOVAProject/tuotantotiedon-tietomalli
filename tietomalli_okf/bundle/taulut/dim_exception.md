---
type: PostgreSQL Table
title: Poikkeamataulu (dim_exception)
description: Poikkeamien tiedot.
resource: postgresql://TUOVA_DB/public/dim_exception
tags: [tietomalli, ulottuvuustaulu, dim_exception]
status: stable
table_name: dim_exception
table_kind: ulottuvuus
column_count: 3
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Poikkeamien tiedot.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Poikkeama ID** | `exception_id` | PK / int | Poikkeaman yksilöivä avain. |
| **Poikkeamatyyppi** | `exception_type` | char | Poikkeaman tyyppi. |
| **Poikkeaman kuvaus** | `exception_description` | char | Kuvaus tapahtumasta tai poikkeamasta. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_exception (
    exception_id bigint NOT NULL,
    exception_type text,
    exception_description text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
