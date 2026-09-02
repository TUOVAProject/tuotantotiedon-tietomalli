---
type: Metric
title: 1.6 Toimituspoikkeama
description: Toteutuneen ja luvatun toimituspäivän eron päivinä.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.6
metric_group: Aikavertailujen mittarit
unit: vrk
grain: tilausrivi, asiakas, nimike, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Toteutuneen ja luvatun toimituspäivän eron päivinä.

| | |
| :--- | :--- |
| **Mittayksikkö** | vrk |
| **Tarkastelutaso** | tilausrivi, asiakas, nimike, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
date_index(delivery_date_actual) − date_index(delivery_date_planned)
```

Sama kaava semanttisilla nimillä:

```text
Päivämääräindeksi(Toteutunut toimitus) − Päivämääräindeksi(Suunniteltu toimitus)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Positiivinen arvo tulkitaan yleensä myöhästymiseksi.
- Sama kaava toimii lähetykselle kentillä `dispatch_date_actual` ja `dispatch_date_planned`, jolloin tuotannon ja logistiikan osuudet erottuvat toisistaan.
- Keskiarvon rinnalla kannattaa seurata myöhästyneiden osuutta ja pahimpia poikkeamia, koska yksittäinen suuri myöhästyminen hukkuu keskiarvoon.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
