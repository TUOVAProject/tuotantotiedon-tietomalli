---
type: Metric
title: 6.6 Kytkemättömien rivien osuus
description: Kuinka suuri osa tilausriveistä on ilman työvaiheita ja työvaiheista ilman konetapahtumia.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.6
metric_group: Datan laadun tarkastus
unit: "%"
grain: asiakas, nimike, työkeskus, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa tilausriveistä on ilman työvaiheita ja työvaiheista ilman konetapahtumia. Paljastaa katkokset porautumisketjussa.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | asiakas, nimike, työkeskus, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(order_row_id ilman fact_workphases-riviä) / COUNT(order_row_id) * 100
COUNT(workphase_id ilman fact_machine_events-riviä) / COUNT(workphase_id) * 100
```

Sama kaava semanttisilla nimillä:

```text
Työvaiheettomat tilausrivit / Kaikki tilausrivit * 100
Konetapahtumattomat työvaiheet / Kaikki työvaiheet * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md), [`fact_workphases`](/taulut/fact_workphases.md), [`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Osa tilausriveistä on aidosti ilman tuotantoa, esimerkiksi kauppatavara. Ne on rajattava pois, muuten mittari näyttää jatkuvasti huonolta.
- Vaikuttaa suoraan tuntikatteeseen ([3.10](/mittarit/kannattavuus/3-10-tuntikate.md)) ja kaikkiin mittareihin, joissa yhdistetään tilausrivin arvo ja tuotannon aika.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
