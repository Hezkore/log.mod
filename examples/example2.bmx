' Example of sections, getting lines and message severity

Framework brl.standardio
Import hez.log

Local logger:TLogger = New TLogger("my_log.txt")
Local myLogWriter:TLogWriter = New TLogWriter("Test Writer", logger)
Local myLogWriter2:TLogWriter = New TLogWriter("Test2 Writer", logger)

myLogWriter.Write("Fatal",ELogSeverity.Fatal)
myLogWriter.Write("Error",ELogSeverity.Error)
myLogWriter.Write("Warn",ELogSeverity.Warn)
myLogWriter.Write("Info",ELogSeverity.Info)
myLogWriter.Write("Debug",ELogSeverity.Debug)
myLogWriter.Write("Trace",ELogSeverity.Trace)

myLogWriter.Section("Lines!")

myLogWriter.Write("Line ",ELogSeverity.Warn)
myLogWriter2.Write("Line ",ELogSeverity.Warn)
myLogWriter.Append("1")
myLogWriter2.Append("2")
myLogWriter.Write("Line ",ELogSeverity.Info)
myLogWriter2.Write("Line ",ELogSeverity.Info)
myLogWriter.Append("3")
myLogWriter2.Append("4")
myLogWriter.Write("Line ")
myLogWriter2.Write("Line ")
myLogWriter.Append("5")
myLogWriter2.Append("6")

' We can also print the log
' Get the last 7 lines
For Local l:TLogLine = EachIn logger.GetLines(7)
	'Print l.FullString()
	If l.IsSection() Then
		Print "New Section: " + l.ToString()
	Else
		Print "From " + l.Parent().Name + " at " + l.Time() + " [" + l.Severity.ToString() + "] " + l.ToString()
	EndIf
Next