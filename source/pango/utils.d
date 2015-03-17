module pango.utils;

import glib;
import gobject;

import std.traits;
import std.conv;
import std.string;
import std.range;
import core.memory;


package enum Transfer {
    Full,
    None,
}


private GQuark gobjAssocQuark;

static this() {
    gobjAssocQuark = g_quark_from_string(toStringz("D_GObject"));
}



DObjT getDObject(DObjT, GObjT)(GObjT * obj, Transfer transfer)
{
    static if ( is(DObjT : D_GObject) )
    {
        if (!obj) return null;

        auto p = g_object_get_qdata(cast(GObject*)obj, gobjAssocQuark);
        if (p) return cast(DObjT)(cast(D_GObject)p);
        return new DObjT(obj, transfer);
    }
    else static if ( is(DObjT == class) )
    {
        if (!obj) return null;

        return new DObjT(obj, transfer);
    }
    else
    {
        if (!obj) throw new Exception("tentative to construct obj from null ptr");

        return DObjT(obj, transfer);
    }
}


D_GObject getExistingDObject(GObjT, bool ThrowErrorIfNot=true) (GObjT * obj, Transfer transfer)
{
    if (!obj) return null;

    auto p = g_object_get_qdata(cast(GObject*)obj, gobjAssocQuark);
    if (!p) {
        static if (ThrowErrorIfNot) throw new Error("could not retrieve \"existing\" object");
        else return null;
    }
    return cast(D_GObject)p;
    
}


abstract class D_GObject
{
    private GObject *gobjPtr_;
    private bool isGCProtected;

    protected inout(GObject)* gobjPtr() inout { return gobjPtr_; }


    protected this(GObject* ptr, Transfer transfer) {
        gobjPtr_ = ptr;
        if (transfer == Transfer.None) g_object_ref(gobjPtr_);
        
        g_object_set_qdata_full(gobjPtr_, gobjAssocQuark,
                               cast(gpointer)this, &destroyNotification);
        g_object_add_toggle_ref(gobjPtr_, &toggleNotification, cast(gpointer)this);

        if (gobjPtr_.ref_count > 1) protectFromGC();
    }


    ~this() {
        g_object_steal_qdata(gobjPtr_, gobjAssocQuark);
        exposeToGC();
        g_object_unref(gobjPtr_);
    }

    invariant() {
        assert(gobjPtr_ !is null);
    }


    private
    {

        void protectFromGC() {
            if (!isGCProtected) {
                GC.addRoot(cast(void*)this);
                GC.setAttr(cast(void*)this, GC.BlkAttr.NO_MOVE);
                isGCProtected = true;
            }
        }

        void exposeToGC() {
            if (isGCProtected) {
                GC.removeRoot(cast(void*)this);
                GC.clrAttr(cast(void*)this, GC.BlkAttr.NO_MOVE);
                isGCProtected = false;
            }
        }
    }
}


mixin template GObjectHolder(GDerivedT)
{
    alias NativePtrT = GDerivedT*;

    @property inout(GDerivedT)* nativePtr() inout { return cast(inout(GDerivedT)*) gobjPtr; }
}


private {

    extern (C)
    void toggleNotification(gpointer data,
                            GObject *object,
                            gboolean is_last_ref)
    {
        D_GObject obj = cast(D_GObject)data;
        if (is_last_ref) {
            obj.exposeToGC();
        }
        else {
            obj.protectFromGC();
        }
    }


    extern (C)
        void destroyNotification(gpointer data) {
            D_GObject obj = cast(D_GObject)data;
            obj.exposeToGC();
    }

}



mixin template NativePtrHolder(PangoCType, alias FreeFunc)
{
    private {
        PangoCType *nativePtr_;
        Transfer transfer_;
        
        void initialize(PangoCType *ptr, Transfer transfer) {
            nativePtr_ = ptr;
            transfer_ = transfer;
        }

        invariant() {
            assert(nativePtr_ !is null);
        }
    }

    alias NativePtrT = PangoCType*;

    ~this() {
        if (transfer_ == Transfer.Full) FreeFunc(nativePtr_);
    }

    pure @property inout(PangoCType)* nativePtr() inout { return nativePtr_; }

}


mixin template RefCountThat(PangoCType, alias FreeFunc)
{
    import std.typecons;

    private {

        struct Payload
        {
            PangoCType *_payload;

            this(PangoCType *ptr)
            {
                _payload = ptr;
            }
            ~this()
            {
                if(_payload)
                {
                    FreeFunc(_payload);
                    _payload = null;
                }
            }

            @disable this(this);
        }

        alias Data = RefCounted!Payload;
        Data data_;

        void initialize(PangoCType *ptr, Transfer transfer) {
            data_ = Data(ptr);
            assert(transfer == Transfer.Full);
        }
    }

    public alias NativePtrT = PangoCType*;

    public @property inout(PangoCType) *nativePtr() inout {
        return data_.payload_;
    }
}




