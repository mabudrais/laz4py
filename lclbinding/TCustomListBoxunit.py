from TWinControlunit import*
class TCustomListBox(TWinControl):
    def Click(self):
        r=PyMinMod.TCustomListBoxClick(self.pointer)
    def Clear(self):
        r=PyMinMod.TCustomListBoxClear(self.pointer)
    def ClearSelection(self):
        r=PyMinMod.TCustomListBoxClearSelection(self.pointer)
    def GetIndexAtXY(self,Y,X):
        r=PyMinMod.TCustomListBoxGetIndexAtXY(self.pointer,Y,X)
        return r
    def GetIndexAtY(self,Y):
        r=PyMinMod.TCustomListBoxGetIndexAtY(self.pointer,Y)
        return r
    def GetSelectedText(self):
        r=PyMinMod.TCustomListBoxGetSelectedText(self.pointer)
        return r
    def ItemVisible(self,Index):
        r=PyMinMod.TCustomListBoxItemVisible(self.pointer,Index)
        return r
    def ItemFullyVisible(self,Index):
        r=PyMinMod.TCustomListBoxItemFullyVisible(self.pointer,Index)
        return r
    def LockSelectionChange(self):
        r=PyMinMod.TCustomListBoxLockSelectionChange(self.pointer)
    def MakeCurrentVisible(self):
        r=PyMinMod.TCustomListBoxMakeCurrentVisible(self.pointer)
    def MeasureItem(self,TheHeight,Index):
        r=PyMinMod.TCustomListBoxMeasureItem(self.pointer,TheHeight,Index)
    def SelectAll(self):
        r=PyMinMod.TCustomListBoxSelectAll(self.pointer)
    def setColumns(self,a1):
        r=PyMinMod.TCustomListBoxsetColumns(self.pointer,a1)
    def getColumns(self):
        r=PyMinMod.TCustomListBoxgetColumns(self.pointer)
        return r
    Columns=property(getColumns,setColumns)
    def getCount(self):
        r=PyMinMod.TCustomListBoxgetCount(self.pointer)
        return r
    def setExtendedSelect(self,a1):
        r=PyMinMod.TCustomListBoxsetExtendedSelect(self.pointer,a1)
    def getExtendedSelect(self):
        r=PyMinMod.TCustomListBoxgetExtendedSelect(self.pointer)
        return r
    ExtendedSelect=property(getExtendedSelect,setExtendedSelect)
    def setIntegralHeight(self,a1):
        r=PyMinMod.TCustomListBoxsetIntegralHeight(self.pointer,a1)
    def getIntegralHeight(self):
        r=PyMinMod.TCustomListBoxgetIntegralHeight(self.pointer)
        return r
    IntegralHeight=property(getIntegralHeight,setIntegralHeight)
    def setItemHeight(self,a1):
        r=PyMinMod.TCustomListBoxsetItemHeight(self.pointer,a1)
    def getItemHeight(self):
        r=PyMinMod.TCustomListBoxgetItemHeight(self.pointer)
        return r
    ItemHeight=property(getItemHeight,setItemHeight)
    def setItemIndex(self,a1):
        r=PyMinMod.TCustomListBoxsetItemIndex(self.pointer,a1)
    def getItemIndex(self):
        r=PyMinMod.TCustomListBoxgetItemIndex(self.pointer)
        return r
    ItemIndex=property(getItemIndex,setItemIndex)
    def setMultiSelect(self,a1):
        r=PyMinMod.TCustomListBoxsetMultiSelect(self.pointer,a1)
    def getMultiSelect(self):
        r=PyMinMod.TCustomListBoxgetMultiSelect(self.pointer)
        return r
    MultiSelect=property(getMultiSelect,setMultiSelect)
    def setScrollWidth(self,a1):
        r=PyMinMod.TCustomListBoxsetScrollWidth(self.pointer,a1)
    def getScrollWidth(self):
        r=PyMinMod.TCustomListBoxgetScrollWidth(self.pointer)
        return r
    ScrollWidth=property(getScrollWidth,setScrollWidth)
    def getSelCount(self):
        r=PyMinMod.TCustomListBoxgetSelCount(self.pointer)
        return r
    def setSorted(self,a1):
        r=PyMinMod.TCustomListBoxsetSorted(self.pointer,a1)
    def getSorted(self):
        r=PyMinMod.TCustomListBoxgetSorted(self.pointer)
        return r
    Sorted=property(getSorted,setSorted)
    def setTopIndex(self,a1):
        r=PyMinMod.TCustomListBoxsetTopIndex(self.pointer,a1)
    def getTopIndex(self):
        r=PyMinMod.TCustomListBoxgetTopIndex(self.pointer)
        return r
    TopIndex=property(getTopIndex,setTopIndex)
