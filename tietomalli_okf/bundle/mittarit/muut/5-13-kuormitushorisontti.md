---
type: Metric
title: 5.13 Kuormitushorisontti
description: Kuinka pitkäksi ajaksi nykyinen työjono kuormittaa resurssin.
tags: [mittari, muut, edellyttaa-maarittelya]
status: stable
metric_id: 5.13
metric_group: Muut mittarit ja laskentakaavat
unit: päivää tai viikkoa
grain: työkeskus, työkeskusryhmä
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka pitkäksi ajaksi nykyinen työjono kuormittaa resurssin.

| | |
| :--- | :--- |
| **Mittayksikkö** | päivää tai viikkoa |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (tehollinen kapasiteetti) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Työjonon kuormitus / (Tehollinen kapasiteetti per päivä)
```

Sama kaava semanttisilla nimillä:

```text
Työjonon kuormitus / Päiväkohtainen tehollinen kapasiteetti
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + kapasiteettitieto

# Huomiot ja rajoitteet

- Havainnollisempi luku myyntikeskusteluun kuin kuormitusprosentti: se kertoo suoraan, mistä eteenpäin uusi työ voidaan luvata.
- Ei ota huomioon töiden prioriteetteja eikä myöhässä olevaa kuormaa, joten se on optimistinen arvio.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
