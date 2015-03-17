/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.attributes;

import pango.utils;
import pango.font;
import pango.language;
import pango.gravity;
import pango.types;
import pango.c.attributes;
import pango.c.font;
import pango.c.gravity;

import glib;

import std.string;
import std.typecons;


/* Color */
/**
 * PangoColor:
 * @red: value of red component
 * @green: value of green component
 * @blue: value of blue component
 *
 * The #PangoColor structure is used to
 * represent a color in an uncalibrated RGB color-space.
 */

alias Color = PangoColor;

bool parseColor(string spec, out Color color) {
    return cast(bool)pango_color_parse(&color, toStringz(spec));
}


string toString(in Color color) {
    auto str = pango_color_to_string(&color);
    scope(exit) g_free(str);
    return fromStringz(str).dup;
}


/**
 * PangoAttrIterator:
 *
 * The #PangoAttrIterator structure is used to represent an
 * iterator through a #PangoAttrList. A new iterator is created
 * with pango_attr_list_get_iterator(). Once the iterator
 * is created, it can be advanced through the style changes
 * in the text using pango_attr_iterator_next(). At each
 * style change, the range of the current style segment and the
 * attributes currently in effect can be queried.
 */
/**
 * PangoAttrList:
 *
 * The #PangoAttrList structure represents a list of attributes
 * that apply to a section of text. The attributes are, in general,
 * allowed to overlap in an arbitrary fashion, however, if the
 * attributes are manipulated only through pango_attr_list_change(),
 * the overlap between properties will meet stricter criteria.
 *
 * Since the #PangoAttrList structure is stored as a linear list,
 * it is not suitable for storing attributes for large amounts
 * of text. In general, you should not use a single #PangoAttrList
 * for more than one paragraph of text.
 */

/**
 * PangoAttrType:
 * @PANGO_ATTR_INVALID: does not happen
 * @PANGO_ATTR_LANGUAGE: language (#PangoAttrLanguage)
 * @PANGO_ATTR_FAMILY: font family name list (#PangoAttrString)
 * @PANGO_ATTR_STYLE: font slant style (#PangoAttrInt)
 * @PANGO_ATTR_WEIGHT: font weight (#PangoAttrInt)
 * @PANGO_ATTR_VARIANT: font variant (normal or small caps) (#PangoAttrInt)
 * @PANGO_ATTR_STRETCH: font stretch (#PangoAttrInt)
 * @PANGO_ATTR_SIZE: font size in points scaled by %PANGO_SCALE (#PangoAttrInt)
 * @PANGO_ATTR_FONT_DESC: font description (#PangoAttrFontDesc)
 * @PANGO_ATTR_FOREGROUND: foreground color (#PangoAttrColor)
 * @PANGO_ATTR_BACKGROUND: background color (#PangoAttrColor)
 * @PANGO_ATTR_UNDERLINE: whether the text has an underline (#PangoAttrInt)
 * @PANGO_ATTR_STRIKETHROUGH: whether the text is struck-through (#PangoAttrInt)
 * @PANGO_ATTR_RISE: baseline displacement (#PangoAttrInt)
 * @PANGO_ATTR_SHAPE: shape (#PangoAttrShape)
 * @PANGO_ATTR_SCALE: font size scale factor (#PangoAttrFloat)
 * @PANGO_ATTR_FALLBACK: whether fallback is enabled (#PangoAttrInt)
 * @PANGO_ATTR_LETTER_SPACING: letter spacing (#PangoAttrInt)
 * @PANGO_ATTR_UNDERLINE_COLOR: underline color (#PangoAttrColor)
 * @PANGO_ATTR_STRIKETHROUGH_COLOR: strikethrough color (#PangoAttrColor)
 * @PANGO_ATTR_ABSOLUTE_SIZE: font size in pixels scaled by %PANGO_SCALE (#PangoAttrInt)
 * @PANGO_ATTR_GRAVITY: base text gravity (#PangoAttrInt)
 * @PANGO_ATTR_GRAVITY_HINT: gravity hint (#PangoAttrInt)
 *
 * The #PangoAttrType
 * distinguishes between different types of attributes. Along with the
 * predefined values, it is possible to allocate additional values
 * for custom attributes using pango_attr_type_register(). The predefined
 * values are given below. The type of structure used to store the
 * attribute is listed in parentheses after the description.
 */
