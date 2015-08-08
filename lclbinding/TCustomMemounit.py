from TCustomEditunit import*
class TCustomMemo(TCustomEdit):
    def setWantReturns(self,a1):
        r=PyMinMod.TCustomMemosetWantReturns(self.pointer,a1)
    def getWantReturns(self):
        r=PyMinMod.TCustomMemogetWantReturns(self.pointer)
        return r
    WantReturns=property(getWantReturns,setWantReturns)
    def setWantTabs(self,a1):
        r=PyMinMod.TCustomMemosetWantTabs(self.pointer,a1)
    def getWantTabs(self):
        r=PyMinMod.TCustomMemogetWantTabs(self.pointer)
        return r
    WantTabs=property(getWantTabs,setWantTabs)
    def setWordWrap(self,a1):
        r=PyMinMod.TCustomMemosetWordWrap(self.pointer,a1)
    def getWordWrap(self):
        r=PyMinMod.TCustomMemogetWordWrap(self.pointer)
        return r
    WordWrap=property(getWordWrap,setWordWrap)
