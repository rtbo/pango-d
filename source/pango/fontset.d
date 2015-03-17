/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.fontset;

import pango.utils;
import pango.font;
import pango.c.font;
import pango.c.fontset;

import gobject;
import glib;


/**
* PangoFontset:
*
* A #PangoFontset represents a set of #PangoFont to use
* when rendering text. It is the result of resolving a
* #PangoFontDescription against a particular #PangoContext.
* It has operations for finding the component font for
* a particular Unicode character, and for finding a composite
* set of metrics for the entire fontset.
*/
 class FontSet : D_GObject
{
    mixin GObjectHolder!PangoFontset;
    mixin FontFactoryHolder;

    package this(PangoFontset *ptr, Transfer transfer)
    {
        super(cast(GObject*)ptr, transfer);
        fontFactory = defaultFontFactory;
    }

    Font font(uint wc) {
        return fontFactory.getFont(pango_fontset_get_font(nativePtr, wc), Transfer.Full);
    }

    @property FontMetrics metrics() {
        return getDObject!FontMetrics(pango_fontset_get_metrics(nativePtr), Transfer.Full);
    }


    int opApply(int delegate(ref Font font) dg)
    {
        auto fd = ForeachData(dg, fontFactory);
        pango_fontset_foreach(nativePtr, &foreachApplyCb, &fd);
        return fd.res;
    }

}


private
{
    alias ForeachDelegate = int delegate(ref Font font);

    struct ForeachData
    {
        int res = 0;
        ForeachDelegate dg;
        FontFactory fontFactory;

        @disable this();

        this (ForeachDelegate dg, FontFactory fontFactory) {
            this.dg = dg;
            this.fontFactory = fontFactory;
        }
    }

    extern (C)
    private gboolean foreachApplyCb(PangoFontset* fontset, PangoFont *font, gpointer userData)
    {
        ForeachData *fd = cast(ForeachData*)userData;
        auto dg = fd.dg;
        auto f = fd.fontFactory.getFont(font, Transfer.None);
        fd.res = dg(f);
        if (fd.res) return TRUE;
        else return FALSE;
    }

}
