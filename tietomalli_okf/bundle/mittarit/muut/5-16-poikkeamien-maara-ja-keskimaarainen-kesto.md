---
type: Metric
title: 5.16 Poikkeamien määrä ja keskimääräinen kesto
description: Kuinka usein häiriöitä esiintyy ja kuinka kauan ne kestävät.
tags: [mittari, muut, edellyttaa-maarittelya]
status: stable
metric_id: 5.16
metric_group: Muut mittarit ja laskentakaavat
unit: kpl, min ja min/poikkeama
grain: kone, työkeskusryhmä, poikkeamatyyppi, vuoro, kuukausi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka usein häiriöitä esiintyy ja kuinka kauan ne kestävät.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl, min ja min/poikkeama |
| **Tarkastelutaso** | kone, työkeskusryhmä, poikkeamatyyppi, vuoro, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (poikkeamien luokittelu) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Määrä         = COUNT(machine_event_id) WHERE event_type_id IN (4, 15)
Kokonaisaika  = SUM(exception_min)
Keskim. kesto = SUM(exception_min) / COUNT(poikkeamat)
```

Sama kaava semanttisilla nimillä:

```text
Poikkeamatapahtumien lukumäärä, SUMMA(Poikkeama min) ja niiden osamäärä
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`dim_exception`](/taulut/dim_exception.md), [`dim_event_type`](/taulut/dim_event_type.md)

# Huomiot ja rajoitteet

- Konetapahtumataulun poikkeamat ovat koneen häiriötiloja, eivät kunnossapidon vikailmoituksia. Mittari kuvaa tuotannon menetettyä aikaa, ei korjausaikaa, joten se ei ole varsinainen MTBF tai MTTR.
- Kunnossapidon näkökulmasta lasketut vastineet (häiriöiden välinen käyntiaika `SUM(machine_active_min) / poikkeamien määrä`) ovat käyttökelpoisia vain, jos `dim_exception.exception_type` erottelee todelliset viat muista poikkeamista.
- Pareto-analyysi `exception_id`-kentän kautta kohdistaa kehitystyön tehokkaimmin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
