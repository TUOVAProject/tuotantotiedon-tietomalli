---
type: Metric
title: 5.22 Uusien nimikkeiden osuus ja kustannuspoikkeama
description: Kuinka suuri osa tuotannosta on uustuotantoa ja kuinka paljon heikommin kustannusarviot osuvat siinä.
tags: [mittari, muut]
status: stable
metric_id: 5.22
metric_group: Muut mittarit ja laskentakaavat
unit: "% ja %-yks."
grain: nimike, asiakas, myyjä, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa tuotannosta on uustuotantoa ja kuinka paljon heikommin kustannusarviot osuvat siinä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % ja %-yks. |
| **Tarkastelutaso** | nimike, asiakas, myyjä, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Osuus       = COUNT(order_row_id WHERE new_article = TRUE) / COUNT(order_row_id) * 100
Poikkeamaero = Jälkilaskennan poikkeama-% (new_article = TRUE)
                 − Jälkilaskennan poikkeama-% (new_article = FALSE)
```

Sama kaava semanttisilla nimillä:

```text
Uusien nimikkeiden tilausrivit / Kaikki tilausrivit * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md)

# Huomiot ja rajoitteet

- Uustuotannon osuus selittää usein kustannus- ja aikataulupoikkeamia paremmin kuin mikään yksittäinen tehokkuusmittari. Kannattaa ottaa käyttöön muiden poikkeamamittareiden selittäjänä.
- `new_article`-kentän määrittelysääntö on yrityskohtainen ja se on dokumentoitava, jotta aikasarja pysyy vertailukelpoisena.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
