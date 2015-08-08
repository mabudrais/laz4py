from TLCLComponentunit import*
class TMenu(TLCLComponent):
    def DestroyHandle(self):
        r=PyMinMod.TMenuDestroyHandle(self.pointer)
    def HandleAllocated(self):
        r=PyMinMod.TMenuHandleAllocated(self.pointer)
        return r
    def IsRightToLeft(self):
        r=PyMinMod.TMenuIsRightToLeft(self.pointer)
        return r
    def UseRightToLeftAlignment(self):
        r=PyMinMod.TMenuUseRightToLeftAlignment(self.pointer)
        return r
    def UseRightToLeftReading(self):
        r=PyMinMod.TMenuUseRightToLeftReading(self.pointer)
        return r
    def HandleNeeded(self):
        r=PyMinMod.TMenuHandleNeeded(self.pointer)
    def setParentBidiMode(self,a1):
        r=PyMinMod.TMenusetParentBidiMode(self.pointer,a1)
    def getParentBidiMode(self):
        r=PyMinMod.TMenugetParentBidiMode(self.pointer)
        return r
    ParentBidiMode=property(getParentBidiMode,setParentBidiMode)
