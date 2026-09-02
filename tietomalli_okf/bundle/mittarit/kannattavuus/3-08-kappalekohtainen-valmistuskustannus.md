---
type: Metric
title: 3.8 Kappalekohtainen valmistuskustannus
description: Yhden valmistetun kappaleen kustannuksen.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.8
metric_group: Kannattavuuden mittarit
unit: €/kpl
grain: nimike, nimikeryhmä, asiakas, eräkoko, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Yhden valmistetun kappaleen kustannuksen. Hinnoittelun ja kustannuskehityksen seurantamittari.

| | |
| :--- | :--- |
| **Mittayksikkö** | €/kpl |
| **Tarkastelutaso** | nimike, nimikeryhmä, asiakas, eräkoko, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
SUM(manufacturing_cost_actual) / SUM(ordered_qty)
tai  AVG(unit_manufacturing_cost_actual)
```

Sama kaava semanttisilla nimillä:

```text
SUMMA(Valmistuskustannukset toteutunut) / SUMMA(Tilattu määrä)
tai  KESKIARVO(Kappale valmistuskustannukset toteutunut)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_article`](/taulut/dim_article.md)

# Huomiot ja rajoitteet

- Summasuhde on aggregoidussa raportissa parempi kuin rivikohtaisten kappalehintojen keskiarvo, koska jälkimmäinen painottaa pieniä eriä liikaa.
- Vastaava välittömien kustannusten mittari saadaan kentistä `prime_cost_actual_sum` ja `unit_prime_cost_actual`.
- Eräkoon mukaan ryhmiteltynä mittari näyttää, missä sarjapituudessa kappalekustannus tasaantuu.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
