import PyMinMod
import os
import re
class Application:
	def find_element(p,t):
		i = 0
		for e in p:
			if e == t:
				return i
			else:
				i +=1
		return -1
	@staticmethod
	def CreateForm(formclass,filename):
		form=formclass()
		allatr=dir(form)
		separated=''
		for str in allatr:
			separated=separated+'*'+str
		with open(filename) as f:
			lines = f.readlines()
		newlines=[]
		eventslist=[]
		eventsobjlist=[]
		eventscalllist=[]
		for str in lines:
			newstr=str.strip()
			if not newstr.startswith("On"):
				newlines.append(str)
			if  newstr.startswith("object"):
				cobject=re.split(': ',str)[0]
				cobject=cobject.split()[1]
				print(cobject)
			if  newstr.startswith("On"):
				ev=re.split('=',str)[0]
				print(ev)
				evcall=re.split(': ',str)[1]
				print(evcall)
				eventslist.append(ev)
				eventscalllist.append(evcall)
				eventsobjlist.append(cobject)				
		newlfmfile=open("temp.lfm",'w')
		for str in newlines:
			newlfmfile.write("%s" % str)
		newlfmfile.close()
		pointerstr=PyMinMod.Create_FormLfm("temp.lfm",separated)
		pointerstrlist=pointerstr.split('*')
		i=0
		while i<len(allatr):
			str=pointerstrlist[i+1]
			p=int(str)
			if p>-1:
				getattr(form,allatr[i]).pointer=p
			i=i+1
		form.pointer=int(0)
		print 'end load lfm'
		i=0
		#while i<len(eventslist):
			#if not hasattr(form,eventscalllist[i]):
				#print "form dont hav callback %s" % eventscalllist[i]
				#continue
			#if not hasattr(form,eventsobjlist[i]):
				#print "form dont hav callback %s" % eventscalllist[i]
				#continue
			#evobj=getattr(form,eventsobjlist[i])
			#if not hasattr(evobj,"set"+eventslist[i]):
				#print "obj dont have set event %s" % eventscalllist[i]
				#continue
			#setev=getattr(evobj,"set"+eventslist[i])
			#setev(getattr(form,eventscalllist[i]))
			#i=i+1
		return form
	@staticmethod
	def Run():
		r=PyMinMod.Application_Run()
		r=r+1
				
		
		
		
        
