SuperStrict

Framework brl.standardio
Import brl.linkedlist

rem
bbdoc: Logging
about:
Log and save informational messages
endrem
Module hez.log

ModuleInfo "Author: Rob C."
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 Rob C."

' Dependencies
Import brl.standardio
Import brl.collections
Import brl.stringbuilder
Import brl.system

Type TLogger
	
	Field Path:String
	Field AutoFlush:Int = True
	Field MaxLines:Int
	
	Method New(path:String, maxLines:Int = 100)
		Self.Path = path
		Self.MaxLines = maxLines
		Self.Stream = WriteStream(path)
		Self.Stream.WriteString(CurrentDate() + " " + CurrentTime())
	EndMethod
	
	Method Flush(force:Int = False)
		If Not Self.Stream Return
		If Not force And Not Self.Dirty Return
		Self.Dirty = False
		Self.Stream.Flush()
	EndMethod
	
	Method GetLines:TLogLine[](range:Long)
		Local rl:TLogLine[range+1]
		Local count:Long
		Local skip:Long = Self.Lines.Count() - range
		For Local l:TLogLine = EachIn Self.Lines
			If skip > 0 Then
				skip:-1
				Continue
			EndIf
			rl[count] = l
			count:+1
		Next
		Return rl
	EndMethod
	
	Method ToString:String()
		If Self.Lines.Count() <= 0 Return ""
		Local str:String
		For Local l:TLogLine = EachIn Self.Lines
			str:+l.ToString() + "~n"
		Next
		If Not str Return ""
		Return str[..str.Length-1]
	EndMethod
	
	Private
		Field NextLineIndex:Long
		Field Dirty:Int
		Field Lines:TQueue<TLogLine> = New TQueue<TLogLine>
		Field Stream:TStream
		
		Method New()
		EndMethod
		
		Method TrimQueue()
			If Self.Lines.Size <= 0 Return
			Local DequeueLine:TLogLine
			While Self.Lines.Size > Self.MaxLines
				DequeueLine = Self.Lines.Dequeue()
				If DequeueLine.Parent().LastLine = DequeueLine..
					DequeueLine.Parent().LastLine = Null
			Wend
		EndMethod
	Public
EndType

Type TLogWriter
	
	Field Name:String
	Field Logger:TLogger
	Field LastLine:TLogLine
	Field LastSeverity:ELogSeverity
	
	Method New(name:String, logger:TLogger)
		Self.Name = name
		Self.Logger = logger
	EndMethod
	
	Method Append(message:String)
		If Not Self.Logger Or Not Self.Logger.Stream Return
		If Not Self.LastLine And Self.LastSeverity Then
			Self.Write(message, Self.LastSeverity)
			Return
		EndIf
		
		Self.Logger.Stream.Seek(Self.LastLine._seekPos + 1 + Self.LastLine._text.Length())
		Self.LastLine._text.Append(message)
		Self.Logger.Stream.WriteString(message)
		
		For Local l:TLogLine = EachIn Self.Logger.Lines
			If l._seekPos <= Self.LastLine._seekPos Continue
			l._seekPos = Self.Logger.Stream.Pos()
			Self.Logger.Stream.WriteString("~n"+l.ToString())
		Next
		
		Self.Logger.Dirty = True
		If Self.Logger.AutoFlush Self.Logger.Flush()
	EndMethod
	
	Method Write(message:String, severity:ELogSeverity = ELogSeverity.Debug)
		If Not Self.Logger Or Not Self.Logger.Stream Return
		
		Self.LastLine = New TLogLine(..
			Self.Logger.Stream.Size(),..
			message,..
			Self, Self.Logger.NextLineIndex,..
			severity)
		Self.Logger.NextLineIndex:+1
		Self.LastSeverity = severity
		Self.Logger.Lines.Enqueue(Self.LastLine)
		Self.Logger.Stream.WriteString("~n"+message)
		
		Self.Logger.Dirty = True
		If Self.Logger.AutoFlush Self.Logger.Flush()
		Self.Logger.TrimQueue()
	EndMethod
	
	Private
		Method New()
		EndMethod
	Public
EndType

Enum ELogSeverity
	Fatal
	Error
	Warn
	Info
	Debug
	Trace
EndEnum

Type TLogLine
	
	Method Parent:TLogWriter()
		Return Self._writer
	EndMethod
	
	Method Severity:ELogSeverity()
		Return Self._severity
	EndMethod
	
	Method LineNumber:Long()
		Return Self._index
	EndMethod
	
	Method Time:String()
		Return Self._time
	EndMethod
	
	Method ToString:String()
		Return Self._text.ToString()
	EndMethod
	
	Private
		Field _seekPos:Long
		Field _text:TStringBuilder
		Field _writer:TLogWriter
		Field _index:Long
		Field _severity:ELogSeverity
		Field _time:String
		
		Method New(seekPos:Long, text:String, writer:TLogWriter, index:Long, severity:ELogSeverity)
			Self._seekPos = seekPos
			Self._text = New TStringBuilder(text)
			Self._writer = writer
			Self._index = index
			Self._severity = severity
			Self._time = CurrentTime()
		EndMethod
	Public
EndType