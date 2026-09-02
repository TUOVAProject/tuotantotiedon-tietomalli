---
type: Metric
title: 2.12 Asetus- ja vaihtoajan osuus
description: Kuinka suuri osa tapahtuma-ajasta kuluu asetustyöhön ja kappaleen vaihtoihin.
tags: [mittari, oee]
status: stable
metric_id: 2.12
metric_group: OEE ja sen osat
unit: "%"
grain: kone, nimike, nimikeryhmä, eräkoko, vuoro
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa tapahtuma-ajasta kuluu asetustyöhön ja kappaleen vaihtoihin. Paljastaa eräkoon vaikutuksen tuotannon rakenteeseen.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | kone, nimike, nimikeryhmä, eräkoko, vuoro |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Asetusajan osuus = SUM(setup_time_min) / SUM(duration_min) * 100
Vaihtoajan osuus = SUM(part_change_time_min) / SUM(duration_min) * 100
```

Sama kaava semanttisilla nimillä:

```text
Asetusajan osuus = SUMMA(Asetusaika min) / SUMMA(Kesto min) * 100
Vaihtoajan osuus = SUMMA(Vaihtoaika min) / SUMMA(Kesto min) * 100
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Ryhmittely eräkoon mukaan (`planned_qty` työvaihetaulusta) tekee näkyväksi, missä eräkoossa asetusten osuus muuttuu kohtuuttomaksi. Tämä kytkeytyy suoraan kannattavuusmittariin 3.11.
- Vaihtoaika on kohdistettavissa kiinnitin- ja automaatiokehitykseen; asetusaika taas SMED-tyyppiseen kehitystyöhön.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
