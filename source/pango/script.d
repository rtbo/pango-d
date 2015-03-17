/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.script;

import pango.utils;
import pango.language;
import pango.c.script;
import pango.c.language;

import std.string;
import std.range;
import std.conv;


/**
* PangoScript:
* InvalidCode: a value never returned from pango_script_for_unichar()
* Common: a character used by multiple different scripts
* Inherited: a mark glyph that takes its script from the
* base glyph to which it is attached
* Arabic: 	Arabic
* Armenian: Armenian
* Bengali: 	Bengali
* Bopomofo: Bopomofo
* Cherokee: 	Cherokee
* Coptic: 	Coptic
* Cyrillic: 	Cyrillic
* Deseret: 	Deseret
* Devanagari: 	Devanagari
* Ethiopic: 	Ethiopic
* Georgian: 	Georgian
* Gothic: 	Gothic
* Greek: 	Greek
* Gujarati: 	Gujarati
* Gurmukhi: 	Gurmukhi
* Han: 	Han
* Hangul: 	Hangul
* Hebrew: 	Hebrew
* Hiragana: 	Hiragana
* Kannada: 	Kannada
* Katakana: 	Katakana
* Khmer: 	Khmer
* Lao: 	Lao
* Latin: 	Latin
* Malayalam: 	Malayalam
* Mongolian: 	Mongolian
* Myanmar: 	Myanmar
* Ogham: 	Ogham
* OldItalic: 	Old Italic
* Oriya: 	Oriya
* Runic: 	Runic
* Sinhala: 	Sinhala
* Syriac: 	Syriac
* Tamil: 	Tamil
* Telugu: 	Telugu
* Thaana: 	Thaana
* Thai: 	Thai
* Tibetan: 	Tibetan
* CanadianAboriginal: 	Canadian Aboriginal
* Yi: 	Yi
* Tagalog: 	Tagalog
* Hanunoo: 	Hanunoo
* Buhid: 	Buhid
* Tagbanwa: 	Tagbanwa
* Braille: 	Braille
* Cypriot: 	Cypriot
* Limbu: 	Limbu
* Osmanya: 	Osmanya
* Shavian: 	Shavian
* LinearB: 	Linear B
* TaiLe: 	Tai Le
* Ugaritic: 	Ugaritic
* NewTaiLue: 	New Tai Lue. Since 1.10
* Buginese: 	Buginese. Since 1.10
* Glagolitic: 	Glagolitic. Since 1.10
* Tifinagh: 	Tifinagh. Since 1.10
* SylotiNagri: 	Syloti Nagri. Since 1.10
* OldPersian: 	Old Persian. Since 1.10
* Kharoshthi: 	Kharoshthi. Since 1.10
* Unknown: 		an unassigned code point. Since 1.14
* Balinese: 		Balinese. Since 1.14
* Cuneiform: 	Cuneiform. Since 1.14
* Phoenician: 	Phoenician. Since 1.14
* PhagsPa: 		Phags-pa. Since 1.14
* Nko: 		N'Ko. Since 1.14
* KayahLi:   Kayah Li. Since 1.20.1
* Lepcha:     Lepcha. Since 1.20.1
* Rejang:     Rejang. Since 1.20.1
* Sundanese:  Sundanese. Since 1.20.1
* Saurashtra: Saurashtra. Since 1.20.1
* Cham:       Cham. Since 1.20.1
* OlChiki:   Ol Chiki. Since 1.20.1
* Vai:        Vai. Since 1.20.1
* Carian:     Carian. Since 1.20.1
* Lycian:     Lycian. Since 1.20.1
* Lydian:     Lydian. Since 1.20.1
* Batak:      Batak. Since 1.32
* Brahmi:     Brahmi. Since 1.32
* Mandaic:    Mandaic. Since 1.32
* Chakma:               Chakma. Since: 1.32
* MeroiticCursive:     Meroitic Cursive. Since: 1.32
* MeroiticHieroglyphs: Meroitic Hieroglyphs. Since: 1.32
* Miao:                 Miao. Since: 1.32
* Sharada:              Sharada. Since: 1.32
* SoraSompeng:         Sora Sompeng. Since: 1.32
* Takri:                Takri. Since: 1.32
*
* The #PangoScript enumeration identifies different writing
* systems. The values correspond to the names as defined in the
* Unicode standard.
* Note that new types may be added in the future. Applications should be ready
* to handle unknown values.  This enumeration is interchangeable with
* #GUnicodeScript.  See <ulink
* url="http://www.unicode.org/reports/tr24/">Unicode Standard Annex
* #24: Script names</ulink>.
*/
enum Script {                                                       /* ISO 15924 code */
    InvalidCode         = PangoScript.PANGO_SCRIPT_INVALID_CODE,
    Common              = PangoScript.PANGO_SCRIPT_COMMON,             /* Zyyy */
    Inherited           = PangoScript.PANGO_SCRIPT_INHERITED,          /* Qaai */
    Arabic              = PangoScript.PANGO_SCRIPT_ARABIC,             /* Arab */
    Armenian            = PangoScript.PANGO_SCRIPT_ARMENIAN,           /* Armn */
    Bengali             = PangoScript.PANGO_SCRIPT_BENGALI,            /* Beng */
    Bopomofo            = PangoScript.PANGO_SCRIPT_BOPOMOFO,           /* Bopo */
    Cherokee            = PangoScript.PANGO_SCRIPT_CHEROKEE,           /* Cher */
    Coptic              = PangoScript.PANGO_SCRIPT_COPTIC,             /* Qaac */
    Cyrillic            = PangoScript.PANGO_SCRIPT_CYRILLIC,           /* Cyrl (Cyrs) */
    Deseret             = PangoScript.PANGO_SCRIPT_DESERET,            /* Dsrt */
    Devanagari          = PangoScript.PANGO_SCRIPT_DEVANAGARI,         /* Deva */
    Ethiopic            = PangoScript.PANGO_SCRIPT_ETHIOPIC,           /* Ethi */
    Georgian            = PangoScript.PANGO_SCRIPT_GEORGIAN,           /* Geor (Geon, Geoa) */
    Gothic              = PangoScript.PANGO_SCRIPT_GOTHIC,             /* Goth */
    Greek               = PangoScript.PANGO_SCRIPT_GREEK,              /* Grek */
    Gujarati            = PangoScript.PANGO_SCRIPT_GUJARATI,           /* Gujr */
    Gurmukhi            = PangoScript.PANGO_SCRIPT_GURMUKHI,           /* Guru */
    Han                 = PangoScript.PANGO_SCRIPT_HAN,                /* Hani */
    Hangul              = PangoScript.PANGO_SCRIPT_HANGUL,             /* Hang */
    Hebrew              = PangoScript.PANGO_SCRIPT_HEBREW,             /* Hebr */
    Hiragana            = PangoScript.PANGO_SCRIPT_HIRAGANA,           /* Hira */
    Kannada             = PangoScript.PANGO_SCRIPT_KANNADA,            /* Knda */
    Katakana            = PangoScript.PANGO_SCRIPT_KATAKANA,           /* Kana */
    Khmer               = PangoScript.PANGO_SCRIPT_KHMER,              /* Khmr */
    Lao                 = PangoScript.PANGO_SCRIPT_LAO,                /* Laoo */
    Latin               = PangoScript.PANGO_SCRIPT_LATIN,              /* Latn (Latf, Latg) */
    Malayalam           = PangoScript.PANGO_SCRIPT_MALAYALAM,          /* Mlym */
    Mongolian           = PangoScript.PANGO_SCRIPT_MONGOLIAN,          /* Mong */
    Myanmar             = PangoScript.PANGO_SCRIPT_MYANMAR,            /* Mymr */
    Ogham               = PangoScript.PANGO_SCRIPT_OGHAM,              /* Ogam */
    OldItalic           = PangoScript.PANGO_SCRIPT_OLD_ITALIC,         /* Ital */
    Oriya               = PangoScript.PANGO_SCRIPT_ORIYA,              /* Orya */
    Runic               = PangoScript.PANGO_SCRIPT_RUNIC,              /* Runr */
    Sinhala             = PangoScript.PANGO_SCRIPT_SINHALA,            /* Sinh */
    Syriac              = PangoScript.PANGO_SCRIPT_SYRIAC,             /* Syrc (Syrj, Syrn, Syre) */
    Tamil               = PangoScript.PANGO_SCRIPT_TAMIL,              /* Taml */
    Telugu              = PangoScript.PANGO_SCRIPT_TELUGU,             /* Telu */
    Thaana              = PangoScript.PANGO_SCRIPT_THAANA,             /* Thaa */
    Thai                = PangoScript.PANGO_SCRIPT_THAI,               /* Thai */
    Tibetan             = PangoScript.PANGO_SCRIPT_TIBETAN,            /* Tibt */
    CanadianAboriginal  = PangoScript.PANGO_SCRIPT_CANADIAN_ABORIGINAL, /* Cans */
    Yi                  = PangoScript.PANGO_SCRIPT_YI,                 /* Yiii */
    Tagalog             = PangoScript.PANGO_SCRIPT_TAGALOG,            /* Tglg */
    Hanunoo             = PangoScript.PANGO_SCRIPT_HANUNOO,            /* Hano */
    Buhid               = PangoScript.PANGO_SCRIPT_BUHID,              /* Buhd */
    Tagbanwa            = PangoScript.PANGO_SCRIPT_TAGBANWA,           /* Tagb */

