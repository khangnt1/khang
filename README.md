Option Explicit
Dim i As Double
Dim j As Double
Dim Data As String
Dim Index As String
Dim Item1 As String, Item2 As String, Item3 As String, Item4 As String

Sub group()
    
    Sheets(4).Cells.ClearContents
    
    For i = 1 To 1000
        
        Data = Worksheets(1).Cells(i, 3).Value
        Index = Worksheets(1).Cells(i, 11).Value
        
        Select Case Index
            Case "1"
                Item1 = Data
                For j = 1 To i
                    If Worksheets(4).Cells(j, 1).Value = "" Then
                        Worksheets(4).Cells(j, 1).Value = Item1
                        Exit For
                    End If
                Next j
                
            Case "2"
                Item2 = Data
                For j = 1 To i
                    If Worksheets(4).Cells(j, 2).Value = "" Then
                        Worksheets(4).Cells(j, 2).Value = Item2
                        Exit For
                    End If
                Next j
            Case "3"
                Item3 = Data
                For j = 1 To i
                    If Worksheets(4).Cells(j, 3).Value = "" Then
                        Worksheets(4).Cells(j, 3).Value = Item3
                        Exit For
                    End If
                Next j
            Case "4"
                Item4 = Data
                For j = 1 To i
                    If Worksheets(4).Cells(j, 4).Value = "" Then
                        Worksheets(4).Cells(j, 4).Value = Item4
                        Exit For
                    End If
                Next j
        End Select

    Next i
    Worksheets(4).Select
End Sub

Sub Find_Address()
    
    For i = 2 To 1000
        If Worksheets(1).Cells(i, 2).Value <> "" Then
            For j = 2 To 300
                If Worksheets(1).Cells(i, 2).Value = Worksheets("KH").Cells(j, 1).Value Then
                    Worksheets(1).Cells(i, 9).Value = Worksheets("KH").Cells(j, 3).Value
                    Worksheets(1).Cells(i, 8).Value = Worksheets("KH").Cells(j, 2).Value
                End If
            Next j
        End If
    Next i
            
              
        
        
End Sub

