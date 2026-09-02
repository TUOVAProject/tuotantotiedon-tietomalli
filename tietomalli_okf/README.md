# Tuotantotiedon tietopaketti (OKF)

Konepajan tuotantotiedon tietomalli ja siitä laskettavat mittarit
[Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format)
v0.2 -muodossa: hakemistollinen markdown-tiedostoja, joissa on YAML-frontmatter.

Paketti on tarkoitettu sekä ihmisen luettavaksi että agentin syötteeksi. Yksikään
tiedosto ei vaadi työkalua avautuakseen: `cat` riittää ihmiselle ja tiedoston
lukeminen agentille.

**Sisältö:** 110 konseptia — 14 taulua, 83 mittaria, 3 kokoavaa konseptia,
9 hakemistoa ja muutosloki. Konseptien välillä on 504 ristiinlinkkiä.

## Rakenne

```
.
├── index.html                     Staattinen visualisointi (GitHub Pages)
├── bundle/                        OKF-paketti
│   ├── index.md                   Juurihakemisto, okf_version: "0.2"
│   ├── log.md                     Muutosloki
│   ├── tietomalli.md              Tietomallin yleiskuvaus, porautumisketju
│   ├── laskennan-periaatteet.md   Kaikkia mittareita koskevat säännöt
│   ├── perusmittaristo.md         Suositeltu vähimmäismittaristo
│   ├── taulut/
│   │   ├── index.md
│   │   ├── fact_order_rows.md     3 faktataulua
│   │   ├── fact_workphases.md
│   │   ├── fact_machine_events.md
│   │   └── dim_*.md               11 ulottuvuustaulua
│   ├── mittarit/
│   │   ├── index.md
│   │   ├── aikavertailut/         14 mittaria
│   │   ├── oee/                   15 mittaria
│   │   ├── kannattavuus/          16 mittaria
│   │   ├── laatu/                 7 mittaria
│   │   ├── muut/                  22 mittaria
│   │   └── datan-laatu/           9 mittaria
│   └── references/
│       └── db_create.sql          Täysi PostgreSQL-skeema
└── tools/
    ├── build_okf.py               Muodostaa paketin lähdedokumenteista
    ├── make_viz.py                Muodostaa visualisoinnin paketista
    └── validate_okf.py            Tarkistaa OKF v0.2 -vaatimustenmukaisuuden
```

## Konseptityypit

| `type` | Määrä | Sisältö |
| :--- | ---: | :--- |
| `PostgreSQL Table` | 14 | Sarakkeet, suhteet, luontilause ja tauluun liittyvät mittarit |
| `Metric` | 83 | Määritelmä, laskentakaava teknisillä ja semanttisilla nimillä, tietolähde, rajoitteet |
| `Data Model` | 1 | Tietomallin yleiskuvaus ja porautumisketju |
| `Reference` | 2 | Laskennan yleiset periaatteet, perusmittaristo |

## Linkitys

Ristiinlinkit ovat pakettijuuresta lähteviä absoluuttisia markdown-linkkejä
(SPEC §6.1), jolloin ne kestävät tiedostojen siirtelyn hakemistojen sisällä.

- Taulukonsepti linkittää jokaiseen mittariin, joka lasketaan sen tiedoista,
  sekä jokaiseen tauluun, johon sillä on suhde.
- Mittarikonsepti linkittää käyttämiinsä tauluihin ja niihin mittareihin,
  joihin sen huomioissa viitataan.
- Kaikki linkittävät laskennan yleisiin periaatteisiin ja tietomallin
  yleiskuvaukseen.

Visualisoinnin verkkonäkymä piirtää tämän graafin.

## Frontmatter

Vakiokenttien (`type`, `title`, `description`, `resource`, `tags`, `status`,
`generated`, `sources`) lisäksi paketti käyttää tuottajakohtaisia kenttiä,
jotka SPEC §4.1 sallii:

| Kenttä | Konsepti | Arvot |
| :--- | :--- | :--- |
| `metric_id` | Metric | Mittarin tunniste, esim. `2.4` |
| `metric_group` | Metric | Mittariryhmän nimi |
| `unit` | Metric | Mittayksikkö |
| `grain` | Metric | Tarkastelutasot |
| `readiness` | Metric | `direct` tai `requires-definition` |
| `table_name` | PostgreSQL Table | Taulun tekninen nimi |
| `table_kind` | PostgreSQL Table | `fakta` tai `ulottuvuus` |
| `column_count` | PostgreSQL Table | Sarakkeiden määrä |

`readiness` erottaa suoraan laskettavat mittarit (61 kpl) niistä, jotka
edellyttävät yrityskohtaista määrittelyä (22 kpl), esimerkiksi teholliselta
kapasiteetilta tai ihannesykliajalta. Agentti voi suodattaa tällä.

## Visualisointi

`index.html` on itsenäinen sivu: koko paketti on upotettu siihen, joten se
toimii ilman palvelinta myös `file://`-osoitteesta. Ei riippuvuuksia,
ei CDN-kutsuja, ei verkkoyhteyttä.

Näkymät:

- **Selaus** — hakukenttä, konseptit ryhmiteltynä, renderöity markdown,
  frontmatter-tunnisteet ja kunkin konseptin linkit molempiin suuntiin.
- **Verkko** — konseptigraafi, solmut väritettynä tyypin mukaan. Vieritys
  zoomaa, raahaus siirtää, solmun klikkaus avaa konseptin.

## Lähdeaineisto

- `tietomalli.md` — TUOVA-hankkeen tuotantotiedon tietomalli, versio 1.0
- `mittarit.md` — tietomallista laskettavat mittarit
- `db_create.sql` — PostgreSQL-skeema
