---
type: PostgreSQL Table
title: Työkeskustaulu (dim_workcenter)
description: Työpisteen/työkeskuksen/tuotantoyksikön/kuormitusryhmän tarkemmat tiedot.
resource: postgresql://TUOVA_DB/public/dim_workcenter
tags: [tietomalli, ulottuvuustaulu, dim_workcenter]
status: stable
table_name: dim_workcenter
table_kind: ulottuvuus
column_count: 4
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Työpisteen/työkeskuksen/tuotantoyksikön/kuormitusryhmän tarkemmat tiedot. Alihankinta, kokoonpano, laadunvarmistus ja työstökoneet menevät samaan.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Työkeskus ID** | `workcenter_id` | PK / int | Työkeskuksen yksilöivä tunniste. |
| **Työkeskuksen nimi** | `workcenter_name` | char | Työkeskuksen nimi. |
| **Työkeskuksen kuvaus** | `workcenter_description` | char | Esimerkiksi koneen valmistaja tai jotain muuta lisätietoa. |
| **Työkeskuksen tyyppi** | `workcenter_type` | char | Työkeskuksen tyyppi. Voidaan käyttää suodatuksessa. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_workcenter (
    workcenter_id bigint NOT NULL,
    workcenter_name text,
    workcenter_description text,
    workcenter_type text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
