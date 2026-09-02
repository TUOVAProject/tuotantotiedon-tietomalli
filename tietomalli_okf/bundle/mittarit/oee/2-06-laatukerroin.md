---
type: Metric
title: 2.6 Laatukerroin
description: Hyväksyttyjen kappaleiden osuuden kaikista valmistetuista.
tags: [mittari, oee]
status: stable
metric_id: 2.6
metric_group: OEE ja sen osat
unit: "%"
grain: kone, nimike, työvaihe, vuoro, käyttäjä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Hyväksyttyjen kappaleiden osuuden kaikista valmistetuista. OEE:n kolmas osatekijä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, nimike, työvaihe, vuoro, käyttäjä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(produced_qty_machine) − SUM(rejected_qty_stamping))
  / SUM(produced_qty_machine) * 100
```

Sama kaava semanttisilla nimillä:

```text
(Tuotettu määrä konedata − Hylätty määrä kpl) / Tuotettu määrä konedata * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md), työvaihetasolla [`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Tietomalli ei erottele korjattuja kappaleita hyväksytyistä, joten arvo on lievästi optimistinen suhteessa OEE:n suositeltuun määritelmään, jossa hyväksytty on ensimmäisellä kerralla onnistunut kappale.
- Jos tuotantomäärä ja hylkäysmäärä tulevat eri lähteestä (konedata ja leimaus), niiden rajausten on vastattava toisiaan. Muuten kerroin vääristyy.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
