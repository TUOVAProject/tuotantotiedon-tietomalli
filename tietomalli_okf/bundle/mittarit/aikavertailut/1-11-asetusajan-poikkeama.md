---
type: Metric
title: 1.11 Asetusajan poikkeama
description: Kuinka paljon toteutunut asetustyö poikkeaa suunnitellusta asetusajasta.
tags: [mittari, aikavertailut, edellyttaa-maarittelya]
status: stable
metric_id: 1.11
metric_group: Aikavertailujen mittarit
unit: "%"
grain: työkeskus, nimike, nimikeryhmä, käyttäjä, vuoro
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka paljon toteutunut asetustyö poikkeaa suunnitellusta asetusajasta.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, nimike, nimikeryhmä, käyttäjä, vuoro |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (asetusajan sisältö) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
(SUM(setup_time_actual_min) − SUM(setup_time_planned_min))
  / SUM(setup_time_planned_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
(Asetusaika leimattu − Asetusaika suunniteltu) / Asetusaika suunniteltu * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md), tarkempi toteuma [`fact_machine_events`](/taulut/fact_machine_events.md) (`event_type_id = 7`)

# Huomiot ja rajoitteet

- On sovittava, mitä asetusaikaan lasketaan: työkalujen haku, ohjelman lataus, koeajo ja ensimmäisen kappaleen tarkastus voidaan kirjata joko asetukseen tai tuotantoon.
- Konedatasta johdettu asetusaika on yleensä tarkempi kuin leimattu, koska leimaus tehdään usein jälkikäteen pyöristettynä.
- Käyttäjäkohtaisessa tarkastelussa tulokset on käsiteltävä ryhmätasolla, ei yksittäisen henkilön arviointiin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
