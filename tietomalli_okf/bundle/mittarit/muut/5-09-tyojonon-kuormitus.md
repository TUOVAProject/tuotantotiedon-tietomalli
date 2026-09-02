---
type: Metric
title: 5.9 Työjonon kuormitus
description: Aloittamattomien ja keskeneräisten työvaiheiden jäljellä olevan työmäärän työkeskuksittain.
tags: [mittari, muut]
status: stable
metric_id: 5.9
metric_group: Muut mittarit ja laskentakaavat
unit: standardih
grain: työkeskus, työkeskusryhmä, viikko
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Aloittamattomien ja keskeneräisten työvaiheiden jäljellä olevan työmäärän työkeskuksittain.

| | |
| :--- | :--- |
| **Mittayksikkö** | standardih |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, viikko |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(phase_duration_planned_min) WHERE end_date_actual IS NULL
  GROUP BY workcenter_id
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Vaiheaika suunniteltu) avoimille työvaiheille ryhmiteltynä Työkeskus ID
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_workcenter`](/taulut/dim_workcenter.md)

# Huomiot ja rajoitteet

- Osittain aloitetuista vaiheista kannattaa vähentää jo toteutunut aika, muuten jono näyttää todellista pidemmältä.
- Työjonon koko yhdessä sen kehityssuunnan kanssa ennakoi ruuhkautumista aikaisemmin kuin toimitusvarmuus.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
