from TCustomFormunit import*
class TForm(TCustomForm):
    def Tile(self):
        r=PyMinMod.TFormTile(self.pointer)
    def setLCLVersion(self,a1):
        r=PyMinMod.TFormsetLCLVersion(self.pointer,a1)
    def getLCLVersion(self):
        r=PyMinMod.TFormgetLCLVersion(self.pointer)
        return r
    LCLVersion=property(getLCLVersion,setLCLVersion)
