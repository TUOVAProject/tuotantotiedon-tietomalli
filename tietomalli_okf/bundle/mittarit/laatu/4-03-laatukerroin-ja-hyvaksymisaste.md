---
type: Metric
title: 4.3 Laatukerroin ja hyväksymisaste
description: Hyväksyttyjen kappaleiden osuuden valmistetuista.
tags: [mittari, laatu]
status: stable
metric_id: 4.3
metric_group: Laadun mittarit
unit: "%"
grain: nimike, työvaihe, työkeskus, vuoro, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Hyväksyttyjen kappaleiden osuuden valmistetuista. Sama peruslogiikka kuin OEE:n laatukomponentissa.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | nimike, työvaihe, työkeskus, vuoro, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(produced_qty) − SUM(rejected_qty)) / SUM(produced_qty) * 100
```

Sama kaava semanttisilla nimillä:

```text
(SUMMA(Tehty määrä) − SUMMA(Hylätty määrä)) / SUMMA(Tehty määrä) * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Täydentää hylkäysastetta ([4.2](/mittarit/laatu/4-02-hylkaysaste.md)): mittarit summautuvat sataan, joten kumpikin riittää raportille. Valinta on esitystapakysymys.
- Tarkastettujen kappaleiden määrää ei ole erikseen, joten hyväksymisaste lasketaan tuotetuista kappaleista. Jos kaikkia kappaleita ei tarkasteta, mittari kuvaa tuotantoa, ei tarkastusta.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
