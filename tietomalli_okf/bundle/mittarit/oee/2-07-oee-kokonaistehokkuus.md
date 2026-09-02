---
type: Metric
title: 2.7 OEE, kokonaistehokkuus
description: Käytettävyyden, nopeuden ja laadun yhteisvaikutuksen yhtenä lukuna.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.7
metric_group: OEE ja sen osat
unit: "%"
grain: kone, työkeskusryhmä, nimike, vuoro, päivä, viikko
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Käytettävyyden, nopeuden ja laadun yhteisvaikutuksen yhtenä lukuna.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, työkeskusryhmä, nimike, vuoro, päivä, viikko |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (perustuu mittareihin 2.4–2.6) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Käytettävyys * Nopeus * Laatukerroin        (desimaalilukuina)

tai suoraan:
SUM(Hyväksytty määrä * cycle_time_ideal_min) / Suunniteltu tuotantoaika * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Hyväksytty määrä * Kappale jaksoaika tavoite) / Suunniteltu tuotantoaika * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`fact_workphases`](/taulut/fact_workphases.md) + [`dim_workcenter`](/taulut/dim_workcenter.md), [`dim_time`](/taulut/dim_time.md)

# Huomiot ja rajoitteet

- Yksittäinen OEE-luku ei kerro, mistä häviö syntyy. Osatekijät on raportoitava aina yhdessä kokonaisluvun kanssa.
- OEE soveltuu parhaiten toistuvaan konekohtaiseen tuotantoon. Piensarjatuotannossa, jossa asetusten osuus on suuri, se antaa systemaattisesti matalia arvoja eikä kerro toiminnan laadusta.
- OEE ei sovi työkeskusten keskinäiseen vertailuun, ellei ihannesykliaikoja ole asetettu samalla periaatteella.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
