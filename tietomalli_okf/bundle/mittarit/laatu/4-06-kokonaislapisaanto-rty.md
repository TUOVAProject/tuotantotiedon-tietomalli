---
type: Metric
title: 4.6 Kokonaisläpisaanto, RTY
description: Todennäköisyyden, että kappale läpäisee kaikki peräkkäiset työvaiheet ilman virhettä.
tags: [mittari, laatu, edellyttaa-maarittelya]
status: stable
metric_id: 4.6
metric_group: Laadun mittarit
unit: "%"
grain: työ, nimike, nimikeryhmä, tuotantolinja
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Todennäköisyyden, että kappale läpäisee kaikki peräkkäiset työvaiheet ilman virhettä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työ, nimike, nimikeryhmä, tuotantolinja |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (perustuu mittariin 4.5) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
TULO(FPY(vaihe)) saman work_id:n vaiheille, järjestettynä phase_number mukaan
```

Sama kaava semanttisilla nimillä:

```text
Vaihekohtaisten läpäisysaantojen tulo työn kaikkien vaiheiden yli
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Tietomallin porautumisketju tukee laskentaa hyvin, koska vaiheet ovat järjestettävissä ja liitettävissä samaan työhön.
- Perii FPY:n rajoitteen: korjatut kappaleet eivät erotu, joten RTY on todellista korkeampi.
- Mittari on herkkä vaiheiden määrälle. Eri pituisten reittien tuotteita ei voi verrata suoraan keskenään.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
