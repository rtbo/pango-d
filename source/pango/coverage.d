/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.coverage;

import pango.utils;
import pango.c.coverage;

import glib;


/**
* CoverageLevel:
* None: The character is not representable with the font.
* Fallback: The character is represented in a way that may be
* comprehensible but is not the correct graphical form.
* For instance, a Hangul character represented as a
* a sequence of Jamos, or a Latin transliteration of a Cyrillic word.
* Approximate: The character is represented as basically the correct
* graphical form, but with a stylistic variant inappropriate for
* the current script.
* Exact: The character is represented as the correct graphical form.
*
* Used to indicate how well a font can represent a particular Unicode
* character point for a particular script.
*/
enum CoverageLevel {
    None        = PangoCoverageLevel.PANGO_COVERAGE_NONE,
    Fallback    = PangoCoverageLevel.PANGO_COVERAGE_FALLBACK,
    Approximate = PangoCoverageLevel.PANGO_COVERAGE_APPROXIMATE,
    Exact       = PangoCoverageLevel.PANGO_COVERAGE_EXACT
}

/**
* PangoCoverage:
*
* The #PangoCoverage structure represents a map from Unicode characters
* to #PangoCoverageLevel. It is an opaque structure with no public fields.
*/
struct Coverage
{
    mixin RefCountedGObj!(PangoCoverage, "pango_coverage");


    static Coverage create() {
        return Coverage(pango_coverage_new(), Transfer.Full);
    }

    package this(PangoCoverage *ptr, Transfer transfer)
    {
        initialize(ptr, transfer);
    }

    this(ubyte[] bytes)
    {
        initialize(pango_coverage_from_bytes (bytes.ptr, bytes.length), Transfer.Full);
    }

    Coverage copy()
    {
        return Coverage(pango_coverage_copy(nativePtr), Transfer.Full);
    }


    CoverageLevel get(int index)
    {
        return cast(CoverageLevel)pango_coverage_get(nativePtr, index);
    }

    void set(int index, CoverageLevel level)
    {
        pango_coverage_set(nativePtr, index, level);
    }

    void max (Coverage other)
    {
        pango_coverage_max(nativePtr, other.nativePtr);
    }

    ubyte[] toBytes()
    {
        ubyte *arr;
        int n_bytes;
        pango_coverage_to_bytes(nativePtr, &arr, &n_bytes);
        scope(exit) g_free(arr);

        if (!n_bytes) return [];

        ubyte[] res = new ubyte[n_bytes];
        foreach(i; 0 .. n_bytes) {
            res[i] = arr[i];
        }
        return res;
    }
}
