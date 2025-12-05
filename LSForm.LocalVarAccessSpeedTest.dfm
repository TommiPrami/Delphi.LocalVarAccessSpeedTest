object LSLocalVarAccessSpeedTestForm: TLSLocalVarAccessSpeedTestForm
  Left = 0
  Top = 0
  Caption = 'LSLocalVarAccessSpeedTestForm'
  ClientHeight = 260
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object ButtonRun: TButton
    Left = 220
    Top = 15
    Width = 75
    Height = 25
    Caption = 'ButtonRun'
    TabOrder = 0
    OnClick = ButtonRunClick
  end
  object MemoLog: TMemo
    Left = 8
    Top = 46
    Width = 287
    Height = 206
    TabOrder = 1
  end
  object EditLoopCount: TEdit
    Left = 8
    Top = 17
    Width = 121
    Height = 23
    TabOrder = 2
    Text = '900000000'
  end
end
