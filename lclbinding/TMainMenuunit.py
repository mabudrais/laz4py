from TMenuunit import*
class TMainMenu(TMenu):
    def getHeight(self):
        r=PyMinMod.TMainMenugetHeight(self.pointer)
        return r
