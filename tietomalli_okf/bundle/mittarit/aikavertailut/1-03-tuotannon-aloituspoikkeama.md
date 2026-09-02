---
type: Metric
title: 1.3 Tuotannon aloituspoikkeama
description: Kuinka monta päivää tuotannon todellinen aloitus poikkesi suunnitellusta aloituspäivästä.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.3
metric_group: Aikavertailujen mittarit
unit: vrk
grain: tilausrivi, työkeskus, viikko, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka monta päivää tuotannon todellinen aloitus poikkesi suunnitellusta aloituspäivästä.

| | |
| :--- | :--- |
| **Mittayksikkö** | vrk |
| **Tarkastelutaso** | tilausrivi, työkeskus, viikko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
date_index(production_start_date_actual) − date_index(production_start_date_planned)
```

Sama kaava semanttisilla nimillä:

```text
Päivämääräindeksi(Tuotannon toteutunut aloitus)
  − Päivämääräindeksi(Tuotannon suunniteltu aloitus)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Erottaa aloituksen myöhästymisen tuotannon hitaudesta, mikä on olennaista syytä etsittäessä.
- Negatiivinen arvo tarkoittaa suunniteltua aikaisempaa aloitusta. Kannattaa raportoida sekä keskiarvo että jakauma, koska etu- ja jälkijättöiset arvot kumoavat toisensa keskiarvossa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
