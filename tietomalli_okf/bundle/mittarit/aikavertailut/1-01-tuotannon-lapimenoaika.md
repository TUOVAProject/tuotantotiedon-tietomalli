---
type: Metric
title: 1.1 Tuotannon läpimenoaika
description: Kuinka kauan tilausrivin tuotanto kesti ensimmäisen työvaiheen aloituksesta viimeisen työvaiheen valmistumiseen.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.1
metric_group: Aikavertailujen mittarit
unit: vrk
grain: tilausrivi, työ, nimike, asiakas, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka kauan tilausrivin tuotanto kesti ensimmäisen työvaiheen aloituksesta viimeisen työvaiheen valmistumiseen.

| | |
| :--- | :--- |
| **Mittayksikkö** | vrk |
| **Tarkastelutaso** | tilausrivi, työ, nimike, asiakas, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
dim_date[production_end_date_actual].date_index
  − dim_date[production_start_date_actual].date_index
```

Sama kaava semanttisilla nimillä:

```text
Päivämääräindeksi(Tuotannon toteutunut lopetus)
  − Päivämääräindeksi(Tuotannon toteutunut aloitus)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Sisältää kaiken tuotannossa kuluneen ajan, myös jonotuksen ja odotuksen työvaiheiden välillä.
- Työpäivinä laskettuna käytä `dim_date.is_workday = TRUE` -rivien lukumäärää välillä; kalenteripäivät ja työpäivät antavat eri tuloksen etenkin lomakausina.
- Keskeneräiset työt on rajattava pois: `production_end_date_actual IS NOT NULL`.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
