# Aikavertailujen mittarit

Aikavertailujen mittarit vertaavat toteutuneita päivämääriä ja kestoja suunniteltuihin. Ne muodostavat toimituskyvyn ja tuotannonsuunnittelun osuvuuden perusmittariston. Tietolähteenä ovat `fact_order_rows` (tilaus- ja toimitustaso) ja `fact_workphases` (työvaihetaso).

# Mittarit

* [1.1 Tuotannon läpimenoaika](1-01-tuotannon-lapimenoaika.md) - Kuinka kauan tilausrivin tuotanto kesti ensimmäisen työvaiheen aloituksesta viimeisen työvaiheen valmistumiseen.
* [1.2 Tuotannon läpimenoajan poikkeama](1-02-tuotannon-lapimenoajan-poikkeama.md) - Kuinka paljon toteutunut tuotannon läpimenoaika poikkeaa suunnitellusta.
* [1.3 Tuotannon aloituspoikkeama](1-03-tuotannon-aloituspoikkeama.md) - Kuinka monta päivää tuotannon todellinen aloitus poikkesi suunnitellusta aloituspäivästä.
* [1.4 Tuotannon valmistumispoikkeama](1-04-tuotannon-valmistumispoikkeama.md) - Kuinka monta päivää tuotanto valmistui suunniteltua myöhemmin tai aikaisemmin.
* [1.5 Tilauksesta toimitukseen kulunut aika](1-05-tilauksesta-toimitukseen-kulunut-aika.md) - Asiakkaan kokema kokonaisläpimenoaika tilauksen luonnista toimitukseen.
* [1.6 Toimituspoikkeama](1-06-toimituspoikkeama.md) - Toteutuneen ja luvatun toimituspäivän eron päivinä.
* [1.7 Tilausten toimitusvarmuus](1-07-tilausten-toimitusvarmuus.md) - Kuinka suuri osa toimitetuista tilausriveistä toimitettiin viimeistään luvattuna päivänä.
* [1.8 OTIF, ajallaan ja täysimääräisenä toimitetut](1-08-otif-ajallaan-ja-taysimaaraisena-toimitetut.md) - Kuinka suuri osa toimituksista oli sekä ajallaan että täysimääräisiä.
* [1.9 Työvaiheen toteutunut kesto](1-09-tyovaiheen-toteutunut-kesto.md) - Kuinka kauan yksittäinen työvaihe kesti aloituksesta valmistumiseen kalenteriaikana.
* [1.10 Vaiheajan poikkeama](1-10-vaiheajan-poikkeama.md) - Kuinka paljon työvaiheeseen todella kulunut työaika poikkeaa suunnitellusta.
* [1.11 Asetusajan poikkeama](1-11-asetusajan-poikkeama.md) - Kuinka paljon toteutunut asetustyö poikkeaa suunnitellusta asetusajasta.
* [1.12 Työvaiheiden aikataulupitävyys](1-12-tyovaiheiden-aikataulupitavyys.md) - Kuinka suuri osa valmistuneista työvaiheista valmistui viimeistään suunniteltuna päivänä.
* [1.13 Uudelleenaikataulutettujen työvaiheiden osuus](1-13-uudelleenaikataulutettujen-tyovaiheiden-osuus.md) - Kuinka usein tuotantosuunnitelmaa on jouduttu muuttamaan alkuperäisen suunnittelun jälkeen.
* [1.14 Odotusaika työvaiheiden välillä](1-14-odotusaika-tyovaiheiden-valilla.md) - Kuinka kauan työ seisoi kahden peräkkäisen työvaiheen välissä.

# Rajaukset

**Tietomallin laajennusta vaativat aikamittarit:** kiiretilausten osuus ja kiirekuorman osuus edellyttävät kiireellisyys- tai prioriteettikenttää. Ne ovat johdettavissa vain, jos yritys koodaa kiireellisyyden `order_type`-kenttään.
