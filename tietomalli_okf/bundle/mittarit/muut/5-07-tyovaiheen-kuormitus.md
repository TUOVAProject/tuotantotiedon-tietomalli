---
type: Metric
title: 5.7 Työvaiheen kuormitus
description: Yksittäisen työvaiheen vaatiman kapasiteetin.
tags: [mittari, muut]
status: stable
metric_id: 5.7
metric_group: Muut mittarit ja laskentakaavat
unit: min tai h
grain: työvaihe, työ, tilausrivi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Yksittäisen työvaiheen vaatiman kapasiteetin.

| | |
| :--- | :--- |
| **Mittayksikkö** | min tai h |
| **Tarkastelutaso** | työvaihe, työ, tilausrivi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
setup_time_planned_min + planned_qty * cycle_time_planned_min
tai suoraan phase_duration_planned_min
```

Sama kaava semanttisilla nimillä:

```text
Asetusaika suunniteltu + Suunniteltu määrä * Kappale jaksoaika suunniteltu
tai Vaiheaika suunniteltu
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Molempien laskentatapojen pitäisi antaa sama tulos. Ero kertoo, että `phase_duration_planned_min` on johdettu jollain muulla säännöllä; sääntö kannattaa tarkistaa.
- Kuormitus on kaikkien kapasiteettimittareiden perusta.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
