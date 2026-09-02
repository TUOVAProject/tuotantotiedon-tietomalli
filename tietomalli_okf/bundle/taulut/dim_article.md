---
type: PostgreSQL Table
title: Nimiketaulu (dim_article)
description: Nimike- tai tuotetiedot ERP-järjestelmästä.
resource: postgresql://TUOVA_DB/public/dim_article
tags: [tietomalli, ulottuvuustaulu, dim_article]
status: stable
table_name: dim_article
table_kind: ulottuvuus
column_count: 8
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

Nimike- tai tuotetiedot ERP-järjestelmästä.

# Schema

| Näyttönimi | Tekninen nimi | Tyyppi | Kuvaus |
| :--- | :--- | :--- | :--- |
| **Nimike ID** | `article_id` | PK / int | Nimikkeen yksilöivä avain. |
| **Nimikekoodi** | `article_code` | char | ERP-järjestelmässä käytettävä yksilöllinen nimiketunnus. |
| **Nimikkeen nimi** | `article_name` | char | Nimikkeen nimi. |
| **Nimikkeen muu nimi** | `article_name_other` | char | Vaihtoehtoinen nimi, jos saatavilla. |
| **Nimikkeen kuvaus** | `article_description` | char | Nimikkeen kuvaus. |
| **Nimikeryhmä** | `article_group` | char | Nimikeryhmä. |
| **Revisio** | `revision` | char | Nimikkeen revisio. Samalla nimikekoodilla voi olla useita revisioita, jolloin ne voivat olla erillisinä riveinä. |
| **Lisätiedot** | `notes` | char | Tähän nimikeversioon liittyvät lisätiedot. |

# Luontilause

Sarakemäärittelyt. Täysi skeema perusavaimineen, viiteavaimineen ja indekseineen on tiedostossa [db_create.sql](/references/db_create.sql).

```sql
CREATE TABLE public.dim_article (
    article_id bigint NOT NULL,
    article_code text,
    article_name text,
    article_name_other text,
    article_description text,
    article_group text,
    revision text,
    notes text
);
```

Taulu on osa [tuotantotiedon tietomallia](/tietomalli.md).
