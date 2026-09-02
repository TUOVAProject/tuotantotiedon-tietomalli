# Laadun mittarit

Tietomallin laatutieto on kappalemääräistä: tuotetut ja hylätyt kappaleet työvaiheittain (`fact_workphases`) ja konetapahtumittain (`fact_machine_events`). Uudelleentyötä, romutusta ja mittaustuloksia ei erotella, joten osa oppaan laatumittareista jää mallin ulkopuolelle.

# Mittarit

* [4.1 Hyväksytty ja hylätty määrä](4-01-hyvaksytty-ja-hylatty-maara.md) - Valmistuneiden ja hylättyjen kappaleiden määrät, joista muut laatumittarit johdetaan.
* [4.2 Hylkäysaste](4-02-hylkaysaste.md) - Hylättyjen kappaleiden osuuden valmistetuista.
* [4.3 Laatukerroin ja hyväksymisaste](4-03-laatukerroin-ja-hyvaksymisaste.md) - Hyväksyttyjen kappaleiden osuuden valmistetuista.
* [4.4 PPM](4-04-ppm.md) - Virheellisten kappaleiden määrän miljoonaa valmistettua kappaletta kohti.
* [4.5 Ensimmäisen läpäisyn saanto, FPY](4-05-ensimmaisen-lapaisyn-saanto-fpy.md) - Kuinka suuri osa kappaleista läpäisi työvaiheen ilman korjausta.
* [4.6 Kokonaisläpisaanto, RTY](4-06-kokonaislapisaanto-rty.md) - Todennäköisyyden, että kappale läpäisee kaikki peräkkäiset työvaiheet ilman virhettä.
* [4.7 Hylkäyksen kustannusvaikutus](4-07-hylkayksen-kustannusvaikutus.md) - Hylättyjen kappaleiden valmistusarvon euroina ja sen osuuden valmistuskustannuksista.

# Rajaukset

**Tietomallin laajennusta vaativat laatumittarit:** romutusaste erillään hylkäyksestä, uudelleentyöaste ja uudelleentyön tunnit, materiaalihukka, virheiden lukumäärä ja vakavuusluokat, DPMO, prosessikyvykkyys (Cp, Cpk) sekä kaikki asiakkaalla havaitut laatumittarit. Prosessikyvykkyys edellyttää mittausdatan taulua, joka on tietomallin dokumentaatiossa tunnistettu mahdolliseksi laajennukseksi tapahtumatyypin 13 yhteydessä.
