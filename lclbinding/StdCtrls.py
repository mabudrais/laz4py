import PyMinMod
from Controls import*
from classesh import*
#import end
#class TButtonControl start
class TButtonControl(TWinControl):
    def __init__(self):#TButtonControl
        TWinControl.__init__(self)
    def Create(self,TheOwner):
        r=PyMinMod.TButtonControlCreate(self.pointer,TheOwner.pointer)
        obj=TButtonControl()
        obj.pointer=r
        return obj
#class TButtonControl end

#class TCustomScrollBar start
class TCustomScrollBar(TWinControl):
    def __init__(self):#TCustomScrollBar
        self.OnChangehandler=-1
        TWinControl.__init__(self)
    def Create(self,AOwner):
        r=PyMinMod.TCustomScrollBarCreate(self.pointer,AOwner.pointer)
        obj=TCustomScrollBar()
        obj.pointer=r
        return obj
    def SetParams(self,APosition,AMin,AMax,APageSize):
        r=PyMinMod.TCustomScrollBarSetParams(self.pointer,APosition,AMin,AMax,APageSize)
    def setMax(self,para0):
        r=PyMinMod.TCustomScrollBarsetMax(self.pointer,para0)
        return r
    def getMax(self):
        r=PyMinMod.TCustomScrollBargetMax(self.pointer)
        return r
    def setMin(self,para0):
        r=PyMinMod.TCustomScrollBarsetMin(self.pointer,para0)
        return r
    def getMin(self):
        r=PyMinMod.TCustomScrollBargetMin(self.pointer)
        return r
    def setPageSize(self,para0):
        r=PyMinMod.TCustomScrollBarsetPageSize(self.pointer,para0)
        return r
    def getPageSize(self):
        r=PyMinMod.TCustomScrollBargetPageSize(self.pointer)
        return r
    def setPosition(self,para0):
        r=PyMinMod.TCustomScrollBarsetPosition(self.pointer,para0)
        return r
    def getPosition(self):
        r=PyMinMod.TCustomScrollBargetPosition(self.pointer)
        return r
    def setOnChange(self,handler):
        self.OnChangehandler=PyMinMod.TCustomScrollBarsetOnChange(handler,self.pointer,self.OnChangehandler)
#class TCustomScrollBar end
#class TCustomComboBox start
class TCustomComboBox(TWinControl):
    def __init__(self):#TCustomComboBox
        TWinControl.__init__(self)
    def IntfGetItems(self):
        r=PyMinMod.TCustomComboBoxIntfGetItems(self.pointer)
    def AddItem(self,Item,AnObject):
        r=PyMinMod.TCustomComboBoxAddItem(self.pointer,Item,AnObject.pointer)
    def Clear(self):
        r=PyMinMod.TCustomComboBoxClear(self.pointer)
    def ClearSelection(self):
        r=PyMinMod.TCustomComboBoxClearSelection(self.pointer)
    def setDroppedDown(self,para0):
        r=PyMinMod.TCustomComboBoxsetDroppedDown(self.pointer,para0)
        return r
    def getDroppedDown(self):
        r=PyMinMod.TCustomComboBoxgetDroppedDown(self.pointer)
        return r
    def SelectAll(self):
        r=PyMinMod.TCustomComboBoxSelectAll(self.pointer)
    def setAutoSelect(self,para0):
        r=PyMinMod.TCustomComboBoxsetAutoSelect(self.pointer,para0)
        return r
    def getAutoSelect(self):
        r=PyMinMod.TCustomComboBoxgetAutoSelect(self.pointer)
        return r
    def setAutoSelected(self,para0):
        r=PyMinMod.TCustomComboBoxsetAutoSelected(self.pointer,para0)
        return r
    def getAutoSelected(self):
        r=PyMinMod.TCustomComboBoxgetAutoSelected(self.pointer)
        return r
    def setDropDownCount(self,para0):
        r=PyMinMod.TCustomComboBoxsetDropDownCount(self.pointer,para0)
        return r
    def getDropDownCount(self):
        r=PyMinMod.TCustomComboBoxgetDropDownCount(self.pointer)
        return r
    def setItems(self,para0):
        r=PyMinMod.TCustomComboBoxsetItems(self.pointer,para0.pointer)
        obj=TStrings()
        obj.pointer=r
        return obj
    def getItems(self):
        r=PyMinMod.TCustomComboBoxgetItems(self.pointer)
        obj=TStrings()
        obj.pointer=r
        return obj
    def setItemIndex(self,para0):
        r=PyMinMod.TCustomComboBoxsetItemIndex(self.pointer,para0)
        return r
    def getItemIndex(self):
        r=PyMinMod.TCustomComboBoxgetItemIndex(self.pointer)
        return r
    def setReadOnly(self,para0):
        r=PyMinMod.TCustomComboBoxsetReadOnly(self.pointer,para0)
        return r
    def getReadOnly(self):
        r=PyMinMod.TCustomComboBoxgetReadOnly(self.pointer)
        return r
    def setSelLength(self,para0):
        r=PyMinMod.TCustomComboBoxsetSelLength(self.pointer,para0)
        return r
    def getSelLength(self):
        r=PyMinMod.TCustomComboBoxgetSelLength(self.pointer)
        return r
    def setSelStart(self,para0):
        r=PyMinMod.TCustomComboBoxsetSelStart(self.pointer,para0)
        return r
    def getSelStart(self):
        r=PyMinMod.TCustomComboBoxgetSelStart(self.pointer)
        return r
    def setSelText(self,para0):
        r=PyMinMod.TCustomComboBoxsetSelText(self.pointer,para0)
        return r
    def getSelText(self):
        r=PyMinMod.TCustomComboBoxgetSelText(self.pointer)
        return r
