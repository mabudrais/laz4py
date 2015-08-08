from TControlunit import*
class TWinControl(TControl):
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
    def getDockClientCount(self):
        r=PyMinMod.TWinControlgetDockClientCount(self.pointer)
        return r
    def setDockSite(self,a1):
        r=PyMinMod.TWinControlsetDockSite(self.pointer,a1)
    def getDockSite(self):
        r=PyMinMod.TWinControlgetDockSite(self.pointer)
        return r
    DockSite=property(getDockSite,setDockSite)
    def setDoubleBuffered(self,a1):
        r=PyMinMod.TWinControlsetDoubleBuffered(self.pointer,a1)
    def getDoubleBuffered(self):
        r=PyMinMod.TWinControlgetDoubleBuffered(self.pointer)
        return r
    DoubleBuffered=property(getDoubleBuffered,setDoubleBuffered)
    def getIsResizing(self):
        r=PyMinMod.TWinControlgetIsResizing(self.pointer)
        return r
    def setTabStop(self,a1):
        r=PyMinMod.TWinControlsetTabStop(self.pointer,a1)
    def getTabStop(self):
        r=PyMinMod.TWinControlgetTabStop(self.pointer)
        return r
    TabStop=property(getTabStop,setTabStop)
    def setOnEnter(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnExit(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def getShowing(self):
        r=PyMinMod.TWinControlgetShowing(self.pointer)
        return r
    def setDesignerDeleting(self,a1):
        r=PyMinMod.TWinControlsetDesignerDeleting(self.pointer,a1)
    def getDesignerDeleting(self):
        r=PyMinMod.TWinControlgetDesignerDeleting(self.pointer)
        return r
    DesignerDeleting=property(getDesignerDeleting,setDesignerDeleting)
    def AutoSizeDelayed(self):
        r=PyMinMod.TWinControlAutoSizeDelayed(self.pointer)
        return r
    def AutoSizeDelayedReport(self):
        r=PyMinMod.TWinControlAutoSizeDelayedReport(self.pointer)
        return r
    def AutoSizeDelayedHandle(self):
        r=PyMinMod.TWinControlAutoSizeDelayedHandle(self.pointer)
        return r
    def BeginUpdateBounds(self):
        r=PyMinMod.TWinControlBeginUpdateBounds(self.pointer)
    def EndUpdateBounds(self):
        r=PyMinMod.TWinControlEndUpdateBounds(self.pointer)
    def LockRealizeBounds(self):
        r=PyMinMod.TWinControlLockRealizeBounds(self.pointer)
    def UnlockRealizeBounds(self):
        r=PyMinMod.TWinControlUnlockRealizeBounds(self.pointer)
    def DoAdjustClientRectChange(self,InvalidateRect):
        r=PyMinMod.TWinControlDoAdjustClientRectChange(self.pointer,InvalidateRect)
    def InvalidateClientRectCache(self,WithChildControls):
        r=PyMinMod.TWinControlInvalidateClientRectCache(self.pointer,WithChildControls)
    def ClientRectNeedsInterfaceUpdate(self):
        r=PyMinMod.TWinControlClientRectNeedsInterfaceUpdate(self.pointer)
        return r
    def SetBounds(self,AHeight,AWidth,ATop,ALeft):
        r=PyMinMod.TWinControlSetBounds(self.pointer,AHeight,AWidth,ATop,ALeft)
    def DisableAlign(self):
        r=PyMinMod.TWinControlDisableAlign(self.pointer)
    def EnableAlign(self):
        r=PyMinMod.TWinControlEnableAlign(self.pointer)
    def ReAlign(self):
        r=PyMinMod.TWinControlReAlign(self.pointer)
    def ScrollBy(self,DeltaY,DeltaX):
        r=PyMinMod.TWinControlScrollBy(self.pointer,DeltaY,DeltaX)
    def WriteLayoutDebugReport(self,Prefix):
        r=PyMinMod.TWinControlWriteLayoutDebugReport(self.pointer,Prefix)
    def CanFocus(self):
        r=PyMinMod.TWinControlCanFocus(self.pointer)
        return r
    def Focused(self):
        r=PyMinMod.TWinControlFocused(self.pointer)
        return r
    def PerformTab(self,ForwardTab):
        r=PyMinMod.TWinControlPerformTab(self.pointer,ForwardTab)
        return r
    def BroadCast(self):
        r=PyMinMod.TWinControlBroadCast(self.pointer)
    def DefaultHandler(self):
        r=PyMinMod.TWinControlDefaultHandler(self.pointer)
    def GetTextLen(self):
        r=PyMinMod.TWinControlGetTextLen(self.pointer)
        return r
    def Invalidate(self):
        r=PyMinMod.TWinControlInvalidate(self.pointer)
    def AddControl(self):
        r=PyMinMod.TWinControlAddControl(self.pointer)
    def Repaint(self):
        r=PyMinMod.TWinControlRepaint(self.pointer)
    def Update(self):
        r=PyMinMod.TWinControlUpdate(self.pointer)
    def SetFocus(self):
        r=PyMinMod.TWinControlSetFocus(self.pointer)
    def FlipChildren(self,AllLevels):
        r=PyMinMod.TWinControlFlipChildren(self.pointer,AllLevels)
    def ScaleBy(self,Divider,Multiplier):
        r=PyMinMod.TWinControlScaleBy(self.pointer,Divider,Multiplier)
    def HandleAllocated(self):
        r=PyMinMod.TWinControlHandleAllocated(self.pointer)
        return r
    def ParentHandlesAllocated(self):
        r=PyMinMod.TWinControlParentHandlesAllocated(self.pointer)
        return r
    def HandleNeeded(self):
        r=PyMinMod.TWinControlHandleNeeded(self.pointer)
    def BrushCreated(self):
        r=PyMinMod.TWinControlBrushCreated(self.pointer)
        return r
