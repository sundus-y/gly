# gly

The friendly Gregorian notation format

## Why

For Gregorian notation there is no other software with such great
features as [Gregorio][gregorio].
However, it's input format, allowing only one score per file
and intermingling music with lyrics (thus making the lyrics
not-very-well-readable, preventing their easy copying etc.)
offends a programmer's eye (which desires separation of
content from logic, lyrics from music, ...).
As a typesetter working with petrified traditional liturgical chants
I could live with GABC, despite of not liking it very much.
But I sometimes also compose melodies for texts missing them -
and in such scenarios the limitations of GABC are a real pain.
Therefore I designed GLY - a new Gregorian notation plaintext format,
based on GABC and translating to it.

*GLY* is an acronym of "Gregorio for liLYponders" or
"Gregorio with separate LYrics.

## Core features

* music separated from lyrics => no need of the ubiquitous
  and tedious parentheses
  (with exception of music chunks containing spaces)
* music and lyrics can be interspersed as needed
* no semicolons in the header
* custom header fields supported (commented out in the GABC output)
* several scores per file
* compile pdf preview by a single command, without writing any (La)TeX

## Examples

Typical GABC source of an antiphon looks like this:

    name: Nativitas gloriosae;
    office-part: laudes, 1. ant.;
    occasion: In Nativitate B. Mariae Virginis;
    book: Antiphonale Romanum 1912, pg. 704;
    mode: 8;
    initial-style: 1;
    %%
    
    (c4) NA(g)TI(g)VI(g)TAS(gd) glo(f)ri(gh)ó(g)sae(g) * (,)
    Vír(g)gi(g)nis(hi) Ma(gh)rí(gf)ae,(f) (;)
    ex(f) sé(g)mi(h)ne(h) A(hiwji)bra(hg)hae,(g) (;)
    or(gh~)tae(g) de(g) tri(g)bu(fe/fgf) Ju(d)da,(d) (;)
    cla(df!gh)ra(g) ex(f) stir(hg~)pe(hi) Da(h)vid.(g) (::)

Corresponding GLY may look like this:

    name: Nativitas gloriosae
    office-part: laudes, 1. ant.
    occasion: In Nativitate B. Mariae Virginis
    book: Antiphonale Romanum 1912, pg. 704
    mode: 8
    initial-style: 1
    
    c4 g g g gd f gh g g ,
    g g hi gh gf f ;
    f g h h hiwji hg g ;
    gh~ g g g fe/fgf d d ;
    df!gh g f hg~ hi h g ::
    
    NA -- TI -- VI -- TAS glo -- ri -- ósae *
    Vír -- gi -- nis Ma -- rí -- ae,
    ex sé -- mi -- ne A -- bra -- hae,
    or -- tae de tri -- bu Ju -- da,
    cla -- ra ex stir -- pe Da -- vid.

Or, with music and lyrics interlaced:

    name: Nativitas gloriosae
    office-part: laudes, 1. ant.
    occasion: In Nativitate B. Mariae Virginis
    book: Antiphonale Romanum 1912, pg. 704
    mode: 8
    initial-style: 1
    
    c4 g g g gd f gh g g ,
    NA -- TI -- VI -- TAS glo -- ri -- ósae *
    
    g g hi gh gf f ;
    Vír -- gi -- nis Ma -- rí -- ae,
    
    f g h h hiwji hg g ;
    ex sé -- mi -- ne A -- bra -- hae,
    
    gh~ g g g fe/fgf d d ;
    or -- tae de tri -- bu Ju -- da,
    
    df!gh g f hg~ hi h g ::
    cla -- ra ex stir -- pe Da -- vid.

Other arrangements are also possible. Order of music and lyrics
is actually ignored during processing.

## Run tests

by executing `tests/run.rb`

## License

MIT

[gregorio]: https://github.com/gregorio-project/gregorio