    /* Unicode-4.0 additions */
    Braille             = PangoScript.PANGO_SCRIPT_BRAILLE,            /* Brai */
    Cypriot             = PangoScript.PANGO_SCRIPT_CYPRIOT,            /* Cprt */
    Limbu               = PangoScript.PANGO_SCRIPT_LIMBU,              /* Limb */
    Osmanya             = PangoScript.PANGO_SCRIPT_OSMANYA,            /* Osma */
    Shavian             = PangoScript.PANGO_SCRIPT_SHAVIAN,            /* Shaw */
    LinearB             = PangoScript.PANGO_SCRIPT_LINEAR_B,           /* Linb */
    TaiLe               = PangoScript.PANGO_SCRIPT_TAI_LE,             /* Tale */
    Ugaritic            = PangoScript.PANGO_SCRIPT_UGARITIC,           /* Ugar */

    /* Unicode-4.1 additions */
    NewTaiLue           = PangoScript.PANGO_SCRIPT_NEW_TAI_LUE,        /* Talu */
    Buginese            = PangoScript.PANGO_SCRIPT_BUGINESE,           /* Bugi */
    Glagolitic          = PangoScript.PANGO_SCRIPT_GLAGOLITIC,         /* Glag */
    Tifinagh            = PangoScript.PANGO_SCRIPT_TIFINAGH,           /* Tfng */
    SylotiNagri         = PangoScript.PANGO_SCRIPT_SYLOTI_NAGRI,       /* Sylo */
    OldPersian          = PangoScript.PANGO_SCRIPT_OLD_PERSIAN,        /* Xpeo */
    Kharoshthi          = PangoScript.PANGO_SCRIPT_KHAROSHTHI,         /* Khar */

