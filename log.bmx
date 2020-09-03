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

Type TLogger
	
	Field Path:String
	Field Stream:TStream
	Field AutoFlush:Int = True
	
	Method New(path:String)
		Self.Path = path
		Self.Stream = WriteStream(path)
		Self.Stream.WriteLine(CurrentDate() + " " + CurrentTime())
	EndMethod
	
	Method Flush()
		If Self.Stream Self.Stream.Flush()
	EndMethod
	
	Private
		Method New()
		EndMethod
	Public
EndType

Type TLogWriter
	
	Field Name:String
	Field Logger:TLogger
	Field LastWrittenDir:UInt
	
	Method New(name:String, logger:TLogger)
		Self.Name = name
		Self.Logger = logger
	EndMethod
	
	Method Write(message:String, severity:ELogSeverity = ELogSeverity.Debug, onNewLine:Int = True)
		If Not Self.Logger Or Not Self.Logger.Stream Return
		
		Self.Logger.Flush()
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