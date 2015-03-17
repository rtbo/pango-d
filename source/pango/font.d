module pango.font;

import pango.utils;
import pango.gravity;
import pango.coverage;
import pango.language;
import pango.types;
import pango.fontmap;
import pango.fontset;
import pango.c;


import gobject;
import glib;

import std.string;




/**
* Style:
* Normal: the font is upright.
* Oblique: the font is slanted, but in a roman style.
* Italic: the font is slanted in an italic style.
*
* An enumeration specifying the various slant styles possible for a font.
**/
enum Style {
    Normal = PangoStyle.PANGO_STYLE_NORMAL,
    Oblique = PangoStyle.PANGO_STYLE_OBLIQUE,
    Italic = PangoStyle.PANGO_STYLE_ITALIC
}

/**
* PangoVariant:
* Normal: A normal font.
* SmallCaps: A font with the lower case characters
* replaced by smaller variants of the capital characters.
*
* An enumeration specifying capitalization variant of the font.
*/
enum Variant {
    Normal = PangoVariant.PANGO_VARIANT_NORMAL,
    SmallCaps = PangoVariant.PANGO_VARIANT_SMALL_CAPS
}

/**
* Weight:
* Thin: the thin weight (= 100; Since: 1.24)
* UltraLight: the ultralight weight (= 200)
* Light: the light weight (= 300)
* SemiLight: the semilight weight (= 350; Since: 1.36.7)
* Book: the book weight (= 380; Since: 1.24)
* Normal: the default weight (= 400)
* Medium: the normal weight (= 500; Since: 1.24)
* SemiBold: the semibold weight (= 600)
* Bold: the bold weight (= 700)
* UltraBold: the ultrabold weight (= 800)
* Heavy: the heavy weight (= 900)
* UltraHeavy: the ultraheavy weight (= 1000; Since: 1.24)
*
* An enumeration specifying the weight (boldness) of a font. This is a numerical
* value ranging from 100 to 1000, but there are some predefined values:
*/
enum Weight {
    Thin = 100,
    UltraLight = 200,
    Light = 300,
    SemiLight = 350,
    Book = 380,
    Normal = 400,
    Medium = 500,
    SemiBold = 600,
    Bold = 700,
    UltraBold = 800,
    Heavy = 900,
    UltraHeavy = 1000
}

/**
* Stretch:
* UltraCondensed: ultra condensed width
* ExtraCondesed: extra condensed width
* Condensed: condensed width
* SemiCondensed: semi condensed width
* Normal: the normal width
* SemiExpanded: semi expanded width
* Expanded: expanded width
* ExtraExpanded: extra expanded width
* UltraExpanded: ultra expanded width
*
* An enumeration specifying the width of the font relative to other designs
* within a family.
*/
enum Stretch {
    UltraCondensed = PangoStretch.PANGO_STRETCH_ULTRA_CONDENSED,
    ExtraCondesed = PangoStretch.PANGO_STRETCH_EXTRA_CONDENSED,
    Condensed = PangoStretch.PANGO_STRETCH_CONDENSED,
    SemiCondensed = PangoStretch.PANGO_STRETCH_SEMI_CONDENSED,
    Normal = PangoStretch.PANGO_STRETCH_NORMAL,
    SemiExpanded = PangoStretch.PANGO_STRETCH_SEMI_EXPANDED,
    Expanded = PangoStretch.PANGO_STRETCH_EXPANDED,
    ExtraExpanded = PangoStretch.PANGO_STRETCH_EXTRA_EXPANDED,
    UltraExpanded = PangoStretch.PANGO_STRETCH_ULTRA_EXPANDED
}

/**
* FontMask:
* Family: the font family is specified.
* Style: the font style is specified.
* Variant: the font variant is specified.
* Weight: the font weight is specified.
* Stretch: the font stretch is specified.
* Size: the font size is specified.
* Gravity: the font gravity is specified (Since: 1.16.)
*
* The bits in a #PangoFontMask correspond to fields in a
* #PangoFontDescription that have been set.
*/
enum FontMask {
    Family  = 1 << 0,
    Style   = 1 << 1,
    Variant = 1 << 2,
    Weight  = 1 << 3,
    Stretch = 1 << 4,
    Size    = 1 << 5,
    Gravity = 1 << 6
}


/**
* Scale:  CSS scale factors (1.2 factor between each size)
* XXSmall: the scale factor for three shrinking steps (1 / (1.2 * 1.2 * 1.2))
* XSmall: the scale factor for two shrinking steps (1 / (1.2 * 1.2))
* Small: the scale factor for one shrinking steps (1 / 1.2)
* Medium: the scale factor for normal size (1.0))
* Large: the scale factor for one magnification step (1.2)
* XLarge: the scale factor for two magnification steps (1.2 * 1.2)
* XXLarge: the scale factor for three magnification steps (1.2 * 1.2 * 1.2)
*/
enum Scale : double {
    XXSmall = PANGO_SCALE_XX_SMALL,
    XSmall = PANGO_SCALE_X_SMALL,
    Small = PANGO_SCALE_SMALL,
    Medium = PANGO_SCALE_MEDIUM,
    Large = PANGO_SCALE_LARGE,
    XLarge = PANGO_SCALE_X_LARGE,
    XXLarge = PANGO_SCALE_XX_LARGE,
}



