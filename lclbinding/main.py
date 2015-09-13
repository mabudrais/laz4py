import lclaplication
import unit1
import PyMinMod
app=lclaplication.Application()
lfmfile='G:\dev\laz4py\laz4py3\streamtest\unit2.lfm'
form1=app.CreateForm3(unit1.TForm1,lfmfile)
#x=form1.Button1.getWidth
#form1.Button1.setWidth(200)
#form1.setWidth(900)
form1.Button1.setOnClick(form1.onlic)
form1.MenuItem2.setOnClick(form1.onopenfile)
app.Run()
