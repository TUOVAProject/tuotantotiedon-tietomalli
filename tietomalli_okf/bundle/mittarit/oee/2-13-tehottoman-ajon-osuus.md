---
type: Metric
title: 2.13 Tehottoman ajon osuus
description: Kuinka suuri osa koneen käyntiajasta ajetaan alennetulla teholla.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.13
metric_group: OEE ja sen osat
unit: "%"
grain: kone, nimike, ohjelma, vuoro
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa koneen käyntiajasta ajetaan alennetulla teholla. Kone käy, mutta ei tavoitenopeudella.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, nimike, ohjelma, vuoro |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (tehokkaan ajon raja) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(inefficient_production_min)
  / (SUM(efficient_production_min) + SUM(inefficient_production_min)) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Tehoton työstöaika min)
  / (SUMMA(Tehokas työstöaika min) + SUMMA(Tehoton työstöaika min)) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Tehokkaan ja tehottoman ajon raja on määriteltävä konekohtaisesti, esimerkiksi karan kuormituksen tai syöttönopeuden perusteella. Ilman yhtenäistä sääntöä koneita ei voi verrata keskenään.
- Selittää usein OEE:n nopeushäviön syyn tarkemmin kuin nopeuskomponentti yksinään.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
