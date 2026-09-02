---
type: Metric
title: 1.2 Tuotannon läpimenoajan poikkeama
description: Kuinka paljon toteutunut tuotannon läpimenoaika poikkeaa suunnitellusta.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.2
metric_group: Aikavertailujen mittarit
unit: vrk
grain: tilausrivi, nimike, asiakas, tilaustyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon toteutunut tuotannon läpimenoaika poikkeaa suunnitellusta. Kertoo tuotannonsuunnittelun osuvuudesta.

| | |
| :--- | :--- |
| **Mittayksikkö** | vrk |
| **Tarkastelutaso** | tilausrivi, nimike, asiakas, tilaustyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(date_index(production_end_date_actual) − date_index(production_start_date_actual))
  − (date_index(production_end_date_planned) − date_index(production_start_date_planned))
```

Sama kaava semanttisilla nimillä:

```text
Toteutunut tuotannon läpimenoaika − Suunniteltu tuotannon läpimenoaika
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Positiivinen arvo tarkoittaa suunniteltua pidempää läpimenoa.
- Mittari ei erottele, johtuuko poikkeama myöhäisestä aloituksesta vai hitaasta tuotannosta. Erottelu tehdään mittareilla 1.3 ja 1.4.
- Uusilla nimikkeillä (`new_article = TRUE`) poikkeama on tyypillisesti suurempi; ryhmittely tämän kentän mukaan selittää usein hajontaa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
