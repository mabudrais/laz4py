class TLCLComponent():
    pointer=-1
    def DestroyHandle(self):
        r=PyMinMod.TLCLComponentDestroyHandle(self.pointer)
    def HandleAllocated(self):
        r=PyMinMod.TLCLComponentHandleAllocated(self.pointer)
        return r
    def IsRightToLeft(self):
        r=PyMinMod.TLCLComponentIsRightToLeft(self.pointer)
        return r
    def UseRightToLeftAlignment(self):
        r=PyMinMod.TLCLComponentUseRightToLeftAlignment(self.pointer)
        return r
    def UseRightToLeftReading(self):
        r=PyMinMod.TLCLComponentUseRightToLeftReading(self.pointer)
        return r
    def HandleNeeded(self):
        r=PyMinMod.TLCLComponentHandleNeeded(self.pointer)
    def setParentBidiMode(self,a1):
        r=PyMinMod.TLCLComponentsetParentBidiMode(self.pointer,a1)
    def getParentBidiMode(self):
        r=PyMinMod.TLCLComponentgetParentBidiMode(self.pointer)
        return r
    ParentBidiMode=property(getParentBidiMode,setParentBidiMode)
