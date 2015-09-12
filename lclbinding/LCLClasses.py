import PyMinMod
from classesh import*
#import end
#class TLCLComponent start
class TLCLComponent(TComponent):
    def __init__(self):#TLCLComponent
        TComponent.__init__(self)
    def RemoveAllHandlersOfObject(self,AnObject):
        r=PyMinMod.TLCLComponentRemoveAllHandlersOfObject(self.pointer,AnObject.pointer)
    def IncLCLRefCount(self):
        r=PyMinMod.TLCLComponentIncLCLRefCount(self.pointer)
    def DecLCLRefCount(self):
        r=PyMinMod.TLCLComponentDecLCLRefCount(self.pointer)
    def getLCLRefCount(self):
        r=PyMinMod.TLCLComponentgetLCLRefCount(self.pointer)
        return r
#class TLCLComponent end
