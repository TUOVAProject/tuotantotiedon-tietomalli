---
type: Metric
title: 3.5 Jälkilaskennan poikkeama
description: Toteutuneiden ja suunniteltujen suorien tuotantokustannusten eron.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.5
metric_group: Kannattavuuden mittarit
unit: €
grain: tilausrivi, nimike, asiakas, myyjä, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Toteutuneiden ja suunniteltujen suorien tuotantokustannusten eron. Tarjous- ja ennakkolaskennan tarkkuuden perusmittari.

| | |
| :--- | :--- |
| **Mittayksikkö** | € |
| **Tarkastelutaso** | tilausrivi, nimike, asiakas, myyjä, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Suorat tuotantokustannukset toteutunut)
  − SUMMA(Suorat tuotantokustannukset suunniteltu)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Positiivinen arvo tarkoittaa suunniteltua suurempaa kustannusta.
- Sama laskenta täysillä valmistuskustannuksilla: `manufacturing_cost_actual − manufacturing_cost_planned`.
- Mittari edellyttää, että sekä suunniteltu että toteutunut kustannus on täytetty. Kattavuus kannattaa tarkistaa mittarilla 6.7 ennen tulkintaa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
