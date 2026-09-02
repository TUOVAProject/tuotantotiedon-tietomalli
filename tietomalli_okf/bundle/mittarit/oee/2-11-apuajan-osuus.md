---
type: Metric
title: 2.11 Apuajan osuus
description: Aktiivisen työstön aikana kuluneen ei-lastuavan ajan osuuden.
tags: [mittari, oee]
status: stable
metric_id: 2.11
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

Aktiivisen työstön aikana kuluneen ei-lastuavan ajan osuuden. Sisältää pikaliikkeet, työkalunvaihdot ja työstönaikaiset mittaukset.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, nimike, ohjelma, työvaihe |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(non_cutting_time_min) / SUM(machine_active_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Koneen apuaika min) / SUMMA(Työstöaika min) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Täydentää lastuamisastetta ([2.10](/mittarit/oee/2-10-lastuamisaste.md)): niiden summa on määritelmän mukaan 100 %, jos aktiivinen aika on jaettu täysin näihin kahteen.
- Poikkeuksellisen suuri apuaika samalla nimikkeellä eri koneilla viittaa ohjelmointieroon, ei koneen ominaisuuteen.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
