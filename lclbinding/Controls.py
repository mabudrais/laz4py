import PyMinMod
from LCLClasses import*
#import end
#class TControl start
class TControl(TLCLComponent):
    def __init__(self):#TControl
        self.OnResizehandler=-1
        self.OnClickhandler=-1
        self.OnChangeBoundshandler=-1
        self.OnResizehandler=-1
        self.OnClickhandler=-1
        self.OnChangeBoundshandler=-1
        TLCLComponent.__init__(self)
    def DragDrop(self,Source,X,Y):
        r=PyMinMod.TControlDragDrop(self.pointer,Source.pointer,X,Y)
    def AdjustSize(self):
        r=PyMinMod.TControlAdjustSize(self.pointer)
    def AutoSizeDelayed(self):
        r=PyMinMod.TControlAutoSizeDelayed(self.pointer)
    def AutoSizeDelayedReport(self):
        r=PyMinMod.TControlAutoSizeDelayedReport(self.pointer)
    def AutoSizeDelayedHandle(self):
        r=PyMinMod.TControlAutoSizeDelayedHandle(self.pointer)
    def AnchorHorizontalCenterTo(self,Sibling):
        r=PyMinMod.TControlAnchorHorizontalCenterTo(self.pointer,Sibling.pointer)
    def AnchorVerticalCenterTo(self,Sibling):
        r=PyMinMod.TControlAnchorVerticalCenterTo(self.pointer,Sibling.pointer)
    def AnchorClient(self,Space):
        r=PyMinMod.TControlAnchorClient(self.pointer,Space)
    def AnchoredControlCount(self):
        r=PyMinMod.TControlAnchoredControlCount(self.pointer)
    def getAnchoredControls(self,indexedpara0):
        r=PyMinMod.TControlgetAnchoredControls(self.pointer,indexedpara0)
        obj=TControl()
        obj.pointer=r
        return obj
    def SetBounds(self,aLeft,aTop,aWidth,aHeight):
        r=PyMinMod.TControlSetBounds(self.pointer,aLeft,aTop,aWidth,aHeight)
    def SetInitialBounds(self,aLeft,aTop,aWidth,aHeight):
        r=PyMinMod.TControlSetInitialBounds(self.pointer,aLeft,aTop,aWidth,aHeight)
    def GetDefaultWidth(self):
        r=PyMinMod.TControlGetDefaultWidth(self.pointer)
    def GetDefaultHeight(self):
        r=PyMinMod.TControlGetDefaultHeight(self.pointer)
    def CNPreferredSizeChanged(self):
        r=PyMinMod.TControlCNPreferredSizeChanged(self.pointer)
    def InvalidatePreferredSize(self):
        r=PyMinMod.TControlInvalidatePreferredSize(self.pointer)
    def WriteLayoutDebugReport(self,Prefix):
        r=PyMinMod.TControlWriteLayoutDebugReport(self.pointer,Prefix)
    def ShouldAutoAdjustLeftAndTop(self):
        r=PyMinMod.TControlShouldAutoAdjustLeftAndTop(self.pointer)
    def BeforeDestruction(self):
        r=PyMinMod.TControlBeforeDestruction(self.pointer)
    def EditingDone(self):
        r=PyMinMod.TControlEditingDone(self.pointer)
    def ExecuteDefaultAction(self):
        r=PyMinMod.TControlExecuteDefaultAction(self.pointer)
    def ExecuteCancelAction(self):
        r=PyMinMod.TControlExecuteCancelAction(self.pointer)
    def BeginDrag(self,Immediate,Threshold):
        r=PyMinMod.TControlBeginDrag(self.pointer,Immediate,Threshold)
    def EndDrag(self,Drop):
        r=PyMinMod.TControlEndDrag(self.pointer,Drop)
    def BringToFront(self):
        r=PyMinMod.TControlBringToFront(self.pointer)
    def HasParent(self):
        r=PyMinMod.TControlHasParent(self.pointer)
    def GetParentComponent(self):
        r=PyMinMod.TControlGetParentComponent(self.pointer)
    def IsParentOf(self,AControl):
        r=PyMinMod.TControlIsParentOf(self.pointer,AControl.pointer)
    def GetTopParent(self):
        r=PyMinMod.TControlGetTopParent(self.pointer)
    def IsVisible(self):
        r=PyMinMod.TControlIsVisible(self.pointer)
    def IsControlVisible(self):
        r=PyMinMod.TControlIsControlVisible(self.pointer)
    def IsEnabled(self):
        r=PyMinMod.TControlIsEnabled(self.pointer)
    def IsParentColor(self):
        r=PyMinMod.TControlIsParentColor(self.pointer)
    def IsParentFont(self):
        r=PyMinMod.TControlIsParentFont(self.pointer)
    def FormIsUpdating(self):
        r=PyMinMod.TControlFormIsUpdating(self.pointer)
    def IsProcessingPaintMsg(self):
        r=PyMinMod.TControlIsProcessingPaintMsg(self.pointer)
    def Hide(self):
        r=PyMinMod.TControlHide(self.pointer)
    def Refresh(self):
        r=PyMinMod.TControlRefresh(self.pointer)
    def Repaint(self):
        r=PyMinMod.TControlRepaint(self.pointer)
    def Invalidate(self):
        r=PyMinMod.TControlInvalidate(self.pointer)
    def CheckNewParent(self,AParent):
        r=PyMinMod.TControlCheckNewParent(self.pointer,AParent.pointer)
    def SendToBack(self):
        r=PyMinMod.TControlSendToBack(self.pointer)
    def UpdateRolesForForm(self):
        r=PyMinMod.TControlUpdateRolesForForm(self.pointer)
    def ActiveDefaultControlChanged(self,NewControl):
        r=PyMinMod.TControlActiveDefaultControlChanged(self.pointer,NewControl.pointer)
    def GetTextLen(self):
        r=PyMinMod.TControlGetTextLen(self.pointer)
    def Show(self):
        r=PyMinMod.TControlShow(self.pointer)
    def Update(self):
        r=PyMinMod.TControlUpdate(self.pointer)
    def HandleObjectShouldBeVisible(self):
        r=PyMinMod.TControlHandleObjectShouldBeVisible(self.pointer)
    def ParentDestroyingHandle(self):
        r=PyMinMod.TControlParentDestroyingHandle(self.pointer)
    def ParentHandlesAllocated(self):
        r=PyMinMod.TControlParentHandlesAllocated(self.pointer)
    def InitiateAction(self):
        r=PyMinMod.TControlInitiateAction(self.pointer)
    def ShowHelp(self):
        r=PyMinMod.TControlShowHelp(self.pointer)
    def RemoveAllHandlersOfObject(self,AnObject):
        r=PyMinMod.TControlRemoveAllHandlersOfObject(self.pointer,AnObject.pointer)
    def setAccessibleDescription(self,para0):
        r=PyMinMod.TControlsetAccessibleDescription(self.pointer,para0)
        return r
    def getAccessibleDescription(self):
        r=PyMinMod.TControlgetAccessibleDescription(self.pointer)
        return r
    def setAccessibleValue(self,para0):
        r=PyMinMod.TControlsetAccessibleValue(self.pointer,para0)
        return r
    def getAccessibleValue(self):
        r=PyMinMod.TControlgetAccessibleValue(self.pointer)
        return r
    def setAutoSize(self,para0):
        r=PyMinMod.TControlsetAutoSize(self.pointer,para0)
        return r
    def getAutoSize(self):
        r=PyMinMod.TControlgetAutoSize(self.pointer)
        return r
    def setCaption(self,para0):
        r=PyMinMod.TControlsetCaption(self.pointer,para0)
        return r
    def getCaption(self):
        r=PyMinMod.TControlgetCaption(self.pointer)
        return r
    def setClientHeight(self,para0):
        r=PyMinMod.TControlsetClientHeight(self.pointer,para0)
        return r
    def getClientHeight(self):
        r=PyMinMod.TControlgetClientHeight(self.pointer)
        return r
    def setClientWidth(self,para0):
        r=PyMinMod.TControlsetClientWidth(self.pointer,para0)
        return r
    def getClientWidth(self):
        r=PyMinMod.TControlgetClientWidth(self.pointer)
        return r
    def setEnabled(self,para0):
        r=PyMinMod.TControlsetEnabled(self.pointer,para0)
        return r
    def getEnabled(self):
        r=PyMinMod.TControlgetEnabled(self.pointer)
        return r
    def setIsControl(self,para0):
        r=PyMinMod.TControlsetIsControl(self.pointer,para0)
        return r
    def getIsControl(self):
        r=PyMinMod.TControlgetIsControl(self.pointer)
        return r
    def getMouseEntered(self):
        r=PyMinMod.TControlgetMouseEntered(self.pointer)
        return r
    def setOnChangeBounds(self,handler):
        self.OnChangeBoundshandler=PyMinMod.TControlsetOnChangeBounds(handler,self.pointer,self.OnChangeBoundshandler)
    def setOnClick(self,handler):
        self.OnClickhandler=PyMinMod.TControlsetOnClick(handler,self.pointer,self.OnClickhandler)
    def setOnResize(self,handler):
        self.OnResizehandler=PyMinMod.TControlsetOnResize(handler,self.pointer,self.OnResizehandler)
    def setParent(self,para0):
        r=PyMinMod.TControlsetParent(self.pointer,para0.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def getParent(self):
        r=PyMinMod.TControlgetParent(self.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def setPopupMenu(self,para0):
        r=PyMinMod.TControlsetPopupMenu(self.pointer,para0.pointer)
        obj=TPopupmenu()
        obj.pointer=r
        return obj
    def getPopupMenu(self):
        r=PyMinMod.TControlgetPopupMenu(self.pointer)
        obj=TPopupmenu()
        obj.pointer=r
        return obj
    def setShowHint(self,para0):
        r=PyMinMod.TControlsetShowHint(self.pointer,para0)
        return r
    def getShowHint(self):
        r=PyMinMod.TControlgetShowHint(self.pointer)
        return r
    def setVisible(self,para0):
        r=PyMinMod.TControlsetVisible(self.pointer,para0)
        return r
    def getVisible(self):
        r=PyMinMod.TControlgetVisible(self.pointer)
        return r
    def getFloating(self):
        r=PyMinMod.TControlgetFloating(self.pointer)
        return r
    def setHostDockSite(self,para0):
        r=PyMinMod.TControlsetHostDockSite(self.pointer,para0.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def getHostDockSite(self):
        r=PyMinMod.TControlgetHostDockSite(self.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def setLRDockWidth(self,para0):
        r=PyMinMod.TControlsetLRDockWidth(self.pointer,para0)
        return r
    def getLRDockWidth(self):
        r=PyMinMod.TControlgetLRDockWidth(self.pointer)
        return r
    def setTBDockHeight(self,para0):
        r=PyMinMod.TControlsetTBDockHeight(self.pointer,para0)
        return r
    def getTBDockHeight(self):
        r=PyMinMod.TControlgetTBDockHeight(self.pointer)
        return r
    def setUndockHeight(self,para0):
        r=PyMinMod.TControlsetUndockHeight(self.pointer,para0)
        return r
    def getUndockHeight(self):
        r=PyMinMod.TControlgetUndockHeight(self.pointer)
        return r
    def UseRightToLeftAlignment(self):
        r=PyMinMod.TControlUseRightToLeftAlignment(self.pointer)
    def UseRightToLeftReading(self):
        r=PyMinMod.TControlUseRightToLeftReading(self.pointer)
    def UseRightToLeftScrollBar(self):
        r=PyMinMod.TControlUseRightToLeftScrollBar(self.pointer)
    def IsRightToLeft(self):
        r=PyMinMod.TControlIsRightToLeft(self.pointer)
    def setLeft(self,para0):
        r=PyMinMod.TControlsetLeft(self.pointer,para0)
        return r
    def getLeft(self):
        r=PyMinMod.TControlgetLeft(self.pointer)
        return r
    def setHeight(self,para0):
        r=PyMinMod.TControlsetHeight(self.pointer,para0)
        return r
    def getHeight(self):
        r=PyMinMod.TControlgetHeight(self.pointer)
        return r
    def setTop(self,para0):
        r=PyMinMod.TControlsetTop(self.pointer,para0)
        return r
    def getTop(self):
        r=PyMinMod.TControlgetTop(self.pointer)
        return r
    def setWidth(self,para0):
        r=PyMinMod.TControlsetWidth(self.pointer,para0)
        return r
    def getWidth(self):
        r=PyMinMod.TControlgetWidth(self.pointer)
        return r
    def setHelpKeyword(self,para0):
        r=PyMinMod.TControlsetHelpKeyword(self.pointer,para0)
        return r
    def getHelpKeyword(self):
        r=PyMinMod.TControlgetHelpKeyword(self.pointer)
        return r
    def setOnChangeBounds(self,handler):
        self.OnChangeBoundshandler=PyMinMod.TControlsetOnChangeBounds(handler,self.pointer,self.OnChangeBoundshandler)
    def setOnClick(self,handler):
        self.OnClickhandler=PyMinMod.TControlsetOnClick(handler,self.pointer,self.OnClickhandler)
    def setOnResize(self,handler):
        self.OnResizehandler=PyMinMod.TControlsetOnResize(handler,self.pointer,self.OnResizehandler)
#class TControl end
#class TWinControl start
class TWinControl(TControl):
    def __init__(self):#TWinControl
        self.OnExithandler=-1
        self.OnEnterhandler=-1
        self.OnExithandler=-1
        self.OnEnterhandler=-1
        TControl.__init__(self)
    def getBoundsLockCount(self):
        r=PyMinMod.TWinControlgetBoundsLockCount(self.pointer)
        return r
    def getCachedClientHeight(self):
        r=PyMinMod.TWinControlgetCachedClientHeight(self.pointer)
        return r
    def getCachedClientWidth(self):
        r=PyMinMod.TWinControlgetCachedClientWidth(self.pointer)
        return r
    def getControlCount(self):
        r=PyMinMod.TWinControlgetControlCount(self.pointer)
        return r
    def getControls(self,indexedpara0):
        r=PyMinMod.TWinControlgetControls(self.pointer,indexedpara0)
        obj=TControl()
        obj.pointer=r
        return obj
    def getDockClientCount(self):
        r=PyMinMod.TWinControlgetDockClientCount(self.pointer)
        return r
    def getDockClients(self,indexedpara0):
        r=PyMinMod.TWinControlgetDockClients(self.pointer,indexedpara0)
        obj=TControl()
        obj.pointer=r
        return obj
    def setDockSite(self,para0):
        r=PyMinMod.TWinControlsetDockSite(self.pointer,para0)
        return r
    def getDockSite(self):
        r=PyMinMod.TWinControlgetDockSite(self.pointer)
        return r
    def setDoubleBuffered(self,para0):
        r=PyMinMod.TWinControlsetDoubleBuffered(self.pointer,para0)
        return r
    def getDoubleBuffered(self):
        r=PyMinMod.TWinControlgetDoubleBuffered(self.pointer)
        return r
    def getIsResizing(self):
        r=PyMinMod.TWinControlgetIsResizing(self.pointer)
        return r
    def setTabStop(self,para0):
        r=PyMinMod.TWinControlsetTabStop(self.pointer,para0)
        return r
    def getTabStop(self):
        r=PyMinMod.TWinControlgetTabStop(self.pointer)
        return r
    def setOnEnter(self,handler):
        self.OnEnterhandler=PyMinMod.TWinControlsetOnEnter(handler,self.pointer,self.OnEnterhandler)
    def setOnExit(self,handler):
        self.OnExithandler=PyMinMod.TWinControlsetOnExit(handler,self.pointer,self.OnExithandler)
    def getShowing(self):
        r=PyMinMod.TWinControlgetShowing(self.pointer)
        return r
    def setDesignerDeleting(self,para0):
        r=PyMinMod.TWinControlsetDesignerDeleting(self.pointer,para0)
        return r
    def getDesignerDeleting(self):
        r=PyMinMod.TWinControlgetDesignerDeleting(self.pointer)
        return r
    def AutoSizeDelayed(self):
        r=PyMinMod.TWinControlAutoSizeDelayed(self.pointer)
    def AutoSizeDelayedReport(self):
        r=PyMinMod.TWinControlAutoSizeDelayedReport(self.pointer)
    def AutoSizeDelayedHandle(self):
        r=PyMinMod.TWinControlAutoSizeDelayedHandle(self.pointer)
    def BeginUpdateBounds(self):
        r=PyMinMod.TWinControlBeginUpdateBounds(self.pointer)
    def EndUpdateBounds(self):
        r=PyMinMod.TWinControlEndUpdateBounds(self.pointer)
    def LockRealizeBounds(self):
        r=PyMinMod.TWinControlLockRealizeBounds(self.pointer)
    def UnlockRealizeBounds(self):
        r=PyMinMod.TWinControlUnlockRealizeBounds(self.pointer)
    def ContainsControl(self,Control):
        r=PyMinMod.TWinControlContainsControl(self.pointer,Control.pointer)
    def DoAdjustClientRectChange(self,InvalidateRect):
        r=PyMinMod.TWinControlDoAdjustClientRectChange(self.pointer,InvalidateRect)
    def InvalidateClientRectCache(self,WithChildControls):
        r=PyMinMod.TWinControlInvalidateClientRectCache(self.pointer,WithChildControls)
    def ClientRectNeedsInterfaceUpdate(self):
        r=PyMinMod.TWinControlClientRectNeedsInterfaceUpdate(self.pointer)
    def SetBounds(self,ALeft,ATop,AWidth,AHeight):
        r=PyMinMod.TWinControlSetBounds(self.pointer,ALeft,ATop,AWidth,AHeight)
    def DisableAlign(self):
        r=PyMinMod.TWinControlDisableAlign(self.pointer)
    def EnableAlign(self):
        r=PyMinMod.TWinControlEnableAlign(self.pointer)
    def ReAlign(self):
        r=PyMinMod.TWinControlReAlign(self.pointer)
    def ScrollBy(self,DeltaX,DeltaY):
        r=PyMinMod.TWinControlScrollBy(self.pointer,DeltaX,DeltaY)
    def WriteLayoutDebugReport(self,Prefix):
        r=PyMinMod.TWinControlWriteLayoutDebugReport(self.pointer,Prefix)
    def CanFocus(self):
        r=PyMinMod.TWinControlCanFocus(self.pointer)
    def GetControlIndex(self,AControl):
        r=PyMinMod.TWinControlGetControlIndex(self.pointer,AControl.pointer)
    def SetControlIndex(self,AControl,NewIndex):
        r=PyMinMod.TWinControlSetControlIndex(self.pointer,AControl.pointer,NewIndex)
    def Focused(self):
        r=PyMinMod.TWinControlFocused(self.pointer)
    def PerformTab(self,ForwardTab):
        r=PyMinMod.TWinControlPerformTab(self.pointer,ForwardTab)
    def FindChildControl(self,ControlName):
        r=PyMinMod.TWinControlFindChildControl(self.pointer,ControlName)
    def BroadCast(self):
        r=PyMinMod.TWinControlBroadCast(self.pointer)
    def DefaultHandler(self):
        r=PyMinMod.TWinControlDefaultHandler(self.pointer)
    def GetTextLen(self):
        r=PyMinMod.TWinControlGetTextLen(self.pointer)
    def Invalidate(self):
        r=PyMinMod.TWinControlInvalidate(self.pointer)
    def AddControl(self):
        r=PyMinMod.TWinControlAddControl(self.pointer)
    def InsertControl(self,AControl):
        r=PyMinMod.TWinControlInsertControl(self.pointer,AControl.pointer)
    def Repaint(self):
        r=PyMinMod.TWinControlRepaint(self.pointer)
    def Update(self):
        r=PyMinMod.TWinControlUpdate(self.pointer)
    def SetFocus(self):
        r=PyMinMod.TWinControlSetFocus(self.pointer)
    def FlipChildren(self,AllLevels):
        r=PyMinMod.TWinControlFlipChildren(self.pointer,AllLevels)
    def ScaleBy(self,Multiplier,Divider):
        r=PyMinMod.TWinControlScaleBy(self.pointer,Multiplier,Divider)
    def GetDockCaption(self,AControl):
        r=PyMinMod.TWinControlGetDockCaption(self.pointer,AControl.pointer)
    def UpdateDockCaption(self,Exclude):
        r=PyMinMod.TWinControlUpdateDockCaption(self.pointer,Exclude.pointer)
    def HandleAllocated(self):
        r=PyMinMod.TWinControlHandleAllocated(self.pointer)
    def ParentHandlesAllocated(self):
        r=PyMinMod.TWinControlParentHandlesAllocated(self.pointer)
    def HandleNeeded(self):
        r=PyMinMod.TWinControlHandleNeeded(self.pointer)
    def BrushCreated(self):
        r=PyMinMod.TWinControlBrushCreated(self.pointer)
    def IntfGetDropFilesTarget(self):
        r=PyMinMod.TWinControlIntfGetDropFilesTarget(self.pointer)
    def setOnEnter(self,handler):
        self.OnEnterhandler=PyMinMod.TWinControlsetOnEnter(handler,self.pointer,self.OnEnterhandler)
    def setOnExit(self,handler):
        self.OnExithandler=PyMinMod.TWinControlsetOnExit(handler,self.pointer,self.OnExithandler)
#class TWinControl end
#class TCustomControl start
class TCustomControl(TWinControl):
    def __init__(self):#TCustomControl
        self.OnPainthandler=-1
        TWinControl.__init__(self)
    def setOnPaint(self,handler):
        self.OnPainthandler=PyMinMod.TCustomControlsetOnPaint(handler,self.pointer,self.OnPainthandler)
#class TCustomControl end
#class TGraphicControl start
class TGraphicControl(TControl):
    def __init__(self):#TGraphicControl
        TControl.__init__(self)
#class TGraphicControl end
