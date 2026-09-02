---
type: Metric
title: 1.8 OTIF, ajallaan ja täysimääräisenä toimitetut
description: Kuinka suuri osa toimituksista oli sekä ajallaan että täysimääräisiä.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.8
metric_group: Aikavertailujen mittarit
unit: "%"
grain: asiakas, nimike, tilaustyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa toimituksista oli sekä ajallaan että täysimääräisiä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | asiakas, nimike, tilaustyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(order_row_id WHERE delivery_date_actual <= delivery_date_planned
                     AND delivered_qty >= ordered_qty)
  / COUNT(order_row_id WHERE delivery_date_actual IS NOT NULL) * 100
```

Sama kaava semanttisilla nimillä:

```text
Ajallaan ja täysimääräisenä toimitetut tilausrivit / Toimitetut tilausrivit * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Edellyttää, että `delivered_qty` täytetään. Jos kenttä jätetään tyhjäksi, mittari palautuu toimitusvarmuudeksi ([1.7](/mittarit/aikavertailut/1-07-tilausten-toimitusvarmuus.md)).
- Tietomallissa on yksi rivi tilausriviä kohti, joten osatoimitukset eivät erotu omiksi tapahtumikseen. Osatoimitetun rivin täysimääräisyys näkyy vasta viimeisen toimituserän jälkeen.
- Jos ylitoimitus on mahdollinen, ehto kannattaa määritellä muotoon `delivered_qty >= ordered_qty` eikä tasan yhtä suureksi.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
