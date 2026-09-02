---
type: Metric
title: 1.12 Työvaiheiden aikataulupitävyys
description: Kuinka suuri osa valmistuneista työvaiheista valmistui viimeistään suunniteltuna päivänä.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.12
metric_group: Aikavertailujen mittarit
unit: "%"
grain: työkeskus, työkeskusryhmä, vaihenumero, nimike, viikko
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa valmistuneista työvaiheista valmistui viimeistään suunniteltuna päivänä. Paikantaa tuotannon sisäisen virtauksen häiriöt.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, vaihenumero, nimike, viikko |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(workphase_id WHERE end_date_actual <= end_date_latest_planned)
  / COUNT(workphase_id WHERE end_date_actual IS NOT NULL) * 100
```

Sama kaava semanttisilla nimillä:

```text
Ajoissa valmistuneet työvaiheet / Valmistuneet työvaiheet * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Vertailu viimeisimpään suunnitelmaan (`end_date_latest_planned`) mittaa toteutusta, vertailu alkuperäiseen (`end_date_original_planned`) mittaa suunnitelman pitävyyttä. Molemmat kannattaa laskea, koska pelkkä jälkimmäinen suunnitelma voi kaunistaa tuloksen.
- Työkeskuskohtainen tarkastelu paljastaa pullonkaulat nopeammin kuin tilaustason toimitusvarmuus.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
