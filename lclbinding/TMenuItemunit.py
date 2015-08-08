from TLCLComponentunit import*
class TMenuItem(TLCLComponent):
    def GetIsRightToLeft(self):
        r=PyMinMod.TMenuItemGetIsRightToLeft(self.pointer)
        return r
    def HandleAllocated(self):
        r=PyMinMod.TMenuItemHandleAllocated(self.pointer)
        return r
    def HasIcon(self):
        r=PyMinMod.TMenuItemHasIcon(self.pointer)
        return r
    def HasParent(self):
        r=PyMinMod.TMenuItemHasParent(self.pointer)
        return r
    def InitiateAction(self):
        r=PyMinMod.TMenuItemInitiateAction(self.pointer)
    def IntfDoSelect(self):
        r=PyMinMod.TMenuItemIntfDoSelect(self.pointer)
    def IndexOfCaption(self,ACaption):
        r=PyMinMod.TMenuItemIndexOfCaption(self.pointer,ACaption)
        return r
    def AddSeparator(self):
        r=PyMinMod.TMenuItemAddSeparator(self.pointer)
    def Click(self):
        r=PyMinMod.TMenuItemClick(self.pointer)
    def Delete(self,Index):
        r=PyMinMod.TMenuItemDelete(self.pointer,Index)
    def HandleNeeded(self):
        r=PyMinMod.TMenuItemHandleNeeded(self.pointer)
    def RecreateHandle(self):
        r=PyMinMod.TMenuItemRecreateHandle(self.pointer)
    def IsCheckItem(self):
        r=PyMinMod.TMenuItemIsCheckItem(self.pointer)
        return r
    def IsLine(self):
        r=PyMinMod.TMenuItemIsLine(self.pointer)
        return r
    def IsInMenuBar(self):
        r=PyMinMod.TMenuItemIsInMenuBar(self.pointer)
        return r
    def Clear(self):
        r=PyMinMod.TMenuItemClear(self.pointer)
    def HasBitmap(self):
        r=PyMinMod.TMenuItemHasBitmap(self.pointer)
        return r
    def getCount(self):
        r=PyMinMod.TMenuItemgetCount(self.pointer)
        return r
    def setMenuIndex(self,a1):
        r=PyMinMod.TMenuItemsetMenuIndex(self.pointer,a1)
    def getMenuIndex(self):
        r=PyMinMod.TMenuItemgetMenuIndex(self.pointer)
        return r
    MenuIndex=property(getMenuIndex,setMenuIndex)
    def MenuVisibleIndex(self):
        r=PyMinMod.TMenuItemMenuVisibleIndex(self.pointer)
        return r
    def setAutoCheck(self,a1):
        r=PyMinMod.TMenuItemsetAutoCheck(self.pointer,a1)
    def getAutoCheck(self):
        r=PyMinMod.TMenuItemgetAutoCheck(self.pointer)
        return r
    AutoCheck=property(getAutoCheck,setAutoCheck)
    def setDefault(self,a1):
        r=PyMinMod.TMenuItemsetDefault(self.pointer,a1)
    def getDefault(self):
        r=PyMinMod.TMenuItemgetDefault(self.pointer)
        return r
    Default=property(getDefault,setDefault)
    def setRadioItem(self,a1):
        r=PyMinMod.TMenuItemsetRadioItem(self.pointer,a1)
    def getRadioItem(self):
        r=PyMinMod.TMenuItemgetRadioItem(self.pointer)
        return r
    RadioItem=property(getRadioItem,setRadioItem)
    def setRightJustify(self,a1):
        r=PyMinMod.TMenuItemsetRightJustify(self.pointer,a1)
    def getRightJustify(self):
        r=PyMinMod.TMenuItemgetRightJustify(self.pointer)
        return r
    RightJustify=property(getRightJustify,setRightJustify)
    def setOnClick(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
