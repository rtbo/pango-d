/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module pango.tabs;

import pango.utils;
import pango.c.tabs;

import glib;
import gobject;


/**
 * PangoTabAlign:
 * @PANGO_TAB_LEFT: the tab stop appears to the left of the text.
 *
 * A #PangoTabAlign specifies where a tab stop appears relative to the text.
 */
enum TabAlign
{
  Left = PangoTabAlign.PANGO_TAB_LEFT

  /* These are not supported now, but may be in the
   * future.
   *
   *  PANGO_TAB_RIGHT,
   *  PANGO_TAB_CENTER,
   *  PANGO_TAB_NUMERIC
   */
}

struct Tab {
    TabAlign alignment;
    int location;
}


/**
 * PANGO_TYPE_TAB_ARRAY:
 *
 * The #GObject type for #PangoTabArray.
 */
class TabArray
{
    mixin NativePtrHolder!(PangoTabArray, pango_tab_array_free);

    package this (PangoTabArray *ptr, Transfer transfer) {
        initialize(ptr, transfer);
    }

    this(int initialSize, bool positionsInPixels) {
        this(pango_tab_array_new(initialSize, positionsInPixels), Transfer.Full);
    }

    this(Args...)(int size, bool positionsInPixels, Args tabs) {
        this(size, positionsInPixels);

        this.length = tabs.length;
        foreach(i, t; tabs) {
            setTab(i, t);
        }
    }


    TabArray copy() {
        return getDObject!TabArray(pango_tab_array_copy(nativePtr), Transfer.Full);
    }

    @property int length() {
        return pango_tab_array_get_size(nativePtr);
    }

    @property length(int newSize) {
        pango_tab_array_resize(nativePtr, newSize);
    }

    Tab tab(int tabIndex) {
        Tab res;
        pango_tab_array_get_tab(nativePtr, tabIndex, cast(PangoTabAlign*)&res.alignment, &res.location);
        return res;
    }

    void setTab(int tabIndex, Tab tab) {
        pango_tab_array_set_tab(nativePtr, tabIndex, cast(PangoTabAlign)tab.alignment, tab.location);
    }

    @property Tab[] tabs() {
        auto l = length;
        if (!l) return [];

        PangoTabAlign *alignments;
        int *locations;
        pango_tab_array_get_tabs(nativePtr, &alignments, &locations);
        scope(exit) {
            g_free(alignments);
            g_free(locations);
        }

        Tab[] res;
        foreach(i; 0 .. l) {
            res ~= Tab(cast(TabAlign)alignments[i], locations[i]);
        }
        return res;
    }

    @property bool positionsInPixels() {
        return cast(bool)pango_tab_array_get_positions_in_pixels(nativePtr);
    }
}

