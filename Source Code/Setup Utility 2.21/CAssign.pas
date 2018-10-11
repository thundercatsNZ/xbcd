unit CAssign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TCAssign = class(TForm)
    txtControl: TStaticText;
    cmdOK:      TButton;
    cmdCancel:  TButton;
    cmbButton:  TComboBox;
    cmbAxis:    TComboBox;
    cmbPOV:     TComboBox;
    rdbNone: TRadioButton;
    rdbButton: TRadioButton;
    rdbAxis: TRadioButton;
    rdbPOV: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure rdbClick(Sender: TObject);
  private
    { Private declarations }
    iNewValue: integer;
  public
    { Public declarations }
    function AssignControl(sName: string; iOldValue: integer): integer;
  end;

const

  WinControls2: array[0..42] of string = (
    'None',
    'Button 1', 'Button 2', 'Button 3', 'Button 4', 'Button 5', 'Button 6',
    'Button 7', 'Button 8', 'Button 9', 'Button 10', 'Button 11', 'Button 12',
    'Button 13', 'Button 14', 'Button 15', 'Button 16', 'Button 17', 'Button 18',
    'Button 19', 'Button 20', 'Button 21', 'Button 22', 'Button 23', 'Button 24',
    'X -', 'X +',
    'Y -', 'Y +',
    'Z -', 'Z +',
    'X Rotation -', 'X Rotation +',
    'Y Rotation -', 'Y Rotation +',
    'Z Rotation -', 'Z Rotation +',
    'Slider -', 'Slider +',
    'POV Up', 'POV Right', 'POV Down', 'POV Left'
    );

  BUTTON_BEGIN = 1;
  BUTTON_END   = 24;
  AXIS_BEGIN   = 25;
  AXIS_END     = 38;
  POV_BEGIN    = 39;
  POV_END      = 42;

implementation

{$R *.dfm}

procedure TCAssign.FormCreate(Sender: TObject);
var
  iCount: integer;
begin
  Font.Name := Screen.IconFont.Name;

  for iCount := BUTTON_BEGIN to BUTTON_END do
  begin
    cmbButton.AddItem(WinControls2[iCount], nil);
  end;

  for iCount := AXIS_BEGIN to AXIS_END do
  begin
    cmbAxis.AddItem(WinControls2[iCount], nil);
  end;

  for iCount := POV_BEGIN to POV_END do
  begin
    cmbPOV.AddItem(WinControls2[iCount], nil);
  end;

  for iCount := 0 to ControlCount - 1 do
    if Controls[iCount] is TRadioButton then
      with TRadioButton(Controls[iCount]) do begin
        Width := Canvas.TextWidth(Caption) + 16;
        Left := 89 - Width;
      end;
end;

function TCAssign.AssignControl(sName: string; iOldValue: integer): integer;
begin
  txtControl.Caption := sName;

  iNewValue := iOldValue;

  if (iNewValue < BUTTON_BEGIN) or (iNewValue > POV_END) then
  begin
    iNewValue := 0;
  end;

  if iNewValue >= POV_BEGIN then
  begin
    rdbPOV.Checked := True;

    cmbPOV.ItemIndex := iNewValue - POV_BEGIN;
    cmbPOV.Enabled := True;
  end
  else
  begin
    if iNewValue >= AXIS_BEGIN then
    begin
      rdbAxis.Checked := True;

      cmbAxis.ItemIndex := iNewValue - AXIS_BEGIN;
      cmbAxis.Enabled := True;
    end
    else
    begin
      if iNewValue >= BUTTON_BEGIN then
      begin
        rdbButton.Checked := True;

        cmbButton.ItemIndex := iNewValue - BUTTON_BEGIN;
        cmbButton.Enabled := True;
      end
      else
      begin
        rdbNone.Checked := True;
      end;
    end;
  end;
  Self.ShowModal;

  Result := iNewValue;
end;

procedure TCAssign.cmdOKClick(Sender: TObject);
begin
  if rdbPOV.Checked then
  begin
    if cmbPOV.ItemIndex >= 0 then
    begin
      iNewValue := cmbPOV.ItemIndex + POV_BEGIN;
    end
    else
    begin
      MessageBox(Self.Handle, 'Please make a valid selection.',
        'Warning', MB_OK or MB_ICONEXCLAMATION);
      Exit;
    end;
  end
  else
  begin
    if rdbAxis.Checked then
    begin
      if cmbAxis.ItemIndex >= 0 then
      begin
        iNewValue := cmbAxis.ItemIndex + AXIS_BEGIN;
      end
      else
      begin
        MessageBox(Self.Handle, 'Please make a valid selection.',
          'Warning', MB_OK or MB_ICONEXCLAMATION);
        Exit;
      end;
    end
    else
    begin
      if rdbButton.Checked then
      begin
        if cmbButton.ItemIndex >= 0 then
        begin
          iNewValue := cmbButton.ItemIndex + BUTTON_BEGIN;
        end
        else
        begin
          MessageBox(Self.Handle,
            'Please make a valid selection.', 'Warning', MB_OK or MB_ICONEXCLAMATION);
          Exit;
        end;
      end
      else
      begin
        iNewValue := 0;
      end;
    end;
  end;

  Self.Close;
end;

procedure TCAssign.cmdCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TCAssign.rdbClick(Sender: TObject);
var
  iCount: Integer;
begin
  for iCount := 0 to ControlCount - 1 do
    if Controls[iCount] is TComboBox then
      TComboBox(Controls[iCount]).Enabled :=
        (TComponent(Controls[iCount]).Tag = TComponent(Sender).Tag);
end;

end.
