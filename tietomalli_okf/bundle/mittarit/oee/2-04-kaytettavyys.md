---
type: Metric
title: 2.4 Käytettävyys
description: Kuinka suuren osan suunnitellusta tuotantoajasta kone oli käynnissä.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.4
metric_group: OEE ja sen osat
unit: "%"
grain: työkeskus, kone, työkeskusryhmä, vuoro, päivä, viikko
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuren osan suunnitellusta tuotantoajasta kone oli käynnissä. OEE:n ensimmäinen osatekijä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | työkeskus, kone, työkeskusryhmä, vuoro, päivä, viikko |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (perustuu mittareihin 2.1 ja 2.2) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Käyntiaika / Suunniteltu tuotantoaika * 100
```

Sama kaava semanttisilla nimillä:

```text
Käyntiaika / Suunniteltu tuotantoaika * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`dim_workcenter`](/taulut/dim_workcenter.md), [`dim_date`](/taulut/dim_date.md), [`dim_time`](/taulut/dim_time.md)

# Huomiot ja rajoitteet

- Käytettävyys ja koneen käyttöaste ([2.9](/mittarit/oee/2-09-koneen-kayttoaste.md)) eivät ole sama asia: käytettävyydessä vertailuaika on suunniteltu tuotantoaika, käyttöasteessa kalenteriaika.
- Yli 100 %:n arvot ovat merkki siitä, että käyntiaikaa on kirjattu suunnitellun tuotantoajan ulkopuolelta, esimerkiksi miehittämättömästä yöajosta. Tämä on määrittelykysymys, ei virhe.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
