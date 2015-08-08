from TWinControlunit import*
class TCustomScrollBar(TWinControl):
    def SetParams(self,APageSize,AMax,AMin,APosition):
        r=PyMinMod.TCustomScrollBarSetParams(self.pointer,APageSize,AMax,AMin,APosition)
    def setMax(self,a1):
        r=PyMinMod.TCustomScrollBarsetMax(self.pointer,a1)
    def getMax(self):
        r=PyMinMod.TCustomScrollBargetMax(self.pointer)
        return r
    Max=property(getMax,setMax)
    def setMin(self,a1):
        r=PyMinMod.TCustomScrollBarsetMin(self.pointer,a1)
    def getMin(self):
        r=PyMinMod.TCustomScrollBargetMin(self.pointer)
        return r
    Min=property(getMin,setMin)
    def setPageSize(self,a1):
        r=PyMinMod.TCustomScrollBarsetPageSize(self.pointer,a1)
    def getPageSize(self):
        r=PyMinMod.TCustomScrollBargetPageSize(self.pointer)
        return r
    PageSize=property(getPageSize,setPageSize)
    def setPosition(self,a1):
        r=PyMinMod.TCustomScrollBarsetPosition(self.pointer,a1)
    def getPosition(self):
        r=PyMinMod.TCustomScrollBargetPosition(self.pointer)
        return r
    Position=property(getPosition,setPosition)
    def setOnChange(self,event_handler):
        PyMinMod.setTNotifyEvent(event_handler,self.pointer)
