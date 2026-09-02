---
type: Metric
title: 3.11 Asetuskustannus kappaletta kohti
description: Eräkoon vaikutuksen yksittäisen kappaleen kannattavuuteen.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.11
metric_group: Kannattavuuden mittarit
unit: €/kpl
grain: työvaihe, nimike, työkeskus, eräkoko
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Eräkoon vaikutuksen yksittäisen kappaleen kannattavuuteen. Tukee sopivan valmistuserän määrittämistä.

| | |
| :--- | :--- |
| **Mittayksikkö** | €/kpl |
| **Tarkastelutaso** | työvaihe, nimike, työkeskus, eräkoko |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(setup_time_planned_min / 60 * workcenter_hour_rate) / planned_qty
```

Sama kaava semanttisilla nimillä:

```text
(Asetusaika suunniteltu / 60 * Tuntihinta) / Suunniteltu määrä
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`dim_workcenter`](/taulut/dim_workcenter.md), [`dim_article`](/taulut/dim_article.md)

# Huomiot ja rajoitteet

- Summattavissa työn kaikkien vaiheiden yli kappalekohtaiseksi kokonaisasetuskustannukseksi.
- Toteumaan perustuva versio saadaan korvaamalla suunniteltu asetusaika kentällä `setup_time_stamping_min` tai `setup_time_machine_min`.
- Edellyttää, että `workcenter_hour_rate` on täytetty ja vastaa työn ajankohdan konetuntihintaa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
