/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.cairo;

import pango.utils;
import pango.font;
import pango.fontmap;
import pango.fontset;
import pango.context : PgContext=Context;
import pango.layout;
import pango.glyph;
import pango.glyph_item;
import pango.language;
import pango.c.cairo;
import pango.c.font;
import pango.c.fontmap;
import pango.c.fontset;
import pango.c.context;

import cairo.cairo : FontType, ScaledFont, FontOptions, CrContext=Context;
import cairo.c.cairo;

import gobject;

import std.string;


/**
 * PangoCairoShapeRendererFunc:
 * @cr: a Cairo context with current point set to where the shape should
 * be rendered
 * @attr: the %PANGO_ATTR_SHAPE to render
 * @do_path: whether only the shape path should be appended to current
 * path of @cr and no filling/stroking done.  This will be set
 * to %TRUE when called from pango_cairo_layout_path() and
 * pango_cairo_layout_line_path() rendering functions.
 * @data: user data passed to pango_cairo_context_set_shape_renderer()
 *
 * Function type for rendering attributes of type %PANGO_ATTR_SHAPE
 * with Pango's Cairo renderer.
 */
//alias PangoCairoShapeRendererFunc = void function (cairo_t        *cr,
//                          PangoAttrShape *attr,
//                          gboolean        do_path,
//                          gpointer        data);

/**
* PangoCairoFontMap:
*
* #PangoCairoFontMap is an interface exported by font maps for
* use with Cairo. The actual type of the font map will depend
* on the particular font technology Cairo was compiled to use.
*
* Since: 1.10
**/

class CairoFontMap : FontMap
{
    mixin GObjectHolder!PangoCairoFontMap;

    package this(PangoCairoFontMap *ptr, Transfer transfer) {
        super(cast(PangoFontMap*)ptr, transfer);
    }

    this() {
        this(cast(PangoCairoFontMap*)pango_cairo_font_map_new(), Transfer.Full);
    }

    this(FontType fonttype) {
        this(cast(PangoCairoFontMap*)pango_cairo_font_map_new_for_font_type(fonttype), Transfer.Full);
    }

    static CairoFontMap getDefault() {
        return getDObject!CairoFontMap(cast(PangoCairoFontMap*)pango_cairo_font_map_get_default(), Transfer.None);
    }

    static void setDefault(CairoFontMap fm) {
        pango_cairo_font_map_set_default(fm.nativePtr);
    }

    override PgContext createContext()
    {
        return getDObject!CairoContext(pango_font_map_create_context(cast(PangoFontMap*)nativePtr), Transfer.Full);
    }

    override Font loadFont(PgContext context, const(FontDescription) desc) {
        return CairoFontFactory.instance.getFont(pango_font_map_load_font(
                                                            cast(PangoFontMap*)nativePtr,
                                                            context.nativePtr,
                                                            desc.nativePtr),
                                   Transfer.Full);
    }

    override FontSet loadFontSet(PgContext context, const(FontDescription) desc, Language language) {
        return CairoFontFactory.instance.getFontSet(pango_font_map_load_fontset(cast(PangoFontMap*)nativePtr,
                                            context.nativePtr, desc.nativePtr, language.nativePtr),
                                      Transfer.Full);
    }

    @property FontType fontType() {
        return pango_cairo_font_map_get_font_type(nativePtr);
    }

    @property double resolution() {
        return pango_cairo_font_map_get_resolution(nativePtr);
    }

    @property void resolution(double dpi) {
        pango_cairo_font_map_set_resolution(nativePtr, dpi);
    }

}



/**
* PangoCairoFont:
*
* #PangoCairoFont is an interface exported by fonts for
* use with Cairo. The actual type of the font will depend
* on the particular font technology Cairo was compiled to use.
*
* Since: 1.18
**/
class CairoFont : Font {

    mixin GObjectHolder!PangoCairoFont;

    package this(PangoCairoFont *ptr, Transfer transfer) {
        super(cast(PangoFont*)ptr, transfer);
    }

    @property ScaledFont scaledFont() {
        auto sf = pango_cairo_font_get_scaled_font(nativePtr);
        cairo_scaled_font_reference(sf);
        return new ScaledFont(sf);
    }

}


