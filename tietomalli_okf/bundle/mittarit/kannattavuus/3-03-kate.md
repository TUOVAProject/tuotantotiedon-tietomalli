---
type: Metric
title: 3.3 Kate-%
description: Katteen osuuden myyntihinnasta.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.3
metric_group: Kannattavuuden mittarit
unit: "%"
grain: asiakas, nimike, nimikeryhmä, myyjä, tilaustyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Katteen osuuden myyntihinnasta. Mahdollistaa erikokoisten tilausten vertailun.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | asiakas, nimike, nimikeryhmä, myyjä, tilaustyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(sales_margin_actual) / SUM(total_price) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Myyntikate toteutunut) / SUMMA(Tilausrivi hinta) * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Laske vain, jos myynti on suurempi kuin nolla. Takuutöillä ja hyvityksillä `total_price` voi olla nolla tai negatiivinen.
- Prosentti lasketaan summista, ei rivikohtaisten prosenttien keskiarvona.
- Suunniteltu vastine `sales_margin_planned / total_price * 100`; näiden erotus prosenttiyksikköinä on hyödyllinen tarjouslaskennan mittari.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
