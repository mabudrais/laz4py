from TButtonunit import*
class TForm1:
	def __init__(self):
		self.Button1=TButton()
		#self.Memo1=TMemo()
		#self.Button1.getActive()
	def onlic(self):
		print self.Button1.Width
		self.Button1.setWidth(self.Button1.getWidth()+10)
		self.Button1.setTop(self.Button1.getTop()+8)
		v=self.Button1.getCaption()
		print v
