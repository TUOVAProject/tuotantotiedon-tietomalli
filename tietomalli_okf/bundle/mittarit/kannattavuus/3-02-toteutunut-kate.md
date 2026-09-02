---
type: Metric
title: 3.2 Toteutunut kate
description: Tilausrivin euromääräisen kannattavuuden valitulla kustannustasolla.
tags: [mittari, kannattavuus, edellyttaa-maarittelya]
status: stable
metric_id: 3.2
metric_group: Kannattavuuden mittarit
unit: €
grain: tilausrivi, asiakas, nimike, myyjä, tilaustyyppi, kuukausi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Tilausrivin euromääräisen kannattavuuden valitulla kustannustasolla.

| | |
| :--- | :--- |
| **Mittayksikkö** | € |
| **Tarkastelutaso** | tilausrivi, asiakas, nimike, myyjä, tilaustyyppi, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (kustannustason valinta) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(sales_margin_actual)
tai  SUM(total_price) − SUM(prime_cost_actual_sum)       (myyntikate)
tai  SUM(total_price) − SUM(manufacturing_cost_actual)   (tulos yleiskustannusten jälkeen)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Myyntikate toteutunut)
tai  SUMMA(Tilausrivi hinta) − SUMMA(Suorat tuotantokustannukset toteutunut)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Valitse yksi laskentasääntö ja käytä sitä johdonmukaisesti. Valmiiksi johdettu `sales_margin_actual` ja itse laskettu erotus voivat poiketa toisistaan, jos ERP:n katelaskenta poikkeaa tietomallin kaavasta.
- Yleiskustannusten kohdistustapa vaikuttaa suoraan siihen, mitkä tilaukset näyttävät kannattavilta. Jos yleiskustannuslisä on kiinteä prosentti, kateprosentti ei kerro todellisesta kustannusrakenteesta.
- Suunniteltu vastine on `sales_margin_planned`.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
