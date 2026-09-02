---
type: Metric
title: 5.20 Miehittämättömän ajon osuus
description: Kuinka suuri osa koneajasta ajetaan ilman käyttäjää.
tags: [mittari, muut, edellyttaa-maarittelya]
status: stable
metric_id: 5.20
metric_group: Muut mittarit ja laskentakaavat
unit: "%"
grain: kone, työkeskusryhmä, vuoro, kuukausi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa koneajasta ajetaan ilman käyttäjää. Automaatioasteen seurantamittari.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, työkeskusryhmä, vuoro, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (läsnäolotiedon keruu) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(machine_active_min) ilman päällekkäistä event_type_id = 18 -jaksoa
  / SUM(machine_active_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
Työstöaika ilman käyttäjän läsnäoloa / Työstöaika yhteensä * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) (`event_type_id = 18` sekä työstötapahtumat)

# Huomiot ja rajoitteet

- Edellyttää, että käyttäjän läsnäolo kirjataan tapahtumatyypillä 18 joko leimauksesta tai antureista. Ilman sitä mittaria ei voi laskea.
- Aikajaksojen päällekkäisyyden laskenta vaatii aikaleimapohjaisen käsittelyn (`start_at`, `end_at`), ei pelkkää summausta.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
