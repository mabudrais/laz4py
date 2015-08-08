from TWinControlunit import*
class TCustomComboBox(TWinControl):
    def IntfGetItems(self):
        r=PyMinMod.TCustomComboBoxIntfGetItems(self.pointer)
    def Clear(self):
        r=PyMinMod.TCustomComboBoxClear(self.pointer)
    def ClearSelection(self):
        r=PyMinMod.TCustomComboBoxClearSelection(self.pointer)
    def setDroppedDown(self,a1):
        r=PyMinMod.TCustomComboBoxsetDroppedDown(self.pointer,a1)
    def getDroppedDown(self):
        r=PyMinMod.TCustomComboBoxgetDroppedDown(self.pointer)
        return r
    DroppedDown=property(getDroppedDown,setDroppedDown)
    def SelectAll(self):
        r=PyMinMod.TCustomComboBoxSelectAll(self.pointer)
    def setAutoSelect(self,a1):
        r=PyMinMod.TCustomComboBoxsetAutoSelect(self.pointer,a1)
    def getAutoSelect(self):
        r=PyMinMod.TCustomComboBoxgetAutoSelect(self.pointer)
        return r
    AutoSelect=property(getAutoSelect,setAutoSelect)
    def setAutoSelected(self,a1):
        r=PyMinMod.TCustomComboBoxsetAutoSelected(self.pointer,a1)
    def getAutoSelected(self):
        r=PyMinMod.TCustomComboBoxgetAutoSelected(self.pointer)
        return r
    AutoSelected=property(getAutoSelected,setAutoSelected)
    def setDropDownCount(self,a1):
        r=PyMinMod.TCustomComboBoxsetDropDownCount(self.pointer,a1)
    def getDropDownCount(self):
        r=PyMinMod.TCustomComboBoxgetDropDownCount(self.pointer)
        return r
    DropDownCount=property(getDropDownCount,setDropDownCount)
    def setItemIndex(self,a1):
        r=PyMinMod.TCustomComboBoxsetItemIndex(self.pointer,a1)
    def getItemIndex(self):
        r=PyMinMod.TCustomComboBoxgetItemIndex(self.pointer)
        return r
    ItemIndex=property(getItemIndex,setItemIndex)
    def setReadOnly(self,a1):
        r=PyMinMod.TCustomComboBoxsetReadOnly(self.pointer,a1)
    def getReadOnly(self):
        r=PyMinMod.TCustomComboBoxgetReadOnly(self.pointer)
        return r
    ReadOnly=property(getReadOnly,setReadOnly)
    def setSelLength(self,a1):
        r=PyMinMod.TCustomComboBoxsetSelLength(self.pointer,a1)
    def getSelLength(self):
        r=PyMinMod.TCustomComboBoxgetSelLength(self.pointer)
        return r
    SelLength=property(getSelLength,setSelLength)
    def setSelStart(self,a1):
        r=PyMinMod.TCustomComboBoxsetSelStart(self.pointer,a1)
    def getSelStart(self):
        r=PyMinMod.TCustomComboBoxgetSelStart(self.pointer)
        return r
    SelStart=property(getSelStart,setSelStart)
    def setSelText(self,a1):
        r=PyMinMod.TCustomComboBoxsetSelText(self.pointer,a1)
    def getSelText(self):
        r=PyMinMod.TCustomComboBoxgetSelText(self.pointer)
        return r
    SelText=property(getSelText,setSelText)
