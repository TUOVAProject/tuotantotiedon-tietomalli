---
type: Metric
title: 5.10 Myöhässä olevan kuorman osuus
description: Kuinka suuri osa työjonosta on jo myöhässä suunnitellusta valmistumisesta.
tags: [mittari, muut]
status: stable
metric_id: 5.10
metric_group: Muut mittarit ja laskentakaavat
unit: "%"
grain: työkeskus, työkeskusryhmä, asiakas
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa työjonosta on jo myöhässä suunnitellusta valmistumisesta. Toimitusriskin ennakoiva mittari.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, asiakas |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(phase_duration_planned_min) WHERE end_date_latest_planned < tarkastelupäivä
                                  AND end_date_actual IS NULL
  / Työjonon kuormitus * 100
```

Sama kaava semanttisilla nimillä:

```text
Myöhässä olevien avoimien työvaiheiden kuormitus / Työjonon kuormitus * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Mittari on tilannekuva, ei jaksomittari. Se lasketaan aina tarkasteluhetkeen nähden.
- Suuri arvo yhdellä työkeskuksella tunnistaa pullonkaulan nopeammin kuin kuormitusaste, joka vaatii kapasiteettitiedon.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
