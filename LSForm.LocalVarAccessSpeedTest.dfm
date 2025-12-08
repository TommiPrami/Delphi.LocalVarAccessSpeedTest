object LSLocalVarAccessSpeedTestForm: TLSLocalVarAccessSpeedTestForm
  Left = 0
  Top = 0
  Caption = 'LSLocalVarAccessSpeedTestForm'
  ClientHeight = 399
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    459
    399)
  TextHeight = 15
  object ButtonRun: TButton
    Left = 374
    Top = 15
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'ButtonRun'
    TabOrder = 0
    OnClick = ButtonRunClick
    ExplicitLeft = 220
  end
  object MemoLog: TMemo
    Left = 8
    Top = 46
    Width = 441
    Height = 342
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitWidth = 397
    ExplicitHeight = 310
  end
end
