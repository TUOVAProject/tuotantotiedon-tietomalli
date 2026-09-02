---
type: Metric
title: 6.9 Ristiriitaiset kirjaukset
description: Rivien määrän, joissa data on loogisesti mahdotonta.
tags: [mittari, datan-laatu]
status: stable
metric_id: 6.9
metric_group: Datan laadun tarkastus
unit: kpl
grain: taulu, kone, tietolähde, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Rivien määrän, joissa data on loogisesti mahdotonta.

| | |
| :--- | :--- |
| **Mittayksikkö** | kpl |
| **Tarkastelutaso** | taulu, kone, tietolähde, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(end_at < start_at)
COUNT(produced_qty = 0 AND duration_min > 0)
COUNT(rejected_qty > produced_qty)
COUNT(end_date_actual < start_date_actual)
```

Sama kaava semanttisilla nimillä:

```text
Rivit, joilla lopetus on ennen aloitusta, hylkyjä enemmän kuin tuotantoa
  tai aikaa ilman tuotantomäärää
```

# Tietolähde

kaikki faktataulut

# Huomiot ja rajoitteet

- Nämä tarkistukset kannattaa ajaa osana latausprosessia, ei vasta raportilla.
- Nollatuotantomäärälliset tuotantotapahtumat eivät aina ole virheitä: ne voivat olla keskeytyneitä töitä tai koeajoja. Tapaukset on syytä käydä läpi ennen sääntöjen kiristämistä.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