enum AttrType
{
  Invalid               = PangoAttrType.PANGO_ATTR_INVALID,           /* 0 is an invalid attribute type */
  Language              = PangoAttrType.PANGO_ATTR_LANGUAGE,		/* PangoAttrLanguage */
  Family                = PangoAttrType.PANGO_ATTR_FAMILY,		/* PangoAttrString */
  Style                 = PangoAttrType.PANGO_ATTR_STYLE,		/* PangoAttrInt */
  Weight                = PangoAttrType.PANGO_ATTR_WEIGHT,		/* PangoAttrInt */
  Variant               = PangoAttrType.PANGO_ATTR_VARIANT,		/* PangoAttrInt */
  Stretch               = PangoAttrType.PANGO_ATTR_STRETCH,		/* PangoAttrInt */
  Size                  = PangoAttrType.PANGO_ATTR_SIZE,		/* PangoAttrSize */
  FontDesc              = PangoAttrType.PANGO_ATTR_FONT_DESC,		/* PangoAttrFontDesc */
  Foreground            = PangoAttrType.PANGO_ATTR_FOREGROUND,	/* PangoAttrColor */
  Background            = PangoAttrType.PANGO_ATTR_BACKGROUND,	/* PangoAttrColor */
  Underline             = PangoAttrType.PANGO_ATTR_UNDERLINE,		/* PangoAttrInt */
  Strikethrough         = PangoAttrType.PANGO_ATTR_STRIKETHROUGH,	/* PangoAttrInt */
  Rise                  = PangoAttrType.PANGO_ATTR_RISE,		/* PangoAttrInt */
  Shape                 = PangoAttrType.PANGO_ATTR_SHAPE,		/* PangoAttrShape */
  Scale                 = PangoAttrType.PANGO_ATTR_SCALE,             /* PangoAttrFloat */
  Fallback              = PangoAttrType.PANGO_ATTR_FALLBACK,          /* PangoAttrInt */
  LetterSpacing         = PangoAttrType.PANGO_ATTR_LETTER_SPACING,    /* PangoAttrInt */
  UnderlineColor        = PangoAttrType.PANGO_ATTR_UNDERLINE_COLOR,	/* PangoAttrColor */
  StrikethroughColor    = PangoAttrType.PANGO_ATTR_STRIKETHROUGH_COLOR,/* PangoAttrColor */
  AbsoluteSize          = PangoAttrType.PANGO_ATTR_ABSOLUTE_SIZE,	/* PangoAttrSize */
  Gravity               = PangoAttrType.PANGO_ATTR_GRAVITY,		/* PangoAttrInt */
  GravityHint           = PangoAttrType.PANGO_ATTR_GRAVITY_HINT	/* PangoAttrInt */
}


@property string name(AttrType at) {
    return fromStringz(pango_attr_type_get_name(cast(PangoAttrType)at)).idup;
}

/**
 * PangoUnderline:
 * @PANGO_UNDERLINE_NONE: no underline should be drawn
 * @PANGO_UNDERLINE_SINGLE: a single underline should be drawn
 * @PANGO_UNDERLINE_DOUBLE: a double underline should be drawn
 * @PANGO_UNDERLINE_LOW: a single underline should be drawn at a position
 * beneath the ink extents of the text being
 * underlined. This should be used only for underlining
 * single characters, such as for keyboard
 * accelerators. %PANGO_UNDERLINE_SINGLE should
 * be used for extended portions of text.
 * @PANGO_UNDERLINE_ERROR: a wavy underline should be drawn below.
 * This underline is typically used to indicate
 * an error such as a possilble mispelling; in some
 * cases a contrasting color may automatically
 * be used. This type of underlining is available since Pango 1.4.
 *
 * The #PangoUnderline enumeration is used to specify
 * whether text should be underlined, and if so, the type
 * of underlining.
 */
enum Underline {
  None      = PangoUnderline.PANGO_UNDERLINE_NONE,
  Single    = PangoUnderline.PANGO_UNDERLINE_SINGLE,
  Double    = PangoUnderline.PANGO_UNDERLINE_DOUBLE,
  Low       = PangoUnderline.PANGO_UNDERLINE_LOW,
  Error     = PangoUnderline.PANGO_UNDERLINE_ERROR
}



abstract class Attribute
{
    mixin NativePtrHolder!(PangoAttribute, pango_attribute_destroy);

