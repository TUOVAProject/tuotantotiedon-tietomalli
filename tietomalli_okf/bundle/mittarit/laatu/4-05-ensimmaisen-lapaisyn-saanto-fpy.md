---
type: Metric
title: 4.5 Ensimmäisen läpäisyn saanto, FPY
description: Kuinka suuri osa kappaleista läpäisi työvaiheen ilman korjausta.
tags: [mittari, laatu, edellyttaa-maarittelya]
status: stable
metric_id: 4.5
metric_group: Laadun mittarit
unit: "%"
grain: työvaihe, vaihenumero, nimike, työkeskus
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa kappaleista läpäisi työvaiheen ilman korjausta. Tietomallilla laskettuna arvio.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työvaihe, vaihenumero, nimike, työkeskus |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (korjausten käsittely) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100
  laskettuna työvaiheittain
```

Sama kaava semanttisilla nimillä:

```text
(Tehty määrä − Hylätty määrä) / Tehty määrä * 100 vaiheittain
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Aito FPY edellyttäisi tietoa korjatuista kappaleista. Nykymallissa korjattu kappale näkyy hyväksyttynä, joten laskettu arvo on yläraja todelliselle FPY:lle.
- Osittainen kiertotie on tunnistaa uudelleentyö siitä, että sama `work_id` ja `phase_number` esiintyy useaan kertaan. Sääntö on yrityskohtainen ja epävarma, joten se on dokumentoitava.
- Arvo ei ole vertailukelpoinen muiden yritysten FPY-lukujen kanssa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
