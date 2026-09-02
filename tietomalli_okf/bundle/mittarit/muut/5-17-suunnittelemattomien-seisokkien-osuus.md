---
type: Metric
title: 5.17 Suunnittelemattomien seisokkien osuus
description: Vikojen ja muiden ennakoimattomien häiriöiden osuuden suunnitellusta tuotantoajasta.
tags: [mittari, muut, edellyttaa-maarittelya]
status: stable
metric_id: 5.17
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

Vikojen ja muiden ennakoimattomien häiriöiden osuuden suunnitellusta tuotantoajasta.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, työkeskusryhmä, vuoro, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (suunnittelemattoman seisokin rajaus) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(exception_min + undefined_idle_min) / Suunniteltu tuotantoaika * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Poikkeama min + Muu odotusaika min) / Suunniteltu tuotantoaika * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Kohdistamaton tyhjäkäynti (`undefined_idle_min`) ei ole automaattisesti suunnittelematon seisokki. Sen sisällyttäminen on määrittelykysymys ja vaikuttaa lukuun merkittävästi.
- Häiriösyyt on kirjattava vakioluokituksella, muuten mittari ei ohjaa toimenpiteisiin.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
