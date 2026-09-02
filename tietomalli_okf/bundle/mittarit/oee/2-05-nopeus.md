---
type: Metric
title: 2.5 Nopeus
description: Toteutuneen tuotantonopeuden suhteen tavoitenopeuteen.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.5
metric_group: OEE ja sen osat
unit: "%"
grain: kone, nimike, ohjelma, vuoro
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Toteutuneen tuotantonopeuden suhteen tavoitenopeuteen. Paljastaa hitaat syklit, pienpysähdykset ja alennetun työstönopeuden. OEE:n toinen osatekijä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, nimike, ohjelma, vuoro |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (ihannesykliajan asettaminen) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(cycle_time_ideal_min * Valmistettu määrä) / Käyntiaika * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Kappale jaksoaika tavoite * Valmistettu määrä) / Käyntiaika * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`fact_workphases`](/taulut/fact_workphases.md) (`cycle_time_ideal_min`)

# Huomiot ja rajoitteet

- Valmistettuun määrään lasketaan myös hylätyt kappaleet, koska ne ovat vieneet koneaikaa. Hylkyjen vaikutus tulee mukaan vasta laatukertoimessa.
- Ihannesykliaika (`cycle_time_ideal_min`) on täytettävä nimikkeittäin. Jos se puuttuu, `cycle_time_planned_min` antaa tavoitepohjaisen mutta ei OEE-määritelmän mukaisen arvon.
- Kentän kattavuutta kannattaa seurata mittarilla 6.8, koska puuttuvat ihannesykliajat vääristävät nopeutta ja siten koko OEE:tä.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
