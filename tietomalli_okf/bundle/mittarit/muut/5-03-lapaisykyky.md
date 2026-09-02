---
type: Metric
title: 5.3 Läpäisykyky
description: Kuinka nopeasti hyväksyttyjä kappaleita valmistuu.
tags: [mittari, muut]
status: stable
metric_id: 5.3
metric_group: Muut mittarit ja laskentakaavat
unit: kpl/h
grain: työkeskus, nimike, työvaihe, vuoro
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka nopeasti hyväksyttyjä kappaleita valmistuu.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl/h |
| **Tarkastelutaso** | työkeskus, nimike, työvaihe, vuoro |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_actual_min) / 60)
```

Sama kaava semanttisilla nimillä:

```text
(Tehty määrä − Hylätty määrä) / (Vaiheaika leimattu / 60)
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md), konetapahtumatasolla [`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Nimittäjän valinta muuttaa merkityksen: aktiivinen työstöaika (`machine_active_min`) kuvaa koneen nopeutta, tapahtuman kokonaiskesto (`duration_min`) todellista läpäisyä odotuksineen.
- Vertailukelpoinen vain samankaltaisten nimikkeiden kesken.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
