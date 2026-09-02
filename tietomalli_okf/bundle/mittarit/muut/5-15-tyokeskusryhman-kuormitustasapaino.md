---
type: Metric
title: 5.15 Työkeskusryhmän kuormitustasapaino
description: Kuinka tasaisesti kuorma jakautuu ryhmän koneiden kesken.
tags: [mittari, muut]
status: stable
metric_id: 5.15
metric_group: Muut mittarit ja laskentakaavat
unit: h tai %
grain: työkeskusryhmä, viikko, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka tasaisesti kuorma jakautuu ryhmän koneiden kesken.

| | |
| :--- | :--- |
| **Mittayksikkö** | h tai % |
| **Tarkastelutaso** | työkeskusryhmä, viikko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
STDDEV(kuormitus) GROUP BY workcenter_group_id
  tai (MAX(kuormitus) − MIN(kuormitus)) / AVG(kuormitus) * 100
```

Sama kaava semanttisilla nimillä:

```text
Työkeskusten kuormitusten hajonta ryhmiteltynä Työkeskusryhmä ID
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_workcenter_group`](/taulut/dim_workcenter_group.md)

# Huomiot ja rajoitteet

- Mielekäs vain, jos ryhmän koneet ovat aidosti keskenään vaihtoehtoisia. Jos koneilla on eri kyvykkyydet, epätasapaino on väistämätön eikä kerro suunnittelusta.
- Kertoo hienokuormituksen toimivuudesta nopeammin kuin yksittäisen koneen kuormitusaste.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