mixin template RefCountedGObj(GObjT, string prefix)
{
    alias NativePtrT = GObjT*;

    private GObjT* nativePtr_;


    private void initialize(GObjT* ptr, Transfer transfer) {
        nativePtr_ = ptr;
        if (transfer != Transfer.Full) {
            reference();
        }
    }
    
    pure @property inout(GObjT)* nativePtr() inout { return nativePtr_; }


    private void reference() {
        mixin(prefix ~ "_ref(nativePtr_);");
    }
    
    private void unreference() {
        mixin(prefix ~ "_unref(nativePtr_);");
    }

    @disable this();


    this(this) {
        reference();
    }

    ~this() {
        unreference();
    }

    invariant() {
        assert(nativePtr_ !is null);
    }
}



template listGObjects(ObjT, alias ListFun) // if (__traits(hasMember, ObjT, "nativePtr_"))
{
    ObjT[] listGObjects(CollecT)(CollecT* ptr, Transfer transfer)
    {
        ObjT.NativePtrT *arr;
        int n;
        ListFun(ptr, &arr, &n);
        scope(exit) g_free(arr);

        if (!n) return [];

        ObjT[] res;
        foreach(i; 0 .. n) {
            res ~= getDObject!ObjT(arr[i], transfer);
        }

        return res;
    }
}


template listValues(T, alias ListFun)
{
    T[] listValues(CollecT)(CollecT* ptr)
    {
        T *arr;
        int n;
        ListFun(ptr, &arr, &n);
        scope(exit) g_free(arr);

        if (!n) return [];

        return arr[0 .. n].dup;
    }
}



GList *objsToGList(ObjT)(ObjT[] objs) if (is(ObjT == class) || isPointer!ObjT ||
                                          (ObjT.sizeof == gpointer.sizeof && isIntegral!ObjT))
{
    GList *res;
    foreach (obj; objs) {
        res = g_list_append(res, cast(gpointer)obj);
    }
    return res;
}


ObjT[] objsFromGList(ObjT)(GList *list) if (is(ObjT == class) || isPointer!ObjT ||
                                            (ObjT.sizeof == gpointer.sizeof && isIntegral!ObjT))
{
    ObjT[] res;
    while (list !is null) {
        res ~= cast(ObjT)list.data;
        list = list.next;
    }
    return res;
}

GSList *objsToGSList(ObjT)(ObjT[] objs) if (is(ObjT == class) || isPointer!ObjT ||
                                          (ObjT.sizeof == gpointer.sizeof && isIntegral!ObjT))
{
    GSList *res;
    foreach (obj; objs) {
        res = g_slist_append(res, cast(gpointer)obj);
    }
    return res;
}


ObjT[] objsFromGSList(ObjT)(GSList *list) if (is(ObjT == class) || isPointer!ObjT ||
                                            (ObjT.sizeof == gpointer.sizeof && isIntegral!ObjT))
{
    ObjT[] res;
    while (list !is null) {
        res ~= cast(ObjT)list.data;
        list = list.next;
    }
    return res;
}



DObjT[] dobjsFromGList(DObjT)(GList *list, Transfer transfer) if (__traits(hasMember, DObjT, "nativePtr"))
{
    DObjT[] res;
    while (list !is null) {
        res ~= getDObject!DObjT(cast(DObjT.NativePtrT)list.data, transfer);
        list = list.next;
    }
    return res;
}



GList *dobjsToGList(DObjT)(DObjT[] dobjs) if (__traits(hasMember, DObjT, "nativePtr"))
{
    GList *res;
    foreach (dobj; dobjs) {
        res = g_list_append(res, cast(gpointer)dobj.nativePtr);
    }
    return res;
}



DObjT[] dobjsFromGSList(DObjT)(GSList *list, Transfer transfer) if (__traits(hasMember, DObjT, "nativePtr"))
{
    DObjT[] res;
    while (list !is null) {
        res ~= getDObject!DObjT(cast(DObjT.NativePtrT)list.data, transfer);
        list = list.next;
    }
    return res;
}



GList *dobjsToGSList(DObjT)(DObjT[] dobjs) if (__traits(hasMember, DObjT, "nativePtr"))
{
    GSList *res;
    foreach (dobj; dobjs) {
        res = g_slist_append(res, cast(gpointer)dobj.nativePtr);
    }
    return res;
}




