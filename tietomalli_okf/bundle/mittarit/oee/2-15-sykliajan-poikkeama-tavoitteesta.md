---
type: Metric
title: 2.15 Sykliajan poikkeama tavoitteesta
description: Kuinka paljon toteutunut kappalekohtainen jaksoaika poikkeaa tavoitteesta.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.15
metric_group: OEE ja sen osat
unit: "%"
grain: nimike, ohjelma, kone, työvaihe
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon toteutunut kappalekohtainen jaksoaika poikkeaa tavoitteesta. Erittelee nopeushäviön nimike- ja ohjelmatasolle.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | nimike, ohjelma, kone, työvaihe |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (ihannesykliaika) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(cycle_time_machine_min − cycle_time_ideal_min) / cycle_time_ideal_min * 100
```

Sama kaava semanttisilla nimillä:

```text
(Kappale jaksoaika konedata − Kappale jaksoaika tavoite)
  / Kappale jaksoaika tavoite * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md), tapahtumatasolla `fact_machine_events.unit_cycle_time_min`

# Huomiot ja rajoitteet

- Sama nimike eri koneilla tai eri ohjelmaversioilla on hyödyllisin vertailu; se paljastaa parhaan käytännön.
- Sykliajan hajonta `STDDEV(unit_cycle_time_min)` yksittäisten kappaletapahtumien (`event_type_id = 9`) yli kertoo prosessin vakaudesta ilman mittausdataa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
