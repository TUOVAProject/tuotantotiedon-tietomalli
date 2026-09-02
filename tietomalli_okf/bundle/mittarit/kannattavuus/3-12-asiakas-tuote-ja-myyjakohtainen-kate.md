---
type: Metric
title: 3.12 Asiakas-, tuote- ja myyjäkohtainen kate
description: "Mistä kate todella syntyy: mitkä asiakkaat, tuotteet ja myyjät tuovat tulosta ja mitkä sitovat kapasiteettia heikolla katteella."
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.12
metric_group: Kannattavuuden mittarit
unit: € ja %
grain: asiakas, nimike, nimikeryhmä, myyjä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Mistä kate todella syntyy: mitkä asiakkaat, tuotteet ja myyjät tuovat tulosta ja mitkä sitovat kapasiteettia heikolla katteella.

| | |
| :--- | :--- |
| **Mittayksikkö** | € ja % |
| **Tarkastelutaso** | asiakas, nimike, nimikeryhmä, myyjä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(sales_margin_actual) GROUP BY customer_id | article_id | seller_id
SUM(sales_margin_actual) / SUM(total_price) * 100 samalla ryhmittelyllä
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Myyntikate toteutunut) ryhmiteltynä
  Asiakkaan ID / Nimike ID / Myyjä ID mukaan
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_customer`](/taulut/dim_customer.md), [`dim_article`](/taulut/dim_article.md), [`dim_user`](/taulut/dim_user.md)

# Huomiot ja rajoitteet

- Kate ei sisällä asiakaskohtaisia palvelukustannuksia (myynti, suunnittelu, laatu, hallinto), ellei niitä ole kohdistettu kustannuskenttiin. Suuren liikevaihdon asiakas voi siksi näyttää kannattavammalta kuin on.
- Nimikeryhmätaso saadaan kentän `dim_article.article_group` kautta.
- Kate ja volyymi kannattaa esittää yhdessä, esimerkiksi hajontakuviona, koska kumpikaan yksin ei riitä asiakassalkun priorisointiin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
