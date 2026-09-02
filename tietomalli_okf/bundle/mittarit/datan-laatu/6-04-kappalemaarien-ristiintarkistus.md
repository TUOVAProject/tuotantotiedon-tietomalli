---
type: Metric
title: 6.4 Kappalemäärien ristiintarkistus
description: Vastaavatko leimattu ja konedatasta laskettu tuotantomäärä toisiaan.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.4
metric_group: Datan laadun tarkastus
unit: kpl
grain: kone, työvaihe, nimike, päivä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Vastaavatko leimattu ja konedatasta laskettu tuotantomäärä toisiaan.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl |
| **Tarkastelutaso** | kone, työvaihe, nimike, päivä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(produced_qty_stamping) − SUM(produced_qty_machine)
sekä part_counter-kentän jatkuvuuden tarkistus
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Tuotettu määrä leimausdata) − SUMMA(Tuotettu määrä konedata)
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Ero paljastaa raportointivirheitä molempiin suuntiin: unohtuneita leimauksia tai koneen laskurin laskemia koeajokappaleita.
- Kappalelaskurin (`part_counter`) nollaukset ja vaihtumiset on käsiteltävä erikseen, muuten erotus antaa virheellisiä arvoja.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
