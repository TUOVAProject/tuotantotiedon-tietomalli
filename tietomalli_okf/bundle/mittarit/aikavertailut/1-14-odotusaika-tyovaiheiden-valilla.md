---
type: Metric
title: 1.14 Odotusaika työvaiheiden välillä
description: Kuinka kauan työ seisoi kahden peräkkäisen työvaiheen välissä.
tags: [mittari, aikavertailut]
status: stable
metric_id: 1.14
metric_group: Aikavertailujen mittarit
unit: h
grain: työ, työvaihepari, työkeskus, työkeskusryhmä
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka kauan työ seisoi kahden peräkkäisen työvaiheen välissä. Paljastaa jonot ja siirrot, jotka eivät näy vaiheaikojen summassa.

| | |
| :--- | :--- |
| **Mittayksikkö** | h |
| **Tarkastelutaso** | työ, työvaihepari, työkeskus, työkeskusryhmä |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
start_timestamp_actual(phase_number = n+1) − end_timestamp_actual(phase_number = n)
  saman work_id:n sisällä
```

Sama kaava semanttisilla nimillä:

```text
Aloitus aikaleima toteutunut (seuraava vaihe)
  − Lopetus aikaleima toteutunut (edellinen vaihe)
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Edellyttää, että vaiheet voidaan järjestää `phase_number`-kentän mukaan ja että aikaleimat on täytetty.
- Vaiheiden osittainen limittyminen tuottaa negatiivisia arvoja; ne kannattaa käsitellä erikseen eikä suodattaa pois, koska ne kertovat rinnakkaisesta tekemisestä.
- Odotusajan summa suhteessa läpimenoaikaan ([1.1](/mittarit/aikavertailut/1-01-tuotannon-lapimenoaika.md)) antaa arvion arvoa lisäämättömästä ajasta.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
