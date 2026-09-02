---
type: Metric
title: 6.2 Kohdistamattoman ajan osuus
description: Kuinka suuri osa ajasta jää luokittelematta mihinkään tilaan.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.2
metric_group: Datan laadun tarkastus
unit: "%"
grain: kone, tietolähde, tapahtumatyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa ajasta jää luokittelematta mihinkään tilaan.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, tietolähde, tapahtumatyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(other_min) / SUM(duration_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Muu aika min) / SUMMA(Kesto min) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Täydentää mittaria 6.1: kohdistusaste kertoo kokonaisuuden, tämä kertoo tunnistetun mutta luokittelemattoman ajan.
- Osuuden pienentyminen ajan myötä on merkki siitä, että tiedonkeruun luokittelusäännöt paranevat.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
