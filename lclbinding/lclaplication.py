import PyMinMod
import os
class Application:
	def find_element(p,t):
		i = 0
		for e in p:
			if e == t:
				return i
			else:
				i +=1
		return -1
	def CreateForm(self,formclass,filename):
		form=formclass()
		allatr=dir(form)
		separated=''
		for str in allatr:
			separated=separated+'*'+str
		pointerstr=PyMinMod.Create_FormLfm(filename,separated)
		pointerstrlist=pointerstr.split('*')
		i=0
		while i<len(allatr):
			str=pointerstrlist[i+1]
			p=int(str)
			if p>-1:
				getattr(form,allatr[i]).pointer=p
			i=i+1
		form.pointer=int(0)
		with open('ev'+os.sep+'TControl.txt') as f:
			lines = f.readlines()
		return form
	def Run(self):
		PyMinMod.Application_Run()
				
		
		
		
        
