---
type: Metric
title: 5.2 Tuotantomäärä standarditunteina
description: Valmistuneen tuotannon suunnitellun työmäärän.
tags: [mittari, muut]
status: stable
metric_id: 5.2
metric_group: Muut mittarit ja laskentakaavat
unit: standardih/jakso
grain: työkeskus, työkeskusryhmä, vuoro, viikko, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Valmistuneen tuotannon suunnitellun työmäärän. Tekee monituoteympäristön tuotannon vertailukelpoiseksi.

| | |
| :--- | :--- |
| **Mittayksikkö** | standardih/jakso |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, vuoro, viikko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(produced_qty * unit_time_planned_min) / 60
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Tehty määrä * Kappaleaika suunniteltu) / 60
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Standardiaika on tässä suunniteltu kappaleaika. Jos suunnitteluarvot ovat vanhentuneet, mittari kuvaa vanhaa standardia eikä todellista työmäärää.
- Sopii tuottavuuden aikasarjaseurantaan paremmin kuin kappalemäärä.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