#class TCustomComboBox end
#class TCustomListBox start
class TCustomListBox(TWinControl):
    def __init__(self):#TCustomListBox
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        self.OnDblClickhandler=-1
        TWinControl.__init__(self)
    def AddItem(self,Item,AnObject):
        r=PyMinMod.TCustomListBoxAddItem(self.pointer,Item,AnObject.pointer)
    def Click(self):
        r=PyMinMod.TCustomListBoxClick(self.pointer)
    def Clear(self):
        r=PyMinMod.TCustomListBoxClear(self.pointer)
    def ClearSelection(self):
        r=PyMinMod.TCustomListBoxClearSelection(self.pointer)
    def GetIndexAtXY(self,X,Y):
        r=PyMinMod.TCustomListBoxGetIndexAtXY(self.pointer,X,Y)
    def GetIndexAtY(self,Y):
        r=PyMinMod.TCustomListBoxGetIndexAtY(self.pointer,Y)
    def GetSelectedText(self):
        r=PyMinMod.TCustomListBoxGetSelectedText(self.pointer)
    def ItemVisible(self,Index):
        r=PyMinMod.TCustomListBoxItemVisible(self.pointer,Index)
    def ItemFullyVisible(self,Index):
        r=PyMinMod.TCustomListBoxItemFullyVisible(self.pointer,Index)
    def LockSelectionChange(self):
        r=PyMinMod.TCustomListBoxLockSelectionChange(self.pointer)
    def MakeCurrentVisible(self):
        r=PyMinMod.TCustomListBoxMakeCurrentVisible(self.pointer)
    def MeasureItem(self,Index,TheHeight):
        r=PyMinMod.TCustomListBoxMeasureItem(self.pointer,Index,TheHeight)
    def SelectAll(self):
        r=PyMinMod.TCustomListBoxSelectAll(self.pointer)
    def setColumns(self,para0):
        r=PyMinMod.TCustomListBoxsetColumns(self.pointer,para0)
        return r
    def getColumns(self):
        r=PyMinMod.TCustomListBoxgetColumns(self.pointer)
        return r
    def getCount(self):
        r=PyMinMod.TCustomListBoxgetCount(self.pointer)
        return r
    def setExtendedSelect(self,para0):
        r=PyMinMod.TCustomListBoxsetExtendedSelect(self.pointer,para0)
        return r
    def getExtendedSelect(self):
        r=PyMinMod.TCustomListBoxgetExtendedSelect(self.pointer)
        return r
    def setIntegralHeight(self,para0):
        r=PyMinMod.TCustomListBoxsetIntegralHeight(self.pointer,para0)
        return r
    def getIntegralHeight(self):
        r=PyMinMod.TCustomListBoxgetIntegralHeight(self.pointer)
        return r
    def setItemHeight(self,para0):
        r=PyMinMod.TCustomListBoxsetItemHeight(self.pointer,para0)
        return r
    def getItemHeight(self):
        r=PyMinMod.TCustomListBoxgetItemHeight(self.pointer)
        return r
    def setItemIndex(self,para0):
        r=PyMinMod.TCustomListBoxsetItemIndex(self.pointer,para0)
        return r
    def getItemIndex(self):
        r=PyMinMod.TCustomListBoxgetItemIndex(self.pointer)
        return r
    def setItems(self,para0):
        r=PyMinMod.TCustomListBoxsetItems(self.pointer,para0.pointer)
        obj=TStrings()
        obj.pointer=r
        return obj
    def getItems(self):
        r=PyMinMod.TCustomListBoxgetItems(self.pointer)
        obj=TStrings()
        obj.pointer=r
        return obj
    def setMultiSelect(self,para0):
        r=PyMinMod.TCustomListBoxsetMultiSelect(self.pointer,para0)
        return r
    def getMultiSelect(self):
        r=PyMinMod.TCustomListBoxgetMultiSelect(self.pointer)
        return r
    def setOnDblClick(self,handler):
        self.OnDblClickhandler=PyMinMod.TCustomListBoxsetOnDblClick(handler,self.pointer,self.OnDblClickhandler)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TCustomListBoxsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TCustomListBoxsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentFont(self,para0):
        r=PyMinMod.TCustomListBoxsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TCustomListBoxgetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TCustomListBoxsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TCustomListBoxgetParentShowHint(self.pointer)
        return r
    def setScrollWidth(self,para0):
        r=PyMinMod.TCustomListBoxsetScrollWidth(self.pointer,para0)
        return r
    def getScrollWidth(self):
        r=PyMinMod.TCustomListBoxgetScrollWidth(self.pointer)
        return r
    def getSelCount(self):
        r=PyMinMod.TCustomListBoxgetSelCount(self.pointer)
        return r
    def setSelected(self,para0,indexedpara0):
        r=PyMinMod.TCustomListBoxsetSelected(self.pointer,para0,indexedpara0)
        return r
    def getSelected(self,indexedpara0):
        r=PyMinMod.TCustomListBoxgetSelected(self.pointer,indexedpara0)
        return r
    def setSorted(self,para0):
        r=PyMinMod.TCustomListBoxsetSorted(self.pointer,para0)
        return r
    def getSorted(self):
        r=PyMinMod.TCustomListBoxgetSorted(self.pointer)
        return r
    def setTopIndex(self,para0):
        r=PyMinMod.TCustomListBoxsetTopIndex(self.pointer,para0)
        return r
    def getTopIndex(self):
        r=PyMinMod.TCustomListBoxgetTopIndex(self.pointer)
        return r
