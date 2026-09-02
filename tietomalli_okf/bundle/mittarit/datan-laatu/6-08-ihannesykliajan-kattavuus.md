---
type: Metric
title: 6.8 Ihannesykliajan kattavuus
description: Kuinka suurelle osalle työvaiheista tavoitesykliaika on määritelty.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.8
metric_group: Datan laadun tarkastus
unit: "%"
grain: nimike, nimikeryhmä, työkeskus, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suurelle osalle työvaiheista tavoitesykliaika on määritelty. OEE:n nopeuskomponentin laskettavuus riippuu suoraan tästä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | nimike, nimikeryhmä, työkeskus, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(workphase_id WHERE cycle_time_ideal_min IS NOT NULL)
  / COUNT(workphase_id) * 100
```

Sama kaava semanttisilla nimillä:

```text
Työvaiheet, joilla Kappale jaksoaika tavoite on täytetty / Kaikki työvaiheet * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_article`](/taulut/dim_article.md)

# Huomiot ja rajoitteet

- Kannattaa painottaa tuotantoajalla, ei rivimäärällä: tärkeintä on, että eniten kapasiteettia vievillä nimikkeillä tavoiteaika on määritelty.
- Kattavuuden nosto on käytännössä edellytys sille, että OEE:n nopeus ([2.5](/mittarit/oee/2-05-nopeus.md)) ja koko OEE ([2.7](/mittarit/oee/2-07-oee-kokonaistehokkuus.md)) ovat määritelmän mukaisia.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
