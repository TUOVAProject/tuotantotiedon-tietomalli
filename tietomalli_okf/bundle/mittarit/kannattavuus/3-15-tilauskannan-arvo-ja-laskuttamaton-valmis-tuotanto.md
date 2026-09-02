---
type: Metric
title: 3.15 Tilauskannan arvo ja laskuttamaton valmis tuotanto
description: Avoimen tilauskannan arvon sekä sen osan, joka on jo valmistettu mutta laskuttamatta.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.15
metric_group: Kannattavuuden mittarit
unit: €
grain: asiakas, nimike, suunniteltu toimituskuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Avoimen tilauskannan arvon sekä sen osan, joka on jo valmistettu mutta laskuttamatta.

| | |
| :--- | :--- |
| **Mittayksikkö** | € |
| **Tarkastelutaso** | asiakas, nimike, suunniteltu toimituskuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Tilauskanta          = SUM(total_price) WHERE order_complete = FALSE
Laskuttamaton valmis = SUM(total_price) WHERE order_complete = FALSE
                         AND production_end_date_actual IS NOT NULL
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Tilausrivi hinta) rajattuna riveihin, joilla Tilaus valmis = EPÄTOSI
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Tilauskanta kannattaa ryhmitellä suunnitellun toimituspäivän mukaan, jolloin se toimii samalla kuormitusennusteena.
- Laskuttamaton valmis tuotanto tunnistaa suoraan kassavirtaa hidastavat rivit ja on siksi yksi nopeimmin hyötyä tuottavista mittareista.
- Edellyttää, että `order_complete` päivitetään luotettavasti.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
