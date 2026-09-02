---
type: Metric
title: 3.6 Jälkilaskennan poikkeamaprosentti
description: Kustannuspoikkeaman suhteessa suunniteltuun kustannukseen.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.6
metric_group: Kannattavuuden mittarit
unit: "%"
grain: nimike, nimikeryhmä, asiakas, myyjä, tilaustyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kustannuspoikkeaman suhteessa suunniteltuun kustannukseen. Mahdollistaa erikokoisten töiden vertailun.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | nimike, nimikeryhmä, asiakas, myyjä, tilaustyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(prime_cost_actual_sum) − SUM(prime_cost_planned_sum))
  / SUM(prime_cost_planned_sum) * 100
```

Sama kaava semanttisilla nimillä:

```text
(Suorat tuotantokustannukset toteutunut − Suorat tuotantokustannukset suunniteltu)
  / Suorat tuotantokustannukset suunniteltu * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_article`](/taulut/dim_article.md)

# Huomiot ja rajoitteet

- Laske vain, jos suunniteltu kustannus on suurempi kuin nolla.
- Ryhmittely `new_article`-kentän mukaan kertoo, kuinka paljon heikommin tarjouslaskenta osuu uusilla nimikkeillä. Tämä on yksi hyödyllisimmistä yksittäisistä selittäjistä.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
