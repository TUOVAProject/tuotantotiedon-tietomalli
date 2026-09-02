---
type: Metric
title: 2.8 Täysin tuottava aika
description: Ajan, joka olisi tavoitenopeudella tarvittu hyväksyttyjen kappaleiden valmistamiseen.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.8
metric_group: OEE ja sen osat
unit: min tai h
grain: kone, nimike, päivä, viikko
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Ajan, joka olisi tavoitenopeudella tarvittu hyväksyttyjen kappaleiden valmistamiseen. OEE:n aikatulkinta.

| | |
| :--- | :--- |
| **Mittayksikkö** | min tai h |
| **Tarkastelutaso** | kone, nimike, päivä, viikko |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (ihannesykliaika) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(Hyväksytty määrä * cycle_time_ideal_min)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Hyväksytty määrä * Kappale jaksoaika tavoite)
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Erotus suunniteltuun tuotantoaikaan on menetetty aika minuutteina, mikä on usein havainnollisempi luku kuin OEE-prosentti.
- Sopii hyvin OEE:n visualisointiin vesiputouskaaviona: suunniteltu aika, seisokkihäviö, nopeushäviö, laatuhäviö, jäljelle jäävä tuottava aika.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
