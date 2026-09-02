---
type: PostgreSQL Table
title: Käyttäjätaulu (dim_user)
description: Käyttäjätiedot ERP-järjestelmästä.
resource: postgresql://TUOVA_DB/public/dim_user
tags: [tietomalli, ulottuvuustaulu, dim_user]
status: stable
table_name: dim_user
table_kind: ulottuvuus
column_count: 3
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Käyttäjätiedot ERP-järjestelmästä.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Käyttäjä ID** | `user_id` | PK / int | Käyttäjän yksilöivä avain |
| **Käyttäjän nimi** | `user_name` | char | Käyttäjän nimi tai muu tunniste. |
| **Käyttäjän rooli** | `user_role` | char | Käyttäjän rooli organisaatiossa. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_user (
    user_id bigint NOT NULL,
    user_name text,
    user_role text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
