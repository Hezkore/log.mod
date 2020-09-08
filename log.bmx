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
Import BRL.StringBuilder

Type TLogger
	
	Field Path:String
	Field Stream:TStream
	Field AutoFlush:Int = True
	Field Log:TLogLine[]
	Field NextLine:Long
	
	Method New(path:String, maxLines:Long = 1000)
		Self.Path = path
		Self.Stream = WriteStream(path)
		Self.Log = New TLogLine[maxLines]
		'Self.Stream.WriteLine(CurrentDate() + " " + CurrentTime())
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
		Method New()
		EndMethod
	Public
EndType

Type TLogWriter
	
	Field Name:String
	Field Logger:TLogger
	Field LastLine:TLogLine
	
	Method New(name:String, logger:TLogger)
		Self.Name = name
		Self.Logger = logger
	EndMethod
	
	Method Write(severity:ELogSeverity = ELogSeverity.Debug, message:String, onNewLine:Int = True)
		If Not Self.Logger Or Not Self.Logger.Stream Return
		
		If onNewLine Then
			Self.Logger.Log[Self.Logger.NextLine] = New TLogLine(Self.Logger.Stream.Size(), message)
			Self.LastLine =  Self.Logger.Log[Self.Logger.NextLine]
			Self.Logger.NextLine:+1
		Else
			
		EndIf
		
		If Self.Logger.AutoFlush Self.Logger.Flush()
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
	
	Method New(seekPos:Long, text:String)
		Self.SeekPos = seekPos
		Self.Text = New TStringBuilder(text)
	EndMethod
EndType