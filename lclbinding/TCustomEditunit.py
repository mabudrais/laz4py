from TWinControlunit import*
class TCustomEdit(TWinControl):
    def Clear(self):
        r=PyMinMod.TCustomEditClear(self.pointer)
    def SelectAll(self):
        r=PyMinMod.TCustomEditSelectAll(self.pointer)
    def ClearSelection(self):
        r=PyMinMod.TCustomEditClearSelection(self.pointer)
    def CopyToClipboard(self):
        r=PyMinMod.TCustomEditCopyToClipboard(self.pointer)
    def CutToClipboard(self):
        r=PyMinMod.TCustomEditCutToClipboard(self.pointer)
    def PasteFromClipboard(self):
        r=PyMinMod.TCustomEditPasteFromClipboard(self.pointer)
    def getCanUndo(self):
        r=PyMinMod.TCustomEditgetCanUndo(self.pointer)
        return r
    def setHideSelection(self,a1):
        r=PyMinMod.TCustomEditsetHideSelection(self.pointer,a1)
    def getHideSelection(self):
        r=PyMinMod.TCustomEditgetHideSelection(self.pointer)
        return r
    HideSelection=property(getHideSelection,setHideSelection)
    def setMaxLength(self,a1):
        r=PyMinMod.TCustomEditsetMaxLength(self.pointer,a1)
    def getMaxLength(self):
        r=PyMinMod.TCustomEditgetMaxLength(self.pointer)
        return r
    MaxLength=property(getMaxLength,setMaxLength)
    def setModified(self,a1):
        r=PyMinMod.TCustomEditsetModified(self.pointer,a1)
    def getModified(self):
        r=PyMinMod.TCustomEditgetModified(self.pointer)
        return r
    Modified=property(getModified,setModified)
    def setNumbersOnly(self,a1):
        r=PyMinMod.TCustomEditsetNumbersOnly(self.pointer,a1)
    def getNumbersOnly(self):
        r=PyMinMod.TCustomEditgetNumbersOnly(self.pointer)
        return r
    NumbersOnly=property(getNumbersOnly,setNumbersOnly)
    def setOnChange(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setReadOnly(self,a1):
        r=PyMinMod.TCustomEditsetReadOnly(self.pointer,a1)
    def getReadOnly(self):
        r=PyMinMod.TCustomEditgetReadOnly(self.pointer)
        return r
    ReadOnly=property(getReadOnly,setReadOnly)
    def setSelLength(self,a1):
        r=PyMinMod.TCustomEditsetSelLength(self.pointer,a1)
    def getSelLength(self):
        r=PyMinMod.TCustomEditgetSelLength(self.pointer)
        return r
    SelLength=property(getSelLength,setSelLength)
    def setSelStart(self,a1):
        r=PyMinMod.TCustomEditsetSelStart(self.pointer,a1)
    def getSelStart(self):
        r=PyMinMod.TCustomEditgetSelStart(self.pointer)
        return r
    SelStart=property(getSelStart,setSelStart)
    def setSelText(self,a1):
        r=PyMinMod.TCustomEditsetSelText(self.pointer,a1)
    def getSelText(self):
        r=PyMinMod.TCustomEditgetSelText(self.pointer)
        return r
    SelText=property(getSelText,setSelText)
