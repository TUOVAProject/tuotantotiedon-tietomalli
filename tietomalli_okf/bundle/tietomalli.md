---
type: Data Model
title: Tuotantotiedon tietomalli
description: "Konepajan tuotantotiedon dimensiopohjainen tietomalli: kolme faktataulua ja yksitoista ulottuvuustaulua."
tags: [tietomalli, konepaja, dimensiomallinnus]
status: stable
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Yleiskuvaus

Tuotantotiedon tietomalli on dimensiopohjainen malli konepajan analytiikkaan ja raportointiin. Se koostuu kolmesta linkittyvästä transaktiomuotoisesta faktataulusta ja niitä täydentävistä ulottuvuustauluista.

Faktataulut muodostavat porautumisketjun:

```text
Tilausrivit  ->  Työvaiheet  ->  Työvaiheen tapahtumat
```

Ketjun avulla voidaan siirtyä tilausrivitasolta yksittäisiin työvaiheisiin ja edelleen koneen tapahtuma-, käyttöaste-, OEE-, seisokki-, virhe- ja energiatietoihin.

# Faktataulut

- [`fact_order_rows`](/taulut/fact_order_rows.md) — Tilausrivit koottuna pääosin ERP datasta.
- [`fact_workphases`](/taulut/fact_workphases.md) — Työvaihetaulu.
- [`fact_machine_events`](/taulut/fact_machine_events.md) — Töiden toteumatietoja leimauksista ja/tai konedatasta johdettuna.

# Ulottuvuustaulut

- [`dim_customer`](/taulut/dim_customer.md) — Asiakastiedot.
- [`dim_article`](/taulut/dim_article.md) — Nimike- tai tuotetiedot ERP-järjestelmästä.
- [`dim_workcenter`](/taulut/dim_workcenter.md) — Työpisteen/työkeskuksen/tuotantoyksikön/kuormitusryhmän tarkemmat tiedot.
- [`dim_workcenter_group`](/taulut/dim_workcenter_group.md) — Työkeskuksen tai tuotantoyksikön tyypit.
- [`dim_user`](/taulut/dim_user.md) — Käyttäjätiedot ERP-järjestelmästä.
- [`dim_order_state`](/taulut/dim_order_state.md) — Tilausten tilojen hakutaulu.
- [`dim_event_type`](/taulut/dim_event_type.md) — Valmiiksi määritetty konetapahtumatyyppien hakutaulu.
- [`dim_source`](/taulut/dim_source.md) — Konetapahtumien tietolähteiden hakutaulu.
- [`dim_exception`](/taulut/dim_exception.md) — Poikkeamien tiedot.
- [`dim_date`](/taulut/dim_date.md) — Päivämääräulottuvuus ajallista suodatusta varten.
- [`dim_time`](/taulut/dim_time.md) — Aikaulottuvuus suodatuksia ja ajallista analysointia varten.

# Mittarit

Mallista laskettavat mittarit on kuvattu omina konsepteinaan, ks. [mittariryhmät](/mittarit/index.md). Kaikkia mittareita koskevat [laskennan yleiset periaatteet](/laskennan-periaatteet.md), ja käyttöönoton voi aloittaa [perusmittaristosta](/perusmittaristo.md).

# Luontilauseet

Täysi PostgreSQL-skeema perusavaimineen, viiteavaimineen, indekseineen ja hakutaulujen vakiosisältöineen on tiedostossa [db_create.sql](/references/db_create.sql). Taulukohtaiset sarakemäärittelyt ovat kunkin taulun omassa konseptissa.
