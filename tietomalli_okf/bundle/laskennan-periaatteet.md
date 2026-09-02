---
type: Reference
title: Laskennan yleiset periaatteet
description: "Säännöt, jotka koskevat kaikkien mittareiden laskentaa: päivämäärien erotukset, tapahtumien suodatus, toteumalähteen valinta ja prosenttiosuuksien laskenta."
tags: [mittari, periaatteet]
status: stable
generated: { by: tuova-okf-export/1.0, at: 2026-09-02T00:00:00Z }
sources:
  - id: tietomalli
    resource: https://github.com/TUOVAProject/tuotantotiedon-tietomalli
    title: TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
    last_modified: 2026-09-01T00:00:00Z
---

# Periaatteet

Alla olevat periaatteet tulee huomioida mittareiden laskennassa.

**Huom!** Tässä kuvataan, mitä mittareita tietomallin kentistä voidaan laskea. Varsinainen käyttöönotto edellyttää yrityskohtaisten laskentasääntöjen sopimista, esimerkiksi mitä lasketaan suunnitelluksi tuotantoajaksi, miten asetukset luokitellaan, miten uudelleentyö erotetaan hylkäyksestä ja miten yleiskustannukset kohdistetaan.

**1. Päivämäärien erotukset lasketaan [`dim_date`](/taulut/dim_date.md)-taulun kautta.** Faktataulujen päivämääräkentät ovat semanttisia avaimia muodossa `YYYYMMDD`, joten niiden suora vähennyslasku antaa väärän tuloksen kuukauden vaihtuessa. Käytä joko `date_index`-kenttien erotusta tai `date_iso`-kenttiä:

```text
Kalenteripäivien erotus = dim_date[loppu].date_index − dim_date[alku].date_index
Työpäivien erotus       = COUNT(dim_date WHERE is_workday = TRUE AND date_index välillä)
```

**2. Konetapahtumataulun rivit on aina suodatettava `event_type_id`- ja `source_id`-kentillä.** Sama työvaihe voi olla taulussa useaan kertaan eri tarkkuustasoilla (vaiheleimaus, konedatan vaihekoonti, yksittäiset kappaleet, päiväkoonti). Ilman suodatusta ajat ja kappalemäärät kaksinkertaistuvat. Vakiintuneet suodatinjoukot kannattaa määritellä kerran ja käyttää niitä kaikissa mittareissa:

```text
Leimausperusteinen toteuma  : source_id = 1 (STAMPING)
Konedataperusteinen toteuma : source_id IN (2, 3) (MACHINE API, SENSOR)
Vaihetason koonnit          : event_type_id IN (1, 6)
Päivätason koonnit          : event_type_id = 17
Suunniteltu tuotantoaika    : event_type_id = 19
Poikkeamat                  : event_type_id IN (4, 15)
```

**3. Toteuma-arvoista on aina kaksi rinnakkaista versiota.** Tietomallissa on erikseen leimauspohjaiset (`*_stamping_*`) ja konedatapohjaiset (`*_machine_*`) toteumat. Mittarin määritelmässä on kerrottava kumpaa käytetään. Kaavoissa alla käytetään merkintää `*_actual_*`, joka tarkoittaa yrityksen valitsemaa ensisijaista lähdettä.

**4. Aikayksikkö on minuutti.** Kaikki `_min`-päätteiset kentät ovat minuutteja; tunneiksi jaetaan luvulla 60.

**5. Yleiskustannusten kohtelu on päätettävä.** Tietomalli tarjoaa kolme kustannustasoa: `prime_cost_*_sum` (välittömät), `manufacturing_cost_*` (omakustannus, sisältää yleiskustannukset) ja `profit_*` (voitto). Katemittarissa on kerrottava, mistä tasosta kate lasketaan.

**6. Tarkastelutason valinta.** Useimmat mittarit voidaan laskea esimerkiksi tilausrivi-, työ-, työvaihe-, työkeskus-, työkeskusryhmä-, nimike-, asiakas-, käyttäjä-, päivä-, viikko-, kuukausi- tai vuorotasolla.

**7. Prosenttiosuudet lasketaan summista.** Osoittaja ja nimittäjä summataan ensin koko tarkastelujoukolle ja jaetaan vasta sitten. Rivikohtaisten prosenttien keskiarvo antaa eri ja yleensä väärän tuloksen. Jos nimittäjä on nolla tai tyhjä, mittari jätetään tyhjäksi eikä aseteta nollaksi.

**8. Mittarikuvausten "Tila"-kenttä.** Jokaisella mittarilla on tila, joka kertoo mitä mittarin laskenta edellyttää:

```text
Laskettavissa suoraan          : mittari saadaan tietomallin kentistä sellaisenaan
Edellyttää yrityskohtaista
määrittelyä                    : kentät ovat olemassa, mutta laskenta vaatii yrityksen
                                 päättämän parametrin, rajauksen tai luokittelun
                                 (esim. tehollinen kapasiteetti, sähkön hinta,
                                 kiireellisyyden tunnistesääntö)
```

Tietomallin laajennusta vaativat mittarit (mittaustulokset ja prosessikyvykkyys, reklamaatiot ja palautukset, uudelleentyön ja romutuksen erottelu, materiaalihukka, huoltosuunnitelma) on jätetty tämän tiedoston ulkopuolelle. Ne on koottu lyhyesti kunkin osion loppuun.
