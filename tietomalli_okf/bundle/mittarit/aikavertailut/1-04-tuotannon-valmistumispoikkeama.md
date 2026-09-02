---
type: Metric
title: 1.4 Tuotannon valmistumispoikkeama
description: Kuinka monta päivää tuotanto valmistui suunniteltua myöhemmin tai aikaisemmin.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.4
metric_group: Aikavertailujen mittarit
unit: vrk
grain: tilausrivi, työ, nimike, työkeskus, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka monta päivää tuotanto valmistui suunniteltua myöhemmin tai aikaisemmin.

| | |
| :--- | :--- |
| **Mittayksikkö** | vrk |
| **Tarkastelutaso** | tilausrivi, työ, nimike, työkeskus, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
date_index(production_end_date_actual) − date_index(production_end_date_planned)
```

Sama kaava semanttisilla nimillä:

```text
Päivämääräindeksi(Tuotannon toteutunut lopetus)
  − Päivämääräindeksi(Tuotannon suunniteltu lopetus)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Tuotannon valmistumisvarmuus saadaan osuutena: `COUNT(poikkeama <= 0) / COUNT(valmistuneet) * 100`.
- Mittari kertoo tuotannon sisäisestä suorituskyvystä myös silloin, kun toimituspäivä on edelleen pidossa varastossa tai logistiikassa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
