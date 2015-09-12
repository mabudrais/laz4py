import PyMinMod
#import end
#class TMenu start
class TMenu(TLCLComponent):
    def __init__(self):#TMenu
        TLCLComponent.__init__(self)
    def DestroyHandle(self):
        r=PyMinMod.TMenuDestroyHandle(self.pointer)
    def HandleAllocated(self):
        r=PyMinMod.TMenuHandleAllocated(self.pointer)
    def IsRightToLeft(self):
        r=PyMinMod.TMenuIsRightToLeft(self.pointer)
    def UseRightToLeftAlignment(self):
        r=PyMinMod.TMenuUseRightToLeftAlignment(self.pointer)
    def UseRightToLeftReading(self):
        r=PyMinMod.TMenuUseRightToLeftReading(self.pointer)
    def HandleNeeded(self):
        r=PyMinMod.TMenuHandleNeeded(self.pointer)
    def setParent(self,para0):
        r=PyMinMod.TMenusetParent(self.pointer,para0.pointer)
        obj=TComponent()
        obj.pointer=r
        return obj
    def getParent(self):
        r=PyMinMod.TMenugetParent(self.pointer)
        obj=TComponent()
        obj.pointer=r
        return obj
    def setParentBidiMode(self,para0):
        r=PyMinMod.TMenusetParentBidiMode(self.pointer,para0)
        return r
    def getParentBidiMode(self):
        r=PyMinMod.TMenugetParentBidiMode(self.pointer)
        return r
    def getItems(self):
        r=PyMinMod.TMenugetItems(self.pointer)
        obj=TMenuItem()
        obj.pointer=r
        return obj
#class TMenu end
#class TPopupMenu start
class TPopupMenu(TMenu):
    def __init__(self):#TPopupMenu
        self.OnClosehandler=-1
        self.OnPopuphandler=-1
        TMenu.__init__(self)
    def PopUp(self):
        r=PyMinMod.TPopupMenuPopUp(self.pointer)
    def setPopupComponent(self,para0):
        r=PyMinMod.TPopupMenusetPopupComponent(self.pointer,para0.pointer)
        obj=TComponent()
        obj.pointer=r
        return obj
    def getPopupComponent(self):
        r=PyMinMod.TPopupMenugetPopupComponent(self.pointer)
        obj=TComponent()
        obj.pointer=r
        return obj
    def setAutoPopup(self,para0):
        r=PyMinMod.TPopupMenusetAutoPopup(self.pointer,para0)
        return r
    def getAutoPopup(self):
        r=PyMinMod.TPopupMenugetAutoPopup(self.pointer)
        return r
    def setOnPopup(self,handler):
        self.OnPopuphandler=PyMinMod.TPopupMenusetOnPopup(handler,self.pointer,self.OnPopuphandler)
    def setOnClose(self,handler):
        self.OnClosehandler=PyMinMod.TPopupMenusetOnClose(handler,self.pointer,self.OnClosehandler)
