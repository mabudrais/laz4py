from TMenuunit import*
class TPopupMenu(TMenu):
    def PopUp(self):
        r=PyMinMod.TPopupMenuPopUp(self.pointer)
    def PopUp(self,Y,X):
        r=PyMinMod.TPopupMenuPopUp(self.pointer,Y,X)
    def setAutoPopup(self,a1):
        r=PyMinMod.TPopupMenusetAutoPopup(self.pointer,a1)
    def getAutoPopup(self):
        r=PyMinMod.TPopupMenugetAutoPopup(self.pointer)
        return r
    AutoPopup=property(getAutoPopup,setAutoPopup)
    def setOnPopup(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
    def setOnClose(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
