import PyMinMod
#import end
class TObject:
    def __init__(self):
        self.pointer=-1
#class TComponent start
class TComponent(TObject):
    def __init__(self):#TComponent
        TObject.__init__(self)
    def BeforeDestruction(self):
        r=PyMinMod.TComponentBeforeDestruction(self.pointer)
    def DestroyComponents(self):
        r=PyMinMod.TComponentDestroyComponents(self.pointer)
    def Destroying(self):
        r=PyMinMod.TComponentDestroying(self.pointer)
    def FindComponent(self,AName):
        r=PyMinMod.TComponentFindComponent(self.pointer,AName)
    def FreeNotification(self,AComponent):
        r=PyMinMod.TComponentFreeNotification(self.pointer,AComponent.pointer)
    def RemoveFreeNotification(self,AComponent):
        r=PyMinMod.TComponentRemoveFreeNotification(self.pointer,AComponent.pointer)
    def FreeOnRelease(self):
        r=PyMinMod.TComponentFreeOnRelease(self.pointer)
    def GetNamePath(self):
        r=PyMinMod.TComponentGetNamePath(self.pointer)
    def GetParentComponent(self):
        r=PyMinMod.TComponentGetParentComponent(self.pointer)
    def HasParent(self):
        r=PyMinMod.TComponentHasParent(self.pointer)
    def InsertComponent(self,AComponent):
        r=PyMinMod.TComponentInsertComponent(self.pointer,AComponent.pointer)
    def RemoveComponent(self,AComponent):
        r=PyMinMod.TComponentRemoveComponent(self.pointer,AComponent.pointer)
    def SetSubComponent(self,ASubComponent):
        r=PyMinMod.TComponentSetSubComponent(self.pointer,ASubComponent)
    def getComponents(self,indexedpara0):
        r=PyMinMod.TComponentgetComponents(self.pointer,indexedpara0)
        obj=TComponent()
        obj.pointer=r
        return obj
    def getComponentCount(self):
        r=PyMinMod.TComponentgetComponentCount(self.pointer)
        return r
    def setComponentIndex(self,para0):
        r=PyMinMod.TComponentsetComponentIndex(self.pointer,para0)
        return r
    def getComponentIndex(self):
        r=PyMinMod.TComponentgetComponentIndex(self.pointer)
        return r
    def getOwner(self):
        r=PyMinMod.TComponentgetOwner(self.pointer)
        obj=TComponent()
        obj.pointer=r
        return obj
#class TComponent end
#class TStrings start
class TStrings(TObject):
    def __init__(self):#TStrings
        TObject.__init__(self)
    def Add(self,S):
        r=PyMinMod.TStringsAdd(self.pointer,S)
    def AddObject(self,S,AObject):
        r=PyMinMod.TStringsAddObject(self.pointer,S,AObject.pointer)
    def Append(self,S):
        r=PyMinMod.TStringsAppend(self.pointer,S)
    def AddStrings(self,TheStrings):
        r=PyMinMod.TStringsAddStrings(self.pointer,TheStrings.pointer)
    def BeginUpdate(self):
        r=PyMinMod.TStringsBeginUpdate(self.pointer)
    def Clear(self):
        r=PyMinMod.TStringsClear(self.pointer)
    def Delete(self,Index):
        r=PyMinMod.TStringsDelete(self.pointer,Index)
    def EndUpdate(self):
        r=PyMinMod.TStringsEndUpdate(self.pointer)
    def Equals(self,Obj):
        r=PyMinMod.TStringsEquals(self.pointer,Obj.pointer)
    def Exchange(self,Index1,Index2):
        r=PyMinMod.TStringsExchange(self.pointer,Index1,Index2)
    def IndexOf(self,S):
        r=PyMinMod.TStringsIndexOf(self.pointer,S)
    def IndexOfName(self,Name):
        r=PyMinMod.TStringsIndexOfName(self.pointer,Name)
    def IndexOfObject(self,AObject):
        r=PyMinMod.TStringsIndexOfObject(self.pointer,AObject.pointer)
    def Insert(self,Index,S):
        r=PyMinMod.TStringsInsert(self.pointer,Index,S)
    def LoadFromFile(self,FileName):
        r=PyMinMod.TStringsLoadFromFile(self.pointer,FileName)
    def Move(self,CurIndex,NewIndex):
        r=PyMinMod.TStringsMove(self.pointer,CurIndex,NewIndex)
    def SaveToFile(self,FileName):
        r=PyMinMod.TStringsSaveToFile(self.pointer,FileName)
    def GetNameValue(self,Index,AName,AValue):
        r=PyMinMod.TStringsGetNameValue(self.pointer,Index,AName,AValue)
    def setValueFromIndex(self,para0,indexedpara0):
        r=PyMinMod.TStringssetValueFromIndex(self.pointer,para0,indexedpara0)
        return r
    def getValueFromIndex(self,indexedpara0):
        r=PyMinMod.TStringsgetValueFromIndex(self.pointer,indexedpara0)
        return r
    def setCapacity(self,para0):
        r=PyMinMod.TStringssetCapacity(self.pointer,para0)
        return r
    def getCapacity(self):
        r=PyMinMod.TStringsgetCapacity(self.pointer)
        return r
    def setCommaText(self,para0):
        r=PyMinMod.TStringssetCommaText(self.pointer,para0)
        return r
    def getCommaText(self):
        r=PyMinMod.TStringsgetCommaText(self.pointer)
        return r
    def getCount(self):
        r=PyMinMod.TStringsgetCount(self.pointer)
        return r
    def getNames(self,indexedpara0):
        r=PyMinMod.TStringsgetNames(self.pointer,indexedpara0)
        return r
    def setObjects(self,para0,indexedpara0):
        r=PyMinMod.TStringssetObjects(self.pointer,para0.pointer,indexedpara0)
        obj=TObject()
        obj.pointer=r
        return obj
    def getObjects(self,indexedpara0):
        r=PyMinMod.TStringsgetObjects(self.pointer,indexedpara0)
        obj=TObject()
        obj.pointer=r
        return obj
    def setValues(self,para0,indexedpara0):
        r=PyMinMod.TStringssetValues(self.pointer,para0,indexedpara0)
        return r
    def getValues(self,indexedpara0):
        r=PyMinMod.TStringsgetValues(self.pointer,indexedpara0)
        return r
    def setStrings(self,para0,indexedpara0):
        r=PyMinMod.TStringssetStrings(self.pointer,para0,indexedpara0)
        return r
    def getStrings(self,indexedpara0):
        r=PyMinMod.TStringsgetStrings(self.pointer,indexedpara0)
        return r
    def setText(self,para0):
        r=PyMinMod.TStringssetText(self.pointer,para0)
        return r
    def getText(self):
        r=PyMinMod.TStringsgetText(self.pointer)
        return r
#class TStrings end