#class TPopupMenu end
#class TMenuItem start
class TMenuItem(TLCLComponent):
    def __init__(self):#TMenuItem
        self.OnClickhandler=-1
        TLCLComponent.__init__(self)
    def Find(self,ACaption):
        r=PyMinMod.TMenuItemFind(self.pointer,ACaption)
    def GetParentComponent(self):
        r=PyMinMod.TMenuItemGetParentComponent(self.pointer)
    def GetParentMenu(self):
        r=PyMinMod.TMenuItemGetParentMenu(self.pointer)
    def GetIsRightToLeft(self):
        r=PyMinMod.TMenuItemGetIsRightToLeft(self.pointer)
    def HandleAllocated(self):
        r=PyMinMod.TMenuItemHandleAllocated(self.pointer)
    def HasIcon(self):
        r=PyMinMod.TMenuItemHasIcon(self.pointer)
    def HasParent(self):
        r=PyMinMod.TMenuItemHasParent(self.pointer)
    def InitiateAction(self):
        r=PyMinMod.TMenuItemInitiateAction(self.pointer)
    def IntfDoSelect(self):
        r=PyMinMod.TMenuItemIntfDoSelect(self.pointer)
    def IndexOf(self,Item):
        r=PyMinMod.TMenuItemIndexOf(self.pointer,Item.pointer)
    def IndexOfCaption(self,ACaption):
        r=PyMinMod.TMenuItemIndexOfCaption(self.pointer,ACaption)
    def VisibleIndexOf(self,Item):
        r=PyMinMod.TMenuItemVisibleIndexOf(self.pointer,Item.pointer)
    def Add(self,Item):
        r=PyMinMod.TMenuItemAdd(self.pointer,Item.pointer)
    def AddSeparator(self):
        r=PyMinMod.TMenuItemAddSeparator(self.pointer)
    def Click(self):
        r=PyMinMod.TMenuItemClick(self.pointer)
    def Delete(self,Index):
        r=PyMinMod.TMenuItemDelete(self.pointer,Index)
    def HandleNeeded(self):
        r=PyMinMod.TMenuItemHandleNeeded(self.pointer)
    def Insert(self,Index,Item):
        r=PyMinMod.TMenuItemInsert(self.pointer,Index,Item.pointer)
    def RecreateHandle(self):
        r=PyMinMod.TMenuItemRecreateHandle(self.pointer)
    def Remove(self,Item):
        r=PyMinMod.TMenuItemRemove(self.pointer,Item.pointer)
    def IsCheckItem(self):
        r=PyMinMod.TMenuItemIsCheckItem(self.pointer)
    def IsLine(self):
        r=PyMinMod.TMenuItemIsLine(self.pointer)
    def IsInMenuBar(self):
        r=PyMinMod.TMenuItemIsInMenuBar(self.pointer)
    def Clear(self):
        r=PyMinMod.TMenuItemClear(self.pointer)
    def HasBitmap(self):
        r=PyMinMod.TMenuItemHasBitmap(self.pointer)
    def RemoveAllHandlersOfObject(self,AnObject):
        r=PyMinMod.TMenuItemRemoveAllHandlersOfObject(self.pointer,AnObject.pointer)
    def getCount(self):
        r=PyMinMod.TMenuItemgetCount(self.pointer)
        return r
    def getItems(self,indexedpara0):
        r=PyMinMod.TMenuItemgetItems(self.pointer,indexedpara0)
        obj=TMenuItem()
        obj.pointer=r
        return obj
    def setMenuIndex(self,para0):
        r=PyMinMod.TMenuItemsetMenuIndex(self.pointer,para0)
        return r
    def getMenuIndex(self):
        r=PyMinMod.TMenuItemgetMenuIndex(self.pointer)
        return r
    def getMenu(self):
        r=PyMinMod.TMenuItemgetMenu(self.pointer)
        obj=TMenu()
        obj.pointer=r
        return obj
    def getParent(self):
        r=PyMinMod.TMenuItemgetParent(self.pointer)
        obj=TMenuItem()
        obj.pointer=r
        return obj
    def MenuVisibleIndex(self):
        r=PyMinMod.TMenuItemMenuVisibleIndex(self.pointer)
    def setAutoCheck(self,para0):
        r=PyMinMod.TMenuItemsetAutoCheck(self.pointer,para0)
        return r
    def getAutoCheck(self):
        r=PyMinMod.TMenuItemgetAutoCheck(self.pointer)
        return r
    def setDefault(self,para0):
        r=PyMinMod.TMenuItemsetDefault(self.pointer,para0)
        return r
    def getDefault(self):
        r=PyMinMod.TMenuItemgetDefault(self.pointer)
        return r
    def setRadioItem(self,para0):
        r=PyMinMod.TMenuItemsetRadioItem(self.pointer,para0)
        return r
    def getRadioItem(self):
        r=PyMinMod.TMenuItemgetRadioItem(self.pointer)
        return r
    def setRightJustify(self,para0):
        r=PyMinMod.TMenuItemsetRightJustify(self.pointer,para0)
        return r
    def getRightJustify(self):
        r=PyMinMod.TMenuItemgetRightJustify(self.pointer)
        return r
    def setOnClick(self,handler):
        self.OnClickhandler=PyMinMod.TMenuItemsetOnClick(handler,self.pointer,self.OnClickhandler)
#class TMenuItem end
#class TMainMenu start
class TMainMenu(TMenu):
    def __init__(self):#TMainMenu
        TMenu.__init__(self)
    def Create(self,AOwner):
        r=PyMinMod.TMainMenuCreate(self.pointer,AOwner.pointer)
        obj=TMainMenu()
        obj.pointer=r
        return obj
    def getHeight(self):
        r=PyMinMod.TMainMenugetHeight(self.pointer)
        return r
#class TMainMenu end