    package this (PangoAttribute *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    pure @property inout(PangoAttribute)* nativePtr() inout { return nativePtr_; }

    @property AttrType type() const {
        if (!nativePtr.klass) return AttrType.Invalid;
        return cast(AttrType) nativePtr.klass.type;
    }

    static Attribute getAttrDObject(PangoAttribute *attr, Transfer transfer)
    {
        if (!attr || !attr.klass) return null;

        final switch(cast(AttrType)(attr.klass.type)) {
            case AttrType.Language:
                return getDObject!AttrLanguage(cast(PangoAttrLanguage*)attr, transfer);
            case AttrType.Family:
                return getDObject!AttrString(cast(PangoAttrString*)attr, transfer);
            case AttrType.Style:
            case AttrType.Weight:
            case AttrType.Variant:
            case AttrType.Stretch:
            case AttrType.Underline:
            case AttrType.Strikethrough:
            case AttrType.Rise:
            case AttrType.Fallback:
            case AttrType.LetterSpacing:
            case AttrType.Gravity:
            case AttrType.GravityHint:
                return getDObject!AttrInt(cast(PangoAttrInt*)attr, transfer);
            case AttrType.Size:
            case AttrType.AbsoluteSize:
                return getDObject!AttrSize(cast(PangoAttrSize*)attr, transfer);
            case AttrType.FontDesc:
                return getDObject!AttrFontDesc(cast(PangoAttrFontDesc*)attr, transfer);
            case AttrType.Foreground:
            case AttrType.Background:
            case AttrType.UnderlineColor:
            case AttrType.StrikethroughColor:
                return getDObject!AttrColor(cast(PangoAttrColor*)attr, transfer);
            case AttrType.Shape:
                return getDObject!AttrShape(cast(PangoAttrShape*)attr, transfer);
            case AttrType.Scale:
                return getDObject!AttrFloat(cast(PangoAttrFloat*)attr, transfer);
            case AttrType.Invalid:
                return null;
        }
    }

    //void             pango_attribute_init        (PangoAttribute       *attr,
    //                          const(PangoAttrClass) *klass);

    abstract Attribute copy() const;

    pure bool equal(const(Attribute) attr)
    {
        if (!attr) return false;
        return cast(bool)pango_attribute_equal(nativePtr, attr.nativePtr);
    }

    pure override bool opEquals(Object obj) const
    {
        if (!obj) return false;
        auto attr = cast(const(Attribute))obj;
        if (!attr) return false;
        return cast(bool)pango_attribute_equal(nativePtr, attr.nativePtr);
    }

    static Attribute languageNew(Language language) {
        return getDObject!AttrLanguage(cast(PangoAttrLanguage*)
                                           pango_attr_language_new(language.nativePtr),
                                           Transfer.Full);
    }

    static Attribute familyNew(string family) {
        return getDObject!AttrString(cast(PangoAttrString*)pango_attr_family_new(toStringz(family)), Transfer.Full);
    }

    static Attribute foregroundNew(ushort red, ushort green, ushort blue) {
        return getDObject!AttrColor(cast(PangoAttrColor*)pango_attr_foreground_new(red, green, blue), Transfer.Full);
    }

    static Attribute backgroundNew(ushort red, ushort green, ushort blue) {
        return getDObject!AttrColor(cast(PangoAttrColor*)pango_attr_background_new(red, green, blue), Transfer.Full);
    }

    static Attribute sizeNew(int size) {
        return getDObject!AttrSize(cast(PangoAttrSize*)pango_attr_size_new(size), Transfer.Full);
    }

    static Attribute sizeNewAbsolute(int size) {
        return getDObject!AttrSize(cast(PangoAttrSize*)pango_attr_size_new_absolute(size), Transfer.Full);
    }

    static Attribute styleNew(Style style) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_style_new(cast(PangoStyle)style), Transfer.Full);
    }

    static Attribute weightNew(Weight weight) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_weight_new(cast(PangoWeight)weight), Transfer.Full);
    }

    static Attribute variantNew(Variant variant) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_variant_new(cast(PangoVariant)variant), Transfer.Full);
    }

    static Attribute stretchNew(Stretch stretch) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_stretch_new(cast(PangoStretch)stretch), Transfer.Full);
    }

    static Attribute fontDescNew(const(FontDescription) fontDesc) {
        return getDObject!AttrFontDesc(cast(PangoAttrFontDesc*)pango_attr_font_desc_new(fontDesc.nativePtr), Transfer.Full);
    }

    static Attribute underlineNew(Underline underline) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_underline_new(cast(PangoUnderline)underline), Transfer.Full);
    }

    static Attribute underlineColorNew(ushort red, ushort green, ushort blue) {
        return getDObject!AttrColor(cast(PangoAttrColor*)pango_attr_underline_color_new(red, green, blue), Transfer.Full);
    }

    static Attribute strikethroughNew(bool strikethrough) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_strikethrough_new(strikethrough), Transfer.Full);
    }

    static Attribute strikethroughColorNew(ushort red, ushort green, ushort blue) {
        return getDObject!AttrColor(cast(PangoAttrColor*)pango_attr_strikethrough_color_new(red, green, blue), Transfer.Full);
    }

    static Attribute riseNew(int rise) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_rise_new(rise), Transfer.Full);
    }

    static Attribute scaleNew(double scaleFactor) {
        return getDObject!AttrFloat(cast(PangoAttrFloat*)pango_attr_scale_new(scaleFactor), Transfer.Full);
    }

    static Attribute fallbackNew(bool enableFallback) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_fallback_new(enableFallback), Transfer.Full);
    }

    static Attribute letterSpacingNew(int letterSpacing) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_letter_spacing_new(letterSpacing), Transfer.Full);
    }

    static Attribute shapeNew(in Rectangle inkRect, in Rectangle logicalRect) {
        return getDObject!AttrShape(cast(PangoAttrShape*)pango_attr_shape_new(&inkRect, &logicalRect), Transfer.Full);
    }

    //PangoAttribute *pango_attr_shape_new_with_data (const(PangoRectangle)       *ink_rect,
    //                        const(PangoRectangle)       *logical_rect,
    //                        gpointer                    data,
    //                        PangoAttrDataCopyFunc       copy_func,
    //                        GDestroyNotify              destroy_func);

    static Attribute gravityNew(Gravity gravity) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_gravity_new(cast(PangoGravity)gravity), Transfer.Full);
    }

    static Attribute gravityHintNew(GravityHint hint) {
        return getDObject!AttrInt(cast(PangoAttrInt*)pango_attr_gravity_hint_new(cast(PangoGravityHint)hint), Transfer.Full);
    }

}


