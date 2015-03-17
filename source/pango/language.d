/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.language;

import pango.utils;
import pango.script;
import pango.c.language;
import pango.c.script;

import std.string;


struct Language
{
    PangoLanguage *nativePtr;

    package this(PangoLanguage *ptr) { nativePtr = ptr; }


    this (string lang) {
        nativePtr = pango_language_from_string(toStringz(lang));
    }


    static Language getDefault() {
        return Language(pango_language_get_default());
    }


    pure string toString() {
        const(char)* s = pango_language_to_string(nativePtr);
        if (s) {
            return fromStringz(s).idup;
        }
        return "";
    }

    pure @property string sampleString()
    {
        const(char)* s = pango_language_get_sample_string(nativePtr);
        if (s) {
            return fromStringz(s).idup;
        }
        return "";
    }

    pure bool matches(string rangeList) {
        return cast(bool)pango_language_matches(nativePtr, toStringz(rangeList));
    }

    pure bool includesScript(Script script) {
        return cast(bool)pango_language_includes_script(nativePtr, cast(PangoScript)script);
    }

    @property Script[] scripts() {
        int num;
        const(PangoScript)* outScripts = pango_language_get_scripts(nativePtr, &num);
        if (outScripts && num > 0) {
            const(Script)* dscripts = cast(const(Script)*)outScripts;
            return dscripts[0 .. num].dup;
        }
        return [];
    }

}