class FontDescription
{
    mixin NativePtrHolder!(PangoFontDescription, pango_font_description_free);
    bool owned_ = true;

    package this(PangoFontDescription *ptr, Transfer transfer)
    {
        initialize(ptr, transfer);
    }

    this() {
        initialize(pango_font_description_new(), Transfer.Full);
    }

    this(string str)
    {
        initialize(pango_font_description_from_string(toStringz(str)), Transfer.Full);
    }


    FontDescription copy() const
    {
        return getDObject!FontDescription(pango_font_description_copy(nativePtr), Transfer.Full);
    }

    FontDescription copyStatic() const
    {
        return getDObject!FontDescription(pango_font_description_copy_static(nativePtr), Transfer.Full);
    }


    pure @property uint hash() const { return pango_font_description_hash(nativePtr); }

    pure bool equal(const(FontDescription) other) const {
        return cast(bool)pango_font_description_equal(nativePtr, other.nativePtr);
    }



    @property void family(string family) {
        pango_font_description_set_family(nativePtr, family.toStringz);
    }

    @property void familyStatic(string family) {
        pango_font_description_set_family_static(nativePtr, family.toStringz);
    }

    pure @property string family() const {
        const(char)* f = pango_font_description_get_family(nativePtr);
        if (f) return fromStringz(f).idup;
        return "";
    }



    @property void style(Style style) {
        pango_font_description_set_style(nativePtr_, cast(PangoStyle)style);
    }

    pure @property Style style() const {
        return cast(Style)pango_font_description_get_style(nativePtr);
    }



    @property void variant(Variant variant) {
        pango_font_description_set_variant(nativePtr, cast(PangoVariant)variant);
    }

    pure @property Variant variant() const {
        return cast(Variant)pango_font_description_get_variant(nativePtr);
    }



    @property void weight(Weight weight) {
        pango_font_description_set_weight(nativePtr, cast(PangoWeight)weight);
    }

    pure @property Weight weight() const {
        return cast(Weight)pango_font_description_get_weight(nativePtr);
    }



    @property void stretch(Stretch stretch) {
        pango_font_description_set_stretch(nativePtr, cast(PangoStretch)stretch);
    }

    pure @property Stretch stretch() const {
        return cast(Stretch)pango_font_description_get_stretch(nativePtr);
    }



    @property void size(int size) {
        pango_font_description_set_size(nativePtr, size);
    }

    pure @property int size() const {
        return pango_font_description_get_size(nativePtr);
    }

    @property void absoluteSize(double size) {
        pango_font_description_set_absolute_size(nativePtr, size);
    }

    pure @property bool sizeIsAbsolute() const {
        return cast(bool)pango_font_description_get_size_is_absolute(nativePtr);
    }



    @property void gravity(Gravity gravity) {
        pango_font_description_set_gravity(nativePtr, cast(PangoGravity)gravity);
    }

    pure @property Gravity gravity() const {
        return cast(Gravity)pango_font_description_get_gravity(nativePtr);
    }


    pure @property FontMask setFields() const {
        return cast(FontMask)pango_font_description_get_set_fields(nativePtr);
    }

    void unsetFields(FontMask toUnset) {
        pango_font_description_unset_fields(nativePtr, cast(PangoFontMask)toUnset);
    }


    
    void merge(const(FontDescription) other, bool replaceExisting)
    {
        pango_font_description_merge(nativePtr, other.nativePtr, replaceExisting);
    }

    void mergeStatic(const(FontDescription) other, bool replaceExisting)
    {
        pango_font_description_merge_static(nativePtr, other.nativePtr, replaceExisting);
    }

    bool betterMatch(const(FontDescription) oldMatch, const(FontDescription) newMatch)
    {
        return cast(bool)pango_font_description_better_match(nativePtr,
                                                             oldMatch.nativePtr,
                                                             newMatch.nativePtr);
    }
    

    override string toString() const {
        char *s = pango_font_description_to_string(nativePtr);
        if (s) {
            string res = fromStringz(s).idup;
            g_free(s);
            return res;
        }
        return "";
    }

    string toFilename() const {
        char *s = pango_font_description_to_filename(nativePtr);
        if (s) {
            string res = fromStringz(s).idup;
            g_free(s);
            return res;
        }
        return "";
    }
}



struct FontMetrics
{
    mixin RefCountedGObj!(PangoFontMetrics, "pango_font_metrics");

