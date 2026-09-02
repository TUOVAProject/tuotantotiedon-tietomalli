---
type: Metric
title: 1.5 Tilauksesta toimitukseen kulunut aika
description: Asiakkaan kokema kokonaisläpimenoaika tilauksen luonnista toimitukseen.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.5
metric_group: Aikavertailujen mittarit
unit: vrk
grain: tilausrivi, asiakas, nimike, tilaustyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Asiakkaan kokema kokonaisläpimenoaika tilauksen luonnista toimitukseen.

| | |
| :--- | :--- |
| **Mittayksikkö** | vrk |
| **Tarkastelutaso** | tilausrivi, asiakas, nimike, tilaustyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
date_index(delivery_date_actual) − date_index(order_created_date)
```

Sama kaava semanttisilla nimillä:

```text
Päivämääräindeksi(Toteutunut toimitus) − Päivämääräindeksi(Tilauksen luontipäivä)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Sisältää myyntikäsittelyn, tuotannon odotuksen, tuotannon ja logistiikan. Logistiikan osuus saadaan erikseen: `date_index(delivery_date_actual) − date_index(dispatch_date_actual)`.
- Vertailtavuus edellyttää samankaltaisia tuotteita tai ryhmittelyä nimikeryhmittäin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
