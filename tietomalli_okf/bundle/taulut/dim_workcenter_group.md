---
type: PostgreSQL Table
title: Työkeskusryhmätaulu (dim_workcenter_group)
description: Työkeskuksen tai tuotantoyksikön tyypit.
resource: postgresql://TUOVA_DB/public/dim_workcenter_group
tags: [tietomalli, ulottuvuustaulu, dim_workcenter_group]
status: stable
table_name: dim_workcenter_group
table_kind: ulottuvuus
column_count: 3
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Työkeskuksen tai tuotantoyksikön tyypit. Voidaan käyttää tarpeen mukaan, mutta ei välttämätön taulu.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Työkeskusryhmä ID** | `workcenter_group_id` | PK / int | Työkeskusryhmän yksilöivä avain. |
| **Työkeskusryhmän nimi** | `workcenter_group_name` | char | Työkeskusryhmän nimi. |
| **Työkeskusryhmän kuvaus** | `workcenter_group_description` | char | Kuvaus työkeskuksen tyypistä. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_workcenter_group (
    workcenter_group_id bigint NOT NULL,
    workcenter_group_name text,
    workcenter_group_description text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
