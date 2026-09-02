---
type: Metric
title: 6.1 Aikojen kohdistusaste
description: Kuinka suuri osa konetapahtuman kestosta on saatu kohdistettua tila-aikoihin.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.1
metric_group: Datan laadun tarkastus
unit: "%"
grain: kone, tietolähde, tapahtumatyyppi, päivä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa konetapahtuman kestosta on saatu kohdistettua tila-aikoihin. Tietomalliin on rakennettu tätä varten oma tarkistuskenttä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, tietolähde, tapahtumatyyppi, päivä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(time_sum_min) / SUM(duration_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Aikojen summa min) / SUMMA(Kesto min) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`dim_source`](/taulut/dim_source.md), [`dim_event_type`](/taulut/dim_event_type.md)

# Huomiot ja rajoitteet

- Tavoitearvo on 100 %. Poikkeama alaspäin tarkoittaa puuttuvaa aikaa, poikkeama ylöspäin päällekkäin laskettua aikaa.
- Ryhmittely tietolähteen ja tapahtumatyypin mukaan paikantaa ongelman lähteen nopeasti.
- Tämä on koko konedataan perustuvan mittariston edellytys: jos kohdistusaste on heikko, käytettävyys, seisokkiaste ja koneajan rakenne ovat epäluotettavia.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
