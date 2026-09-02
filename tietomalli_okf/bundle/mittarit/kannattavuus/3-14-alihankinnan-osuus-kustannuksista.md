---
type: Metric
title: 3.14 Alihankinnan osuus kustannuksista
description: Kuinka suuri osa suorista tuotantokustannuksista ostetaan ulkoa.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.14
metric_group: Kannattavuuden mittarit
unit: "%"
grain: nimike, nimikeryhmä, asiakas, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa suorista tuotantokustannuksista ostetaan ulkoa. Taustatieto tee itse vai osta -päätöksille.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | nimike, nimikeryhmä, asiakas, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(subcontracting_cost_actual) / SUM(prime_cost_actual_sum) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Alihankintakustannukset toteutunut)
  / SUMMA(Suorat tuotantokustannukset toteutunut) * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Työvaihetasolla vastaava tarkastelu saadaan rajaamalla `subcontracting_phase = TRUE`, jolloin myös alihankinnan läpimenoajat tulevat mukaan.
- Sisältääkö alihankintakustannus siihen liittyvän logistiikan, on yrityskohtainen ratkaisu ja vaikuttaa vertailtavuuteen.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