#class TCustomListBox end
#class TCustomCheckBox start
class TCustomCheckBox(TButtonControl):
    def __init__(self):#TCustomCheckBox
        TButtonControl.__init__(self)
    def setAllowGrayed(self,para0):
        r=PyMinMod.TCustomCheckBoxsetAllowGrayed(self.pointer,para0)
        return r
    def getAllowGrayed(self):
        r=PyMinMod.TCustomCheckBoxgetAllowGrayed(self.pointer)
        return r
#class TCustomCheckBox end
#class TCustomEdit start
class TCustomEdit(TWinControl):
    def __init__(self):#TCustomEdit
        self.OnChangehandler=-1
        self.OnChangehandler=-1
        TWinControl.__init__(self)
    def Create(self,AOwner):
        r=PyMinMod.TCustomEditCreate(self.pointer,AOwner.pointer)
        obj=TCustomEdit()
        obj.pointer=r
        return obj
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
    def setHideSelection(self,para0):
        r=PyMinMod.TCustomEditsetHideSelection(self.pointer,para0)
        return r
    def getHideSelection(self):
        r=PyMinMod.TCustomEditgetHideSelection(self.pointer)
        return r
    def setMaxLength(self,para0):
        r=PyMinMod.TCustomEditsetMaxLength(self.pointer,para0)
        return r
    def getMaxLength(self):
        r=PyMinMod.TCustomEditgetMaxLength(self.pointer)
        return r
    def setModified(self,para0):
        r=PyMinMod.TCustomEditsetModified(self.pointer,para0)
        return r
    def getModified(self):
        r=PyMinMod.TCustomEditgetModified(self.pointer)
        return r
    def setNumbersOnly(self,para0):
        r=PyMinMod.TCustomEditsetNumbersOnly(self.pointer,para0)
        return r
    def getNumbersOnly(self):
        r=PyMinMod.TCustomEditgetNumbersOnly(self.pointer)
        return r
    def setOnChange(self,handler):
        self.OnChangehandler=PyMinMod.TCustomEditsetOnChange(handler,self.pointer,self.OnChangehandler)
    def setReadOnly(self,para0):
        r=PyMinMod.TCustomEditsetReadOnly(self.pointer,para0)
        return r
    def getReadOnly(self):
        r=PyMinMod.TCustomEditgetReadOnly(self.pointer)
        return r
    def setSelLength(self,para0):
        r=PyMinMod.TCustomEditsetSelLength(self.pointer,para0)
        return r
    def getSelLength(self):
        r=PyMinMod.TCustomEditgetSelLength(self.pointer)
        return r
    def setSelStart(self,para0):
        r=PyMinMod.TCustomEditsetSelStart(self.pointer,para0)
        return r
    def getSelStart(self):
        r=PyMinMod.TCustomEditgetSelStart(self.pointer)
        return r
    def setSelText(self,para0):
        r=PyMinMod.TCustomEditsetSelText(self.pointer,para0)
        return r
    def getSelText(self):
        r=PyMinMod.TCustomEditgetSelText(self.pointer)
        return r
    def setOnChange(self,handler):
        self.OnChangehandler=PyMinMod.TCustomEditsetOnChange(handler,self.pointer,self.OnChangehandler)
