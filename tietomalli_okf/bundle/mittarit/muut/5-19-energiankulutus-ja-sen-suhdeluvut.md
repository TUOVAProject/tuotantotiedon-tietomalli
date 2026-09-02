---
type: Metric
title: 5.19 Energiankulutus ja sen suhdeluvut
description: Kulutetun energian määrän ja sen suhteen tuotantoon.
tags: [mittari, muut]
status: stable
metric_id: 5.19
metric_group: Muut mittarit ja laskentakaavat
unit: kWh, kWh/kpl, kWh/h ja %
grain: kone, nimike, ohjelma, työvaihe, vuoro, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kulutetun energian määrän ja sen suhteen tuotantoon.

| | |
| :--- | :--- |
| **Mittayksikkö** | kWh, kWh/kpl, kWh/h ja % |
| **Tarkastelutaso** | kone, nimike, ohjelma, työvaihe, vuoro, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Kulutus yhteensä   = SUM(power_consumption_kwh)
Kappaletta kohti   = SUM(power_consumption_kwh) / SUM(produced_qty_machine)
Käyntituntia kohti = SUM(power_consumption_kwh) / (SUM(machine_active_min) / 60)
Tyhjäkäynnin osuus = SUM(power_consumption_kwh) WHERE event_type_id = 14
                       / SUM(power_consumption_kwh) * 100
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Energiankulutus kWh) sekä sen suhde
  Tuotettu määrä konedata -kenttään ja Työstöaika min -kenttään
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md)

# Huomiot ja rajoitteet

- Edellyttää, että `power_consumption_kwh` on täytetty luotettavasti; kaikilla koneilla mittausta ei ole.
- Käytä leimausperusteista tuotantomäärää, jos konedatan määrä ei ole luotettava.
- Energiakustannus (`kulutus × sähkön yksikköhinta`) edellyttää hintatiedon tuomista erikseen, sitä ei ole tietomallissa.
- Tyhjäkäynnin energiaosuus tukee sammutuskäytäntöjen kehittämistä ja täydentää sammutusajan tarkastelua.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
