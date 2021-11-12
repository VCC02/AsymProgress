unit AsymProgressSettingsForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type
  TAsymSettings = record
    DisplayProgress: Boolean;
    DisplayHoldProgress: Boolean;
    DisplayActionProgress: Boolean;
    DisplayHoldComponents: Boolean;
    IncText: string;
    HoldDecText: string;
    DecText: string;
    HoldIncText: string;
  end;

  { TfrmAsymProgressSettings }

  TfrmAsymProgressSettings = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    chkDisplayHoldComponents: TCheckBox;
    chkDisplayActionProgress: TCheckBox;
    chkDisplayProgress: TCheckBox;
    chkDisplayHoldProgress: TCheckBox;
    lbeDecText: TLabeledEdit;
    lbeHoldIncText: TLabeledEdit;
    lbeIncText: TLabeledEdit;
    lbeHoldDecText: TLabeledEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;


function EditAsymSettings(var ASettings: TAsymSettings): Boolean;


implementation

{$R *.frm}

function EditAsymSettings(var ASettings: TAsymSettings): Boolean;
var
  frmAsymProgressSettings: TfrmAsymProgressSettings;
begin
  Application.CreateForm(TfrmAsymProgressSettings, frmAsymProgressSettings);

  frmAsymProgressSettings.chkDisplayProgress.Checked := ASettings.DisplayProgress;
  frmAsymProgressSettings.chkDisplayHoldProgress.Checked := ASettings.DisplayHoldProgress;
  frmAsymProgressSettings.chkDisplayActionProgress.Checked := ASettings.DisplayActionProgress;
  frmAsymProgressSettings.chkDisplayHoldComponents.Checked := ASettings.DisplayHoldComponents;

  frmAsymProgressSettings.lbeIncText.Text := ASettings.IncText;
  frmAsymProgressSettings.lbeHoldDecText.Text := ASettings.HoldDecText;
  frmAsymProgressSettings.lbeDecText.Text := ASettings.DecText;
  frmAsymProgressSettings.lbeHoldIncText.Text := ASettings.HoldIncText;

  frmAsymProgressSettings.ShowModal;

  ASettings.DisplayProgress := frmAsymProgressSettings.chkDisplayProgress.Checked;
  ASettings.DisplayHoldProgress := frmAsymProgressSettings.chkDisplayHoldProgress.Checked;
  ASettings.DisplayActionProgress := frmAsymProgressSettings.chkDisplayActionProgress.Checked;
  ASettings.DisplayHoldComponents := frmAsymProgressSettings.chkDisplayHoldComponents.Checked;

  ASettings.IncText := frmAsymProgressSettings.lbeIncText.Text;
  ASettings.HoldDecText := frmAsymProgressSettings.lbeHoldDecText.Text;
  ASettings.DecText := frmAsymProgressSettings.lbeDecText.Text;
  ASettings.HoldIncText := frmAsymProgressSettings.lbeHoldIncText.Text;

  Result := frmAsymProgressSettings.Tag = 1;

  if Result then
  begin
    ASettings.DisplayProgress := frmAsymProgressSettings.chkDisplayProgress.Checked;
  end;
end;

{ TfrmAsymProgressSettings }

procedure TfrmAsymProgressSettings.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;


procedure TfrmAsymProgressSettings.btnOKClick(Sender: TObject);
begin
  Tag := 1;
  Close;
end;


procedure TfrmAsymProgressSettings.btnCancelClick(Sender: TObject);
begin
  Tag := 0;
  Close;
end;

end.

