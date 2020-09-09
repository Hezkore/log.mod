Framework brl.standardio
Import hez.log

Local logger:TLogger = New TLogger("my_log.txt")
Local myLogWriter:TLogWriter = New TLogWriter("Test Writer", logger)
Local myLogWriter2:TLogWriter = New TLogWriter("Test2 Writer", logger)

myLogWriter.Write("Hello ")
myLogWriter2.Write("Warning")
myLogWriter.Append("World!")
myLogWriter2.Append(" Message")
myLogWriter.Append(" How")
myLogWriter.Append(" are ")
myLogWriter.Append("you?")

Print(logger.ToString())