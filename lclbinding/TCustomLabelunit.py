from TGraphicControlunit import*
class TCustomLabel(TGraphicControl):
    def ColorIsStored(self):
        r=PyMinMod.TCustomLabelColorIsStored(self.pointer)
        return r
    def AdjustFontForOptimalFill(self):
        r=PyMinMod.TCustomLabelAdjustFontForOptimalFill(self.pointer)
        return r
    def Paint(self):
        r=PyMinMod.TCustomLabelPaint(self.pointer)
    def SetBounds(self,aHeight,aWidth,aTop,aLeft):
        r=PyMinMod.TCustomLabelSetBounds(self.pointer,aHeight,aWidth,aTop,aLeft)
