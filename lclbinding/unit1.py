#!/usr/bin/env python
# -*- coding: utf-8 -*-
from StdCtrls import*
class TForm1:
	def __init__(self):
		self.Button1=TButton()
		self.Memo1=TMemo()
		self.Edit1=TEdit()
		self.CheckBox1=TCheckBox()
		self.Label1=TLabel()
	def onlic(self,u):
		print 'hghgh'#self.Button1.getWidth()
		self.Button1.setWidth(100)
		self.Button1.setTop(self.Button1.getTop()+8)
		self.Button1.setCaption(str(self.Button1.getTop()))
		self.Edit1.setCaption('hello')
		if self.CheckBox1.getChecked():
                	self.Edit1.setCaption('welcome')
		self.Memo1.getLines().Append('lll')
		print self.Memo1.getLines().getStrings(0)
		#self.Edit1.setCaption(self.Memo1.getLines().getStrings(0))
		self.Label1.setCaption(str(self.Memo1.getLines().getCount()))
