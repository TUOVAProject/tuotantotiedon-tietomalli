---
type: Metric
title: 2.9 Koneen käyttöaste
description: Kuinka suuren osan tarkastelujakson kalenteriajasta kone oli käynnissä.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.9
metric_group: OEE ja sen osat
unit: "%"
grain: kone, työkeskus, työkeskusryhmä, kuukausi, vuosi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuren osan tarkastelujakson kalenteriajasta kone oli käynnissä. Kapasiteetti- ja investointitarkastelun mittari.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, työkeskus, työkeskusryhmä, kuukausi, vuosi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (vertailuajan rajaus) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(machine_active_min) / (tarkastelujakson päivien määrä * 1440) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Työstöaika min) / (Jakson päivät * 1440) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`dim_date`](/taulut/dim_date.md)

# Huomiot ja rajoitteet

- Vertailuaika on valittava: koko kalenteriaika, työpäivät (`is_workday = TRUE`) tai vuorojen mukainen aika. Luvut eivät ole vertailukelpoisia keskenään.
- Matala käyttöaste ei sinänsä ole ongelma, jos konetta ei ole tarkoitettukaan käytettäväksi ympärivuorokautisesti. Mittari kertoo investoinnin hyödyntämisestä, ei tuotannon sujuvuudesta.
- Sammutusajan osuus saadaan vastaavasti kentästä `power_off_min`; se kertoo miehittämättömän ajon potentiaalista.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
