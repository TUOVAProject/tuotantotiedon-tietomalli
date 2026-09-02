---
type: Metric
title: 2.14 Prosenttikytkinten keskiarvo
description: Kuinka paljon koneenkäyttäjät poikkeavat ohjelmoidusta syötöstä ja karannopeudesta.
tags: [mittari, oee]
status: stable
metric_id: 2.14
metric_group: OEE ja sen osat
unit: "%"
grain: kone, ohjelma, nimike, käyttäjä, vuoro
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon koneenkäyttäjät poikkeavat ohjelmoidusta syötöstä ja karannopeudesta.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, ohjelma, nimike, käyttäjä, vuoro |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
AVG(feed_override), AVG(spindle_override)
```

Sama kaava semanttisilla nimillä:

```text
KESKIARVO(Syötön prosenttikytkin), KESKIARVO(Karan prosenttikytkin)
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Systemaattisesti alle 100 % oleva arvo viittaa ohjelmointi-, työkalu- tai luottamusongelmaan ja kytkeytyy suoraan OEE:n nopeuskomponenttiin.
- Yli 100 % oleva arvo kertoo, että ohjelman arvot ovat varovaisia; se on ohjelman päivitystarve, ei käyttäjän poikkeama.
- Käyttäjäkohtaisia arvoja ei pidä käyttää henkilöarviointiin vaan perehdytyksen ja ohjelmien kehittämiseen.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
