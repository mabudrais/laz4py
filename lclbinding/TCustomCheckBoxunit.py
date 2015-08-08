from TButtonControlunit import*
class TCustomCheckBox(TButtonControl):
    def setAllowGrayed(self,a1):
        r=PyMinMod.TCustomCheckBoxsetAllowGrayed(self.pointer,a1)
    def getAllowGrayed(self):
        r=PyMinMod.TCustomCheckBoxgetAllowGrayed(self.pointer)
        return r
    AllowGrayed=property(getAllowGrayed,setAllowGrayed)
