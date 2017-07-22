
Global CanCreateFile.b = #True

NewList ParamsList.s()
NewList FilesList.s()

Procedure PrintHelp()
  Debug "Here is the help..."
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

; ???
Debug "Processing "+ListSize(ParamsList())+" parameter(s):"
ForEach ParamsList()
  Debug "|--> "+ParamsList()
  
  If Len(ReplaceString(Left(ParamsList(), 1), "-", "")) = 0
    Debug "| |-> Option detected"
    
    If ParamsList() = "-h" Or ParamsList() = "--help"
      PrintHelp()
    Else
      Debug "| |-> ERROR: Unsupported option"
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
; CursorPosition = 24
; Folding = -
; EnableUnicode
; EnableXP