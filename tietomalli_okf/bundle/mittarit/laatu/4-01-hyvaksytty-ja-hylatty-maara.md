---
type: Metric
title: 4.1 Hyväksytty ja hylätty määrä
description: Valmistuneiden ja hylättyjen kappaleiden määrät, joista muut laatumittarit johdetaan.
tags: [mittari, laatu]
status: stable
metric_id: 4.1
metric_group: Laadun mittarit
unit: kpl
grain: työvaihe, työkeskus, nimike, käyttäjä, vuoro, päivä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Valmistuneiden ja hylättyjen kappaleiden määrät, joista muut laatumittarit johdetaan.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl |
| **Tarkastelutaso** | työvaihe, työkeskus, nimike, käyttäjä, vuoro, päivä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Hylätty määrä    = SUM(rejected_qty)
Hyväksytty määrä = SUM(produced_qty) − SUM(rejected_qty)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Hylätty määrä)
SUMMA(Tehty määrä) − SUMMA(Hylätty määrä)
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md), konetapahtumatasolla `produced_qty_stamping` ja `rejected_qty_stamping`

# Huomiot ja rajoitteet

- Konetapahtumatasolla hylkäysmäärä on määritelty leimausperusteiseksi. Jos tuotantomäärä otetaan konedatasta (`produced_qty_machine`), lähteet on syytä pitää mielessä tulkinnassa.
- Työvaihetason ja konetapahtumatason määrien ero on datan laadun mittari ([6.4](/mittarit/datan-laatu/6-04-kappalemaarien-ristiintarkistus.md)).

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
