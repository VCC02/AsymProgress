object frmAsymProgressSettings: TfrmAsymProgressSettings
  Left = 387
  Height = 272
  Top = 43
  Width = 521
  Caption = 'Asymmetric Progress Settings'
  ClientHeight = 272
  ClientWidth = 521
  Constraints.MinHeight = 272
  Constraints.MinWidth = 521
  OnClose = FormClose
  LCLVersion = '7.5'
  object chkDisplayProgress: TCheckBox
    Left = 20
    Height = 19
    Hint = 'Display the horizontal progressbar.'
    Top = 8
    Width = 106
    Caption = 'Display Progress'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object chkDisplayHoldProgress: TCheckBox
    Left = 20
    Height = 19
    Hint = 'Display the vertical progressbar.'
    Top = 40
    Width = 135
    Caption = 'Display Hold Progress'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object chkDisplayActionProgress: TCheckBox
    Left = 20
    Height = 19
    Hint = 'Display the inc/dec circle.'
    Top = 72
    Width = 144
    Caption = 'Display Action Progress'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object chkDisplayHoldComponents: TCheckBox
    Left = 20
    Height = 19
    Hint = 'Display the hold circles and timing settings.'
    Top = 104
    Width = 159
    Caption = 'Display Hold Components'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object lbeIncText: TLabeledEdit
    Left = 224
    Height = 23
    Top = 24
    Width = 280
    EditLabel.Height = 15
    EditLabel.Width = 280
    EditLabel.Caption = 'Inc Text'
    TabOrder = 4
    Text = 'Inc Text'
  end
  object lbeHoldDecText: TLabeledEdit
    Left = 224
    Height = 23
    Top = 80
    Width = 280
    EditLabel.Height = 15
    EditLabel.Width = 280
    EditLabel.Caption = 'Hold Dec Text'
    TabOrder = 5
    Text = 'Hold Dec Text'
  end
  object lbeDecText: TLabeledEdit
    Left = 224
    Height = 23
    Top = 136
    Width = 280
    EditLabel.Height = 15
    EditLabel.Width = 280
    EditLabel.Caption = 'Dec Text'
    TabOrder = 6
    Text = 'Dec Text'
  end
  object lbeHoldIncText: TLabeledEdit
    Left = 224
    Height = 23
    Top = 192
    Width = 280
    EditLabel.Height = 15
    EditLabel.Width = 280
    EditLabel.Caption = 'Hold Inc Text'
    TabOrder = 7
    Text = 'Hold Inc Text'
  end
  object btnOK: TButton
    Left = 184
    Height = 25
    Top = 230
    Width = 75
    Anchors = [akBottom]
    Caption = 'OK'
    OnClick = btnOKClick
    TabOrder = 8
  end
  object btnCancel: TButton
    Left = 272
    Height = 25
    Top = 230
    Width = 75
    Anchors = [akBottom]
    Caption = 'Cancel'
    OnClick = btnCancelClick
    TabOrder = 9
  end
end
