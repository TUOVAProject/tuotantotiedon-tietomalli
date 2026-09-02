---
type: Metric
title: 5.21 Käyttäjä- ja vuorokohtainen tarkastelu
description: Tuottavuuden, asetusaikojen ja laadun erot vuorojen ja käyttäjäryhmien välillä.
tags: [mittari, muut]
status: stable
metric_id: 5.21
metric_group: Muut mittarit ja laskentakaavat
unit: mittarikohtainen
grain: vuoro, käyttäjä, käyttäjäryhmä, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Tuottavuuden, asetusaikojen ja laadun erot vuorojen ja käyttäjäryhmien välillä.

| | |
| :--- | :--- |
| **Mittayksikkö** | mittarikohtainen |
| **Tarkastelutaso** | vuoro, käyttäjä, käyttäjäryhmä, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Mikä tahansa edellä kuvattu mittari ryhmiteltynä
  dim_time.shift_id tai fact_machine_events.user_id mukaan
esim. AVG(setup_time_min) GROUP BY user_id, article_id
```

Sama kaava semanttisilla nimillä:

```text
Mittari ryhmiteltynä Vuoro ID tai Käyttäjä ID mukaan
```

# Tietolähde

[`fact_machine_events`](/taulut/fact_machine_events.md) + [`dim_time`](/taulut/dim_time.md), [`dim_user`](/taulut/dim_user.md)

# Huomiot ja rajoitteet

- Käyttäjätason tuloksia käsitellään ryhmätasolla ja perehdytyksen kohdentamiseen, ei henkilöarviointiin. Tämä on syytä sopia ennen mittarin käyttöönottoa.
- Vuorojen väliset erot selittyvät usein työn sisällöstä, eivät suorituksesta. Vertailu edellyttää samankaltaista työkantaa, esimerkiksi rajausta samaan nimikkeeseen.
- Vuorotieto on käytettävissä vain, jos `dim_time.shift_id` on täytetty.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
