---
type: Metric
title: 2.10 Lastuamisaste
description: Kuinka suuri osa aktiivisesta koneajasta on todellista lastuamista.
tags: [mittari, oee]
status: stable
metric_id: 2.10
metric_group: OEE ja sen osat
unit: "%"
grain: kone, nimike, ohjelma, työvaihe
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa aktiivisesta koneajasta on todellista lastuamista. Yksi konedatan tuomista merkittävimmistä lisistä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, nimike, ohjelma, työvaihe |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(cutting_time_min) / SUM(machine_active_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Lastuamisaika min) / SUMMA(Työstöaika min) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Edellyttää, että lastuamisaika saadaan koneen rajapinnasta tai anturidatasta. Leimausdatasta sitä ei voi johtaa.
- Ohjelmakohtainen tarkastelu (`program_name`) kohdistaa NC-ohjelmien optimointia suoraan sinne, missä hyöty on suurin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
