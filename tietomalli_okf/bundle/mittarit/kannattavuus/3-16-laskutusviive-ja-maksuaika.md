---
type: Metric
title: 3.16 Laskutusviive ja maksuaika
description: Kuinka monta päivää kuluu lähetyksestä laskutukseen ja laskutuksesta maksuun.
tags: [mittari, kannattavuus]
status: stable
metric_id: 3.16
metric_group: Kannattavuuden mittarit
unit: vrk
grain: asiakas, tilaustyyppi, kuukausi
readiness: direct
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka monta päivää kuluu lähetyksestä laskutukseen ja laskutuksesta maksuun.

| | |
| :--- | :--- |
| **Mittayksikkö** | vrk |
| **Tarkastelutaso** | asiakas, tilaustyyppi, kuukausi |
| **Tila** | Laskettavissa suoraan |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
Laskutusviive = date_index(invoice_date_actual) − date_index(dispatch_date_actual)
Maksuaika     = date_index(payment_date_actual) − date_index(invoice_date_actual)
```

Sama kaava semanttisilla nimillä:

```text
Päivämääräindeksi(Lasku lähetyspäivä) − Päivämääräindeksi(Toteutunut lähetys)
Päivämääräindeksi(Lasku maksupäivä)  − Päivämääräindeksi(Lasku lähetyspäivä)
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md), ryhmittely [`dim_customer`](/taulut/dim_customer.md)

# Huomiot ja rajoitteet

- Laskutusviive on yrityksen oma sisäinen prosessi ja siten suoraan korjattavissa; maksuaika kuvaa asiakkaan maksukäyttäytymistä.
- Maksuaika ei ole sama asia kuin maksuehto: erotus näiden välillä on varsinainen ylitys. Maksuehtoa ei ole tietomallissa, joten vertailu vaatii tiedon tuomista erikseen.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
