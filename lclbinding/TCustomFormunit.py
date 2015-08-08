from TScrollingWinControlunit import*
class TCustomForm(TScrollingWinControl):
    def AfterConstruction(self):
        r=PyMinMod.TCustomFormAfterConstruction(self.pointer)
    def BeforeDestruction(self):
        r=PyMinMod.TCustomFormBeforeDestruction(self.pointer)
    def Close(self):
        r=PyMinMod.TCustomFormClose(self.pointer)
    def CloseQuery(self):
        r=PyMinMod.TCustomFormCloseQuery(self.pointer)
        return r
    def DestroyWnd(self):
        r=PyMinMod.TCustomFormDestroyWnd(self.pointer)
    def EnsureVisible(self,AMoveToTop):
        r=PyMinMod.TCustomFormEnsureVisible(self.pointer,AMoveToTop)
    def FormIsUpdating(self):
        r=PyMinMod.TCustomFormFormIsUpdating(self.pointer)
        return r
    def Hide(self):
        r=PyMinMod.TCustomFormHide(self.pointer)
    def AutoSizeDelayedHandle(self):
        r=PyMinMod.TCustomFormAutoSizeDelayedHandle(self.pointer)
        return r
    def Release(self):
        r=PyMinMod.TCustomFormRelease(self.pointer)
    def CanFocus(self):
        r=PyMinMod.TCustomFormCanFocus(self.pointer)
        return r
    def SetFocus(self):
        r=PyMinMod.TCustomFormSetFocus(self.pointer)
    def SetRestoredBounds(self,AHeight,AWidth,ATop,ALeft):
        r=PyMinMod.TCustomFormSetRestoredBounds(self.pointer,AHeight,AWidth,ATop,ALeft)
    def Show(self):
        r=PyMinMod.TCustomFormShow(self.pointer)
    def ShowModal(self):
        r=PyMinMod.TCustomFormShowModal(self.pointer)
        return r
    def ShowOnTop(self):
        r=PyMinMod.TCustomFormShowOnTop(self.pointer)
    def MDIChildCount(self):
        r=PyMinMod.TCustomFormMDIChildCount(self.pointer)
        return r
    def getActive(self):
        r=PyMinMod.TCustomFormgetActive(self.pointer)
        return r
    def setAllowDropFiles(self,a1):
        r=PyMinMod.TCustomFormsetAllowDropFiles(self.pointer,a1)
    def getAllowDropFiles(self):
        r=PyMinMod.TCustomFormgetAllowDropFiles(self.pointer)
        return r
    AllowDropFiles=property(getAllowDropFiles,setAllowDropFiles)
    def setAlphaBlend(self,a1):
        r=PyMinMod.TCustomFormsetAlphaBlend(self.pointer,a1)
    def getAlphaBlend(self):
        r=PyMinMod.TCustomFormgetAlphaBlend(self.pointer)
        return r
    AlphaBlend=property(getAlphaBlend,setAlphaBlend)
    def setDesignTimeDPI(self,a1):
        r=PyMinMod.TCustomFormsetDesignTimeDPI(self.pointer,a1)
    def getDesignTimeDPI(self):
        r=PyMinMod.TCustomFormgetDesignTimeDPI(self.pointer)
        return r
    DesignTimeDPI=property(getDesignTimeDPI,setDesignTimeDPI)
    def setHelpFile(self,a1):
        r=PyMinMod.TCustomFormsetHelpFile(self.pointer,a1)
    def getHelpFile(self):
        r=PyMinMod.TCustomFormgetHelpFile(self.pointer)
        return r
    HelpFile=property(getHelpFile,setHelpFile)
    def setKeyPreview(self,a1):
        r=PyMinMod.TCustomFormsetKeyPreview(self.pointer,a1)
    def getKeyPreview(self):
        r=PyMinMod.TCustomFormgetKeyPreview(self.pointer)
        return r
    KeyPreview=property(getKeyPreview,setKeyPreview)
    def setOnActivate(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnCreate(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnDeactivate(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnDestroy(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnHide(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnShow(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def getRestoredLeft(self):
        r=PyMinMod.TCustomFormgetRestoredLeft(self.pointer)
        return r
    def getRestoredTop(self):
        r=PyMinMod.TCustomFormgetRestoredTop(self.pointer)
        return r
    def getRestoredWidth(self):
        r=PyMinMod.TCustomFormgetRestoredWidth(self.pointer)
        return r
    def getRestoredHeight(self):
        r=PyMinMod.TCustomFormgetRestoredHeight(self.pointer)
        return r
