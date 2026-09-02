---
type: Metric
title: 4.2 Hylkäysaste
description: Hylättyjen kappaleiden osuuden valmistetuista.
tags: [mittari, laatu]
status: stable
metric_id: 4.2
metric_group: Laadun mittarit
unit: "%"
grain: nimike, nimikeryhmä, työvaihe, työkeskus, käyttäjä, vuoro, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Hylättyjen kappaleiden osuuden valmistetuista. Laadun perusmittari.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | nimike, nimikeryhmä, työvaihe, työkeskus, käyttäjä, vuoro, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(rejected_qty) / SUM(produced_qty) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Hylätty määrä) / SUMMA(Tehty määrä) * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_article`](/taulut/dim_article.md), [`dim_workcenter`](/taulut/dim_workcenter.md), [`dim_time`](/taulut/dim_time.md)

# Huomiot ja rajoitteet

- Ryhmittely vaihenumeron mukaan paljastaa, missä kohtaa prosessia hylkyjä syntyy; ryhmittely nimikkeen mukaan sen, mitkä tuotteet ovat vaikeita.
- Myöhäisessä työvaiheessa hylätty kappale on huomattavasti kalliimpi kuin alkuvaiheessa hylätty. Pelkkä kappalemääräinen osuus ei kerro tätä, joten sen rinnalle sopii mittari 4.7.
- Ei erottele romutettavaa ja korjattavaa kappaletta.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
