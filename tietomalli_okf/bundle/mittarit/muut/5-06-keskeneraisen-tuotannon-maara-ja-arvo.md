---
type: Metric
title: 5.6 Keskeneräisen tuotannon määrä ja arvo
description: Tuotannossa olevien avoimien töiden määrän, arvon ja jäljellä olevan työmäärän.
tags: [mittari, muut]
status: stable
metric_id: 5.6
metric_group: Muut mittarit ja laskentakaavat
unit: kpl, € ja h
grain: työkeskus, asiakas, nimike, viikko
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Tuotannossa olevien avoimien töiden määrän, arvon ja jäljellä olevan työmäärän.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl, € ja h |
| **Tarkastelutaso** | työkeskus, asiakas, nimike, viikko |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Määrä  = COUNT(order_row_id) WHERE production_start_date_actual IS NOT NULL
                               AND production_end_date_actual IS NULL
Arvo   = SUM(prime_cost_planned_sum) samalla ehdolla
Jäljellä oleva työ = SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL
```

Sama kaava semanttisilla nimillä:

```text
Avoimien töiden lukumäärä, niiden suunniteltu kustannusarvo ja
avoimien työvaiheiden suunniteltu vaiheaika
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Kustannusperusteinen arvo ei ole varsinainen varastoarvo, koska keskeneräisyyden aste ei ole tiedossa. Tarkempi arvio saadaan laskemalla valmistuneiden vaiheiden osuus työn kaikista vaiheista.
- Jäljellä olevina standarditunteina mitattuna keskeneräinen tuotanto on suoraan verrattavissa työjonon kuormitukseen ([5.9](/mittarit/muut/5-09-tyojonon-kuormitus.md)).

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
