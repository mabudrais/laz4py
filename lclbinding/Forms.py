import PyMinMod
#import end
#class TScrollingWinControl start
class TScrollingWinControl(TCustomControl):
    def __init__(self):#TScrollingWinControl
        TCustomControl.__init__(self)
    def UpdateScrollbars(self):
        r=PyMinMod.TScrollingWinControlUpdateScrollbars(self.pointer)
#class TScrollingWinControl end
#class TCustomForm start
class TCustomForm(TScrollingWinControl):
    def __init__(self):#TCustomForm
        self.OnShowhandler=-1
        self.OnHidehandler=-1
        self.OnDestroyhandler=-1
        self.OnDeactivatehandler=-1
        self.OnCreatehandler=-1
        self.OnActivatehandler=-1
        TScrollingWinControl.__init__(self)
    def AfterConstruction(self):
        r=PyMinMod.TCustomFormAfterConstruction(self.pointer)
    def BeforeDestruction(self):
        r=PyMinMod.TCustomFormBeforeDestruction(self.pointer)
    def Close(self):
        r=PyMinMod.TCustomFormClose(self.pointer)
    def CloseQuery(self):
        r=PyMinMod.TCustomFormCloseQuery(self.pointer)
    def DefocusControl(self,Control,Removing):
        r=PyMinMod.TCustomFormDefocusControl(self.pointer,Control.pointer,Removing)
    def DestroyWnd(self):
        r=PyMinMod.TCustomFormDestroyWnd(self.pointer)
    def EnsureVisible(self,AMoveToTop):
        r=PyMinMod.TCustomFormEnsureVisible(self.pointer,AMoveToTop)
    def FocusControl(self,WinControl):
        r=PyMinMod.TCustomFormFocusControl(self.pointer,WinControl.pointer)
    def FormIsUpdating(self):
        r=PyMinMod.TCustomFormFormIsUpdating(self.pointer)
    def Hide(self):
        r=PyMinMod.TCustomFormHide(self.pointer)
    def IntfHelp(self,AComponent):
        r=PyMinMod.TCustomFormIntfHelp(self.pointer,AComponent.pointer)
    def AutoSizeDelayedHandle(self):
        r=PyMinMod.TCustomFormAutoSizeDelayedHandle(self.pointer)
    def Release(self):
        r=PyMinMod.TCustomFormRelease(self.pointer)
    def CanFocus(self):
        r=PyMinMod.TCustomFormCanFocus(self.pointer)
    def SetFocus(self):
        r=PyMinMod.TCustomFormSetFocus(self.pointer)
    def SetFocusedControl(self,Control):
        r=PyMinMod.TCustomFormSetFocusedControl(self.pointer,Control.pointer)
    def SetRestoredBounds(self,ALeft,ATop,AWidth,AHeight):
        r=PyMinMod.TCustomFormSetRestoredBounds(self.pointer,ALeft,ATop,AWidth,AHeight)
    def Show(self):
        r=PyMinMod.TCustomFormShow(self.pointer)
    def ShowModal(self):
        r=PyMinMod.TCustomFormShowModal(self.pointer)
    def ShowOnTop(self):
        r=PyMinMod.TCustomFormShowOnTop(self.pointer)
    def RemoveAllHandlersOfObject(self,AnObject):
        r=PyMinMod.TCustomFormRemoveAllHandlersOfObject(self.pointer,AnObject.pointer)
    def ActiveMDIChild(self):
        r=PyMinMod.TCustomFormActiveMDIChild(self.pointer)
    def GetMDIChildren(self,AIndex):
        r=PyMinMod.TCustomFormGetMDIChildren(self.pointer,AIndex)
    def MDIChildCount(self):
        r=PyMinMod.TCustomFormMDIChildCount(self.pointer)
    def getActive(self):
        r=PyMinMod.TCustomFormgetActive(self.pointer)
        return r
    def setActiveControl(self,para0):
        r=PyMinMod.TCustomFormsetActiveControl(self.pointer,para0.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def getActiveControl(self):
        r=PyMinMod.TCustomFormgetActiveControl(self.pointer)
        obj=TWinControl()
        obj.pointer=r
        return obj
    def setActiveDefaultControl(self,para0):
        r=PyMinMod.TCustomFormsetActiveDefaultControl(self.pointer,para0.pointer)
        obj=TControl()
        obj.pointer=r
        return obj
    def getActiveDefaultControl(self):
        r=PyMinMod.TCustomFormgetActiveDefaultControl(self.pointer)
        obj=TControl()
        obj.pointer=r
        return obj
    def setAllowDropFiles(self,para0):
        r=PyMinMod.TCustomFormsetAllowDropFiles(self.pointer,para0)
        return r
    def getAllowDropFiles(self):
        r=PyMinMod.TCustomFormgetAllowDropFiles(self.pointer)
        return r
    def setAlphaBlend(self,para0):
        r=PyMinMod.TCustomFormsetAlphaBlend(self.pointer,para0)
        return r
    def getAlphaBlend(self):
        r=PyMinMod.TCustomFormgetAlphaBlend(self.pointer)
        return r
    def setCancelControl(self,para0):
        r=PyMinMod.TCustomFormsetCancelControl(self.pointer,para0.pointer)
        obj=TControl()
        obj.pointer=r
        return obj
    def getCancelControl(self):
        r=PyMinMod.TCustomFormgetCancelControl(self.pointer)
        obj=TControl()
        obj.pointer=r
        return obj
    def setDefaultControl(self,para0):
        r=PyMinMod.TCustomFormsetDefaultControl(self.pointer,para0.pointer)
        obj=TControl()
        obj.pointer=r
        return obj
    def getDefaultControl(self):
        r=PyMinMod.TCustomFormgetDefaultControl(self.pointer)
        obj=TControl()
        obj.pointer=r
        return obj
    def setDesignTimeDPI(self,para0):
        r=PyMinMod.TCustomFormsetDesignTimeDPI(self.pointer,para0)
        return r
    def getDesignTimeDPI(self):
        r=PyMinMod.TCustomFormgetDesignTimeDPI(self.pointer)
        return r
    def setHelpFile(self,para0):
        r=PyMinMod.TCustomFormsetHelpFile(self.pointer,para0)
        return r
    def getHelpFile(self):
        r=PyMinMod.TCustomFormgetHelpFile(self.pointer)
        return r
    def setKeyPreview(self,para0):
        r=PyMinMod.TCustomFormsetKeyPreview(self.pointer,para0)
        return r
    def getKeyPreview(self):
        r=PyMinMod.TCustomFormgetKeyPreview(self.pointer)
        return r
    def setMenu(self,para0):
        r=PyMinMod.TCustomFormsetMenu(self.pointer,para0.pointer)
        obj=TMainMenu()
        obj.pointer=r
        return obj
    def getMenu(self):
        r=PyMinMod.TCustomFormgetMenu(self.pointer)
        obj=TMainMenu()
        obj.pointer=r
        return obj
    def setPopupParent(self,para0):
        r=PyMinMod.TCustomFormsetPopupParent(self.pointer,para0.pointer)
        obj=TCustomForm()
        obj.pointer=r
        return obj
    def getPopupParent(self):
        r=PyMinMod.TCustomFormgetPopupParent(self.pointer)
        obj=TCustomForm()
        obj.pointer=r
        return obj
    def setOnActivate(self,handler):
        self.OnActivatehandler=PyMinMod.TCustomFormsetOnActivate(handler,self.pointer,self.OnActivatehandler)
    def setOnCreate(self,handler):
        self.OnCreatehandler=PyMinMod.TCustomFormsetOnCreate(handler,self.pointer,self.OnCreatehandler)
    def setOnDeactivate(self,handler):
        self.OnDeactivatehandler=PyMinMod.TCustomFormsetOnDeactivate(handler,self.pointer,self.OnDeactivatehandler)
    def setOnDestroy(self,handler):
        self.OnDestroyhandler=PyMinMod.TCustomFormsetOnDestroy(handler,self.pointer,self.OnDestroyhandler)
    def setOnHide(self,handler):
        self.OnHidehandler=PyMinMod.TCustomFormsetOnHide(handler,self.pointer,self.OnHidehandler)
    def setOnShow(self,handler):
        self.OnShowhandler=PyMinMod.TCustomFormsetOnShow(handler,self.pointer,self.OnShowhandler)
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
#class TCustomForm end
#class TForm start
class TForm(TCustomForm):
    def __init__(self):#TForm
        self.OnMouseLeavehandler=-1
        self.OnMouseEnterhandler=-1
        self.OnDblClickhandler=-1
        TCustomForm.__init__(self)
    def Create(self,TheOwner):
        r=PyMinMod.TFormCreate(self.pointer,TheOwner.pointer)
        obj=TForm()
        obj.pointer=r
        return obj
    def Tile(self):
        r=PyMinMod.TFormTile(self.pointer)
    def setAutoScroll(self,para0):
        r=PyMinMod.TFormsetAutoScroll(self.pointer,para0)
        return r
    def getAutoScroll(self):
        r=PyMinMod.TFormgetAutoScroll(self.pointer)
        return r
    def setOnDblClick(self,handler):
        self.OnDblClickhandler=PyMinMod.TFormsetOnDblClick(handler,self.pointer,self.OnDblClickhandler)
    def setOnMouseEnter(self,handler):
        self.OnMouseEnterhandler=PyMinMod.TFormsetOnMouseEnter(handler,self.pointer,self.OnMouseEnterhandler)
    def setOnMouseLeave(self,handler):
        self.OnMouseLeavehandler=PyMinMod.TFormsetOnMouseLeave(handler,self.pointer,self.OnMouseLeavehandler)
    def setParentFont(self,para0):
        r=PyMinMod.TFormsetParentFont(self.pointer,para0)
        return r
    def getParentFont(self):
        r=PyMinMod.TFormgetParentFont(self.pointer)
        return r
    def setSessionProperties(self,para0):
        r=PyMinMod.TFormsetSessionProperties(self.pointer,para0)
        return r
    def getSessionProperties(self):
        r=PyMinMod.TFormgetSessionProperties(self.pointer)
        return r
    def setLCLVersion(self,para0):
        r=PyMinMod.TFormsetLCLVersion(self.pointer,para0)
        return r
    def getLCLVersion(self):
        r=PyMinMod.TFormgetLCLVersion(self.pointer)
        return r
#class TForm end