#class TCustomEdit end
#class TCustomMemo start
class TCustomMemo(TCustomEdit):
    def __init__(self):#TCustomMemo
        TCustomEdit.__init__(self)
    def setLines(self,para0):
        r=PyMinMod.TCustomMemosetLines(self.pointer,para0.pointer)
        obj=TStrings()
        obj.pointer=r
        return obj
    def getLines(self):
        r=PyMinMod.TCustomMemogetLines(self.pointer)
        obj=TStrings()
        obj.pointer=r
        return obj
    def setWantReturns(self,para0):
        r=PyMinMod.TCustomMemosetWantReturns(self.pointer,para0)
        return r
    def getWantReturns(self):
        r=PyMinMod.TCustomMemogetWantReturns(self.pointer)
        return r
    def setWantTabs(self,para0):
        r=PyMinMod.TCustomMemosetWantTabs(self.pointer,para0)
        return r
    def getWantTabs(self):
        r=PyMinMod.TCustomMemogetWantTabs(self.pointer)
        return r
    def setWordWrap(self,para0):
        r=PyMinMod.TCustomMemosetWordWrap(self.pointer,para0)
        return r
    def getWordWrap(self):
        r=PyMinMod.TCustomMemogetWordWrap(self.pointer)
        return r
#class TCustomMemo end
#class TCustomLabel start
class TCustomLabel(TGraphicControl):
    def __init__(self):#TCustomLabel
        TGraphicControl.__init__(self)
    def Create(self,TheOwner):
        r=PyMinMod.TCustomLabelCreate(self.pointer,TheOwner.pointer)
        obj=TCustomLabel()
        obj.pointer=r
        return obj
    def ColorIsStored(self):
        r=PyMinMod.TCustomLabelColorIsStored(self.pointer)
    def AdjustFontForOptimalFill(self):
        r=PyMinMod.TCustomLabelAdjustFontForOptimalFill(self.pointer)
    def Paint(self):
        r=PyMinMod.TCustomLabelPaint(self.pointer)
    def SetBounds(self,aLeft,aTop,aWidth,aHeight):
        r=PyMinMod.TCustomLabelSetBounds(self.pointer,aLeft,aTop,aWidth,aHeight)
