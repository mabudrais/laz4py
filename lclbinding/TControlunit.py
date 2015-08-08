from TLCLComponentunit import*
import PyMinMod
class TControl(TLCLComponent):
    def AdjustSize(self):
        r=PyMinMod.TControlAdjustSize(self.pointer)
    def AutoSizeDelayed(self):
        r=PyMinMod.TControlAutoSizeDelayed(self.pointer)
        return r
    def AutoSizeDelayedReport(self):
        r=PyMinMod.TControlAutoSizeDelayedReport(self.pointer)
        return r
    def AutoSizeDelayedHandle(self):
        r=PyMinMod.TControlAutoSizeDelayedHandle(self.pointer)
        return r
    def AnchorClient(self,Space):
        r=PyMinMod.TControlAnchorClient(self.pointer,Space)
    def AnchoredControlCount(self):
        r=PyMinMod.TControlAnchoredControlCount(self.pointer)
        return r
    def SetBounds(self,aHeight,aWidth,aTop,aLeft):
        r=PyMinMod.TControlSetBounds(self.pointer,aHeight,aWidth,aTop,aLeft)
    def SetInitialBounds(self,aHeight,aWidth,aTop,aLeft):
        r=PyMinMod.TControlSetInitialBounds(self.pointer,aHeight,aWidth,aTop,aLeft)
    def GetDefaultWidth(self):
        r=PyMinMod.TControlGetDefaultWidth(self.pointer)
        return r
    def GetDefaultHeight(self):
        r=PyMinMod.TControlGetDefaultHeight(self.pointer)
        return r
    def CNPreferredSizeChanged(self):
        r=PyMinMod.TControlCNPreferredSizeChanged(self.pointer)
    def InvalidatePreferredSize(self):
        r=PyMinMod.TControlInvalidatePreferredSize(self.pointer)
    def WriteLayoutDebugReport(self,Prefix):
        r=PyMinMod.TControlWriteLayoutDebugReport(self.pointer,Prefix)
    def ShouldAutoAdjustLeftAndTop(self):
        r=PyMinMod.TControlShouldAutoAdjustLeftAndTop(self.pointer)
        return r
    def BeforeDestruction(self):
        r=PyMinMod.TControlBeforeDestruction(self.pointer)
    def EditingDone(self):
        r=PyMinMod.TControlEditingDone(self.pointer)
    def ExecuteDefaultAction(self):
        r=PyMinMod.TControlExecuteDefaultAction(self.pointer)
    def ExecuteCancelAction(self):
        r=PyMinMod.TControlExecuteCancelAction(self.pointer)
    def BeginDrag(self,Threshold,Immediate):
        r=PyMinMod.TControlBeginDrag(self.pointer,Threshold,Immediate)
    def EndDrag(self,Drop):
        r=PyMinMod.TControlEndDrag(self.pointer,Drop)
    def BringToFront(self):
        r=PyMinMod.TControlBringToFront(self.pointer)
    def HasParent(self):
        r=PyMinMod.TControlHasParent(self.pointer)
        return r
    def IsVisible(self):
        r=PyMinMod.TControlIsVisible(self.pointer)
        return r
    def IsControlVisible(self):
        r=PyMinMod.TControlIsControlVisible(self.pointer)
        return r
    def IsEnabled(self):
        r=PyMinMod.TControlIsEnabled(self.pointer)
        return r
    def IsParentColor(self):
        r=PyMinMod.TControlIsParentColor(self.pointer)
        return r
    def IsParentFont(self):
        r=PyMinMod.TControlIsParentFont(self.pointer)
        return r
    def FormIsUpdating(self):
        r=PyMinMod.TControlFormIsUpdating(self.pointer)
        return r
    def IsProcessingPaintMsg(self):
        r=PyMinMod.TControlIsProcessingPaintMsg(self.pointer)
        return r
    def Hide(self):
        r=PyMinMod.TControlHide(self.pointer)
    def Refresh(self):
        r=PyMinMod.TControlRefresh(self.pointer)
    def Repaint(self):
        r=PyMinMod.TControlRepaint(self.pointer)
    def Invalidate(self):
        r=PyMinMod.TControlInvalidate(self.pointer)
    def SendToBack(self):
        r=PyMinMod.TControlSendToBack(self.pointer)
    def UpdateRolesForForm(self):
        r=PyMinMod.TControlUpdateRolesForForm(self.pointer)
    def GetTextLen(self):
        r=PyMinMod.TControlGetTextLen(self.pointer)
        return r
    def Show(self):
        r=PyMinMod.TControlShow(self.pointer)
    def Update(self):
        r=PyMinMod.TControlUpdate(self.pointer)
    def HandleObjectShouldBeVisible(self):
        r=PyMinMod.TControlHandleObjectShouldBeVisible(self.pointer)
        return r
    def ParentDestroyingHandle(self):
        r=PyMinMod.TControlParentDestroyingHandle(self.pointer)
        return r
    def ParentHandlesAllocated(self):
        r=PyMinMod.TControlParentHandlesAllocated(self.pointer)
        return r
    def InitiateAction(self):
        r=PyMinMod.TControlInitiateAction(self.pointer)
    def ShowHelp(self):
        r=PyMinMod.TControlShowHelp(self.pointer)
    def setAccessibleDescription(self,a1):
        r=PyMinMod.TControlsetAccessibleDescription(self.pointer,a1)
    def getAccessibleDescription(self):
        r=PyMinMod.TControlgetAccessibleDescription(self.pointer)
        return r
    AccessibleDescription=property(getAccessibleDescription,setAccessibleDescription)
    def setAccessibleValue(self,a1):
        r=PyMinMod.TControlsetAccessibleValue(self.pointer,a1)
    def getAccessibleValue(self):
        r=PyMinMod.TControlgetAccessibleValue(self.pointer)
        return r
    AccessibleValue=property(getAccessibleValue,setAccessibleValue)
    def setAutoSize(self,a1):
        r=PyMinMod.TControlsetAutoSize(self.pointer,a1)
    def getAutoSize(self):
        r=PyMinMod.TControlgetAutoSize(self.pointer)
        return r
    AutoSize=property(getAutoSize,setAutoSize)
    def setCaption(self,a1):
        r=PyMinMod.TControlsetCaption(self.pointer,a1)
    def getCaption(self):
        r=PyMinMod.TControlgetCaption(self.pointer)
        return r
    Caption=property(getCaption,setCaption)
    def setClientHeight(self,a1):
        r=PyMinMod.TControlsetClientHeight(self.pointer,a1)
    def getClientHeight(self):
        r=PyMinMod.TControlgetClientHeight(self.pointer)
        return r
    ClientHeight=property(getClientHeight,setClientHeight)
    def setClientWidth(self,a1):
        r=PyMinMod.TControlsetClientWidth(self.pointer,a1)
    def getClientWidth(self):
        r=PyMinMod.TControlgetClientWidth(self.pointer)
        return r
    ClientWidth=property(getClientWidth,setClientWidth)
    def setEnabled(self,a1):
        r=PyMinMod.TControlsetEnabled(self.pointer,a1)
    def getEnabled(self):
        r=PyMinMod.TControlgetEnabled(self.pointer)
        return r
    Enabled=property(getEnabled,setEnabled)
    def setIsControl(self,a1):
        r=PyMinMod.TControlsetIsControl(self.pointer,a1)
    def getIsControl(self):
        r=PyMinMod.TControlgetIsControl(self.pointer)
        return r
    IsControl=property(getIsControl,setIsControl)
    def getMouseEntered(self):
        r=PyMinMod.TControlgetMouseEntered(self.pointer)
        return r
    def setOnChangeBounds(self,event_handler):
        PyMinMod.SetOnClick(event_handler,self.pointer)
    def setOnClick(self,event_handler):
        PyMinMod.SetOnClick(event_handler,self.pointer)
    def setOnResize(self,event_handler):
        PyMinMod.SetOnClick(event_handler,self.pointer)
    def setShowHint(self,a1):
        r=PyMinMod.TControlsetShowHint(self.pointer,a1)
    def getShowHint(self):
        r=PyMinMod.TControlgetShowHint(self.pointer)
        return r
    ShowHint=property(getShowHint,setShowHint)
    def setVisible(self,a1):
        r=PyMinMod.TControlsetVisible(self.pointer,a1)
    def getVisible(self):
        r=PyMinMod.TControlgetVisible(self.pointer)
        return r
    Visible=property(getVisible,setVisible)
    def getFloating(self):
        r=PyMinMod.TControlgetFloating(self.pointer)
        return r
    def setLRDockWidth(self,a1):
        r=PyMinMod.TControlsetLRDockWidth(self.pointer,a1)
    def getLRDockWidth(self):
        r=PyMinMod.TControlgetLRDockWidth(self.pointer)
        return r
    LRDockWidth=property(getLRDockWidth,setLRDockWidth)
    def setTBDockHeight(self,a1):
        r=PyMinMod.TControlsetTBDockHeight(self.pointer,a1)
    def getTBDockHeight(self):
        r=PyMinMod.TControlgetTBDockHeight(self.pointer)
        return r
    TBDockHeight=property(getTBDockHeight,setTBDockHeight)
    def setUndockHeight(self,a1):
        r=PyMinMod.TControlsetUndockHeight(self.pointer,a1)
    def getUndockHeight(self):
        r=PyMinMod.TControlgetUndockHeight(self.pointer)
        return r
    UndockHeight=property(getUndockHeight,setUndockHeight)
    def UseRightToLeftAlignment(self):
        r=PyMinMod.TControlUseRightToLeftAlignment(self.pointer)
        return r
    def UseRightToLeftReading(self):
        r=PyMinMod.TControlUseRightToLeftReading(self.pointer)
        return r
    def UseRightToLeftScrollBar(self):
        r=PyMinMod.TControlUseRightToLeftScrollBar(self.pointer)
        return r
    def IsRightToLeft(self):
        r=PyMinMod.TControlIsRightToLeft(self.pointer)
        return r
    def setLeft(self,a1):
        r=PyMinMod.TControlsetLeft(self.pointer,a1)
    def getLeft(self):
        r=PyMinMod.TControlgetLeft(self.pointer)
        return r
    Left=property(getLeft,setLeft)
    def setHeight(self,a1):
        r=PyMinMod.TControlsetHeight(self.pointer,a1)
    def getHeight(self):
        r=PyMinMod.TControlgetHeight(self.pointer)
        return r
    Height=property(getHeight,setHeight)
    def setTop(self,a1):
        r=PyMinMod.TControlsetTop(self.pointer,a1)
    def getTop(self):
        r=PyMinMod.TControlgetTop(self.pointer)
        return r
    Top=property(getTop,setTop)
    def setWidth(self,a1):
        PyMinMod.TControlsetWidth(self.pointer,a1)
    def getWidth(self):
        r=PyMinMod.TControlgetWidth(self.pointer)
        return r
    Width=property(getWidth,setWidth)
    def setHelpKeyword(self,a1):
        r=PyMinMod.TControlsetHelpKeyword(self.pointer,a1)
    def getHelpKeyword(self):
        r=PyMinMod.TControlgetHelpKeyword(self.pointer)
        return r
    HelpKeyword=property(getHelpKeyword,setHelpKeyword)
