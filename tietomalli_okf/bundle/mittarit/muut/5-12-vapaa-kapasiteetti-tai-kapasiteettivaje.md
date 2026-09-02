---
type: Metric
title: 5.12 Vapaa kapasiteetti tai kapasiteettivaje
description: Kapasiteetin ja kuormituksen erotuksen.
tags: [mittari, muut, edellyttaa-maarittelya]
status: stable
metric_id: 5.12
metric_group: Muut mittarit ja laskentakaavat
unit: h tai standardih; osuus %
grain: työkeskus, työkeskusryhmä, viikko
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kapasiteetin ja kuormituksen erotuksen. Kertoo, voidaanko uusia töitä ottaa vastaan.

| | |
| :--- | :--- |
| **Mittayksikkö** | h tai standardih; osuus % |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, viikko |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (tehollinen kapasiteetti) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Tehollinen kapasiteetti − Työpisteen kokonaiskuormitus
Puskurin osuus = (Tehollinen kapasiteetti − kuormitus) / Tehollinen kapasiteetti * 100
```

Sama kaava semanttisilla nimillä:

```text
Tehollinen kapasiteetti − Suunniteltu kuormitus
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + kapasiteettitieto

# Huomiot ja rajoitteet

- Negatiivinen arvo on kapasiteettivaje.
- Kapasiteettipuskuri on tarkoituksellinen: täyteen kuormitettu tuotanto ei kestä häiriöitä eikä kiiretöitä. Tavoitetaso on päätettävä, tietomalli ei sitä sisällä.
- Pullonkaulaksi tunnistetun työkeskuksen marginaali on tärkein yksittäinen luku toimituskyvyn ennakoinnissa.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
