---
type: Metric
title: 1.9 Työvaiheen toteutunut kesto
description: Kuinka kauan yksittäinen työvaihe kesti aloituksesta valmistumiseen kalenteriaikana.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.9
metric_group: Aikavertailujen mittarit
unit: min tai h
grain: työvaihe, työkeskus, työkeskusryhmä, nimike, käyttäjä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka kauan yksittäinen työvaihe kesti aloituksesta valmistumiseen kalenteriaikana.

| | |
| :--- | :--- |
| **Mittayksikkö** | min tai h |
| **Tarkastelutaso** | työvaihe, työkeskus, työkeskusryhmä, nimike, käyttäjä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
end_timestamp_actual − start_timestamp_actual
```

Sama kaava semanttisilla nimillä:

```text
Lopetus aikaleima toteutunut − Aloitus aikaleima toteutunut
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Ero vaiheaikaan (`phase_duration_*_min`) on olennainen: kesto sisältää tauot ja keskeytykset, vaiheaika vain tehdyn työn. Näiden suhde kertoo, kuinka pirstoutunutta työ on.
- Jos aikaleimat puuttuvat, karkeampi arvio saadaan päiväavaimista `end_date_actual` ja `start_date_actual`.
- Alihankintavaiheiden läpimenoaika saadaan rajaamalla `subcontracting_phase = TRUE`, jolloin alihankkijoita voi vertailla `workcenter_id`:n avulla.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
