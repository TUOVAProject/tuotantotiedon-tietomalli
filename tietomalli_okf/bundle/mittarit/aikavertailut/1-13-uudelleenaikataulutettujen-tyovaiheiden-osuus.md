---
type: Metric
title: 1.13 Uudelleenaikataulutettujen työvaiheiden osuus
description: Kuinka usein tuotantosuunnitelmaa on jouduttu muuttamaan alkuperäisen suunnittelun jälkeen.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.13
metric_group: Aikavertailujen mittarit
unit: "%"
grain: työkeskus, työkeskusryhmä, viikko, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka usein tuotantosuunnitelmaa on jouduttu muuttamaan alkuperäisen suunnittelun jälkeen.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, viikko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(workphase_id WHERE start_date_original_planned <> start_date_latest_planned
                      OR end_date_original_planned <> end_date_latest_planned)
  / COUNT(workphase_id) * 100
```

Sama kaava semanttisilla nimillä:

```text
Siirretyt työvaiheet / Suunnitellut työvaiheet * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Tietomalli tallentaa erikseen alkuperäisen ja viimeisimmän suunnitelman, mikä tekee mittarista suoraan laskettavan.
- Siirtymän suuruus saadaan erikseen: `date_index(end_date_latest_planned) − date_index(end_date_original_planned)`.
- Korkea arvo ei aina ole huono: se voi kertoa myös aktiivisesta hienokuormituksesta. Mittaria tulkitaan yhdessä aikataulupitävyyden ([1.12](/mittarit/aikavertailut/1-12-tyovaiheiden-aikataulupitavyys.md)) kanssa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
