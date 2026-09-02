# Kannattavuuden mittarit

Kannattavuusmittarit vertaavat tilausrivin myyntihintaa siihen kohdistettuihin kustannuksiin ja suunniteltuja kustannuksia toteutuneisiin. Tietolähteenä on pääosin `fact_order_rows`, työvaihetason kustannukset `fact_workphases`-taulusta. Ryhmittelyt tehdään `dim_customer`-, `dim_article`- ja `dim_user`-taulujen kautta.

Kaikissa katemittareissa on ensin päätettävä kustannustaso, koska tietomalli tarjoaa niitä kolme:

```text
prime_cost_*_sum       : välittömät kustannukset ilman yleiskustannuslisää
manufacturing_cost_*   : omakustannus, sisältää yleiskustannukset
profit_*               : voitto kaikkien kustannusten jälkeen
```

# Mittarit

* [3.1 Myynti](3-01-myynti.md) - Tilausrivien yhteenlasketun arvon ilman arvonlisäveroa.
* [3.2 Toteutunut kate](3-02-toteutunut-kate.md) - Tilausrivin euromääräisen kannattavuuden valitulla kustannustasolla.
* [3.3 Kate-%](3-03-kate.md) - Katteen osuuden myyntihinnasta.
* [3.4 Katepoikkeama](3-04-katepoikkeama.md) - Toteutuneen ja suunnitellun katteen eron euroina ja prosenttiyksikköinä.
* [3.5 Jälkilaskennan poikkeama](3-05-jalkilaskennan-poikkeama.md) - Toteutuneiden ja suunniteltujen suorien tuotantokustannusten eron.
* [3.6 Jälkilaskennan poikkeamaprosentti](3-06-jalkilaskennan-poikkeamaprosentti.md) - Kustannuspoikkeaman suhteessa suunniteltuun kustannukseen.
* [3.7 Kustannuslajikohtainen poikkeama](3-07-kustannuslajikohtainen-poikkeama.md) - Mistä kustannuslajista kustannuspoikkeama syntyy: työstä, materiaalista, alihankinnasta vai muista suorista kuluista.
* [3.8 Kappalekohtainen valmistuskustannus](3-08-kappalekohtainen-valmistuskustannus.md) - Yhden valmistetun kappaleen kustannuksen.
* [3.9 Voittolisä-%](3-09-voittolisa.md) - Voiton osuuden omakustannusarvosta.
* [3.10 Tuntikate](3-10-tuntikate.md) - Kuinka paljon katetta työ tuotti käytettyä tuotantotuntia kohti.
* [3.11 Asetuskustannus kappaletta kohti](3-11-asetuskustannus-kappaletta-kohti.md) - Eräkoon vaikutuksen yksittäisen kappaleen kannattavuuteen.
* [3.12 Asiakas-, tuote- ja myyjäkohtainen kate](3-12-asiakas-tuote-ja-myyjakohtainen-kate.md) - Mistä kate todella syntyy: mitkä asiakkaat, tuotteet ja myyjät tuovat tulosta ja mitkä sitovat kapasiteettia heikolla katteella.
* [3.13 Vaihekustannuksen poikkeama](3-13-vaihekustannuksen-poikkeama.md) - Kuinka paljon työvaiheen toteutuneet suoran työn kustannukset poikkeavat suunnitelluista.
* [3.14 Alihankinnan osuus kustannuksista](3-14-alihankinnan-osuus-kustannuksista.md) - Kuinka suuri osa suorista tuotantokustannuksista ostetaan ulkoa.
* [3.15 Tilauskannan arvo ja laskuttamaton valmis tuotanto](3-15-tilauskannan-arvo-ja-laskuttamaton-valmis-tuotanto.md) - Avoimen tilauskannan arvon sekä sen osan, joka on jo valmistettu mutta laskuttamatta.
* [3.16 Laskutusviive ja maksuaika](3-16-laskutusviive-ja-maksuaika.md) - Kuinka monta päivää kuluu lähetyksestä laskutukseen ja laskutuksesta maksuun.

# Rajaukset

**Tietomallin laajennusta vaativat kannattavuusmittarit:** laatukustannusten ja reklamaatiokustannusten osuus, asiakkaan palvelukustannukset sekä takuukustannukset erillisenä tietona. Takuutöiden osuus on karkeasti johdettavissa, jos ne kirjataan omalla `order_type`-arvolla.