#class TCustomLabel end
#class TCustomButton start
class TCustomButton(TButtonControl):
    def __init__(self):#TCustomButton
        TButtonControl.__init__(self)
    def Create(self,TheOwner):
        r=PyMinMod.TCustomButtonCreate(self.pointer,TheOwner.pointer)
        obj=TCustomButton()
        obj.pointer=r
        return obj
    def Click(self):
        r=PyMinMod.TCustomButtonClick(self.pointer)
    def ExecuteDefaultAction(self):
        r=PyMinMod.TCustomButtonExecuteDefaultAction(self.pointer)
    def ExecuteCancelAction(self):
        r=PyMinMod.TCustomButtonExecuteCancelAction(self.pointer)
    def ActiveDefaultControlChanged(self,NewControl):
        r=PyMinMod.TCustomButtonActiveDefaultControlChanged(self.pointer,NewControl.pointer)
    def UpdateRolesForForm(self):
        r=PyMinMod.TCustomButtonUpdateRolesForForm(self.pointer)
    def getActive(self):
        r=PyMinMod.TCustomButtongetActive(self.pointer)
        return r
    def setDefault(self,para0):
        r=PyMinMod.TCustomButtonsetDefault(self.pointer,para0)
        return r
    def getDefault(self):
        r=PyMinMod.TCustomButtongetDefault(self.pointer)
        return r
    def setCancel(self,para0):
        r=PyMinMod.TCustomButtonsetCancel(self.pointer,para0)
        return r
    def getCancel(self):
        r=PyMinMod.TCustomButtongetCancel(self.pointer)
        return r
#class TCustomButton end
#class TMemo start
class TMemo(TCustomMemo):
    def __init__(self):#TMemo
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        self.OnDblClickhandler=-1
        TCustomMemo.__init__(self)
    def setOnDblClick(self,handler):
        self.OnDblClickhandler=PyMinMod.TMemosetOnDblClick(handler,self.pointer,self.OnDblClickhandler)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TMemosetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TMemosetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentColor(self,para0):
        r=PyMinMod.TMemosetParentColor(self.pointer,para0)
        return r
    def getParentColor(self):
        r=PyMinMod.TMemogetParentColor(self.pointer)
        return r
    def setParentFont(self,para0):
        r=PyMinMod.TMemosetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TMemogetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TMemosetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TMemogetParentShowHint(self.pointer)
        return r
#class TMemo end
#class TScrollBar start
class TScrollBar(TCustomScrollBar):
    def __init__(self):#TScrollBar
        TCustomScrollBar.__init__(self)
    def setParentShowHint(self,para0):
        r=PyMinMod.TScrollBarsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TScrollBargetParentShowHint(self.pointer)
        return r
