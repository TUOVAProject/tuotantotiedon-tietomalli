---
type: Metric
title: 6.5 Konetapahtumien kohdistusaste työvaiheisiin
description: Kuinka suuri osa konedatasta on saatu liitettyä työvaiheeseen.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.5
metric_group: Datan laadun tarkastus
unit: "%"
grain: kone, tietolähde, tapahtumatyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa konedatasta on saatu liitettyä työvaiheeseen. Rajoittaa suoraan nimike- ja tilauskohtaisen analytiikan luotettavuutta.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, tietolähde, tapahtumatyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(machine_event_id WHERE workphase_id IS NOT NULL)
  / COUNT(machine_event_id) * 100
```

Sama kaava semanttisilla nimillä:

```text
Työvaiheeseen liitetyt konetapahtumat / Kaikki konetapahtumat * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Sama voidaan laskea ajan suhteen (`SUM(duration_min)`), mikä on usein havainnollisempi kuin rivimäärä.
- Osa tapahtumatyypeistä, kuten anturidatan yksittäiset työstötapahtumat (11) ja sammutusajat (16), ei ole tarkoituskaan liittää työhön. Rajaus on tehtävä tapahtumatyypeittäin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
