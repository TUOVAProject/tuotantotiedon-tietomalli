---
type: Metric
title: 3.1 Myynti
description: Tilausrivien yhteenlasketun arvon ilman arvonlisäveroa.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.1
metric_group: Kannattavuuden mittarit
unit: €
grain: asiakas, nimike, myyjä, tilaustyyppi, kuukausi, vuosi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Tilausrivien yhteenlasketun arvon ilman arvonlisäveroa.

| | |
| :--- | :--- |
| **Mittayksikkö** | € |
| **Tarkastelutaso** | asiakas, nimike, myyjä, tilaustyyppi, kuukausi, vuosi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(total_price)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Tilausrivi hinta)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_customer`](/taulut/dim_customer.md), [`dim_article`](/taulut/dim_article.md), [`dim_user`](/taulut/dim_user.md), [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Jaksotus on valittava: tilauksen luontipäivä kuvaa myynnin kertymää, toimituspäivä liikevaihdon tuloutumista ja laskutuspäivä laskutusta. Nämä antavat eri luvut samalle kuukaudelle.
- `total_price` on tietomallissa yleensä `unit_price * ordered_qty`. Jos toimitettu määrä poikkeaa tilatusta, todellinen laskutettu arvo voi olla eri.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
