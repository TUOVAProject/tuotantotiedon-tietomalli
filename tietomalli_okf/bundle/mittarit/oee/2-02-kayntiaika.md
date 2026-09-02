---
type: Metric
title: 2.2 Käyntiaika
description: Ajan, jonka kone oli aktiivisessa työstössä.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.2
metric_group: OEE ja sen osat
unit: min tai h
grain: työkeskus, kone, vuoro, päivä
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Ajan, jonka kone oli aktiivisessa työstössä.

| | |
| :--- | :--- |
| **Mittayksikkö** | min tai h |
| **Tarkastelutaso** | työkeskus, kone, vuoro, päivä |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (käyntiajan rajaus) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(machine_active_min) WHERE event_type_id IN (6, 8, 17)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Työstöaika min) vaihe- tai päiväkoonneilta
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Rajaus tapahtumatyyppeihin on tehtävä kerran ja käytettävä samana kaikissa OEE-osissa, muuten osatekijät eivät ole keskenään vertailukelpoisia.
- Vaihtoehtoinen laskentatapa on `Suunniteltu tuotantoaika − Seisokkiaika`; tulokset eroavat, jos aikojen kohdistus ei ole täydellinen. Ero näkyy mittarissa 6.1.
- Ilman suodatusta sama työ lasketaan useaan kertaan, koska konetapahtumataulussa on eri tarkkuustason rivejä.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
