---
type: Metric
title: 5.5 Työtuntitehokkuus
description: Suunnitellun ajan suhteen toteutuneeseen aikaan.
tags: [mittari, muut]
status: stable
metric_id: 5.5
metric_group: Muut mittarit ja laskentakaavat
unit: "%"
grain: työkeskus, työkeskusryhmä, nimike, vuoro, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Suunnitellun ajan suhteen toteutuneeseen aikaan. Kertoo, tehdäänkö työ suunnitellussa ajassa.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, nimike, vuoro, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(phase_duration_planned_min) / SUM(phase_duration_actual_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Vaiheaika suunniteltu) / SUMMA(Vaiheaika leimattu) * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md)

# Huomiot ja rajoitteet

- Yli 100 % tarkoittaa suunniteltua nopeampaa tekemistä. Jatkuvasti yli sadan oleva arvo kertoo yleensä liian väljistä suunnitteluarvoista, ei poikkeuksellisesta suorituksesta.
- Mittari on vaiheajan poikkeaman ([1.10](/mittarit/aikavertailut/1-10-vaiheajan-poikkeama.md)) käänteinen esitystapa. Valitse organisaatioon vain toinen, muuten samasta asiasta raportoidaan kahdella luvulla.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
