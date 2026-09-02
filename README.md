[![DOI](https://zenodo.org/badge/1353243519.svg)](https://doi.org/10.5281/zenodo.22254202)

# Tuotantotiedon tietomalli

Tuotantotiedon tietomalli on erityisesti konepajateollisuuden yritysten tarpeisiin kehitetty avoin malli, jota voi käyttää vaikka yrityksen tietovaraston pohjana. Tietomallia voi soveltaa myös muissa tuotantoa tekevissä valmistavan teollisuuden yrityksissä.

[Avaa tietomalli HTML-sivuna](https://tuovaproject.github.io/tuotantotiedon-tietomalli/)

## Tietomallin toteutuksesta tietoa

Tietomalli on toteutettu osana Savonia-ammattikorkeakoulun ja LUT-yliopiston *"Tuotantodatan hyödyntäminen valmistavan teollisuuden kehittämisessä ja johtamisessa"* (TUOVA) -hanketta. Hanke on Etelä-Savon ELY-keskuksen kautta EU:n osarahoittama. [Hankkeen kotisivuille.](https://tuova.savonia.fi/)

Tietomallia on kehitetty vuosien 2025-2026 aikana hankkeessa konepajayritysten tehtyjen pilotointien pohjaksi ja pilotointien pohjalta jatkokehittäen. Tietomallin kehityksestä on vastannut pääosin hankkeessa data-analyytikkona toiminut **Jesse Honkanen** Savonia-ammattikorkeakoulusta.

## Tietomallin suunnitteluperiaatteet

Tietomallia kehitettiin seuraavien ajatusten pohjalta:

- Yksinkertainen dimensionaalinen malli tuotannon toteumatietojen monipuoliseen tarkasteluun.
- Perusperiaatteena on verrata toteutuneita tuotannon tietoja suunniteltuihin.
- Kolmikerroksinen malli helpottaa porautumista tilausrivin tasolta työvaiheisiin ja työvaiheiden toteutumiin. 
- Tietomallin pohjalta on tavoitteena voida laskea mahdollisimman monenlaisia kannattavuuden, tehokkuuden ja tuotelaadun mittareita.
- Koneiden käyttötapahtumista tulevat eri lähteistä olevat sekä tarkkuustasoltaan erilaiset tiedot tulevat samaan faktatauluun. Nämä erotetaan tapahtuman tyypin mukaan. Leimaustiedot, koneiden rajapinnoista tulevat tiedot sekä anturitiedot ovat tietomallin kannalta saman tasoisia.
- Alkuperäisiä ajatuksia on helpottaa tuotantokoneista kerätyn datan liittämistä yksittäisiin tilauksiin sekä työvaiheisiin.
- Helposti laajennettavissa muilla tiedoilla, kuten kappaleiden mittaustiedoilla, varastosaldoilla, huoltotiedoilla jne.

Alla on yksinkertaistettu käsitemalli, jossa avataan tietomallin perusrakenne.

![Tuotantotiedon käsitemalli](/tuotantotiedon-kasitemalli.png)

Tietomallin tunnistettuja rajoitteita:

- Tietomalli ei sisällä historiatiedon säilytystä työjonoista ja tilauskannasta. Voisi lisätä esim. tilannekuvatauluja historiatiedon säilytykseen.
- Varaston tilasta ja ostotilauksista ei ole erillistä taulua. Materiaalien ja tuotettujen tuotteiden varastotiedot voisi tarvittaessa lisätä.
- Mittaustietoja ei ole (vielä) tietomallissa mukana. On suunniteltu lisättäväksi erillisenä moduulina.
- Kunnossapitosuunnitelmaa, vikailmoituksia, reklamaatioita, työkalujen kestotietoja tms. ei ole huomioitu tietomallissa.
- Tietomalli ei itsessään sisällä teknistä metatietoa mm. viimeisimmistä datan päivityksistä. Tämä on hyvä lisätä toteutukseen, koska se on keskeistä mm. inkrementaalisten latausten yhteydessä.
- Työntekijöistä, asiakkaista ja alihankkijoista on oletuksena hyvin suppeat tiedot, mutta tarvittaessa voidaan lisätä taustatietoja. Alihankkijat voisi periaatteessa omana ulottuvuustaulunaan olla, nyt ovat yhtenä "työkeskuksen" tyyppinä.
- Uudelleentyöstön tietoja ei ole mukana tietomallissa.
- Vuorotiedot sekä koneiden kapasiteetit voisi tuoda mukaan tietomalliin.
- Joihinkin ulottuvuustauluihin voi olla hyvä lisätä vaihtoehtoja "tuntematon" tai "ei sovellu", jolloin linkitykset taulujen välillä toimivat eivätkä NULL-viittaukset aiheuta ongelmia.
- Tilanteet, joissa myyntitilaukseen liittyy useita tuotantotilauksia tai jos yksi tuotantotilaus liittyy useaan myyntitilauksen riviin, voivat aiheuttaa erilaisia ongelmia käytännön toteutuksessa. Oletuksena on, että yksi tuotantotilaus liittyisi yhteen myyntitilausriviin tai voi olla myös tuotantotilauksia ilman myyntitilausta (varastoon tekeminen). Näitä asioita on hyvä huomioida tietomallia soveltaessa.

## Tiedostojen kuvaus

- [**tietomalli.md**](./tietomalli.md) - Tietomalli yhdessä tiedostossa kuvattuna. Taulujen loogiset kuvaukset sekä luontilauseet.
- [**mittarit.md**](./mittarit.md) - Tietomallin pohjata laskettavat mittarit yhdessä tiedostossa.
- [**db_create.sql**](./db_create.sql) - Tietokantataulujen PostgreSQL-yhteensopivat luontilauseet yhdessä tiedostossa. Ei sisällä dim_date ja dim_time taulujen valmiita arvoja, vaan ne pitää generoida itse.
- [**tietomalli_sarakenimet.csv**](./tietomalli_sarakenimet.csv) - Tietomallin sarakenimien muutostaulu teknisten ja semanttisten nimien välille. Voidaan käyttää korvaamaan tekniset nimet esim. BI-ohjelmistossa.
- [**tietomalli_okf/bundle/**](./tietomalli_okf/bundle/) - Tietomalli ja mittarit kuvattuna erillisinä tiedostoina tekoälyagenteille sopivassa [OKF-formaatissa](https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf).
- [**tietomalli_okf/html/index.hml**](./tietomalli_okf/html/index.html) - Tietomalli ja mittaristo yhtenä HTML-sivuna. Voi tarkastella [https://tuovaproject.github.io/tuotantotiedon-tietomalli/](https://tuovaproject.github.io/tuotantotiedon-tietomalli/).

## Tietomallin käyttötapoja

Tietomallia voidaan hyödyntää erilaisilla tavoilla. Alla joitain ajatuksia.

- Tietomallin ja mittareiden käyttäminen pohjana valmistavan teollisuuden yrityksen oman tietovaraston toteutuksessa.
- Oman yrityksen saatavilla olevien tietojen ja niiden hyödyntämistapojen pohdinta.
- Yrityskohtaisessa käsitteiden määrittelyssä ja vertailussa apuna.
- Tietomallin mukaisen tietovaraston sekä mittareiden antaminen tekoälyagentille kontekstiksi.

Tietomallin pohjalta tehtyjä esimerkkitoteutuksia on kuvattu tarkemmin hankkeessa kehitetyssä [tietopankissa](https://tuovaproject.github.io/). Alla on kuvankaappaus yhdestä kannattavuuden tarkasteluun keskittyvästä esimerkinomaisesta Power BI -raportista.

![Power BI -raportti asiakaskohtainen näkymä](/pbi_esimerkki_asiakas.png)

## Tietomallin päivitykset

**1.0.0 (julkaistu 2.9.2026):** Ensimmäinen julkinen versio tietomallista.

## Lisenssi ja viittaaminen

[![DOI](https://zenodo.org/badge/1353243519.svg)](https://doi.org/10.5281/zenodo.22254202)

Tietomalli on julkaistu **CC BY-SA 4.0** lisenssillä. 

Toivomme viittaukset tietomalliin esim. seuraavassa muodossa: Tuotantotiedon tietomalli (2026), TUOVA-hanke, Savonia-ammattikorkeakoulu. DOI: https://doi.org/10.5281/zenodo.22254203

## Lisätietoja

- TUOVA-hankkeen kotisivut: [https://tuova.savonia.fi/](https://tuova.savonia.fi/)
- TUOVA-hankkeen tietopankki: [https://tuovaproject.github.io/](https://tuovaproject.github.io/)
- Tuotantotiedon tietopaketti HTML-sivuna: [https://tuovaproject.github.io/tuotantotiedon-tietomalli/](https://tuovaproject.github.io/tuotantotiedon-tietomalli/)