    /* Unicode-5.0 additions */
    Unknown             = PangoScript.PANGO_SCRIPT_UNKNOWN,            /* Zzzz */
    Balinese            = PangoScript.PANGO_SCRIPT_BALINESE,           /* Bali */
    Cuneiform           = PangoScript.PANGO_SCRIPT_CUNEIFORM,          /* Xsux */
    Phoenician          = PangoScript.PANGO_SCRIPT_PHOENICIAN,         /* Phnx */
    PhagsPa             = PangoScript.PANGO_SCRIPT_PHAGS_PA,           /* Phag */
    Nko                 = PangoScript.PANGO_SCRIPT_NKO,                /* Nkoo */

    /* Unicode-5.1 additions */
    KayahLi             = PangoScript.PANGO_SCRIPT_KAYAH_LI,           /* Kali */
    Lepcha              = PangoScript.PANGO_SCRIPT_LEPCHA,             /* Lepc */
    Rejang              = PangoScript.PANGO_SCRIPT_REJANG,             /* Rjng */
    Sundanese           = PangoScript.PANGO_SCRIPT_SUNDANESE,          /* Sund */
    Saurashtra          = PangoScript.PANGO_SCRIPT_SAURASHTRA,         /* Saur */
    Cham                = PangoScript.PANGO_SCRIPT_CHAM,               /* Cham */
    OlChiki             = PangoScript.PANGO_SCRIPT_OL_CHIKI,           /* Olck */
    Vai                 = PangoScript.PANGO_SCRIPT_VAI,                /* Vaii */
    Carian              = PangoScript.PANGO_SCRIPT_CARIAN,             /* Cari */
    Lycian              = PangoScript.PANGO_SCRIPT_LYCIAN,             /* Lyci */
    Lydian              = PangoScript.PANGO_SCRIPT_LYDIAN,             /* Lydi */

