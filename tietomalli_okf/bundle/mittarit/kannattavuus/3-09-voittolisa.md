---
type: Metric
title: 3.9 Voittolisä-%
description: Voiton osuuden omakustannusarvosta.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.9
metric_group: Kannattavuuden mittarit
unit: "%"
grain: tilausrivi, asiakas, nimike, tilaustyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Voiton osuuden omakustannusarvosta.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | tilausrivi, asiakas, nimike, tilaustyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(profit_actual) / SUM(manufacturing_cost_actual) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Voittolisä toteutunut) / SUMMA(Valmistuskustannukset toteutunut) * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Laske vain, jos valmistuskustannus on suurempi kuin nolla.
- Mittari on mielekäs vain, jos voittolisä on johdettu luotettavasti eikä vain laskennallisena prosenttina omakustannehinnan päälle. Jälkimmäisessä tapauksessa mittari toistaa hinnoittelusäännön eikä kerro toteumasta.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
