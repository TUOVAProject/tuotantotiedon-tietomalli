---
type: Metric
title: 2.1 Suunniteltu tuotantoaika
description: Ajan, jonka kone oli tarkoitus olla tuotannossa.
tags: [mittari, oee, edellyttaa-maarittelya]
status: stable
metric_id: 2.1
metric_group: OEE ja sen osat
unit: min tai h
grain: työkeskus, työkeskusryhmä, vuoro, päivä, viikko
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Ajan, jonka kone oli tarkoitus olla tuotannossa. OEE:n ja seisokkimittareiden vertailuaika.

| | |
| :--- | :--- |
| **Mittayksikkö** | min tai h |
| **Tarkastelutaso** | työkeskus, työkeskusryhmä, vuoro, päivä, viikko |
| **Tila** | Edellyttää yrityskohtaista määrittelyä |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(duration_min) WHERE event_type_id = 19
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Kesto min) rajattuna tapahtumatyyppiin Suunniteltu tuotantoaika
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) (`event_type_id = 19`) + [`dim_date`](/taulut/dim_date.md), [`dim_time`](/taulut/dim_time.md)

# Huomiot ja rajoitteet

- Edellyttää, että tapahtumatyypin 19 rivejä tuotetaan vuorokausikohtaisesti koneittain. Ilman niitä koko OEE-mittaristo jää laskematta määritelmän mukaisesti.
- Vaihtoehtoisesti aika voidaan johtaa työvuorokalenterista yhdistämällä `dim_date.is_workday` ja `dim_time.shift_id`, mutta silloin suunnitellut seisokit (huollot, koulutukset, lomautukset) eivät vähene automaattisesti.
- On päätettävä, sisältyvätkö suunnitellut huollot ja tauot suunniteltuun tuotantoaikaan. Päätös vaikuttaa suoraan käytettävyyteen ja siten koko OEE:hen.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