// FIXME: finish impl
//struct GListGObjProxy(ObjT)
//{
//    private alias GObjPtrT = ObjT.NativePtrT;
//
//    private GList *listPtr_ =null;
//
//    package this (GList *ptr) {
//        listPtr_ = ptr;
//    }
//
//    @property inout(GList)* listPtr() inout { return listPtr_; }
//
//
//    void free() {
//        g_list_free(listPtr_);
//    }
//    
//    void free1() {
//        g_list_free_1(listPtr_);
//    }
//
//    //void freeFull() if (is (ObjT : D_GObject))
//    //{
//    //    g_list_free_full(list, &g_object_unref);
//    //}
//
//    void freeFull(GDestroyNotify freeFunc) {
//        g_list_free_full(list, freeFunc);
//    }
//
//    void append(ObjT obj) {
//        listPtr_ = g_list_append(listPtr_, obj.nativePtr);
//    }
//
//    void prepend(ObjT obj) {
//        listPtr_ = g_list_prepend(listPtr_, obj.nativePtr);
//    }
//
//    void insert(ObjT obj, int position) {
//        listPtr_ = g_list_insert(listPtr_, obj.nativePtr, position);
//    }
//
//
//    //GList*   g_list_insert_sorted           (GList            *list,
//    //                                         gpointer          data,
//    //                                         GCompareFunc      func);
//    //
//    //GList*   g_list_insert_sorted_with_data (GList            *list,
//    //                                         gpointer          data,
//    //                                         GCompareDataFunc  func,
//    //                                         gpointer          user_data);
//    //
//    //GList*   g_list_insert_before           (GList            *list,
//    //                                         GList            *sibling,
//    //                                         gpointer          data);
//    //
//    //GList*   g_list_concat                  (GList            *list1,
//    //                                         GList            *list2);
//    //
//    //GList*   g_list_remove                  (GList            *list,
//    //                                         gconstpointer     data);
//    //
//    //GList*   g_list_remove_all              (GList            *list,
//    //                                         gconstpointer     data);
//    //
//    //GList*   g_list_remove_link             (GList            *list,
//    //                                         GList            *llink);
//    //
//    //GList*   g_list_delete_link             (GList            *list,
//    //                                         GList            *link_);
//    //
//    //GList*   g_list_reverse                 (GList            *list);
//    //
//    //GList*   g_list_copy                    (GList            *list);
//    //
//    //
//    //GList*   g_list_copy_deep               (GList            *list,
//    //                                         GCopyFunc         func,
//    //                                         gpointer          user_data);
//    //
//    //
//    //GList*   g_list_nth                     (GList            *list,
//    //                                         guint             n);
//    //
//    //GList*   g_list_nth_prev                (GList            *list,
//    //                                         guint             n);
//    //
//    //GList*   g_list_find                    (GList            *list,
//    //                                         gconstpointer     data);
//    //
//    //GList*   g_list_find_custom             (GList            *list,
//    //                                         gconstpointer     data,
//    //                                         GCompareFunc      func);
//    //
//    //gint     g_list_position                (GList            *list,
//    //                                         GList            *llink);
//    //
//    //gint     g_list_index                   (GList            *list,
//    //                                         gconstpointer     data);
//    //
//    //GList*   g_list_last                    (GList            *list);
//    //
//    //GList*   g_list_first                   (GList            *list);
//    //
//    //guint    g_list_length                  (GList            *list);
//    
//    //int opApply(int delegate(ref ObjT obj) dg) {
//    //    ApplyFuncData d;
//    //    d.dg = dg;
//    //    g_list_foreach(listPtr_, &applyFunc, &d);
//    //    return d.res;
//    //}
//    //
//    //private {
//    //    struct ApplyFuncData {
//    //        int res;
//    //        int delegate(ref ObjT obj) dg;
//    //    }
//    //    extern(C) static void applyFunc(gpointer data, gointer userData) {
//    //        ApplyFuncData *d = cast(ApplyFuncData*)userData;
//    //        if (d.res) return;
//    //
//    //        GObjPtrT gobj = cast(GObjPtrT)data;
//    //        if (!gobj) return;
//    //        GObjT obj = getDObject!GObjT(gobj);
//    //        d.res = d.dg(obj);
//    //    }
//    //}
//
//    //void     g_list_foreach                 (GList            *list,
//    //                                         GFunc             func,
//    //                                         gpointer          user_data);
//    //
//    //GList*   g_list_sort                    (GList            *list,
//    //                                         GCompareFunc      compare_func);
//    //
//    //GList*   g_list_sort_with_data          (GList            *list,
//    //                                         GCompareDataFunc  compare_func,
//    //                                         gpointer          user_data);
//    //
//    //gpointer g_list_nth_data                (GList            *list,
//    //                                         guint             n);
//
//}
