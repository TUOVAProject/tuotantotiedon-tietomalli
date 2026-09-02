---
type: Metric
title: 2.3 Seisokkiaika ja seisokkiaste
description: Ajan, jonka kone ei ollut tuotannossa suunnitellun tuotantoajan sisällä, sekä sen osuuden suunnitellusta ajasta.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.3
metric_group: OEE ja sen osat
unit: min tai h; osuus %
grain: työkeskus, kone, vuoro, päivä, viikko
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Ajan, jonka kone ei ollut tuotannossa suunnitellun tuotantoajan sisällä, sekä sen osuuden suunnitellusta ajasta.

| | |
| :--- | :--- |
| **Mittayksikkö** | min tai h; osuus % |
| **Tarkastelutaso** | työkeskus, kone, vuoro, päivä, viikko |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (seisokkiluokittelu) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Seisokkiaika  = SUM(idle_sum_min + exception_min + power_off_min)
Seisokkiaste  = Seisokkiaika / Suunniteltu tuotantoaika * 100
```

Sama kaava semanttisilla nimillä:

```text
Seisokkiaika = SUMMA(Odotusaika min + Poikkeama min + Sammutettu min)
Seisokkiaste = Seisokkiaika / Suunniteltu tuotantoaika * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md), syyerittely [`dim_exception`](/taulut/dim_exception.md)

# Huomiot ja rajoitteet

- Kaikkia tyhjäkäynti- tai sammutusaikoja ei välttämättä lueta OEE-seisokiksi; luokittelu on sovittava.
- Erittely tehdään suoraan omista kentistään: `setup_time_min`, `part_change_time_min`, `undefined_idle_min`, `exception_min`, `power_off_min`.
- Häiriösyiden Pareto-analyysi saadaan liittämällä `exception_id` tauluun [`dim_exception`](/taulut/dim_exception.md).

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
