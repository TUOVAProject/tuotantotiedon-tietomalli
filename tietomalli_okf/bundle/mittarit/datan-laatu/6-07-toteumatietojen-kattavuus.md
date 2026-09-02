---
type: Metric
title: 6.7 Toteumatietojen kattavuus
description: Kuinka suuri osa keskeisistä toteumakentistä on täytetty.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.7
metric_group: Datan laadun tarkastus
unit: "%"
grain: kenttä, taulu, kuukausi, tietolähde
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa keskeisistä toteumakentistä on täytetty.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kenttä, taulu, kuukausi, tietolähde |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(rivit joilla kenttä IS NULL) / COUNT(rivit) * 100
  esim. start_timestamp_actual, end_timestamp_actual,
        prime_cost_actual_sum, delivered_qty
```

Sama kaava semanttisilla nimillä:

```text
Puuttuvat arvot / Kaikki rivit * 100 kentittäin
```

# Tietolähde

kaikki faktataulut

# Huomiot ja rajoitteet

- Tee erikseen suunnitelluille ja toteutuneille kentille; suunnittelupuoli on yleensä kattava ja toteumapuoli puutteellinen.
- Keskeneräiset työt tuottavat luonnollisesti tyhjiä toteumakenttiä, joten laskenta on rajattava valmistuneisiin riveihin.
- Puuttuvien arvojen osuus kannattaa raportoida jokaisen kustannus- ja aikamittarin yhteydessä, jotta lukija tietää, mihin osaan aineistosta luku perustuu.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
