---
type: Metric
title: 6.3 Leimaus- ja konedatan poikkeama
description: Kuinka paljon leimausperusteinen ja konedataperusteinen toteuma eroavat toisistaan.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.3
metric_group: Datan laadun tarkastus
unit: "%"
grain: työkeskus, käyttäjä, vuoro, nimike, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon leimausperusteinen ja konedataperusteinen toteuma eroavat toisistaan. Auttaa valitsemaan ensisijaisen tietolähteen.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, käyttäjä, vuoro, nimike, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(phase_duration_stamping_min) − SUM(phase_duration_machine_min))
  / SUM(phase_duration_machine_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
(Vaiheaika leimattu − Vaiheaika konedata) / Vaiheaika konedata * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Systemaattinen ero kertoo leimauskurin tasosta: leimaus aloitetaan tai lopetetaan väärään aikaan tai pyöristetään.
- Mittari on laskettavissa vain työvaiheille, joilla molemmat lähteet ovat käytössä. Kattavuus on hyvä raportoida rinnalla.
- Suuri hajonta on merkittävämpi ongelma kuin tasainen poikkeama, koska jälkimmäinen on korjattavissa laskennallisesti.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
