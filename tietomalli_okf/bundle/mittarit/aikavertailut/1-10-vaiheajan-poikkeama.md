---
type: Metric
title: 1.10 Vaiheajan poikkeama
description: Kuinka paljon työvaiheeseen todella kulunut työaika poikkeaa suunnitellusta.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.10
metric_group: Aikavertailujen mittarit
unit: "%"
grain: työvaihe, työkeskus, työkeskusryhmä, nimike, käyttäjä, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon työvaiheeseen todella kulunut työaika poikkeaa suunnitellusta. Yksi käytännöllisimmistä suunnitelma vastaan toteuma -mittareista.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työvaihe, työkeskus, työkeskusryhmä, nimike, käyttäjä, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(phase_duration_actual_min) − SUM(phase_duration_planned_min))
  / SUM(phase_duration_planned_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
(Vaiheaika leimattu − Vaiheaika suunniteltu) / Vaiheaika suunniteltu * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Valitse toteumalähde johdonmukaisesti: `phase_duration_stamping_min` tai `phase_duration_machine_min`. Lähteiden ero on itsessään datan laadun mittari ([6.3](/mittarit/datan-laatu/6-03-leimaus-ja-konedatan-poikkeama.md)).
- Laske vain riveille, joilla suunniteltu aika on suurempi kuin nolla.
- Erittely asetusaikaan ja tuotantoaikaan tehdään samalla kaavalla kentillä `setup_time_*` ([1.11](/mittarit/aikavertailut/1-11-asetusajan-poikkeama.md)) ja `production_time_*`.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