#class TScrollBar end
#class TComboBox start
class TComboBox(TCustomComboBox):
    def __init__(self):#TComboBox
        self.OnSelecthandler=-1
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        self.OnGetItemshandler=-1
        self.OnDropDownhandler=-1
        self.OnDblClickhandler=-1
        self.OnCloseUphandler=-1
        self.OnChangehandler=-1
        TCustomComboBox.__init__(self)
    def setItemHeight(self,para0):
        r=PyMinMod.TComboBoxsetItemHeight(self.pointer,para0)
        return r
    def getItemHeight(self):
        r=PyMinMod.TComboBoxgetItemHeight(self.pointer)
        return r
    def setItemWidth(self,para0):
        r=PyMinMod.TComboBoxsetItemWidth(self.pointer,para0)
        return r
    def getItemWidth(self):
        r=PyMinMod.TComboBoxgetItemWidth(self.pointer)
        return r
    def setMaxLength(self,para0):
        r=PyMinMod.TComboBoxsetMaxLength(self.pointer,para0)
        return r
    def getMaxLength(self):
        r=PyMinMod.TComboBoxgetMaxLength(self.pointer)
        return r
    def setOnChange(self,handler):
        self.OnChangehandler=PyMinMod.TComboBoxsetOnChange(handler,self.pointer,self.OnChangehandler)
    def setOnCloseUp(self,handler):
        self.OnCloseUphandler=PyMinMod.TComboBoxsetOnCloseUp(handler,self.pointer,self.OnCloseUphandler)
    def setOnDblClick(self,handler):
        self.OnDblClickhandler=PyMinMod.TComboBoxsetOnDblClick(handler,self.pointer,self.OnDblClickhandler)
    def setOnDropDown(self,handler):
        self.OnDropDownhandler=PyMinMod.TComboBoxsetOnDropDown(handler,self.pointer,self.OnDropDownhandler)
    def setOnGetItems(self,handler):
        self.OnGetItemshandler=PyMinMod.TComboBoxsetOnGetItems(handler,self.pointer,self.OnGetItemshandler)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TComboBoxsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TComboBoxsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setOnSelect(self,handler):
        self.OnSelecthandler=PyMinMod.TComboBoxsetOnSelect(handler,self.pointer,self.OnSelecthandler)
    def setParentColor(self,para0):
        r=PyMinMod.TComboBoxsetParentColor(self.pointer,para0)
        return r
    def getParentColor(self):
        r=PyMinMod.TComboBoxgetParentColor(self.pointer)
        return r
    def setParentFont(self,para0):
        r=PyMinMod.TComboBoxsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TComboBoxgetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TComboBoxsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TComboBoxgetParentShowHint(self.pointer)
        return r
