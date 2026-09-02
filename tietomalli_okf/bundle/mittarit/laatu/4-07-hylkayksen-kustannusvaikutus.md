---
type: Metric
title: 4.7 Hylkäyksen kustannusvaikutus
description: Hylättyjen kappaleiden valmistusarvon euroina ja sen osuuden valmistuskustannuksista.
tags: [mittari, laatu, edellyttaa-maarittelya]
status: stable
metric_id: 4.7
metric_group: Laadun mittarit
unit: € ja %
grain: nimike, asiakas, työvaihe, kuukausi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Hylättyjen kappaleiden valmistusarvon euroina ja sen osuuden valmistuskustannuksista.

| | |
| :--- | :--- |
| **Mittayksikkö** | € ja % |
| **Tarkastelutaso** | nimike, asiakas, työvaihe, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (hylyn arvostusperiaate) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(rejected_qty * unit_manufacturing_cost_actual)
  / SUM(manufacturing_cost_actual) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Hylätty määrä * Kappale valmistuskustannukset toteutunut)
  / SUMMA(Valmistuskustannukset toteutunut) * 100
```

# Tietolähde

[`fact_workphases`](/taulut/fact_workphases.md) + [`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Kattaa vain hylättyjen kappaleiden valmistusarvon, ei korjaustyötä, uusintamateriaalia eikä lajittelua. Todellinen laatukustannus on suurempi.
- Kappaleen arvo riippuu siitä, missä työvaiheessa se hylättiin. Tarkempi arvio saadaan käyttämällä hylkäyshetkeen mennessä kertyneitä vaihekustannuksia koko kappalekustannuksen sijaan.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
