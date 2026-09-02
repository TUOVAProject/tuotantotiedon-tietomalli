---
type: Metric
title: 5.14 Osoitettu kapasiteetti
description: Historiatiedon perusteella todella saavutetun kapasiteetin.
tags: [mittari, muut]
status: stable
metric_id: 5.14
metric_group: Muut mittarit ja laskentakaavat
unit: standardih/jakso
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

Historiatiedon perusteella todella saavutetun kapasiteetin. Toimii tehollisen kapasiteetin realistisuustarkistuksena.

| | |
| :--- | :--- |
| **Mittayksikkö** | standardih/jakso |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, viikko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
AVG(SUM(produced_qty * unit_time_planned_min)) valituilta vertailujaksoilta
  GROUP BY workcenter_id, jakso
```

Sama kaava semanttisilla nimillä:

```text
KESKIARVO(jakson toteutunut tuotanto standarditunteina)
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Ei vaadi kapasiteettiparametria, joten tämä on käytännöllisin kapasiteettimittari ennen kapasiteettikalenterin lisäämistä.
- Vertailujaksot on valittava edustaviksi: lomakaudet ja poikkeukselliset ruuhkat vääristävät keskiarvoa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