#class TComboBox end
#class TListBox start
class TListBox(TCustomListBox):
    def __init__(self):#TListBox
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        self.OnDblClickhandler=-1
        TCustomListBox.__init__(self)
    def setOnDblClick(self,handler):
        self.OnDblClickhandler=PyMinMod.TListBoxsetOnDblClick(handler,self.pointer,self.OnDblClickhandler)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TListBoxsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TListBoxsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentColor(self,para0):
        r=PyMinMod.TListBoxsetParentColor(self.pointer,para0)
        return r
    def getParentColor(self):
        r=PyMinMod.TListBoxgetParentColor(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TListBoxsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TListBoxgetParentShowHint(self.pointer)
        return r
    def setParentFont(self,para0):
        r=PyMinMod.TListBoxsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TListBoxgetParentFont(self.pointer)
        return r
#class TListBox end
#class TRadioButton start
class TRadioButton(TCustomCheckBox):
    def __init__(self):#TRadioButton
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        TCustomCheckBox.__init__(self)
    def setChecked(self,para0):
        r=PyMinMod.TRadioButtonsetChecked(self.pointer,para0)
        return r
    def getChecked(self):
        r=PyMinMod.TRadioButtongetChecked(self.pointer)
        return r
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TRadioButtonsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TRadioButtonsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentColor(self,para0):
        r=PyMinMod.TRadioButtonsetParentColor(self.pointer,para0)
        return r
    def getParentColor(self):
        r=PyMinMod.TRadioButtongetParentColor(self.pointer)
        return r
    def setParentFont(self,para0):
        r=PyMinMod.TRadioButtonsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TRadioButtongetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TRadioButtonsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TRadioButtongetParentShowHint(self.pointer)
        return r
#class TRadioButton end
#class TCheckBox start
class TCheckBox(TCustomCheckBox):
    def __init__(self):#TCheckBox
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        TCustomCheckBox.__init__(self)
    def setChecked(self,para0):
        r=PyMinMod.TCheckBoxsetChecked(self.pointer,para0)
        return r
    def getChecked(self):
        r=PyMinMod.TCheckBoxgetChecked(self.pointer)
        return r
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TCheckBoxsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TCheckBoxsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentColor(self,para0):
        r=PyMinMod.TCheckBoxsetParentColor(self.pointer,para0)
        return r
    def getParentColor(self):
        r=PyMinMod.TCheckBoxgetParentColor(self.pointer)
        return r
    def setParentFont(self,para0):
        r=PyMinMod.TCheckBoxsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TCheckBoxgetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TCheckBoxsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TCheckBoxgetParentShowHint(self.pointer)
        return r
#class TCheckBox end
#class TToggleBox start
class TToggleBox(TCustomCheckBox):
    def __init__(self):#TToggleBox
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        TCustomCheckBox.__init__(self)
    def setChecked(self,para0):
        r=PyMinMod.TToggleBoxsetChecked(self.pointer,para0)
        return r
    def getChecked(self):
        r=PyMinMod.TToggleBoxgetChecked(self.pointer)
        return r
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TToggleBoxsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TToggleBoxsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentFont(self,para0):
        r=PyMinMod.TToggleBoxsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TToggleBoxgetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TToggleBoxsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TToggleBoxgetParentShowHint(self.pointer)
        return r
#class TToggleBox end
#class TEdit start
class TEdit(TCustomEdit):
    def __init__(self):#TEdit
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        self.OnDblClickhandler=-1
        TCustomEdit.__init__(self)
    def setAutoSelect(self,para0):
        r=PyMinMod.TEditsetAutoSelect(self.pointer,para0)
        return r
    def getAutoSelect(self):
        r=PyMinMod.TEditgetAutoSelect(self.pointer)
        return r
    def setOnDblClick(self,handler):
        self.OnDblClickhandler=PyMinMod.TEditsetOnDblClick(handler,self.pointer,self.OnDblClickhandler)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TEditsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TEditsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentColor(self,para0):
        r=PyMinMod.TEditsetParentColor(self.pointer,para0)
        return r
    def getParentColor(self):
        r=PyMinMod.TEditgetParentColor(self.pointer)
        return r
    def setParentFont(self,para0):
        r=PyMinMod.TEditsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TEditgetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TEditsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TEditgetParentShowHint(self.pointer)
        return r
#class TEdit end
#class TLabel start
class TLabel(TCustomLabel):
    def __init__(self):#TLabel
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        self.OnDblClickhandler=-1
        TCustomLabel.__init__(self)
    def setFocusControl(self,para0):
        r=PyMinMod.TLabelsetFocusControl(self.pointer,para0.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def getFocusControl(self):
        r=PyMinMod.TLabelgetFocusControl(self.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def setParentColor(self,para0):
        r=PyMinMod.TLabelsetParentColor(self.pointer,para0)
        return r
    def getParentColor(self):
        r=PyMinMod.TLabelgetParentColor(self.pointer)
        return r
    def setParentFont(self,para0):
        r=PyMinMod.TLabelsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TLabelgetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TLabelsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TLabelgetParentShowHint(self.pointer)
        return r
    def setShowAccelChar(self,para0):
        r=PyMinMod.TLabelsetShowAccelChar(self.pointer,para0)
        return r
    def getShowAccelChar(self):
        r=PyMinMod.TLabelgetShowAccelChar(self.pointer)
        return r
    def setTransparent(self,para0):
        r=PyMinMod.TLabelsetTransparent(self.pointer,para0)
        return r
    def getTransparent(self):
        r=PyMinMod.TLabelgetTransparent(self.pointer)
        return r
    def setWordWrap(self,para0):
        r=PyMinMod.TLabelsetWordWrap(self.pointer,para0)
        return r
    def getWordWrap(self):
        r=PyMinMod.TLabelgetWordWrap(self.pointer)
        return r
    def setOnDblClick(self,handler):
        self.OnDblClickhandler=PyMinMod.TLabelsetOnDblClick(handler,self.pointer,self.OnDblClickhandler)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TLabelsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TLabelsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
#class TLabel end
#class TButton start
class TButton(TCustomButton):
    def __init__(self):#TButton
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        TCustomButton.__init__(self)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TButtonsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TButtonsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentFont(self,para0):
        r=PyMinMod.TButtonsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TButtongetParentFont(self.pointer)
        return r
    def setParentShowHint(self,para0):
        r=PyMinMod.TButtonsetParentShowHint(self.pointer,para0)
        return r
    def getParentShowHint(self):
        r=PyMinMod.TButtongetParentShowHint(self.pointer)
        return r
#class TButton end