/*
 * Update a Pango context for the current state of a cairo context
 */
class CairoContext : PgContext
{
    package this(PangoContext *ptr, Transfer transfer) {
        super(ptr, transfer);
        fontFactory = CairoFontFactory.instance;
    }

    @property void fontOptions(FontOptions options) {
        pango_cairo_context_set_font_options(nativePtr, options.nativePointer);
    }

    @property FontOptions options() {
        auto fo = pango_cairo_context_get_font_options(nativePtr);
        auto foc = cairo_font_options_copy(fo);
        return FontOptions(foc);
    }

    @property double resolution() {
        return  pango_cairo_context_get_resolution(nativePtr);
    }

    @property resolution(double dpi) {
        pango_cairo_context_set_resolution(nativePtr, dpi);
    }

    //void                        pango_cairo_context_set_shape_renderer (PangoContext                *context,
    //                                    PangoCairoShapeRendererFunc  func,
    //                                    gpointer                     data,
    //                                    GDestroyNotify               dnotify);
    //PangoCairoShapeRendererFunc pango_cairo_context_get_shape_renderer (PangoContext                *context,
    //                                    gpointer                    *data);
    //
}



// following complete the definition of cairo.cairo.Context


/*
 * Convenience
 */
PgContext createContext(CrContext cr) {
    return getDObject!CairoContext(pango_cairo_create_context(cr.nativePointer), Transfer.Full);
}

void updatePangoContext(CrContext cr, PgContext context) {
    pango_cairo_update_context(cr.nativePointer, context.nativePtr);
}

Layout createPangoLayout(CrContext cr) {
    return getDObject!Layout(pango_cairo_create_layout(cr.nativePointer), Transfer.Full);
}

void updatePangoLayout(CrContext cr, Layout layout) {
    pango_cairo_update_layout(cr.nativePointer, layout.nativePtr);
}


/*
 * Rendering
 */
void showPangoGlyphString(CrContext cr, Font font, GlyphString glyphs) {
    pango_cairo_show_glyph_string(cr.nativePointer, font.nativePtr, glyphs.nativePtr);
}

void showPangoGlyphItem(CrContext cr, string text, GlyphItem item) {
    pango_cairo_show_glyph_item(cr.nativePointer, toStringz(text), item.nativePtr);
}

void showPangoLayoutLine(CrContext cr, LayoutLine line) {
    pango_cairo_show_layout_line(cr.nativePointer, line.nativePtr);
}

void showPangoLayout(CrContext cr, Layout layout) {
    pango_cairo_show_layout(cr.nativePointer, layout.nativePtr);
}

void showPangoErrorUnderline(CrContext cr, double x, double y, double width, double height) {
    pango_cairo_show_error_underline(cr.nativePointer, x, y, width, height);
}


/*
 * Rendering to a path
 */
void pangoGlyphStringPath(CrContext cr, Font font, GlyphString glyphs) {
    pango_cairo_glyph_string_path(cr.nativePointer, font.nativePtr, glyphs.nativePtr);
}

void pangoLayoutLinePath(CrContext cr, LayoutLine line) {
    pango_cairo_layout_line_path(cr.nativePointer, line.nativePtr);
}

void pangoLayoutPath(CrContext cr, Layout layout) {
    pango_cairo_layout_path(cr.nativePointer, layout.nativePtr);
}

void pangoErrorUnderlinePath(CrContext cr, double x, double y, double width, double height) {
    pango_cairo_error_underline_path(cr.nativePointer, x, y, width, height);
}




class CairoFontFactory : FontFactory
{
    static @property FontFactory instance() {
        static FontFactory inst_;
        if (!inst_) inst_ = new CairoFontFactory;
        return inst_;
    }

    FontMap getFontMap(PangoFontMap *ptr, Transfer transfer) {
        return getDObject!CairoFontMap(cast(PangoCairoFontMap*)ptr, transfer);
    }

    FontSet getFontSet(PangoFontset *ptr, Transfer transfer) {
        auto fs = getDObject!FontSet(ptr, transfer);
        if (fs) fs.fontFactory = this;
        return fs;
    }

    Font getFont(PangoFont *ptr, Transfer transfer) {
        return getDObject!CairoFont(cast(PangoCairoFont*)ptr, transfer);
    }
}


