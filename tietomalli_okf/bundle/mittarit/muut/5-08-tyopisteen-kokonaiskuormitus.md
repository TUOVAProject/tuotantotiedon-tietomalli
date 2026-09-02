---
type: Metric
title: 5.8 Työpisteen kokonaiskuormitus
description: Työkeskukselle tarkastelujaksolla kohdistetun työmäärän.
tags: [mittari, muut]
status: stable
metric_id: 5.8
metric_group: Muut mittarit ja laskentakaavat
unit: h/jakso
grain: työkeskus, työkeskusryhmä, viikko, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Työkeskukselle tarkastelujaksolla kohdistetun työmäärän.

| | |
| :--- | :--- |
| **Mittayksikkö** | h/jakso |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, viikko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(phase_duration_planned_min) GROUP BY workcenter_id, jakso
  jakso start_date_latest_planned kautta dim_date-tauluun
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Vaiheaika suunniteltu) ryhmiteltynä Työkeskus ID ja jakso
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_workcenter`](/taulut/dim_workcenter.md), [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Jos työvaihe on suunniteltu useammalle päivälle, se kohdistuu tässä kokonaisuudessaan aloituspäivän jaksoon. Pitkien vaiheiden jakaminen päiville vaatii erillisen säännön.
- Toteutunut kuormitus saadaan samalla kaavalla kentästä `phase_duration_stamping_min` tai `phase_duration_machine_min`; ero suunniteltuun on kuormituksen poikkeama.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
