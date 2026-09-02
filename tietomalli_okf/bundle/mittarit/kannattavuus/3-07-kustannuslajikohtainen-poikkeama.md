---
type: Metric
title: 3.7 Kustannuslajikohtainen poikkeama
description: "Mistä kustannuslajista kustannuspoikkeama syntyy: työstä, materiaalista, alihankinnasta vai muista suorista kuluista."
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.7
metric_group: Kannattavuuden mittarit
unit: €
grain: tilausrivi, nimike, asiakas, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Mistä kustannuslajista kustannuspoikkeama syntyy: työstä, materiaalista, alihankinnasta vai muista suorista kuluista.

| | |
| :--- | :--- |
| **Mittayksikkö** | € |
| **Tarkastelutaso** | tilausrivi, nimike, asiakas, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(direct_work_cost_actual)    − SUM(direct_work_cost_planned)
SUM(material_cost_actual)       − SUM(material_cost_planned)
SUM(subcontracting_cost_actual) − SUM(subcontracting_cost_planned)
SUM(other_direct_costs_actual)  − SUM(other_direct_costs_planned)
SUM(overhead_costs_actual)      − SUM(overhead_costs_planned)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Suorat työkustannukset toteutunut) − SUMMA(Suorat työkustannukset suunniteltu)
SUMMA(Materiaalikustannukset toteutunut) − SUMMA(Materiaalikustannukset suunniteltu)
SUMMA(Alihankintakustannukset toteutunut) − SUMMA(Alihankintakustannukset suunniteltu)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Kustannuslajien summan pitäisi vastata kokonaispoikkeamaa ([3.5](/mittarit/kannattavuus/3-05-jalkilaskennan-poikkeama.md)). Ero paljastaa kohdistamattomia kustannuksia.
- Yleiskustannuslisän poikkeama on mielekäs vain, jos toteutunut yleiskustannuslisä lasketaan vertailukelpoisella tavalla; usein se on sama laskennallinen prosentti kuin suunniteltu, jolloin poikkeama on rakenteellisesti nolla.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
