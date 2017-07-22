OpenConsole()

Global CanCreateFile.b = #True

NewList ParamsList.s()
NewList FilesList.s()

Procedure PrintHelp()
  PrintN("Create of change time on a file")
  PrintN("")
  PrintN("Usage: touch [options] files...")
  PrintN("")
  ;PrintN("-a                    Change only the access time")
  PrintN("-c, --no-create       Do Not create any files")
  ;PrintN("-d, --date=STRING     Parse STRING And use it instead of current time")
  ;PrintN("-m                    Change only the modification time")
  ;PrintN("-r, --reference=FILE  Use this file's times instead of current time")
  ;PrintN("-t STAMP              Use [[CC]YY]MMDDhhmm[.ss] instead of current time")
  ;PrintN("    --time=WORD       Change the specified time: WORD is access, atime, Or use: equivalent To -a WORD is modify Or mtime: equivalent To -m")
  PrintN("-h, --help            Display this help and exit")
  PrintN("    --version         Output version information And exit")
  Debug "Printed help text"
  End 0
EndProcedure

Procedure PrintVersion()
  PrintN("Build #"+#PB_Editor_BuildCount)
  Debug "Printed version text"
  End 0
EndProcedure

Procedure ProcessFile(FileName.s)
  Debug "Processing: "+FileName
  If ReadFile(0, FileName)
    Debug "  File found."
    ; TODO: change time
  ElseIf CanCreateFile = #True
    If CreateFile(0, FileName)
      Debug "  File created."
      CloseFile(0)
    Else
      Debug "  Unable to create file."
      End 1
    EndIf
  Else
    Debug "  Unused case."
  EndIf
EndProcedure

; Ajoute les paramètres à "ParamsList()" pour faciliter le travail plus tard.
; Peux utiliser moins de place si "ProgramParameter()" est sauvegardé dans une variable temporaire.
ParamsRead.b = #False
While ParamsRead = #False
  CurrentParam.s = ProgramParameter()
  If Len(CurrentParam) > 0
    InsertElement(ParamsList())
    ParamsList() = CurrentParam
  Else
    ParamsRead = #True
  EndIf
Wend

; Si la liste est vide, quitte le programme
If ListSize(ParamsList()) = 0
  End 0
EndIf

; TODO: Trouver un moyen d'utiliser les options courtes (ex: -ac)
Debug "Processing "+ListSize(ParamsList())+" parameter(s):"
ForEach ParamsList()
  Debug "|--> "+ParamsList()
  
  If Len(ReplaceString(Left(ParamsList(), 1), "-", "")) = 0
    Debug "| |-> Option detected"
    
    If ParamsList() = "-h" Or ParamsList() = "--help"
      PrintHelp()
    ElseIf ParamsList() = "--version"
      PrintVersion()
    ElseIf ParamsList() = "-c" Or ParamsList() = "--no-create"
      CanCreateFile = #False
    Else
      PrintN("Unsupported Option: "+ParamsList())
      PrintN("Use --help to see available options")
      End 1
    EndIf
  Else
    ; Ajoute le fichier à "ParamsList()"
    InsertElement(FilesList())
    FilesList() = ParamsList()
    Debug "| |-> File added to FilesList()"
  EndIf
  
  ;Debug ParamsList()
Next

ForEach FilesList()
  ProcessFile(FilesList())
Next

; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 3
; FirstLine = 21
; Folding = -
; EnableUnicode
; EnableXP