Framework brl.standardio
Import hez.log

Local logger:TLogger = New TLogger("my_log.txt")
Local myLogWriter:TLogWriter = New TLogWriter("Test Writer", logger)

myLogWriter.Write("Hello World!")
myLogWriter.Write("WARNING!", ELogSeverity.Warn) ' 