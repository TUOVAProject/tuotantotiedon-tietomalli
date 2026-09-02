---
type: Metric
title: 5.11 Kuormitusaste
description: Kuinka suuri osa käytettävissä olevasta kapasiteetista on suunniteltu käytettäväksi.
tags: [mittari, muut, edellyttaa-maarittelya]
status: stable
metric_id: 5.11
metric_group: Muut mittarit ja laskentakaavat
unit: "%"
grain: työkeskus, työkeskusryhmä, viikko, kuukausi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa käytettävissä olevasta kapasiteetista on suunniteltu käytettäväksi.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, viikko, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (tehollinen kapasiteetti) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Työpisteen kokonaiskuormitus / Tehollinen kapasiteetti * 100
  Tehollinen kapasiteetti = SUM(duration_min) WHERE event_type_id = 19
                            tai erillinen kapasiteettiparametri
```

Sama kaava semanttisilla nimillä:

```text
Suunniteltu kuormitus / Tehollinen kapasiteetti * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`fact_machine_events`](/taulut/fact_machine_events.md) (`event_type_id = 19`)

# Huomiot ja rajoitteet

- Tietomallissa ei ole työkeskuskohtaista kapasiteetti- tai työvuorokalenteria. Kapasiteetti saadaan joko suunnitellun tuotantoajan riveistä tai tuomalla se parametrina (vuorojen määrä × vuoron pituus × koneiden määrä − suunnitellut menetykset).
- Kuormituksen ja kapasiteetin on oltava samalla aikajaksotuksella ja samassa yksikössä, muuten mittari ei ole tulkittavissa.
- Yli 100 %:n kuormitusaste ei tarkoita ylityötä vaan sitä, että suunnitelma ei mahdu kapasiteettiin. Se on suunnitteluvirhe, joka kannattaa nostaa esiin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
