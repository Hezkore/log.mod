Framework brl.standardio
Import hez.log

Local logger:TLogger = New TLogger("my_log.txt")
Local myLogWriter:TLogWriter = New TLogWriter("Test Writer", logger)
Local myLogWriter2:TLogWriter = New TLogWriter("Test2 Writer", logger)

myLogWriter.Write(ELogSeverity.Debug, "Hello ")
myLogWriter2.Write(ELogSeverity.Debug, "Warning")
myLogWriter.Write(ELogSeverity.Debug, "World!", False)
'myLogWriter2.Write(ELogSeverity.Debug, " Message", False)

logger.Print()