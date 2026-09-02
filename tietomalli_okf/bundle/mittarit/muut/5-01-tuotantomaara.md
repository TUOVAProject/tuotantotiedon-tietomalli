---
type: Metric
title: 5.1 Tuotantomäärä
description: Valmistuneen tuotannon määrän tarkastelujaksolla.
tags: [mittari, muut]
status: stable
metric_id: 5.1
metric_group: Muut mittarit ja laskentakaavat
unit: kpl/jakso
grain: työkeskus, nimike, vuoro, päivä, viikko, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Valmistuneen tuotannon määrän tarkastelujaksolla.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl/jakso |
| **Tarkastelutaso** | työkeskus, nimike, vuoro, päivä, viikko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(produced_qty) rajattuna jaksoon end_date_actual kautta
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Tehty määrä)
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Kappalemäärät eivät ole vertailukelpoisia, jos tuotteet eroavat toisistaan paljon. Silloin käytetään standarditunteja ([5.2](/mittarit/muut/5-02-tuotantomaara-standarditunteina.md)).
- Työvaihetasolla sama kappale lasketaan jokaisessa vaiheessa uudelleen. Työn tuotantomäärä otetaan viimeisestä vaiheesta tai tilausrivin `delivered_qty`-kentästä.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