    package this(PangoFontMetrics *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    version(Backend) {
        static FontMetrics create() {
            return FontMetrics(pango_font_metrics_new());
        }
    }


    pure @property int ascent() {
        return pango_font_metrics_get_ascent(nativePtr);
    }
    
    pure @property int descent() {
        return pango_font_metrics_get_descent(nativePtr);
    }
    
    pure @property int approximateCharWidth() {
        return pango_font_metrics_get_approximate_char_width(nativePtr);
    }
    
    pure @property int approximateDigitWidth() {
        return pango_font_metrics_get_approximate_digit_width(nativePtr);
    }

    pure @property int underlinePosition() {
        return pango_font_metrics_get_underline_position(nativePtr);
    }

    pure @property int underlineThickness() {
        return pango_font_metrics_get_underline_thickness(nativePtr);
    }

    pure @property int strikethroughPosition() {
        return pango_font_metrics_get_strikethrough_position(nativePtr);
    }

    pure @property int strikethroughThickness() {
        return pango_font_metrics_get_strikethrough_thickness(nativePtr);
    }

}



class FontFamily : D_GObject
{
    mixin GObjectHolder!PangoFontFamily;
    
    package this(PangoFontFamily *ptr, Transfer transfer) {
        super (cast(GObject*)ptr, transfer);
    }

    FontFace[] listFaces()
    {
        return listGObjects!(FontFace, pango_font_family_list_faces)(nativePtr, Transfer.None);
    }

    @property string name() {
        const(char)* n = pango_font_family_get_name(nativePtr);
        if (n) {
            return fromStringz(n).idup;
        }
        return "";
    }

    @property bool monospace() {
        return cast(bool)pango_font_family_is_monospace(nativePtr);
    }
}




class FontFace : D_GObject
{
    mixin GObjectHolder!PangoFontFace;

    package this(PangoFontFace *ptr, Transfer transfer) {
        super (cast(GObject*)ptr, transfer);
    }

    FontDescription describe() {
        return getDObject!FontDescription(pango_font_face_describe(nativePtr), Transfer.Full);
    }

    @property string faceName() {
        const(char)* fn = pango_font_face_get_face_name(nativePtr);
        if (fn) {
            return fromStringz(fn).idup;
        }
        return "";
    }

    int[] listSizes()
    {
        return listValues!(int, pango_font_face_list_sizes)(nativePtr);
    }

    @property bool isSynthesized() {
        return cast(bool)pango_font_face_is_synthesized(nativePtr);
    }

}


abstract class Font : D_GObject {

    mixin GObjectHolder!PangoFont;

    package this(PangoFont *ptr, Transfer transfer) {
        super (cast(GObject*) ptr, transfer);
    }

    FontDescription describe() {
        return getDObject!FontDescription(pango_font_describe(nativePtr), Transfer.Full);
    }

    FontDescription describeWithAbsoluteSize() {
        return getDObject!FontDescription(pango_font_describe_with_absolute_size(nativePtr), Transfer.Full);
    }

    Coverage coverage(Language language) {
        return getDObject!Coverage(pango_font_get_coverage(nativePtr, language.nativePtr), Transfer.Full);
    }

    
    version (Backend) {
        // FIXME: should not be in Backend version
        //PangoEngineShape *    pango_font_find_shaper       (PangoFont        *font,
        //                                                    PangoLanguage    *language,
        //                                                    guint32           ch);
    }

    FontMetrics metrics(Language language) {
        return getDObject!FontMetrics(pango_font_get_metrics(nativePtr, language.nativePtr), Transfer.Full);
    }

    void glyphExtents(Glyph glyph, out Rectangle inkRect, out Rectangle logicalRect) {
        pango_font_get_glyph_extents(nativePtr, glyph, &inkRect, &logicalRect);
    }


    @property FontMap fontMap() {
        return cast(FontMap)getExistingDObject(pango_font_get_font_map(nativePtr), Transfer.None);
    }

}



interface FontFactory {

    FontMap getFontMap(PangoFontMap *ptr, Transfer transfer);

    FontSet getFontSet(PangoFontset *ptr, Transfer transfer);

    Font getFont(PangoFont *ptr, Transfer transfer);
}


class NullFontFactory : FontFactory {

    FontMap getFontMap(PangoFontMap *ptr, Transfer transfer) {
        return null;
    }

    FontSet getFontSet(PangoFontset *ptr, Transfer transfer) {
        return null;
    }

    Font getFont(PangoFont *ptr, Transfer transfer) {
        return null;
    }
}


class ThrowFontFactory : FontFactory {

    FontMap getFontMap(PangoFontMap *ptr, Transfer transfer) {
        throw new Error("ThrowFontFactory.getFontMap");
    }

    FontSet getFontSet(PangoFontset *ptr, Transfer transfer) {
        throw new Error("ThrowFontFactory.getFontSet");
    }

    Font getFont(PangoFont *ptr, Transfer transfer) {
        throw new Error("ThrowFontFactory.getFont");
    }
}


@property FontFactory defaultFontFactory() {
    static FontFactory inst;
    if (!inst) inst = new ThrowFontFactory;
    return inst;
}


mixin template FontFactoryHolder()
{
    private FontFactory fontFactory_;

    invariant() {
        assert(fontFactory_ !is null);
    }

    @property inout(FontFactory) fontFactory() inout {
        return fontFactory_;
    }

    @property void fontFactory(FontFactory ff) {
        fontFactory_ = ff;
    }
}
