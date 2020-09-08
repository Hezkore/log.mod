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
	Field Stream:TStream
	Field AutoFlush:Int = True
	Field Log:TQueue<TLogLine> = New TQueue<TLogLine>
	Field MaxLines:Int
	Field NextLineIndex:Long
	
	Method New(path:String, maxLines:Int = 1000)
		Self.Path = path
		Self.MaxLines = maxLines
		Self.Stream = WriteStream(path)
		Self.Stream.WriteString(CurrentDate() + " " + CurrentTime())
	EndMethod
	
	Method Flush()
		If Self.Stream Self.Stream.Flush()
	EndMethod
	
	Method Print()
		For Local l:TLogLine = EachIn Self.Log
			Print l.Text.ToString()
		Next
	EndMethod
	
	Private
		Field DequeueLine:TLogLine
		
		Method New()
		EndMethod
		
		Method TrimQueue()
			While Self.Log.Size > Self.MaxLines
				Self.DequeueLine = Self.Log.Dequeue()
				If Self.DequeueLine.Writer.LastLine = Self.DequeueLine..
					Self.DequeueLine.Writer.LastLine = Null
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
		
		Self.Logger.Stream.Seek(Self.LastLine.SeekPos + 1 + Self.LastLine.Text.Length())
		Self.LastLine.Text.Append(message)
		Self.Logger.Stream.WriteString(message)
		
		For Local l:TLogLine = EachIn Self.Logger.Log
			If l.SeekPos <= Self.LastLine.SeekPos Continue
			l.SeekPos = Self.Logger.Stream.Pos()
			Self.Logger.Stream.WriteString("~n"+l.Text.ToString())
		Next
		
		If Self.Logger.AutoFlush Self.Logger.Flush()
	EndMethod
	
	Method Write(message:String, severity:ELogSeverity = ELogSeverity.Debug)
		If Not Self.Logger Or Not Self.Logger.Stream Return
		
		Self.LastLine = New TLogLine(Self.Logger.Stream.Size(), message, Self, Self.Logger.NextLineIndex)
		Self.Logger.NextLineIndex:+1
		Self.LastSeverity = severity
		Self.Logger.Log.Enqueue(Self.LastLine)
		Self.Logger.Stream.WriteString("~n"+message)
		
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
	Field SeekPos:Long
	Field Text:TStringBuilder
	Field Writer:TLogWriter
	Field Index:Long
	
	Method New(seekPos:Long, text:String, writer:TLogWriter, index:Long)
		Self.SeekPos = seekPos
		Self.Text = New TStringBuilder(text)
		Self.Writer = writer
		Self.Index = index
	EndMethod
EndType