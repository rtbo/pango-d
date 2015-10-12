/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.context;

import pango.utils;
import pango.font;
import pango.fontmap;
import pango.fontset;
import pango.language;
import pango.gravity;
import pango.bidi_type;
import pango.matrix;
import pango.item;
import pango.attributes;
import pango.c.context;
import pango.c.font;
import pango.c.bidi_type;
import pango.c.gravity;
import pango.c.matrix;

import gobject;
import glib;


class Context : D_GObject
{
    mixin GObjectHolder!PangoContext;
    mixin FontFactoryHolder;

    package this(PangoContext *ptr, Transfer transfer)
    {
        super(cast(GObject*)ptr, transfer);
        fontFactory = defaultFontFactory;
    }

    this()
    {
        super(cast(GObject*)pango_context_new(), Transfer.Full);
        assert(false, "do not create context directly, use FontMap.createContext instead");
    }


    version (Backend) {
        void changed()
        {
            pango_context_changed(nativePtr);
        }
    }


    @property void fontMap(FontMap fm) {
        pango_context_set_font_map(nativePtr, fm.nativePtr);
    }

    @property FontMap fontMap() {
        return fontFactory.getFontMap(pango_context_get_font_map(nativePtr), Transfer.None);
    }

    @property uint serial() {
        return pango_context_get_serial(nativePtr);
    }

    FontFamily[] listFamilies() {
        return listGObjects!(FontFamily, pango_context_list_families)(nativePtr, Transfer.None);
    }


    Font loadFont(const(FontDescription) desc)
    {
        return fontFactory.getFont(pango_context_load_font(nativePtr, desc.nativePtr), Transfer.Full);
    }

    FontSet loadFontSet(const(FontDescription) desc, Language language)
    {
        return fontFactory.getFontSet(pango_context_load_fontset(nativePtr,
                                                             desc.nativePtr,
                                                             language.nativePtr), Transfer.Full);
    }

    FontMetrics metrics(const(FontDescription) desc, Language language)
    {
        return getDObject!FontMetrics(pango_context_get_metrics(nativePtr,
                                                                desc.nativePtr,
                                                                language.nativePtr), Transfer.Full);
    }

    @property
    {
        void fontDescription(const(FontDescription) desc) {
            pango_context_set_font_description(nativePtr, desc.nativePtr);
        }

        FontDescription fontDescription() {
            return getDObject!FontDescription(pango_context_get_font_description(nativePtr), Transfer.None);
        }

        Language language() {
            return Language(pango_context_get_language(nativePtr));
        }

        void language(Language l) {
            pango_context_set_language(nativePtr, l.nativePtr);
        }


        void baseDir(Direction direction) {
            pango_context_set_base_dir(nativePtr, cast(PangoDirection)direction);
        }

        Direction baseDir() {
            return cast(Direction)pango_context_get_base_dir(nativePtr);
        }

        void baseGravity(Gravity gravity) {
            pango_context_set_base_gravity(nativePtr, cast(PangoGravity)gravity);
        }

        Gravity baseGravity() {
            return cast(Gravity)pango_context_get_base_gravity(nativePtr);
        }

        Gravity gravity() {
            return cast(Gravity)pango_context_get_gravity(nativePtr);
        }

        void gravityHint(GravityHint hint) {
            pango_context_set_gravity_hint(nativePtr, cast(PangoGravityHint)hint);
        }

        GravityHint gravityHint() {
            return cast(GravityHint)pango_context_get_gravity_hint(nativePtr);
        }

        void matrix(const(Matrix) matrix) {
            pango_context_set_matrix(nativePtr, matrix.nativePtr);
        }

        const(Matrix) matrix() {
            return Matrix(cast(PangoMatrix*)pango_context_get_matrix(nativePtr));
        }

    }


    /* Break a string of Unicode characters into segments with
    * consistent shaping/language engine and bidrectional level.
    * Returns a #GList of #PangoItem's
    */
    Item[] itemize(string text, AttrList attrs, AttrIterator cachedIter)
    {
        GList *list = pango_itemize(nativePtr, text.ptr, 0, cast(int)text.length,
            attrs.nativePtr, cachedIter.nativePtr);
        scope(exit) g_list_free(list);
        return dobjsFromGList!Item(list, Transfer.Full);
    }


    Item[] itemizeWithBaseDir(Direction direction, string text, AttrList attrs, AttrIterator cachedIter)
    {
        GList *list = pango_itemize_with_base_dir(nativePtr, cast(PangoDirection)direction,
                                                  text.ptr, 0, cast(int)text.length,
                                                  attrs.nativePtr, cachedIter.nativePtr);
        scope(exit) g_list_free(list);
        return dobjsFromGList!Item(list, Transfer.Full);
    }

}
