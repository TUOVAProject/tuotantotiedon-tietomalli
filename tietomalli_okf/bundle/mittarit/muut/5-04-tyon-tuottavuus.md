---
type: Metric
title: 5.4 Työn tuottavuus
description: Hyväksytyn tuotannon suhteen käytettyyn työpanokseen.
tags: [mittari, muut, edellyttaa-maarittelya]
status: stable
metric_id: 5.4
metric_group: Muut mittarit ja laskentakaavat
unit: kpl/työtunti tai standardih/työtunti
grain: työkeskus, työkeskusryhmä, vuoro, kuukausi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Hyväksytyn tuotannon suhteen käytettyyn työpanokseen.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl/työtunti tai standardih/työtunti |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, vuoro, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (työpanoksen määritelmä) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(produced_qty) − SUM(rejected_qty)) / (SUM(phase_duration_stamping_min) / 60)
```

Sama kaava semanttisilla nimillä:

```text
(Tehty määrä − Hylätty määrä) / (Vaiheaika leimattu / 60)
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Leimausaika vastaa työtuntia vain, jos leimaus on henkilökohtainen. Jos yksi henkilö ajaa useaa konetta tai kone käy miehittämättömänä, leimausaika ei ole työpanos.
- Osoittajana kannattaa monituoteympäristössä käyttää standarditunteja ([5.2](/mittarit/muut/5-02-tuotantomaara-standarditunteina.md)) kappaleiden sijaan.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
