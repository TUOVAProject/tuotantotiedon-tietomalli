# OEE ja sen osat

OEE eli kokonaistehokkuus kuvaa, kuinka suuri osa suunnitellusta tuotantoajasta käytetään hyväksyttyjen kappaleiden valmistamiseen tavoitenopeudella. Tietolähteenä on `fact_machine_events`, ihannesykliaika `fact_workphases`-taulusta.

Määritellään ensin OEE:n perussuureet, joita alla olevat mittarit käyttävät:

```text
Suunniteltu tuotantoaika (min) = SUM(duration_min) WHERE event_type_id = 19
Käyntiaika (min)               = SUM(machine_active_min) WHERE event_type_id IN (6, 8, 17)
Seisokkiaika (min)             = SUM(idle_sum_min + exception_min + power_off_min)
Valmistettu määrä (kpl)        = SUM(produced_qty_machine) tai SUM(produced_qty_stamping)
Hyväksytty määrä (kpl)         = Valmistettu määrä − SUM(rejected_qty_stamping)
```

# Mittarit

* [2.1 Suunniteltu tuotantoaika](2-01-suunniteltu-tuotantoaika.md) - Ajan, jonka kone oli tarkoitus olla tuotannossa.
* [2.2 Käyntiaika](2-02-kayntiaika.md) - Ajan, jonka kone oli aktiivisessa työstössä.
* [2.3 Seisokkiaika ja seisokkiaste](2-03-seisokkiaika-ja-seisokkiaste.md) - Ajan, jonka kone ei ollut tuotannossa suunnitellun tuotantoajan sisällä, sekä sen osuuden suunnitellusta ajasta.
* [2.4 Käytettävyys](2-04-kaytettavyys.md) - Kuinka suuren osan suunnitellusta tuotantoajasta kone oli käynnissä.
* [2.5 Nopeus](2-05-nopeus.md) - Toteutuneen tuotantonopeuden suhteen tavoitenopeuteen.
* [2.6 Laatukerroin](2-06-laatukerroin.md) - Hyväksyttyjen kappaleiden osuuden kaikista valmistetuista.
* [2.7 OEE, kokonaistehokkuus](2-07-oee-kokonaistehokkuus.md) - Käytettävyyden, nopeuden ja laadun yhteisvaikutuksen yhtenä lukuna.
* [2.8 Täysin tuottava aika](2-08-taysin-tuottava-aika.md) - Ajan, joka olisi tavoitenopeudella tarvittu hyväksyttyjen kappaleiden valmistamiseen.
* [2.9 Koneen käyttöaste](2-09-koneen-kayttoaste.md) - Kuinka suuren osan tarkastelujakson kalenteriajasta kone oli käynnissä.
* [2.10 Lastuamisaste](2-10-lastuamisaste.md) - Kuinka suuri osa aktiivisesta koneajasta on todellista lastuamista.
* [2.11 Apuajan osuus](2-11-apuajan-osuus.md) - Aktiivisen työstön aikana kuluneen ei-lastuavan ajan osuuden.
* [2.12 Asetus- ja vaihtoajan osuus](2-12-asetus-ja-vaihtoajan-osuus.md) - Kuinka suuri osa tapahtuma-ajasta kuluu asetustyöhön ja kappaleen vaihtoihin.
* [2.13 Tehottoman ajon osuus](2-13-tehottoman-ajon-osuus.md) - Kuinka suuri osa koneen käyntiajasta ajetaan alennetulla teholla.
* [2.14 Prosenttikytkinten keskiarvo](2-14-prosenttikytkinten-keskiarvo.md) - Kuinka paljon koneenkäyttäjät poikkeavat ohjelmoidusta syötöstä ja karannopeudesta.
* [2.15 Sykliajan poikkeama tavoitteesta](2-15-sykliajan-poikkeama-tavoitteesta.md) - Kuinka paljon toteutunut kappalekohtainen jaksoaika poikkeaa tavoitteesta.
