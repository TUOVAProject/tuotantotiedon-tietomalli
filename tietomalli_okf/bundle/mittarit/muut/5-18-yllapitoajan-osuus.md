---
type: Metric
title: 5.18 Ylläpitoajan osuus
description: Huoltoon ja ylläpitoon kuluneen ajan osuuden.
tags: [mittari, muut]
status: stable
metric_id: 5.18
metric_group: Muut mittarit ja laskentakaavat
unit: "% (myös min tai h absoluuttisena)"
grain: kone, työkeskusryhmä, kuukausi, vuosi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Huoltoon ja ylläpitoon kuluneen ajan osuuden.

| | |
| :--- | :--- |
| **Mittayksikkö** | % (myös min tai h absoluuttisena) |
| **Tarkastelutaso** | kone, työkeskusryhmä, kuukausi, vuosi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(duration_min) WHERE event_type_id = 5
  / SUM(duration_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Kesto min) ylläpitotapahtumilta / SUMMA(Kesto min) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`dim_event_type`](/taulut/dim_event_type.md)

# Huomiot ja rajoitteet

- Mittari kertoo toteutuneesta ylläpidosta. Ennakkohuollon toteutumisastetta ei voi laskea, koska tietomallissa ei ole huoltosuunnitelmaa eikä eräpäiviä.
- Laskeva ylläpitoaika yhdessä nousevan poikkeama-ajan kanssa on varoitusmerkki; mittareita kannattaa katsoa yhdessä.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
