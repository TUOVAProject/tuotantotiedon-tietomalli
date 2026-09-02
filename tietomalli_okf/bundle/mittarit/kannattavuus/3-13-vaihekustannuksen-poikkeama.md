---
type: Metric
title: 3.13 Vaihekustannuksen poikkeama
description: Kuinka paljon työvaiheen toteutuneet suoran työn kustannukset poikkeavat suunnitelluista.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.13
metric_group: Kannattavuuden mittarit
unit: €
grain: työvaihe, työkeskus, työkeskusryhmä, nimike, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon työvaiheen toteutuneet suoran työn kustannukset poikkeavat suunnitelluista.

| | |
| :--- | :--- |
| **Mittayksikkö** | € |
| **Tarkastelutaso** | työvaihe, työkeskus, työkeskusryhmä, nimike, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(phase_cost_actual_stamping) − SUM(phase_cost_planned)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Vaihekustannus leimaukset) − SUMMA(Vaihekustannus suunniteltu)
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Käytä `phase_cost_actual_machine`-kenttää, jos konedata on ensisijainen toteumalähde.
- Vaihetason poikkeamien summa työn yli selittää tilaustason jälkilaskennan poikkeaman ([3.5](/mittarit/kannattavuus/3-05-jalkilaskennan-poikkeama.md)) siltä osin kuin kyse on suorasta työstä.
- Toteutunut tuntikustannus saadaan jakamalla vaihekustannus toteutuneella ajalla; sitä kannattaa verrata työkeskuksen tuntihintaan `workcenter_hour_rate`.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
