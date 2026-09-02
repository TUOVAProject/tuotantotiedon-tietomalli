---
type: Metric
title: 3.4 Katepoikkeama
description: Toteutuneen ja suunnitellun katteen eron euroina ja prosenttiyksikköinä.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.4
metric_group: Kannattavuuden mittarit
unit: € tai %-yks.
grain: tilausrivi, asiakas, nimike, myyjä, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Toteutuneen ja suunnitellun katteen eron euroina ja prosenttiyksikköinä.

| | |
| :--- | :--- |
| **Mittayksikkö** | € tai %-yks. |
| **Tarkastelutaso** | tilausrivi, asiakas, nimike, myyjä, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Euroina:            SUM(sales_margin_actual) − SUM(sales_margin_planned)
Prosenttiyksikköinä: (SUM(sales_margin_actual) / SUM(total_price)
                      − SUM(sales_margin_planned) / SUM(total_price)) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Myyntikate toteutunut) − SUMMA(Myyntikate suunniteltu)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Negatiivinen arvo tarkoittaa suunniteltua heikompaa katetta.
- Mittari kertoo yhtä lailla tarjouslaskennan osuvuudesta kuin tuotannon suorituskyvystä; syy erotellaan mittareilla 3.5–3.7.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
