---
type: Metric
title: 3.10 Tuntikate
description: Kuinka paljon katetta työ tuotti käytettyä tuotantotuntia kohti.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.10
metric_group: Kannattavuuden mittarit
unit: €/h
grain: tilausrivi, nimike, asiakas, työkeskus, työkeskusryhmä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon katetta työ tuotti käytettyä tuotantotuntia kohti. Paljastaa työt, jotka näyttävät katteellisilta mutta sitovat kapasiteettia kohtuuttomasti.

| | |
| :--- | :--- |
| **Mittayksikkö** | €/h |
| **Tarkastelutaso** | tilausrivi, nimike, asiakas, työkeskus, työkeskusryhmä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(sales_margin_actual) / (SUM(fact_workphases.phase_duration_actual_min) / 60)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Myyntikate toteutunut) / (SUMMA(Vaiheaika leimattu) / 60)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Edellyttää, että työvaiheet on liitetty tilausriviin `order_row_id`-kentällä. Liittämättömät vaiheet jäävät nimittäjästä pois ja nostavat tuntikatetta virheellisesti; kattavuus kannattaa tarkistaa mittarilla 6.6.
- Voidaan laskea myös vain koneajalle nimittäjänä `production_time_actual_min`, jolloin mittari vertautuu suoraan konetuntihintaan.
- Pullonkaulaksi tunnistetun työkeskuksen tuntikate on tärkein yksittäinen kannattavuusluku työn valinnassa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