class AttrWithType(PangoAttrType) : Attribute
{
    package this(PangoAttrType *attr, Transfer transfer) {
        super(cast(PangoAttribute*)attr, transfer);
    }

    override Attribute copy() const {
        return getDObject!(AttrWithType!(PangoAttrType)) (
                cast(PangoAttrType*)pango_attribute_copy(nativePtr),
                Transfer.Full
        );
    }
}

alias AttrLanguage = AttrWithType!PangoAttrLanguage;
alias AttrString = AttrWithType!PangoAttrString;
alias AttrInt = AttrWithType!PangoAttrInt;
alias AttrSize = AttrWithType!PangoAttrSize;
alias AttrFontDesc = AttrWithType!PangoAttrFontDesc;
alias AttrColor = AttrWithType!PangoAttrColor;
alias AttrShape = AttrWithType!PangoAttrShape;
alias AttrFloat = AttrWithType!PangoAttrFloat;


struct AttrList
{
    mixin RefCountedGObj!(PangoAttrList, "pango_attr_list");

    package this(PangoAttrList *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    AttrList create() {
        return AttrList(pango_attr_list_new(), Transfer.Full);
    }

    //PangoAttrList *    pango_attr_list_copy          (PangoAttrList  *list);

    void insert(Attribute attr) {
        pango_attr_list_insert(nativePtr, attr.nativePtr);
    }

    void insertBefore(Attribute attr) {
        pango_attr_list_insert_before(nativePtr, attr.nativePtr);
    }

    void change(Attribute attr) {
        pango_attr_list_change(nativePtr, attr.nativePtr);
    }

    void splice(AttrList other, int pos, int len) {
        pango_attr_list_splice(nativePtr, other.nativePtr, pos, len);
    }

    AttrList filter(PangoAttrFilterFunc func, gpointer data) {
        return AttrList(pango_attr_list_filter(nativePtr, func, data), Transfer.Full);
    }

    @property AttrIterator iterator() {
        return getDObject!AttrIterator(pango_attr_list_get_iterator(nativePtr), Transfer.Full);
    }


}


class AttrIterator
{
    mixin NativePtrHolder!(PangoAttrIterator, pango_attr_iterator_destroy);

    package this(PangoAttrIterator* ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }


    void range (out int start, out int end) {
        pango_attr_iterator_range(nativePtr, &start, &end);
    }

    bool next() {
        return cast(bool)pango_attr_iterator_next(nativePtr);
    }

    Attribute get(AttrType type) {
        return Attribute.getAttrDObject(pango_attr_iterator_get(nativePtr, cast(PangoAttrType)type), Transfer.None);
    }

    //void               pango_attr_iterator_get_font (PangoAttrIterator     *iterator,
    //                         PangoFontDescription  *desc,
    //                         PangoLanguage        **language,
    //                         GSList               **extra_attrs);
    //GSList *          pango_attr_iterator_get_attrs (PangoAttrIterator     *iterator);
}

//
//
//gboolean pango_parse_markup (const(char)                 *markup_text,
//                 int                         length,
//                 gunichar                    accel_marker,
//                 PangoAttrList             **attr_list,
//                 char                      **text,
//                 gunichar                   *accel_char,
//                 GError                    **error);
//
//GMarkupParseContext * pango_markup_parser_new (gunichar               accel_marker);
//gboolean              pango_markup_parser_finish (GMarkupParseContext   *context,
//                                                  PangoAttrList        **attr_list,
//                                                  char                 **text,
//                                                  gunichar              *accel_char,
//                                                  GError               **error);
//

