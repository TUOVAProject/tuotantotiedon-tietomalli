---
type: Reference
title: Perusmittaristo
description: Suositeltu vähimmäismittaristo, joka on laskettavissa suoraan tietomallista.
tags: [mittari, kayttoonotto]
status: stable
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Perusmittaristo

Alla on esimerkkejä suoraan tietomallista saatavista mittareista. Alempana avataan tarkemmin erilaisia mittareita.

- **Myynti:** `SUM(total_price)`
- **Toteutunut kate:** `SUM(sales_margin_actual)` tai `SUM(total_price) - SUM(manufacturing_cost_actual)`
- **Toteutunut kate-%:** `SUM(sales_margin_actual) / SUM(total_price) * 100`
- **Valmistuskustannusten poikkeama:** `SUM(manufacturing_cost_actual) - SUM(manufacturing_cost_planned)`
- **Toimitusvarmuus:** ajoissa toimitetut tilausrivit / toimitetut tilausrivit
- **Tuotannon läpimenoaika:** `production_end_date_actual - production_start_date_actual`
- **Työvaiheen aikataulupitävyys:** ajoissa valmistuneet työvaiheet / valmistuneet työvaiheet
- **Vaiheajan poikkeama:** `(SUM(phase_duration_stamping_min) - SUM(phase_duration_planned_min)) / SUM(phase_duration_planned_min) * 100`
- **Hylkäysaste:** `SUM(rejected_qty) / SUM(produced_qty) * 100`
- **Laatukerroin:** `(SUM(produced_qty) - SUM(rejected_qty)) / SUM(produced_qty) * 100`
- **Työpisteen suunniteltu kuormitus:** `SUM(phase_duration_planned_min)` ryhmiteltynä työkeskukselle
- **Työstöajan osuus:** `SUM(machine_active_min) / SUM(duration_min) * 100`
- **Odotusajan osuus:** `SUM(idle_sum_min) / SUM(duration_min) * 100`
- **Poikkeama-ajan osuus:** `SUM(exception_min) / SUM(duration_min) * 100`
- **Energia kappaletta kohti:** `SUM(power_consumption_kwh) / SUM(produced_qty_machine)`, jos energiadata ja konedatan tuotantomäärä ovat luotettavia
