---
type: Metric
title: 1.7 Tilausten toimitusvarmuus
description: Kuinka suuri osa toimitetuista tilausriveistä toimitettiin viimeistään luvattuna päivänä.
tags: [mittari, aikavertailut, edellyttaa-maarittelya]
status: stable
metric_id: 1.7
metric_group: Aikavertailujen mittarit
unit: "%"
grain: asiakas, nimike, tilaustyyppi, myyjä, viikko, kuukausi
readiness: requires-definition
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Määritelmä

Kuinka suuri osa toimitetuista tilausriveistä toimitettiin viimeistään luvattuna päivänä.

| | |
| :--- | :--- |
| **Mittayksikkö** | % |
| **Tarkastelutaso** | asiakas, nimike, tilaustyyppi, myyjä, viikko, kuukausi |
| **Tila** | Edellyttää yrityskohtaista määrittelyä (ajoissa-toimituksen määritelmä) |

# Computation

Laskentakaava tietomallin teknisillä kenttänimillä:

```text
COUNT(order_row_id WHERE delivery_date_actual <= delivery_date_planned)
  / COUNT(order_row_id WHERE delivery_date_actual IS NOT NULL) * 100
```

Sama kaava semanttisilla nimillä:

```text
Ajoissa toimitetut tilausrivit / Toimitetut tilausrivit * 100
```

# Tietolähde

[`fact_order_rows`](/taulut/fact_order_rows.md) + [`dim_date`](/taulut/dim_date.md), ryhmittely [`dim_customer`](/taulut/dim_customer.md), [`dim_article`](/taulut/dim_article.md)

# Huomiot ja rajoitteet

- On päätettävä, lasketaanko etuajassa toimitettu ajoissa toimitetuksi ja sallitaanko toleranssi (esim. yksi työpäivä).
- On päätettävä, verrataanko alkuperäiseen vai viimeisimpään luvattuun toimituspäivään. Tietomallissa tilausrivillä on vain yksi suunniteltu toimituspäivä, joten uudelleensovitut päivät eivät erotu; työvaihetasolla alkuperäinen ja viimeisin suunnitelma sen sijaan säilyvät.
- Vastaava lähetysvarmuus lasketaan kentillä `dispatch_date_*`.

Laskennan yleiset periaatteet: [laskennan periaatteet](/laskennan-periaatteet.md).