    /* Unicode-6.0 additions */
    Batak               = PangoScript.PANGO_SCRIPT_BATAK,              /* Batk */
    Brahmi              = PangoScript.PANGO_SCRIPT_BRAHMI,             /* Brah */
    Mandaic             = PangoScript.PANGO_SCRIPT_MANDAIC,            /* Mand */

    /* Unicode-6.1 additions */
    Chakma              = PangoScript.PANGO_SCRIPT_CHAKMA,             /* Cakm */
    MeroiticCursive     = PangoScript.PANGO_SCRIPT_MEROITIC_CURSIVE,   /* Merc */
    MeroiticHieroglyphs = PangoScript.PANGO_SCRIPT_MEROITIC_HIEROGLYPHS,/* Mero */
    Miao                = PangoScript.PANGO_SCRIPT_MIAO,               /* Plrd */
    Sharada             = PangoScript.PANGO_SCRIPT_SHARADA,            /* Shrd */
    SoraSompeng         = PangoScript.PANGO_SCRIPT_SORA_SOMPENG,       /* Sora */
    Takri               = PangoScript.PANGO_SCRIPT_TAKRI               /* Takr */
}


Script scriptForChar(dchar ch) {
    return cast(Script)pango_script_for_unichar(ch);
}

Language scriptSampleLanguage(Script script) {
    PangoLanguage *lang = pango_script_get_sample_language(cast(PangoScript)script);
    if (!lang) {
        throw new Exception("could not get Language for script " ~ script.to!string);
    }
    return Language(lang);
}


/**
 * TextScriptRange: wrapper around PangoScriptIter
 */
struct TextScriptRange {

    private PangoScriptIter *ptr_ = null;
    private string text_;
    private bool empty_ = false;


    struct Section {
        const(char)[] text;
        Script script;
    }


    this(string text) {
        text_ = text;
        ptr_ = pango_script_iter_new(text_.ptr, text_.length);
        if (text.length == 0) {
            empty_ = true;
        }
    }

    @disable this(this);

    ~this() {
        pango_script_iter_free(ptr_);
        ptr_ = null;
    }

    @property bool empty() const {
        return empty_;
    }

    @property Section front() {
        const (char) *start;
        const (char) *end;
        PangoScript script;
        pango_script_iter_get_range(ptr_, &start, &end, &script);
        assert(end >= start);
        if (end == start) {
            empty_ = true;
            return Section("", cast(Script)script);
        }
        empty_ = false;
        return Section(start[0 .. (end-start)], cast(Script)script);
    }

    void popFront() {
        empty_ = !(cast(bool)pango_script_iter_next(ptr_));
    }
}

static assert(isInputRange!TextScriptRange);
