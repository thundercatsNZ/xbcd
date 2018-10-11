unit Main;

interface

uses
  Windows, Classes, Controls, Forms, Dialogs, Math, StdCtrls,
  ComCtrls, ExtCtrls, Graphics, CPL, Menus;

type
  TMainForm = class(TForm)
    Label1:        TLabel;
    Bevel1:        TBevel;
    cmbDevices:    TComboBox;
    cmdRefresh:    TButton;
    cmdApply:      TButton;
    cmdReset:      TButton;
    tmrContinuousDataCollect: TTimer;
    pageTabs:      TPageControl;
    tabXbox:       TTabSheet;
    tabRumble:     TTabSheet;
    txtBytesReceived: TEdit;
    chkRawData:    TCheckBox;
    txtBytesSent:  TEdit;
    cmdSave:       TButton;
    cmdOpen:       TButton;
    dlgOpen:       TOpenDialog;
    dlgSave:       TSaveDialog;
    cmbProfiles:   TComboBox;
    pnlLS:         TPanel;
    imgCLS:        TImage;
    ImgDPup:       TImage;
    ImgDPdown:     TImage;
    ImgDPleft:     TImage;
    ImgDPright:    TImage;
    TrackBarL:     TTrackBar;
    txtLAct:       TStaticText;
    txtLAFactor:   TStaticText;
    udLAFactor:    TUpDown;
    txtRAct:       TStaticText;
    txtRAFactor:   TStaticText;
    udRAFactor:    TUpDown;
    TrackBarR:     TTrackBar;
    txtLStickDZ:   TStaticText;
    udLStickDZ:    TUpDown;
    udBThreshold:  TUpDown;
    txtBThreshold: TStaticText;
    udTThreshold:  TUpDown;
    txtTThreshold: TStaticText;
    cmdPMenu:      TButton;
    shpLDeadZ:     TShape;
    udAThreshold:  TUpDown;
    txtAThreshold: TStaticText;
    mnuProfile:    TPopupMenu;
    mnuPAdd:       TMenuItem;
    mnuPCopy:      TMenuItem;
    mnuPRemove:    TMenuItem;
    mnuPImport:    TMenuItem;
    mnuPExport:    TMenuItem;
    tabWindows:    TTabSheet;
    pnlRS:         TPanel;
    imgCRS:        TImage;
    shpRDeadZ:     TShape;
    udRStickDZ:    TUpDown;
    txtRStickDZ:   TStaticText;
    grpPOV:        TGroupBox;
    imgD:          TImage;
    imgL:          TImage;
    imgR:          TImage;
    imgU:          TImage;
    imgDL:         TImage;
    imgDR:         TImage;
    imgUR:         TImage;
    imgUL:         TImage;
    udScaleX:      TUpDown;
    udScaleY:      TUpDown;
    txtScaleY: TStaticText;
    txtScaleZ: TStaticText;
    udScaleZ:      TUpDown;
    txtScaleRZ: TStaticText;
    udScaleRZ:     TUpDown;
    udScaleSLD:    TUpDown;
    txtScaleSLD: TStaticText;
    udScaleRX:     TUpDown;
    txtScaleRX: TStaticText;
    udScaleRY:     TUpDown;
    txtScaleRY: TStaticText;
    grpXboxBtns:   TGroupBox;
    chkLFRange:    TCheckBox;
    chkRFRange:    TCheckBox;
    cmbDevType:    TComboBox;
    grpWinBtns:    TGroupBox;
    pnlX:          TPanel;
    imgX:          TImage;
    pnlY:          TPanel;
    imgY:          TImage;
    pnlZ:          TPanel;
    imgZ:          TImage;
    pnlRz:         TPanel;
    imgRz:         TImage;
    pnlSld:        TPanel;
    imgSld:        TImage;
    pnlRx:         TPanel;
    imgRx:         TImage;
    pnlRy:         TPanel;
    imgRy:         TImage;
    ckbZOn:        TCheckBox;
    ckbRxOn:       TCheckBox;
    ckbRyOn:       TCheckBox;
    ckbRzOn:       TCheckBox;
    ckbSliderOn:   TCheckBox;
    udNButtons:    TUpDown;
    txtNButtons: TStaticText;
    txtScaleX: TStaticText;
    txtActiveProfile: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmdExitClick(Sender: TObject);
    procedure tmrContinuousDataCollectTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdApplyClick(Sender: TObject);
    procedure udBThresholdClick(Sender: TObject; Button: TUDBtnType);
    procedure udTThresholdClick(Sender: TObject; Button: TUDBtnType);
    procedure cmdRefreshClick(Sender: TObject);
    procedure cmdResetClick(Sender: TObject);
    procedure udLAFactorClick(Sender: TObject; Button: TUDBtnType);
    procedure udRAFactorClick(Sender: TObject; Button: TUDBtnType);
    procedure cmdOpenClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure cmdAsgnClick(Sender: TObject);
    procedure udLStickDZClick(Sender: TObject; Button: TUDBtnType);
    procedure udRStickDZClick(Sender: TObject; Button: TUDBtnType);
    procedure udAThresholdClick(Sender: TObject; Button: TUDBtnType);
    procedure udScaleClick(Sender: TObject; Button: TUDBtnType);
    procedure cmdPMenuClick(Sender: TObject);
    procedure mnuProfilePopup(Sender: TObject);
    procedure mnuPAddClick(Sender: TObject);
    procedure mnuPCopyClick(Sender: TObject);
    procedure mnuPRemoveClick(Sender: TObject);
    procedure ckbAxesOnClick(Sender: TObject);
    procedure chkLFRangeClick(Sender: TObject);
    procedure chkRFRangeClick(Sender: TObject);
    procedure udNButtonsClick(Sender: TObject; Button: TUDBtnType);
    procedure pageTabsChange(Sender: TObject);
    procedure cmbDevTypeChange(Sender: TObject);
    procedure cmbProfilesChange(Sender: TObject);
    procedure cmbDevicesChange(Sender: TObject);
  private
    { Private declarations }
    // Set this to True to force a re-draw even if input is unchanged
    tabUpdate: Boolean;
    procedure ReadReport;
    procedure DispAxis(imgAxis: TImage; bVal: byte; iIndex: Integer);
  public
    { Public declarations }
  end;


type
  TInterfaceDesc = record
    InterfaceClass, InterfaceSubClass, InterfaceProtocol: byte;
  end;

  TActuators = record
    iRFactor: Integer;
    iLFactor: Integer;
  end;

  PGamepad = ^TGamepad;
  TGamepad = record
    MapMatrix:   array[0..7] of array[0..23] of byte;
    AxesScale:   array[0..6] of byte;
    DevType:     Byte;
    DevTypeOld:  Byte;
    iRStickDZ:   Integer;
    iLStickDZ:   Integer;
    bLStickFull: Boolean;
    bRStickFull: Boolean;
    iBThreshold: Integer;
    iTThreshold: Integer;
    iAThreshold: Integer;
    iRAFactor:   Integer;
    iLAFactor:   Integer;
    iLayouts:    Integer;
    iButtons:    Integer;
    iButtonsOld: Integer;
    iAxesOn:     Integer;
    iAxesOnOld:  Integer;
    is360:       Boolean;
  end;

  TOldGamepad = record
    MapMatrix:   array[0..7] of array[0..23] of byte;
    AxesScale:   array[0..6] of byte;
    actuators:   TActuators;
    iRStickDZ:   Integer;
    iLStickDZ:   Integer;
    iBThreshold: Integer;
    iTThreshold: Integer;
    iAThreshold: Integer;
    iLayouts:    Integer;
    iAxesOn:     Integer;
    iAxesOnOld:  Integer;
  end;

  PFeatureSetConfig = ^TFeatureSetConfig;
  TFeatureSetConfig = packed record
    id:        Byte;
    Signature: Longword;
  end;

var
  MainForm:  TMainForm;
  picWBtn:   array[0..23] of TImage;
  picXBtn:   array[0..11] of TImage;
  picDPad:   array[0..3]  of TImage;
  cmdAsgn:   array[0..23] of TButton;
  trkRumble: array[0..1]  of TTrackBar;
  imgPOV:    array[0..7]  of TImage;
  udScale:   array[0..6]  of TUpDown;
  ckbAxesOn: array[0..4]  of TCheckBox;

  Gamepads: array of TGamepad;

  EventObject: longint;
  HIDHandle: DWORD;
  HIDOverlapped: OVERLAPPED;
  MyDeviceDetected: boolean;
  ReadHandle: DWORD;
  strDevicePath: array of string;
  strUSBDevicePath: array of string;
  intUSBCount: Integer;
  strButtons: array[0..11] of string;
  ModuleName: string;
  FoundWnd: THandle;
  USBGuid: TGUID;

function DllGetClassObject(const CLSID, IID: TGUID; var Obj): HResult; stdcall;
function DllCanUnloadNow: HResult; stdcall;
function CPlApplet(hWndCpl: HWnd; msg: Integer; lParam: longint;
  var NewCPLInfo: TNewCPLInfo): longint; stdcall;

const
  FEATURE_CODE_SET_CONFIG = 3;
  HID_USAGE_JOYSTICK      = 4;
  HID_USAGE_GAMEPAD       = 5;

const
  clDkNavy = $400000;

  XboxLabels: array[0..11] of string = (
    'A', 'B', 'X', 'Y', 'BL', 'WH', 'LT', 'RT',
    'ST', 'BK', 'LS', 'RS'
    );

  X360Labels: array[0..11] of string = (
    'A', 'B', 'X', 'Y', 'LB', 'RB', 'LT', 'RT',
    'ST', 'BK', 'LS', 'RS'
    );

  SemiAxes: array[0..23] of string = (
    'D-Pad Up', 'D-Pad Down', 'D-Pad Left', 'D-Pad Right', 'Start', 'Back',
    'L-Stick Press', 'R-Stick Press', 'A', 'B', 'X', 'Y',
    'Black', 'White', 'L-Trigger', 'R-Trigger',
    'L-Stick Left', 'L-Stick Right', 'L-Stick Down', 'L-Stick Up',
    'R-Stick Left', 'R-Stick Right', 'R-Stick Down', 'R-Stick Up'
    );

  SemiAxes360: array[0..23] of string = (
    'D-Pad Up', 'D-Pad Down', 'D-Pad Left', 'D-Pad Right', 'Start', 'Back',
    'L-Stick Press', 'R-Stick Press', 'A', 'B', 'X', 'Y',
    'L-Bumper', 'R-Bumper', 'L-Trigger', 'R-Trigger',
    'L-Stick Left', 'L-Stick Right', 'L-Stick Down', 'L-Stick Up',
    'R-Stick Left', 'R-Stick Right', 'R-Stick Down', 'R-Stick Up'
    );

  DefMappingNT: array[0..23] of byte = (
    39, 41, 42, 40, 7, 8,
    9, 10, 1, 2, 3, 4,
    5, 6, 11, 12,
    25, 26, 28, 27,
    31, 32, 34, 33
    );

  DefMapping9x: array[0..23] of byte = (
    39, 41, 42, 40, 7, 8,
    9, 10, 1, 2, 3, 4,
    5, 6, 11, 12,
    25, 26, 28, 27,
    35, 36, 30, 29
    );

  WinControls: array[0..42] of string = (
    'None',
    'B1', 'B2', 'B3', 'B4', 'B5', 'B6',
    'B7', 'B8', 'B9', 'B10', 'B11', 'B12',
    'B13', 'B14', 'B15', 'B16', 'B17', 'B18',
    'B19', 'B20', 'B21', 'B22', 'B23', 'B24',
    'X-', 'X+',
    'Y-', 'Y+',
    'Z-', 'Z+',
    'RX-', 'RX+',
    'RY-', 'RY+',
    'RZ-', 'RZ+',
    'Sld-', 'Sld+',
    'POVu', 'POVr', 'POVd', 'POVl'
    );


implementation

{$R *.dfm}

uses
  HID, SetupApi, XBCDIF, CAssign, StrUtils, SysUtils, MixedColor, IniFiles;

procedure AppMain;
  
  function EnumWndProc(hwnd: THandle; Param: Cardinal): Bool; stdcall;
  var
    ClassName, WinModuleName: string;
    WinInstance: THandle;
  begin
    Result := True;
    SetLength(ClassName, 100);
    GetClassName(hwnd, PChar(ClassName), 100);
    ClassName := PChar(ClassName);
    if ClassName = TMainForm.ClassName then
    begin
      // Get the module name of the target window
      SetLength(WinModuleName, 200);
      WinInstance := GetWindowLong(hwnd, GWL_HINSTANCE);
      GetModuleFileName(WinInstance, PChar(WinModuleName), 200);
      WinModuleName := PChar(WinModuleName);
      if WinModuleName = ModuleName then
      begin
        FoundWnd := hwnd;
        Result := False;
      end;
    end;
  end;

var
  HMutex: THandle;
begin
  HMutex := CreateMutex(nil, False, 'XBCDSetup');
  if WaitForSingleObject(HMutex, 0) <> WAIT_TIMEOUT then
  begin
    Application.CreateForm(TMainForm, MainForm);
    Application.Title := MainForm.Caption;

    //if Flag = 1 then MainForm.pageTabs.ActivePageIndex := 1;
    try
      MainForm.ShowModal;
    finally
      MainForm.Free;
    end;
  end
  else
  begin
    SetLength(ModuleName, 200);
    GetModuleFileName(HInstance, PChar(ModuleName), 200);
    ModuleName := PChar(ModuleName);
    EnumWindows(@EnumWndProc, 0);
    if FoundWnd <> 0 then
      SetForegroundWindow(FoundWnd);
  end;
end;

function CPLApplet(hWndCpl: HWnd; Msg: Integer; lParam: Longint;
  var NewCPLInfo: TNewCPLInfo): Longint;
begin
  Result := 0;

  case Msg of
    CPL_INIT: Result := 1;
      { CP asks Are you an Applet  We reply 1 - Yes I am }

    CPL_GETCOUNT: Result := 1;
      { CP asks How many icons do you want  We reply 1 - One icon,
        please }

    CPL_NEWINQUIRE:
    begin
      { CP sends this message once for every icon you require. In our
        case this is only sent once, so we dont need to concern ourself
        with what applet number CP wants to know about }
      with NewCPLInfo do
      begin
        dwSize := sizeof(TNewCPLInfo);
        dwFlags := 0;
        dwHelpContext := 0;
        lData := 0;
        szHelpFile[0] := #0;
        { Now comes the interesting bit; our icon and names }
        hIcon := LoadIcon(HInstance, 'MAINICON');
        StrPCopy(szName, 'XBCD Setup Utility');
        StrPCopy(szInfo, 'Configures gamepads using XBCD');
      end;
    end;

    CPL_DBLCLK: AppMain;
  end;
end;

function DllGetClassObject(const CLSID, IID: TGUID; var Obj): HResult;
begin
  AppMain;

  Pointer(Obj) := nil;

  Result := CLASS_E_CLASSNOTAVAILABLE;
end;

function DllCanUnloadNow: HResult;
begin
  Result := S_OK;
end;

function ParseCompatibleIDs(SI: string): TInterfaceDesc;
begin
  Result.InterfaceClass := StrToInt('$' + SI[11] + SI[12]);
  Result.InterfaceSubClass := StrToInt('$' + SI[23] + SI[24]);
  Result.InterfaceProtocol := StrToInt('$' + SI[31] + SI[32]);
end;

function EnumCallback(EnumDevice: PXBCD_Device): Integer;
begin
  SetLength(strUSBDevicePath, intUSBCount + 1);
  strUSBDevicePath[intUSBCount] := EnumDevice.USBPath;
  SetLength(strDevicePath, intUSBCount + 1);
  strDevicePath[intUSBCount] := EnumDevice.HIDPath;
  MainForm.cmbDevices.AddItem('Gamepad ' + IntToStr(intUSBCount + 1), nil);
  MyDeviceDetected := True;
  intUSBCount := intUSBCount + 1;

  Result := 0;
end;

function ReadRegSetting(const KeyHandle: HKEY; strName: string;
  Buffer: Pointer; iSize: Integer): Integer;
var
  iRetVal: Integer;
begin
  iRetVal := RegQueryValueEx(KeyHandle, PChar(strName),
    nil, nil, Buffer, @iSize);

  if iRetVal = 0 then
    Result := iSize
  else
    Result := 0;
end;

procedure SetDefaultMapping(const MapMatrix: array of byte);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    CopyMemory(@MapMatrix, @DefMappingNT, SizeOf(DefMappingNT));
  end
  else if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
  begin
    CopyMemory(@MapMatrix, @DefMapping9x, SizeOf(DefMapping9x));
  end;
end;

procedure CheckForErrors(Gamepad: PGamepad; bOverwriteOld: boolean);
var
  iCount:  Integer;
  iCount2: Integer;
begin
  if ((Gamepad.DevType <> HID_USAGE_GAMEPAD) and
    (Gamepad.DevType <> HID_USAGE_JOYSTICK)) then
  begin
    Gamepad.DevType := HID_USAGE_GAMEPAD;
    if bOverwriteOld then
      Gamepad.DevTypeOld := HID_USAGE_GAMEPAD;
  end;

  if (Gamepad.iLStickDZ < 0) or (Gamepad.iLStickDZ > 100) then
    Gamepad.iLStickDZ := 0;

  if (Gamepad.iRStickDZ < 0) or (Gamepad.iRStickDZ > 100) then
    Gamepad.iRStickDZ := 0;

  if (Gamepad.iBThreshold < 1) or (Gamepad.iBThreshold > 255) then
    Gamepad.iBThreshold := 10;

  if (Gamepad.iTThreshold < 1) or (Gamepad.iTThreshold > 255) then
    Gamepad.iTThreshold := 10;

  if (Gamepad.iAThreshold < 1) or (Gamepad.iAThreshold > 255) then
    Gamepad.iAThreshold := 100;

  if (Gamepad.iLAFactor < 0) or (Gamepad.iLAFactor > 255) then
    Gamepad.iLAFactor := 255;

  if (Gamepad.iRAFactor < 0) or (Gamepad.iRAFactor > 255) then
    Gamepad.iRAFactor := 255;

  if Gamepad.iButtons < 1 then
  begin
    Gamepad.iButtons := 1;
    if bOverwriteOld then
      Gamepad.iButtonsOld := 1;
  end;

  if Gamepad.iButtons > 24 then
  begin
    Gamepad.iButtons := 24;
    if bOverwriteOld then
      Gamepad.iButtonsOld := 24;
  end;

  if (Gamepad.iAxesOn > 31) then
  begin
    Gamepad.iAxesOn := 31;
    if bOverwriteOld then
      Gamepad.iAxesOnOld := 31;
  end;

  if (Gamepad.iLayouts < 1) or (Gamepad.iLayouts > 8) then
    Gamepad.iLayouts := 1;

  for iCount := 0 to High(Gamepad.MapMatrix) do
  begin
    for iCount2 := 0 to High(Gamepad.MapMatrix[iCount]) do
    begin
      if Gamepad.MapMatrix[iCount][iCount2] > 42 then
      begin
        Gamepad.MapMatrix[iCount][iCount2] := 0;
      end;
    end;
  end;

  for iCount := 0 to High(Gamepad.AxesScale) do
  begin
    if Gamepad.AxesScale[iCount] > 100 then
    begin
      Gamepad.AxesScale[iCount] := 100;
    end;
  end;
end;

procedure ConfigureButtons;
var
  lngDeviceInfoSet: HDEVINFO;
  KeyHandle: HKEY;
  iCount:  Integer;
  iCount2: Integer;
  iConfCount: Integer;
  lngReceived: longint;
  DeviceInterfaceData: TSPDeviceInterfaceData;
  DeviceInfoData: TSPDevInfoData;
  CompatibleIDs: array[0..256] of Char;
  InterfaceDesc: TInterfaceDesc;
  MapTemp: array[0..23] of byte;
  ASTemp:  array[0..6] of byte;
begin
  USBGuid := StringToGUID('{A5DCBF10-6530-11D2-901F-00C04FB951ED}');

  if MyDeviceDetected = True then
  begin
    lngDeviceInfoSet := SetupDiGetClassDevs(Addr(USBGuid),
      nil,
      0,
      (DIGCF_PRESENT or
      DIGCF_DEVICEINTERFACE));
    for iCount := 0 to High(strUSBDevicePath) do
    begin
      DeviceInterfaceData.cbSize := sizeof(DeviceInterfaceData);
      SetupDiOpenDeviceInterface(lngDeviceInfoSet,
        PChar(strUSBDevicePath[iCount]),
        0,
        @DeviceInterfaceData);
      DeviceInfoData.cbSize := sizeof(DeviceInfoData);
      SetupDiGetDeviceInterfaceDetail(lngDeviceInfoSet,
        @DeviceInterfaceData,
        nil,
        0,
        nil,
        @DeviceInfoData);
      KeyHandle := SetupDiOpenDevRegKey(lngDeviceInfoSet,
        DeviceInfoData,
        DICS_FLAG_GLOBAL,
        0,
        DIREG_DEV, KEY_READ);

      SetupDiGetDeviceRegistryProperty(lngDeviceInfoSet,
        @DeviceInfoData,
        SPDRP_COMPATIBLEIDS,
        nil,
        PByte(@CompatibleIDs[0]),
        SizeOf(CompatibleIDs),
        nil);
      InterfaceDesc := ParseCompatibleIDs(CompatibleIDs);

      if KeyHandle <> INVALID_HANDLE_VALUE then
      begin
        SetLength(Gamepads, iCount + 1);

        if ReadRegSetting(KeyHandle, 'DevType', @lngReceived, 4) <> 4 then
        begin
          lngReceived := HID_USAGE_GAMEPAD;
        end;
        Gamepads[iCount].DevType := lngReceived;
        Gamepads[iCount].DevTypeOld := lngReceived;

        with InterfaceDesc do
          if ((InterfaceClass = $FF) and (InterfaceSubClass = $5D)
            and (InterfaceProtocol = $01)) then
          begin
            Gamepads[iCount].is360 := True;
          end;

        if ReadRegSetting(KeyHandle, 'LStickDZ', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 0;
        end;
        Gamepads[iCount].iLStickDZ := lngReceived;

        if ReadRegSetting(KeyHandle, 'RStickDZ', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 0;
        end;
        Gamepads[iCount].iRStickDZ := lngReceived;

        if ReadRegSetting(KeyHandle, 'BThreshold', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 10;
        end;
        Gamepads[iCount].iBThreshold := lngReceived;

        if ReadRegSetting(KeyHandle, 'TThreshold', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 10;
        end;
        Gamepads[iCount].iTThreshold := lngReceived;

        if ReadRegSetting(KeyHandle, 'AThreshold', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 100;
        end;
        Gamepads[iCount].iAThreshold := lngReceived;

        if ReadRegSetting(KeyHandle, 'ALFactor', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 255;
        end;
        Gamepads[iCount].iLAFactor := lngReceived;

        if ReadRegSetting(KeyHandle, 'ARFactor', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 255;
        end;
        Gamepads[iCount].iRAFactor := lngReceived;

        if ReadRegSetting(KeyHandle, 'NButtons', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 24;
        end;
        Gamepads[iCount].iButtons := lngReceived;
        Gamepads[iCount].iButtonsOld := lngReceived;

        if ReadRegSetting(KeyHandle, 'AxesOn', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 31;
        end;
        Gamepads[iCount].iAxesOn := lngReceived;
        Gamepads[iCount].iAxesOnOld := lngReceived;

        if ReadRegSetting(KeyHandle, 'NrOfLayouts', @lngReceived, 4) <> 4 then
        begin
          lngReceived := 1;
        end;
        Gamepads[iCount].iLayouts := lngReceived;

        for iConfCount := 0 to Gamepads[iCount].iLayouts - 1 do
        begin
          if ReadRegSetting(KeyHandle, 'MapMatrix' +
            IntToStr(iConfCount), @MapTemp, sizeof(MapTemp)) <> sizeof(MapTemp) then
          begin
            SetDefaultMapping(MapTemp);
            //CopyMemory(@MapTemp, @DefMapping, sizeof(MapTemp));
          end;
          CopyMemory(@Gamepads[iCount].MapMatrix[iConfCount],
            @MapTemp, sizeof(MapTemp));
        end;

        if ReadRegSetting(KeyHandle, 'AxesScale', @ASTemp, sizeof(ASTemp)) <>
          sizeof(ASTemp) then
        begin
          for iCount2 := 0 to High(ASTemp) do
          begin
            ASTemp[iCount2] := 100;
          end;
        end;
        CopyMemory(@Gamepads[iCount].AxesScale, @ASTemp, sizeof(ASTemp));

        if ReadRegSetting(KeyHandle, 'LFullRange', @lngReceived, 4) = 4 then
        begin
          Gamepads[iCount].bLStickFull := boolean(lngReceived);
        end
        else
        begin
          Gamepads[iCount].bLStickFull := False;
        end;

        if ReadRegSetting(KeyHandle, 'RFullRange', @lngReceived, 4) = 4 then
        begin
          Gamepads[iCount].bRStickFull := boolean(lngReceived);
        end
        else
        begin
          Gamepads[iCount].bRStickFull := False;
        end;

        CheckForErrors(@Gamepads[iCount], True);

        RegCloseKey(KeyHandle);
      end;
    end;
    SetupDiDestroyDeviceInfoList(lngDeviceInfoSet);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);

  procedure SetDesktopIconFonts(const AFont: TFont);
  var
    LogFont: TLogFont;
  begin
    if SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(LogFont),
      @LogFont, 0) then
      AFont.Handle := CreateFontIndirect(LogFont)
    else
      AFont.Handle := GetStockObject(DEFAULT_GUI_FONT);
  end;

var
  iCount: Integer;
  tComp:  TComponent;
begin
  SetDesktopIconFonts(Font);
  Icon.Handle := LoadIcon(HInstance, 'MAINICON');

  grpXboxBtns.DoubleBuffered := True;
  grpWinBtns.DoubleBuffered := True;
  pnlX.DoubleBuffered  := True;
  pnlY.DoubleBuffered  := True;
  pnlZ.DoubleBuffered  := True;
  pnlRz.DoubleBuffered := True;
  pnlSld.DoubleBuffered := True;
  pnlRx.DoubleBuffered := True;
  pnlRy.DoubleBuffered := True;

  for iCount := 0 to 23 do
  begin
    tComp := FindComponent('imgBtn' + IntToStr(iCount));
    picWBtn[iCount] := TImage(tComp);
    with picWBtn[iCount].Canvas do begin
      Brush.Color := clDkNavy;
      Ellipse(0, 0, 24, 24);
      Font.Name := 'MS Sans Serif';
      Font.Color := clWhite;
    end;
  end;

  for iCount := 0 to 11 do
  begin
    tComp := FindComponent('imgXB' + IntToStr(iCount));
    picXBtn[iCount] := TImage(tComp);
    with picXBtn[iCount].Canvas do begin
      Brush.Color := clDkNavy;
      Ellipse(0, 0, 24, 24);
      Font.Name := 'MS Sans Serif';
      Font.Color := clWhite;
    end;
  end;

  for iCount := 0 to 23 do
  begin
    tComp := FindComponent('cmdAsg' + IntToStr(iCount));
    cmdAsgn[iCount] := TButton(tComp);
    cmdAsgn[iCount].OnClick := cmdAsgnClick;
    cmdAsgn[iCount].Tag := iCount;
  end;

  ckbAxesOn[0] := ckbZOn;
  ckbAxesOn[1] := ckbRxOn;
  ckbAxesOn[2] := ckbRyOn;
  ckbAxesOn[3] := ckbRzOn;
  ckbAxesOn[4] := ckbSliderOn;

  for iCount := 0 to 4 do
  begin
    ckbAxesOn[iCount].Tag := iCount;
    ckbAxesOn[iCount].OnClick := ckbAxesOnClick;
  end;

  picDPad[0] := ImgDPup;
  picDPad[1] := ImgDPdown;
  picDPad[2] := ImgDPleft;
  picDPad[3] := ImgDPright;

  imgPOV[0] := imgU;
  imgPOV[1] := imgUR;
  imgPOV[2] := imgR;
  imgPOV[3] := imgDR;
  imgPOV[4] := imgD;
  imgPOV[5] := imgDL;
  imgPOV[6] := imgL;
  imgPOV[7] := imgUL;

  trkRumble[0] := TrackBarL;
  trkRumble[1] := TrackBarR;

  udScale[0] := udScaleX;
  udScale[1] := udScaleY;
  udScale[2] := udScaleZ;
  udScale[3] := udScaleRZ;
  udScale[4] := udScaleSLD;
  udScale[5] := udScaleRX;
  udScale[6] := udScaleRY;

  for iCount := 0 to 6 do
  begin
    udScale[iCount].OnClick := udScaleClick;
    udScale[iCount].Tag := iCount;
  end;

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    for iCount := 0 to 23 do
    begin
      cmdAsgn[iCount].Caption := WinControls[DefMappingNT[iCount]];
    end;
  end
  else
  begin
    if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    begin
      for iCount := 0 to 23 do
      begin
        cmdAsgn[iCount].Caption := WinControls[DefMapping9x[iCount]];
      end;
    end;
  end;

  USBGuid := StringToGUID('{A5DCBF10-6530-11D2-901F-00C04FB951ED}');

  MyDeviceDetected := False;
  intUSBCount := 0;
  SetLength(strUSBDevicePath, intUSBCount);
  SetLength(strDevicePath, intUSBCount);
  XBCDEnumerate(EnumCallback, True);
  ConfigureButtons;

  ReadHandle := INVALID_HANDLE_VALUE;
  HIDHandle  := INVALID_HANDLE_VALUE;

  if MainForm.cmbDevices.Items.Count > 0 then
  begin
    MainForm.cmbDevices.ItemIndex := 0;
    MainForm.cmbDevices.OnChange(nil);
  end;
end;

procedure TMainForm.cmdExitClick(Sender: TObject);
begin
  MainForm.Close;
end;

//--PrepareForOverlappedTransfer--------------------
procedure PrepareForOverlappedTransfer;
begin
  //******************************************************************************
  //CreateEvent
  //Creates an event object for the overlapped structure used with ReadFile.
  //Requires a security attributes structure or null,
  //Manual Reset = True (ResetEvent resets the manual reset object to nonsignaled),
  //Initial state = True (signaled),
  //and event object name (optional)
  //Returns a handle to the event object.
  //******************************************************************************

  if EventObject = 0 then
    EventObject := CreateEvent(nil, True, True, nil);

  //Set the members of the overlapped structure.
  HIDOverlapped.Offset := 0;
  HIDOverlapped.OffsetHigh := 0;
  HIDOverlapped.hEvent := EventObject;
end;
//--PrepareForOverlappedTransfer--------------------

procedure TMainForm.DispAxis(imgAxis: TImage; bVal: byte; iIndex: Integer);
var
  iRetVal: Integer;
  iP2: Integer;
begin
  if bVal <= 127 then
    iRetVal := Trunc((imgAxis.Height / 2) + ((imgAxis.Height / 2) * (bVal / 127)))
  else
    iRetVal := Trunc((imgAxis.Height / 2) + ((imgAxis.Height / 2) * ((bVal - 255) / 127)));

  imgAxis.Canvas.Brush.Color := clBtnFace;
  imgAxis.Canvas.FillRect(Bounds(0, 0, imgAxis.Width, imgAxis.Height));

  if iIndex = -1 then
    imgAxis.Canvas.Brush.Color := clBlue
  else begin
    iP2 := Round(Power(2, iIndex));
    if Gamepads[MainForm.cmbDevices.ItemIndex].iAxesOnOld and iP2 = iP2 then
      imgAxis.Canvas.Brush.Color := clBlue
    else
      imgAxis.Canvas.Brush.Color := clMaroon;
  end;
  imgAxis.Canvas.FillRect(Bounds(0, iRetVal, imgAxis.Width, imgAxis.Height - iRetVal - 1));
end;

procedure TMainForm.ReadReport;

  procedure DrawBtnLbl(Canvas: TCanvas; const T: string); {$IFDEF VER180} inline; {$ENDIF}
  begin
    with Canvas do TextOut(11 - TextWidth(T) div 2, 5, T);
  end;

  function DBtnDown(Data, Button: Integer): Boolean; {$IFDEF VER180} inline; {$ENDIF}
  begin
    Result := (Data and Round(Power(2, Button))) <> 0;
  end;

type
  TReport = array[0..39] of byte;
var
  NumberOfBytesRead: DWORD;
  ReadBuffer: TReport; // Byte 0 is the report ID.
  ByteValue: string;
  iCount: Integer;
  intButtons: Integer;
  intPOVCount: Integer;
  iRetVal: Integer;
  pDevice: PGamepad;
const
  {$J+}
  OldBuffer: TReport = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  {$J-}
begin
  //Read data from the device.

  //******************************************************************************
  //ReadFile
  //Returns: the report in ReadBuffer.
  //Requires: a device handle returned by CreateFile
  //(for overlapped I/O, CreateFile must be called with FILE_FLAG_OVERLAPPED),
  //the Input report length in bytes returned by HidP_GetCaps,
  //and an overlapped structure whose hEvent member is set to an event object.
  //******************************************************************************

  //Do an overlapped ReadFile.
  //The function returns immediately, even if the data hasn't been received yet.
  ReadFile(ReadHandle,
    ReadBuffer,
    SizeOf(ReadBuffer),
    NumberOfBytesRead, @HIDOverlapped);

  //******************************************************************************
  //WaitForSingleObject
  //Used with overlapped ReadFile.
  //Returns when ReadFile has received the requested amount of data or on timeout.
  //Requires an event object created with CreateEvent
  //and a timeout value in milliseconds.
  //******************************************************************************
  iRetVal := WaitForSingleObject(EventObject, 100);

  // Find out if ReadFile completed or timed out.
  case iRetVal of
    WAIT_OBJECT_0:
    begin
      // ReadFile has completed
      if CompareMem(@ReadBuffer, @OldBuffer, 40) and (not tabUpdate) then
        Exit;

      if chkRawData.Checked = True then
      // Display the received bytes in the text box.
      begin
        txtBytesReceived.Text := '';
        if tabWindows.Showing then
        begin
          for iCount := 1 to 18 do
            txtBytesReceived.Text := txtBytesReceived.Text + IntToHex(ReadBuffer[iCount], 2) + '   ';
        end
        else
        begin
          for iCount := 20 to High(ReadBuffer) do
            txtBytesReceived.Text := txtBytesReceived.Text + IntToHex(ReadBuffer[iCount], 2) + '   ';
        end;
      end
      else
        txtBytesReceived.Text := '';

      // Display the driver's active profile
      txtActiveProfile.Caption := IntToStr(ReadBuffer[19]);

      if tabXbox.Showing then
      begin
        pDevice := @Gamepads[cmbDevices.ItemIndex];

        if pDevice.is360 then begin
          // X360 digital buttons
          intButtons := ReadBuffer[23] shr 4;
          for iCount := 0 to 5 do begin
            if iCount = 4 then intButtons := ReadBuffer[23] and $F;                       
            if DBtnDown(intButtons, iCount mod 4) then
              picXBtn[iCount].Canvas.Brush.Color := clBlue
            else
              picXBtn[iCount].Canvas.Brush.Color := clDkNavy;
          end;
          // X360 analog triggers
          for iCount := 6 to 7 do
            picXBtn[iCount].Canvas.Brush.Color :=
              GetMixedColor(clDkNavy, clBlue, 0, ReadBuffer[18+iCount], $FF);
        end else
          for iCount := 0 to 7 do
            picXBtn[iCount].Canvas.Brush.Color :=
              GetMixedColor(clDkNavy, clBlue, 0, ReadBuffer[24+iCount], $FF);

        intButtons := ReadBuffer[22] shr 4;
        for iCount := 8 to 11 do
          if DBtnDown(intButtons, iCount mod 4) then
            picXBtn[iCount].Canvas.Brush.Color := clBlue
          else
            picXBtn[iCount].Canvas.Brush.Color := clDkNavy;

        for iCount := 0 to 11 do begin
          picXBtn[iCount].Canvas.Ellipse(0, 0, 24, 24);
          if pDevice.is360 then
            DrawBtnLbl(picXBtn[iCount].Canvas, X360Labels[iCount])
          else
            DrawBtnLbl(picXBtn[iCount].Canvas, XboxLabels[iCount]);
        end;

        intButtons := ReadBuffer[22] and $F;
        for iCount := 0 to 3 do
          picDPad[iCount].Visible := DBtnDown(intButtons, iCount);

        if pDevice.is360 then iCount := 27 else iCount := 33;
        if ReadBuffer[iCount] <= 127 then
          imgCLS.Left := Trunc((pnlLS.Width / 2) + ((pnlLS.Width / 2) *
            (ReadBuffer[iCount] / 127)) - (imgCLS.Width / 2))
        else
          imgCLS.Left := Trunc((pnlLS.Width / 2) + ((pnlLS.Width / 2) *
            ((ReadBuffer[iCount] - 254) / 127)) - (imgCLS.Width / 2));

        if ReadBuffer[iCount+2] <= 127 then
          imgCLS.Top := Trunc((pnlLS.Height / 2) + ((pnlLS.Height / 2) *
            (-ReadBuffer[iCount+2] / 127)) - imgCLS.Height / 2)
        else
          imgCLS.Top := Trunc((pnlLS.Height / 2) + ((pnlLS.Height / 2) *
            ((255 - ReadBuffer[iCount+2]) / 127)) - imgCLS.Height / 2);

        if ReadBuffer[iCount+4] <= 127 then
          imgCRS.Left := Trunc((pnlRS.Width / 2) + ((pnlRS.Width / 2) *
            (ReadBuffer[iCount+4] / 127)) - (imgCRS.Width / 2))
        else
          imgCRS.Left := Trunc((pnlRS.Width / 2) + ((pnlRS.Width / 2) *
            ((ReadBuffer[iCount+4] - 254) / 127)) - (imgCRS.Width / 2));

        if ReadBuffer[iCount+6] <= 127 then
          imgCRS.Top := Trunc((pnlRS.Height / 2) + ((pnlRS.Height / 2) *
            (-ReadBuffer[iCount+6] / 127)) - imgCRS.Height / 2)
        else
          imgCRS.Top := Trunc((pnlRS.Height / 2) + ((pnlRS.Height / 2) *
            ((255 - ReadBuffer[iCount+6]) / 127)) - imgCRS.Height / 2);
      end;

      if tabWindows.Showing then
      begin
        ByteValue := '';
        ByteValue := LowerCase(IntToHex(ReadBuffer[3], 2) +
          IntToHex(ReadBuffer[2], 2) + IntToHex(ReadBuffer[1], 2));

        intButtons := StrToInt('$' + ByteValue);
        for iCount := 0 to 23 do
        begin
          if DBtnDown(intButtons, iCount) then
          begin
            if iCount < Gamepads[cmbDevices.ItemIndex].iButtonsOld then
              picWBtn[iCount].Canvas.Brush.Color := clBlue
            else
              picWBtn[iCount].Canvas.Brush.Color := clRed;
          end
          else
          begin
            if iCount < Gamepads[cmbDevices.ItemIndex].iButtonsOld then
              picWBtn[iCount].Canvas.Brush.Color := clDkNavy
            else
              picWBtn[iCount].Canvas.Brush.Color := clMaroon;
          end;

          picWBtn[iCount].Canvas.Ellipse(0, 0, 24, 24);
          DrawBtnLbl(picWBtn[iCount].Canvas, IntToStr(iCount + 1));
        end;

        DispAxis(imgX, ReadBuffer[5], -1);
        DispAxis(imgY, ReadBuffer[7], -1);
        DispAxis(imgZ, ReadBuffer[9], 0);
        DispAxis(imgRx, ReadBuffer[11], 1);
        DispAxis(imgRy, ReadBuffer[13], 2);
        DispAxis(imgRz, ReadBuffer[15], 3);
        DispAxis(imgSld, ReadBuffer[17], 4);

        for intPOVCount := 0 to 7 do
          imgPOV[intPOVCount].Visible := (intPOVCount = ReadBuffer[18]);
      end;

      OldBuffer := ReadBuffer;
      tabUpdate := False;
    end;
    WAIT_TIMEOUT:
    begin
      //Timeout
      //Cancel the operation

      //*************************************************************
      //CancelIo
      //Cancels the ReadFile
      //Requires the device handle.
      //Returns non-zero on success.
      //*************************************************************
      CancelIo(ReadHandle);
      //The timeout may have been because the device was removed,
      //so close any open handles and
      //set MyDeviceDetected=False to cause the application to
      //look for the device on the next attempt.
      //CloseHandle(HIDHandle);
      //CloseHandle(ReadHandle);
      MyDeviceDetected := False;
    end
    else
      MyDeviceDetected := False;
  end;

  //******************************************************************************
  //ResetEvent
  //Sets the event object in the overlapped structure to non-signaled.
  //Requires a handle to the event object.
  //Returns non-zero on success.
  //******************************************************************************

  ResetEvent(EventObject);
end;

procedure WriteReport;
var
  NumberOfBytesWritten: DWORD;
  SendBuffer: array [0..2] of byte;
begin
  //Send data to the device.

  //******************************************************************************
  //WriteFile
  //Sends a report to the device.
  //Returns: success or failure.
  //Requires: the handle returned by CreateFile and
  //The output report byte length returned by HidP_GetCaps
  //******************************************************************************

  //The first byte is the Report ID
  SendBuffer[0] := 2;

  SendBuffer[1] := trkRumble[0].Position;
  SendBuffer[2] := trkRumble[1].Position;

  NumberOfBytesWritten := 0;

  WriteFile(HIDHandle, SendBuffer, sizeof(SendBuffer), NumberOfBytesWritten, nil);

  if MainForm.chkRawData.Checked = True then
  begin
    MainForm.txtBytesSent.Text :=
      IntToHex(SendBuffer[1], 2) + '         ' + IntToHex(SendBuffer[2], 2);
  end
  else
    MainForm.txtBytesSent.Text := '';

end;

procedure ReadAndWriteToDevice;
begin
  //If the device hasn't been detected or it timed out on a previous attempt
  //to access it, look for the device.
  if MyDeviceDetected = False then
  begin
    MainForm.tmrContinuousDataCollect.Enabled := False;
    if MessageBox(MainForm.Handle, 'Please make sure the device is plugged in.',
      'Error', MB_RETRYCANCEL or MB_ICONERROR) = idRetry then
    begin
      if HIDHandle <> INVALID_HANDLE_VALUE then
      begin
        CloseHandle(HIDHandle);
      end;
      HIDHandle := INVALID_HANDLE_VALUE;

      if ReadHandle <> INVALID_HANDLE_VALUE then
      begin
        CloseHandle(ReadHandle);
      end;
      ReadHandle := INVALID_HANDLE_VALUE;

      ReadHandle := CreateFile(
        PChar(strDevicePath[MainForm.cmbDevices.ItemIndex]),
        GENERIC_READ,
        FILE_SHARE_READ or
        FILE_SHARE_WRITE, nil,//Addr(Security),
        OPEN_EXISTING,
        FILE_FLAG_OVERLAPPED,
        0);

      HIDHandle := CreateFile(PChar(strDevicePath[MainForm.cmbDevices.ItemIndex]),
        GENERIC_WRITE,
        FILE_SHARE_READ or
        FILE_SHARE_WRITE, nil,//Addr(Security),
        OPEN_EXISTING,
        0,
        0);

      PrepareForOverlappedTransfer;
      if (ReadHandle <> INVALID_HANDLE_VALUE) and
        (HIDHandle <> INVALID_HANDLE_VALUE) then
      begin
        MyDeviceDetected := True;
      end
      else
      begin
        if HIDHandle <> INVALID_HANDLE_VALUE then
        begin
          CloseHandle(HIDHandle);
        end;
        HIDHandle := INVALID_HANDLE_VALUE;

        if ReadHandle <> INVALID_HANDLE_VALUE then
        begin
          CloseHandle(ReadHandle);
        end;
        ReadHandle := INVALID_HANDLE_VALUE;

        MyDeviceDetected := False;
      end;

      MainForm.tmrContinuousDataCollect.Enabled := True;
    end
    else
    begin
      MainForm.cmdRefresh.OnClick(nil);
      Exit;
    end;
    //FindTheHid;
    //MyDeviceDetected := FindTheUSB;
  end;

  if MyDeviceDetected = True then
  begin
    //Write a report to the device
    WriteReport;
    //Read a report from the device.
    MainForm.ReadReport;
  end;

end;

procedure TMainForm.cmbDevicesChange(Sender: TObject);
var
  iCount: Integer;
begin
  trkRumble[0].Position := 0;
  trkRumble[1].Position := 0;

  MainForm.tmrContinuousDataCollect.Enabled := False;

  if HIDHandle <> INVALID_HANDLE_VALUE then
  begin
    WriteReport;
    CloseHandle(HIDHandle);
  end;
  HIDHandle := INVALID_HANDLE_VALUE;

  if ReadHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(ReadHandle);
  end;
  ReadHandle := INVALID_HANDLE_VALUE;

  if cmbDevices.ItemIndex >= 0 then
  begin
    cmdApply.Enabled := True;
    cmdReset.Enabled := True;
    cmdOpen.Enabled  := True;
    cmdSave.Enabled  := True;
    trkRumble[0].Enabled := True;
    trkRumble[1].Enabled := True;

    cmbDevType.Enabled := True;
    cmbDevType.ItemIndex :=
      Gamepads[cmbDevices.ItemIndex].DevType - HID_USAGE_JOYSTICK;

    udLAFactor.Enabled  := True;
    udRAFActor.Enabled  := True;
    udLAFactor.Position := Gamepads[cmbDevices.ItemIndex].iLAFactor;
    udRAFactor.Position := Gamepads[cmbDevices.ItemIndex].iRAFactor;
    txtLAFactor.Caption := IntToStr(udLAFactor.Position);
    txtRAFactor.Caption := IntToStr(udRAFactor.Position);

    udNButtons.Enabled  := True;
    udNButtons.Position := Gamepads[cmbDevices.ItemIndex].iButtons;
    txtNButtons.Caption := IntToStr(udNButtons.Position);

    udLStickDZ.Enabled  := True;
    udRStickDZ.Enabled  := True;
    udLStickDZ.Position := Gamepads[cmbDevices.ItemIndex].iLStickDZ;
    udRStickDZ.Position := Gamepads[cmbDevices.ItemIndex].iRStickDZ;
    txtLStickDZ.Caption := IntToStr(udLStickDZ.Position);
    txtRStickDZ.Caption := IntToStr(udRStickDZ.Position);
    udLStickDZ.OnClick(nil, btNext);
    udRStickDZ.OnClick(nil, btNext);

    chkLFRange.Enabled := True;
    chkRFRange.Enabled := True;
    chkLFRange.Checked := Gamepads[cmbDevices.ItemIndex].bLStickFull;
    chkRFRange.Checked := Gamepads[cmbDevices.ItemIndex].bRStickFull;

    udBThreshold.Enabled  := True;
    udTThreshold.Enabled  := True;
    udAThreshold.Enabled  := True;
    udBThreshold.Position := Gamepads[cmbDevices.ItemIndex].iBThreshold;
    udTThreshold.Position := Gamepads[cmbDevices.ItemIndex].iTThreshold;
    udAThreshold.Position := Gamepads[cmbDevices.ItemIndex].iAThreshold;
    txtBThreshold.Caption := IntToStr(udBThreshold.Position);
    txtTThreshold.Caption := IntToStr(udTThreshold.Position);
    txtAThreshold.Caption := IntToStr(udAThreshold.Position);

    for iCount := 0 to 6 do
    begin
      udScale[iCount].Enabled  := True;
      udScale[iCount].Position :=
        Gamepads[cmbDevices.ItemIndex].AxesScale[iCount];
      TStaticText(udScale[iCount].Associate).Caption :=
        IntToStr(udScale[iCount].Position);
    end;

    cmbProfiles.Clear;

    for iCount := 1 to Gamepads[cmbDevices.ItemIndex].iLayouts do
    begin
      cmbProfiles.AddItem(IntToStr(iCount), nil);
    end;

    cmbProfiles.Enabled := True;
    cmbProfiles.ItemIndex := 0;
    cmbProfiles.OnChange(cmbProfiles);

    cmdPMenu.Enabled := True;

    for iCount := 0 to 4 do
    begin
      ckbAxesOn[iCount].Enabled := True;
      ckbAxesOn[iCount].OnClick := nil;
      ckbAxesOn[iCount].Checked :=
        boolean(Gamepads[cmbDevices.ItemIndex].iAxesOn and Round(Power(2, iCount)));
      ckbAxesOn[iCount].OnClick := ckbAxesOnClick;
    end;

    ReadHandle := CreateFile(PChar(strDevicePath[cmbDevices.ItemIndex]),
      GENERIC_READ,
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      nil,
      OPEN_EXISTING,
      FILE_FLAG_OVERLAPPED, 0);

    HIDHandle := CreateFile(PChar(strDevicePath[cmbDevices.ItemIndex]),
      GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      nil,
      OPEN_EXISTING,
      0, 0);

    PrepareForOverlappedTransfer;
    if (ReadHandle <> INVALID_HANDLE_VALUE) and
      (HIDHandle <> INVALID_HANDLE_VALUE) then
    begin
      ReadAndWriteToDevice;
      MainForm.tmrContinuousDataCollect.Enabled := True;
    end
    else
    begin
      if HIDHandle <> INVALID_HANDLE_VALUE then
      begin
        CloseHandle(HIDHandle);
      end;
      HIDHandle := INVALID_HANDLE_VALUE;

      if ReadHandle <> INVALID_HANDLE_VALUE then
      begin
        CloseHandle(ReadHandle);
      end;
      ReadHandle := INVALID_HANDLE_VALUE;

      cmbDevices.ItemIndex := -1;
      cmbDevices.OnChange(nil);
    end;
  end
  else
  begin
    cmdApply.Enabled := False;
    cmdReset.Enabled := False;
    cmdOpen.Enabled  := False;
    cmdSave.Enabled  := False;
    trkRumble[0].Enabled := False;
    trkRumble[1].Enabled := False;

    cmbDevType.Enabled := False;
    cmbDevType.ItemIndex := -1;

    udLAFactor.Enabled  := False;
    udRAFActor.Enabled  := False;
    udLAFactor.Position := 255;
    udRAFactor.Position := 255;
    txtLAFactor.Caption := IntToStr(udLAFactor.Position);
    txtRAFactor.Caption := IntToStr(udRAFactor.Position);

    udNButtons.Enabled  := False;
    udNButtons.Position := 24;
    txtNButtons.Caption := IntToStr(udNButtons.Position);

    udLStickDZ.Enabled  := False;
    udRStickDZ.Enabled  := False;
    udLStickDZ.Position := 0;
    udRStickDZ.Position := 0;
    txtLStickDZ.Caption := '0';
    txtRStickDZ.Caption := '0';
    udLStickDZ.OnClick(nil, btNext);
    udRStickDZ.OnClick(nil, btNext);
    chkLFRange.Enabled := False;
    chkRFRange.Enabled := False;
    chkLFRange.Checked := False;
    chkRFRange.Checked := False;
    udBThreshold.Enabled := False;
    udTThreshold.Enabled := False;
    udAThreshold.Enabled := False;
    udBThreshold.Position := 10;
    udTThreshold.Position := 10;
    udAThreshold.Position := 100;
    txtBThreshold.Caption := '10';
    txtTThreshold.Caption := '10';
    txtAThreshold.Caption := '100';

    for iCount := 0 to 6 do
    begin
      udScale[iCount].Enabled  := False;
      udScale[iCount].Position := 100;
      TStaticText(udScale[iCount].Associate).Caption :=
        IntToStr(udScale[iCount].Position);
    end;

    for iCount := 0 to 4 do
    begin
      ckbAxesOn[iCount].Enabled := False;
    end;

    for iCount := 0 to 23 do
    begin
      picWBtn[iCount].Canvas.Ellipse(0, 0, 24, 24);
    end;

    for iCount := 0 to 11 do
    begin
      picXBtn[iCount].Canvas.Ellipse(0, 0, 24, 24);
    end;

    cmbProfiles.Enabled := False;
    cmbProfiles.Clear;
    cmbProfiles.OnChange(cmbProfiles);

    cmdPMenu.Enabled := False;
  end;
end;

procedure TMainForm.cmbProfilesChange(Sender: TObject);
var
  iCount: Integer;
begin
  if cmbProfiles.ItemIndex >= 0 then
  begin
    for iCount := 0 to 23 do
    begin
      cmdAsgn[iCount].Caption :=
        WinControls[Gamepads[cmbDevices.ItemIndex].MapMatrix[cmbProfiles.ItemIndex][iCount]];
      cmdAsgn[iCount].Enabled := True;
    end;
  end
  else
  begin
    for iCount := 0 to 23 do
    begin
      cmdAsgn[iCount].Enabled := False;
      //cmdAsgn[iCount].Caption := WinControls[DefMapping[iCount]];
    end;
  end;
end;

procedure TMainForm.tmrContinuousDataCollectTimer(Sender: TObject);
begin
  ReadAndWriteToDevice;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // Actions that must execute when the program ends.

  trkRumble[0].Position := 0;
  trkRumble[1].Position := 0;

  MainForm.tmrContinuousDataCollect.Enabled := False;

  if HIDHandle <> INVALID_HANDLE_VALUE then
  begin
    WriteReport;
    CloseHandle(HIDHandle);
  end;
  HIDHandle := INVALID_HANDLE_VALUE;

  if ReadHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(ReadHandle);
  end;
  ReadHandle := INVALID_HANDLE_VALUE;

  dlgOpen.Free;
  dlgSave.Free;
end;

procedure WriteRegSetting(const KeyHandle: HKEY; strName: string;
  dType: DWORD; Buffer: Pointer; iSize: Integer);
begin
  RegSetValueEx(KeyHandle,
    PChar(strName),
    0,
    dType,
    Buffer,
    iSize);
end;

procedure TMainForm.cmdApplyClick(Sender: TObject);
var
  lngDeviceInfoSet: HDEVINFO;
  KeyHandle: HKEY;
  iCount: Integer;
  iCount2: Integer;
  DeviceInterfaceData: TSPDeviceInterfaceData;
  DeviceInfoData: TSPDevInfoData;
  FSConfig: TFeatureSetConfig;
  propchange: TSPPropChangeParams;
  bRestart: boolean;
  iTempVal: Integer;
begin
  if MyDeviceDetected = True then
  begin
    lngDeviceInfoSet := SetupDiGetClassDevs(Addr(USBGuid),
      nil,
      0,
      (DIGCF_PRESENT or
      DIGCF_DEVICEINTERFACE));

    for iCount := 0 to High(strUSBDevicePath) do
    begin
      DeviceInterfaceData.cbSize := sizeof(DeviceInterfaceData);
      SetupDiOpenDeviceInterface(lngDeviceInfoSet,
        PChar(strUSBDevicePath[iCount]),
        0,
        @DeviceInterfaceData);
      DeviceInfoData.cbSize := sizeof(DeviceInfoData);
      SetupDiGetDeviceInterfaceDetail(lngDeviceInfoSet,
        @DeviceInterfaceData,
        nil,
        0,
        nil,
        @DeviceInfoData);
      KeyHandle := SetupDiOpenDevRegKey(lngDeviceInfoSet,
        DeviceInfoData,
        DICS_FLAG_GLOBAL,
        0,
        DIREG_DEV,
        KEY_ALL_ACCESS);
      if KeyHandle <> INVALID_HANDLE_VALUE then
      begin
        WriteRegSetting(KeyHandle,
          'DevType',
          REG_DWORD,
          @Gamepads[iCount].DevType,
          4);

        WriteRegSetting(KeyHandle,
          'LStickDZ',
          REG_DWORD,
          @Gamepads[iCount].iLStickDZ,
          4);

        WriteRegSetting(KeyHandle,
          'RStickDZ',
          REG_DWORD,
          @Gamepads[iCount].iRStickDZ,
          4);

        WriteRegSetting(KeyHandle,
          'BThreshold',
          REG_DWORD,
          @Gamepads[iCount].iBThreshold,
          4);

        WriteRegSetting(KeyHandle,
          'TThreshold',
          REG_DWORD,
          @Gamepads[iCount].iTThreshold,
          4);

        WriteRegSetting(KeyHandle,
          'AThreshold',
          REG_DWORD,
          @Gamepads[iCount].iAThreshold,
          4);

        WriteRegSetting(KeyHandle,
          'ALFactor',
          REG_DWORD,
          @Gamepads[iCount].iLAFactor,
          4);

        WriteRegSetting(KeyHandle,
          'ARFactor',
          REG_DWORD,
          @Gamepads[iCount].iRAFactor,
          4);

        WriteRegSetting(KeyHandle,
          'NButtons',
          REG_DWORD,
          @Gamepads[iCount].iButtons,
          4);

        WriteRegSetting(KeyHandle,
          'AxesOn',
          REG_DWORD,
          @Gamepads[iCount].iAxesOn,
          4);

        WriteRegSetting(KeyHandle,
          'NrOfLayouts',
          REG_DWORD,
          @Gamepads[iCount].iLayouts,
          4);

        WriteRegSetting(KeyHandle,
          'AxesScale',
          REG_BINARY,
          @Gamepads[iCount].AxesScale,
          7);

        iTempVal := Integer(Gamepads[iCount].bLStickFull);
        WriteRegSetting(KeyHandle,
          'LFullRange',
          REG_DWORD,
          @iTempVal,
          4);

        iTempVal := Integer(Gamepads[iCount].bRStickFull);
        WriteRegSetting(KeyHandle,
          'RFullRange',
          REG_DWORD,
          @iTempVal,
          4);

        for iCount2 := 0 to Gamepads[iCount].iLayouts - 1 do
        begin
          WriteRegSetting(KeyHandle,
            'MapMatrix' + IntToStr(iCount2),
            REG_BINARY,
            @Gamepads[iCount].MapMatrix[iCount2],
            24);
        end;

        RegCloseKey(KeyHandle);
      end;

      bRestart := False;

      if Gamepads[iCount].iAxesOn <> Gamepads[iCount].iAxesOnOld then
      begin
        bRestart := True;
        Gamepads[iCount].iAxesOnOld := Gamepads[iCount].iAxesOn;
      end;

      if Gamepads[iCount].iButtons <> Gamepads[iCount].iButtonsOld then
      begin
        bRestart := True;
        Gamepads[iCount].iButtonsOld := Gamepads[iCount].iButtons;
      end;

      if Gamepads[iCount].DevType <> Gamepads[iCount].DevTypeOld then
      begin
        bRestart := True;
        Gamepads[iCount].DevTypeOld := Gamepads[iCount].DevType;
      end;

      if bRestart then
      begin
        if iCount = cmbDevices.ItemIndex then
        begin
          trkRumble[0].Position := 0;
          trkRumble[1].Position := 0;

          tmrContinuousDataCollect.Enabled := False;

          if HIDHandle <> INVALID_HANDLE_VALUE then
          begin
            WriteReport;
            CloseHandle(HIDHandle);
          end;
          HIDHandle := INVALID_HANDLE_VALUE;

          if ReadHandle <> INVALID_HANDLE_VALUE then
          begin
            CloseHandle(ReadHandle);
          end;
          ReadHandle := INVALID_HANDLE_VALUE;
        end;

        propchange.ClassInstallHeader.cbSize :=
          sizeof(TSPClassInstallHeader);
        propchange.ClassInstallHeader.InstallFunction := DIF_PROPERTYCHANGE;
        propchange.HwProfile := 0;
        propchange.Scope := DICS_FLAG_GLOBAL;
        propchange.StateChange := DICS_PROPCHANGE;
        //propchange.StateChange := DICS_DISABLE;

        SetupDiSetClassInstallParams(lngDeviceInfoSet,
          @DeviceInfoData,
          @propchange,
          sizeof(propchange));

        SetupDiChangeState(lngDeviceInfoSet, DeviceInfoData);

        Sleep(500);

        if iCount = cmbDevices.ItemIndex then
        begin
          ReadHandle :=
            CreateFile(PChar(strDevicePath[cmbDevices.ItemIndex]),
            GENERIC_READ,
            FILE_SHARE_READ or
            FILE_SHARE_WRITE, nil,
            //Addr(Security),
            OPEN_EXISTING,
            FILE_FLAG_OVERLAPPED,
            0);

          HIDHandle :=
            CreateFile(PChar(strDevicePath[cmbDevices.ItemIndex]),
            GENERIC_WRITE,
            FILE_SHARE_READ or
            FILE_SHARE_WRITE, nil,
            //Addr(Security),
            OPEN_EXISTING,
            0,
            0);

          PrepareForOverlappedTransfer;
          if (ReadHandle <> INVALID_HANDLE_VALUE) and
            (HIDHandle <> INVALID_HANDLE_VALUE) then
          begin
            MyDeviceDetected := True;
          end
          else
          begin
            MyDeviceDetected := False;
          end;
          MainForm.tmrContinuousDataCollect.Enabled := True;
        end;
      end
      else
      begin
        if iCount = cmbDevices.ItemIndex then
        begin
          FSConfig.id := FEATURE_CODE_SET_CONFIG;
          FSConfig.Signature := XBCD_SIGNATURE;

          HidD_SetFeature(HIDHandle, FSConfig, sizeof(FSConfig));
        end;
      end;
    end;

    SetupDiDestroyDeviceInfoList(lngDeviceInfoSet);
  end;
end;

procedure TMainForm.cmdRefreshClick(Sender: TObject);
begin
  cmdRefresh.Enabled := False;
  trkRumble[0].Position := 0;
  trkRumble[1].Position := 0;

  tmrContinuousDataCollect.Enabled := False;

  if HIDHandle <> INVALID_HANDLE_VALUE then
  begin
    WriteReport;
    CloseHandle(HIDHandle);
  end;
  HIDHandle := INVALID_HANDLE_VALUE;

  if ReadHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(ReadHandle);
  end;
  ReadHandle := INVALID_HANDLE_VALUE;

  cmbDevices.Clear;

  SetLength(Gamepads, 0);

  MyDeviceDetected := False;
  intUSBCount := 0;
  SetLength(strUSBDevicePath, intUSBCount);
  SetLength(strDevicePath, intUSBCount);
  XBCDEnumerate(EnumCallback, True);
  ConfigureButtons;

  if cmbDevices.Items.Count > 0 then
    cmbDevices.ItemIndex := 0;
  
  cmbDevices.OnChange(nil);

  cmdRefresh.Enabled := True;
end;

procedure TMainForm.cmdResetClick(Sender: TObject);
var
  iCount: Integer;
begin

  if cmbDevices.ItemIndex >= 0 then
  begin
    txtLStickDZ.Caption := '0';
    txtRStickDZ.Caption := '0';
    udLStickDZ.Position := 0;
    udRStickDZ.Position := 0;
    Gamepads[cmbDevices.ItemIndex].iLStickDZ := 0;
    Gamepads[cmbDevices.ItemIndex].iRStickDZ := 0;
    udLStickDZ.OnClick(nil, btNext);
    udRStickDZ.OnClick(nil, btNext);
    chkLFRange.Checked := False;
    chkRFRange.Checked := False;
    Gamepads[cmbDevices.ItemIndex].bLStickFull := False;
    Gamepads[cmbDevices.ItemIndex].bRStickFull := False;

    Gamepads[cmbDevices.ItemIndex].DevType := HID_USAGE_GAMEPAD;
    cmbDevType.ItemIndex :=
      Gamepads[cmbDevices.ItemIndex].DevType - HID_USAGE_JOYSTICK;

    txtLAFactor.Caption := '255';
    txtRAFactor.Caption := '255';
    udLAFactor.Position := 255;
    udRAFactor.Position := 255;
    Gamepads[cmbDevices.ItemIndex].iLAFactor := 255;
    Gamepads[cmbDevices.ItemIndex].iRAFactor := 255;
    txtNButtons.Caption := '24';
    udNButtons.Position := 24;
    Gamepads[cmbDevices.ItemIndex].iButtons := 24;
    txtBThreshold.Caption := '10';
    txtTThreshold.Caption := '10';
    txtAThreshold.Caption := '100';
    udBThreshold.Position := 10;
    udTThreshold.Position := 10;
    udAThreshold.Position := 100;
    Gamepads[cmbDevices.ItemIndex].iBThreshold := 10;
    Gamepads[cmbDevices.ItemIndex].iTThreshold := 10;
    Gamepads[cmbDevices.ItemIndex].iAThreshold := 100;

    for iCount := 0 to 6 do
    begin
      udScale[iCount].Position := 100;
      Gamepads[cmbDevices.ItemIndex].AxesScale[iCount] :=
        udScale[iCount].Position;
      TStaticText(udScale[iCount].Associate).Caption :=
        IntToStr(udScale[iCount].Position);
    end;

    for iCount := 0 to 4 do
    begin
      ckbAxesOn[iCount].Checked := True;
    end;
    Gamepads[cmbDevices.ItemIndex].iAxesOn := 31;

    if cmbProfiles.ItemIndex >= 0 then
    begin
      SetDefaultMapping(
        Gamepads[cmbDevices.ItemIndex].MapMatrix[cmbProfiles.ItemIndex]);
      for iCount := 0 to 23 do
      begin
        //Gamepads[cmbDevices.ItemIndex].MapMatrix[cmbProfiles.ItemIndex][iCount] := DefMapping[iCount];
        cmdAsgn[iCount].Caption :=
          WinControls[Gamepads[cmbDevices.ItemIndex].MapMatrix[cmbProfiles.ItemIndex][iCount]];
      end;
    end;
  end;
end;

procedure TMainForm.cmdOpenClick(Sender: TObject);
var
  theFile: file of TOldGamepad;
  fTest:  file of byte;
  tempGamepad: TGamepad;
  tempOldGamepad: TOldGamepad;
  intFileSize: Integer;
  sinComp: single;
  IniFile: TMemIniFile;
  tempStream: TMemoryStream;
  iCount: Integer;
begin
  if dlgOpen.Execute then
  begin
    if FileExists(dlgOpen.FileName) then
    begin
      if LowerCase(RightStr(dlgOpen.FileName, 4)) = '.xgp' then
      begin
        AssignFile(fTest, dlgOpen.FileName);
        FileMode := fmOpenRead;
        Reset(fTest);
        intFileSize := FileSize(fTest);
        CloseFile(fTest);

        sinComp := intFileSize / Sizeof(TOldGamepad);
        if sinComp = Round(sinComp) then
        begin
          AssignFile(theFile, dlgOpen.FileName);
          FileMode := fmOpenRead;

          Reset(theFile);

          Read(theFile, tempOldGamepad);

          CopyMemory(@tempGamepad.MapMatrix,
            @tempOldGamepad.MapMatrix, sizeof(tempGamepad.MapMatrix));
          CopyMemory(@tempGamepad.AxesScale,
            @tempOldGamepad.AxesScale, sizeof(tempGamepad.AxesScale));
          tempGamepad.DevType  := HID_USAGE_GAMEPAD;
          tempGamepad.DevTypeOld := HID_USAGE_GAMEPAD;
          tempGamepad.iLAFactor := tempOldGamepad.actuators.iLFactor;
          tempGamepad.iRAFactor := tempOldGamepad.actuators.iRFactor;
          tempGamepad.iButtons := 24;
          tempGamepad.iButtonsOld := 24;
          tempGamepad.iRStickDZ := tempOldGamepad.iRStickDZ;
          tempGamepad.iLStickDZ := tempOldGamepad.iLStickDZ;
          tempGamepad.bLStickFull := False;
          tempGamepad.bRStickFull := False;
          tempGamepad.iBThreshold := tempOldGamepad.iBThreshold;
          tempGamepad.iTThreshold := tempOldGamepad.iTThreshold;
          tempGamepad.iAThreshold := tempOldGamepad.iAThreshold;
          tempGamepad.iLayouts := tempOldGamepad.iLayouts;
          tempGamepad.iAxesOn  := tempOldGamepad.iAxesOn;
          tempGamepad.iAxesOnOld :=
            Gamepads[cmbDevices.ItemIndex].iAxesOnOld;
          tempGamepad.is360 := Gamepads[cmbDevices.ItemIndex].is360;
          Gamepads[cmbDevices.ItemIndex] := tempGamepad;
          cmbDevices.OnChange(nil);

          CloseFile(theFile);
        end
        else
        begin
          MessageBox(0, 'Incompatible file!', 'Error', MB_OK or MB_ICONERROR);
        end;
      end
      else
      begin
        if LowerCase(RightStr(dlgOpen.FileName, 4)) = '.xgi' then
        begin
          IniFile := TMemIniFile.Create(dlgOpen.FileName);
          tempStream := TMemoryStream.Create;

          with IniFile, tempGamepad do
          begin
            DevType  :=
              ReadInteger('Gamepad', 'DevType', HID_USAGE_GAMEPAD);
            DevTypeOld := Gamepads[cmbDevices.ItemIndex].DevTypeOld;
            iLStickDZ := ReadInteger('Gamepad', 'LStickDZ', 0);
            iRStickDZ := ReadInteger('Gamepad', 'RStickDZ', 0);
            iBThreshold := ReadInteger('Gamepad', 'BThreshold', 10);
            iTThreshold := ReadInteger('Gamepad', 'TThreshold', 10);
            iAThreshold := ReadInteger('Gamepad', 'AThreshold', 100);
            iAxesOn  := ReadInteger('Gamepad', 'AxesOn', 31);
            iAxesOnOld := Gamepads[cmbDevices.ItemIndex].iAxesOnOld;
            is360 := Gamepads[cmbDevices.ItemIndex].is360;
            iLAFactor := ReadInteger('Gamepad', 'LAFactor', 255);
            iRAFactor := ReadInteger('Gamepad', 'RAFactor', 255);
            iButtons := ReadInteger('Gamepad', 'NButtons', 24);
            iButtonsOld := Gamepads[cmbDevices.ItemIndex].iButtonsOld;
            bLStickFull := ReadBool('Gamepad', 'LStickFull', False);
            bRStickFull := ReadBool('Gamepad', 'RStickFull', False);
            tempStream.Clear;
            ReadBinaryStream('Gamepad', 'AxesScale', tempStream);
            tempStream.Position := 0;
            tempStream.Read(AxesScale, sizeof(AxesScale));
            iLayouts := ReadInteger('Gamepad', 'Layouts', 1);
            for iCount := 0 to High(MapMatrix) do
            begin
              tempStream.Clear;
              ReadBinaryStream('Gamepad',
                'Profile' + IntToStr(iCount), tempStream);
              tempStream.Read(MapMatrix[iCount],
                sizeof(MapMatrix[iCount]));
              tempStream.Position := 0;
            end;
          end;

          CheckForErrors(@tempGamepad, False);

          Gamepads[cmbDevices.ItemIndex] := tempGamepad;
          cmbDevices.OnChange(nil);

          tempStream.Free;
          IniFile.Free;
        end
        else
        begin
          MessageBox(0, 'Wrong type of file!', 'Error', MB_OK or MB_ICONERROR);
        end;
      end;
    end;
  end;
end;

procedure TMainForm.cmdSaveClick(Sender: TObject);
var
  IniFile: TMemIniFile;
  tempGamepad: TGamepad;
  tempStream: TMemoryStream;
  iCount:  Integer;
begin
  if dlgSave.Execute then
  begin
    if LowerCase(RightStr(dlgSave.FileName, 4)) = '.xgi' then
    begin
      IniFile := TMemIniFile.Create(dlgSave.FileName);
      tempStream := TMemoryStream.Create;

      tempGamepad := Gamepads[cmbDevices.ItemIndex];

      with IniFile, tempGamepad do
      begin
        Clear;
        WriteInteger('Gamepad', 'DevType', DevType);
        WriteInteger('Gamepad', 'LStickDZ', iLStickDZ);
        WriteInteger('Gamepad', 'RStickDZ', iRStickDZ);
        WriteInteger('Gamepad', 'BThreshold', iBThreshold);
        WriteInteger('Gamepad', 'TThreshold', iTThreshold);
        WriteInteger('Gamepad', 'AThreshold', iAThreshold);
        WriteInteger('Gamepad', 'AxesOn', iAxesOn);
        WriteInteger('Gamepad', 'LAFactor', iLAFactor);
        WriteInteger('Gamepad', 'RAFactor', iRAFactor);
        WriteInteger('Gamepad', 'NButtons', iButtons);
        WriteBool('Gamepad', 'LStickFull', bLStickFull);
        WriteBool('Gamepad', 'RStickFull', bRStickFull);
        tempStream.Clear;
        tempStream.Write(AxesScale, sizeof(AxesScale));
        tempStream.Position := 0;
        WriteBinaryStream('Gamepad', 'AxesScale', tempStream);
        WriteInteger('Gamepad', 'Layouts', iLayouts);
        for iCount := 0 to iLayouts - 1 do
        begin
          tempStream.Clear;
          tempStream.Write(MapMatrix[iCount], sizeof(MapMatrix[iCount]));
          tempStream.Position := 0;
          WriteBinaryStream('Gamepad', 'Profile' +
            IntToStr(iCount), tempStream);
        end;
        UpdateFile;
      end;

      tempStream.Free;
      IniFile.Free;
    end
    else
    begin
      MessageBox(0, 'Wrong type of file!', 'Error', MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TMainForm.cmdAsgnClick(Sender: TObject);
var
  Tag: Integer;
  SemiAxis: string;
  CAssign: TCAssign;
begin
  Tag := (Sender as TButton).Tag;
  with Gamepads[cmbDevices.ItemIndex] do begin
    if is360 then SemiAxis := SemiAxes360[Tag] else SemiAxis := SemiAxes[Tag];
    CAssign := TCAssign.Create(nil);
    try
      MapMatrix[cmbProfiles.ItemIndex][Tag] := CAssign.AssignControl(SemiAxis,
        MapMatrix[cmbProfiles.ItemIndex][Tag]);
    finally
      CAssign.Free;
    end;
    cmdAsgn[Tag].Caption := WinControls[MapMatrix[cmbProfiles.ItemIndex][Tag]];
  end;
end;

procedure TMainForm.udBThresholdClick(Sender: TObject; Button: TUDBtnType);
begin
  txtBThreshold.Caption := IntToStr(udBThreshold.Position);

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].iBThreshold := udBThreshold.Position;
  end;
end;

procedure TMainForm.udTThresholdClick(Sender: TObject; Button: TUDBtnType);
begin
  txtTThreshold.Caption := IntToStr(udTThreshold.Position);

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].iTThreshold := udTThreshold.Position;
  end;
end;

procedure TMainForm.udAThresholdClick(Sender: TObject; Button: TUDBtnType);
begin
  txtAThreshold.Caption := IntToStr(udAThreshold.Position);

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].iAThreshold := udAThreshold.Position;
  end;
end;

procedure TMainForm.udLAFactorClick(Sender: TObject; Button: TUDBtnType);
begin
  txtLAFactor.Caption := IntToStr(udLAFactor.Position);

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].iLAFactor := udLAFactor.Position;
  end;
end;

procedure TMainForm.udRAFactorClick(Sender: TObject; Button: TUDBtnType);
begin
  txtRAFactor.Caption := IntToStr(udRAFactor.Position);

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].iRAFactor := udRAFactor.Position;
  end;
end;

procedure TMainForm.udLStickDZClick(Sender: TObject; Button: TUDBtnType);
begin
  txtLStickDZ.Caption := IntToStr(udLStickDZ.Position);

  shpLDeadZ.Width := Round(pnlLS.Width * (udLStickDZ.Position / 100));
  shpLDeadZ.Height := Round(pnlLS.Height * (udLStickDZ.Position / 100));
  shpLDeadZ.Left := Round((pnlLS.Width / 2) - (shpLDeadZ.Width / 2));
  shpLDeadZ.Top  := Round((pnlLS.Height / 2) - (shpLDeadZ.Height / 2));

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].iLStickDZ := udLStickDZ.Position;
  end;
end;

procedure TMainForm.udRStickDZClick(Sender: TObject; Button: TUDBtnType);
begin
  txtRStickDZ.Caption := IntToStr(udRStickDZ.Position);

  shpRDeadZ.Width := Round(pnlRS.Width * (udRStickDZ.Position / 100));
  shpRDeadZ.Height := Round(pnlRS.Height * (udRStickDZ.Position / 100));
  shpRDeadZ.Left := Round((pnlRS.Width / 2) - (shpRDeadZ.Width / 2));
  shpRDeadZ.Top  := Round((pnlRS.Height / 2) - (shpRDeadZ.Height / 2));

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].iRStickDZ := udRStickDZ.Position;
  end;
end;

procedure TMainForm.udScaleClick(Sender: TObject; Button: TUDBtnType);
begin
  //txtScale[TUpDown(Sender).Tag].Caption := IntToStr(udScale[TUpDown(Sender).Tag].Position);
  TStaticText(TUpDown(Sender).Associate).Caption :=
    IntToStr(udScale[TUpDown(Sender).Tag].Position);

  if cmbDevices.ItemIndex >= 0 then
  begin
    Gamepads[cmbDevices.ItemIndex].AxesScale[TUpDown(Sender).Tag] :=
      udScale[TUpDown(Sender).Tag].Position;
  end;
end;

procedure TMainForm.cmdPMenuClick(Sender: TObject);
var
  PButton: TPoint;
begin
  PButton := cmdPMenu.ClientToScreen(Point(Round(cmdPMenu.Width / 2),
    Round(cmdPMenu.Height / 2)));
  mnuProfile.Popup(PButton.X, PButton.Y);
end;

procedure TMainForm.mnuProfilePopup(Sender: TObject);
begin
  if cmbProfiles.ItemIndex >= 0 then
  begin
    mnuPAdd.Enabled  := True;
    mnuPCopy.Enabled := True;
    mnuPRemove.Enabled := True;
  end
  else
  begin
    mnuPAdd.Enabled  := False;
    mnuPCopy.Enabled := False;
    mnuPRemove.Enabled := False;
  end;
end;

procedure TMainForm.pageTabsChange(Sender: TObject);
begin
  tabUpdate := True;
end;

procedure TMainForm.mnuPAddClick(Sender: TObject);
begin
  if cmbProfiles.Items.Count < 8 then
  begin
    cmbProfiles.AddItem(IntToStr(cmbProfiles.Items.Count + 1), nil);
    Gamepads[cmbDevices.ItemIndex].iLayouts :=
      Gamepads[cmbDevices.ItemIndex].iLayouts + 1;
    SetDefaultMapping(Gamepads[cmbDevices.ItemIndex].MapMatrix
      [cmbProfiles.Items.Count - 1]);
    //CopyMemory(@Gamepads[cmbDevices.ItemIndex].MapMatrix[cmbProfiles.Items.Count - 1], @DefMapping, sizeof(DefMapping));
    cmbProfiles.ItemIndex := cmbProfiles.Items.Count - 1;
    cmbProfiles.OnChange(nil);
  end
  else
  begin
    MessageBox(MainForm.Handle, 'Maximum number of profiles is 8.',
      'Warning', MB_OK or MB_ICONEXCLAMATION);
  end;
end;

procedure TMainForm.mnuPCopyClick(Sender: TObject);
begin
  if cmbProfiles.Items.Count < 8 then
  begin
    cmbProfiles.AddItem(IntToStr(cmbProfiles.Items.Count + 1), nil);
    Gamepads[cmbDevices.ItemIndex].iLayouts :=
      Gamepads[cmbDevices.ItemIndex].iLayouts + 1;
    CopyMemory(@Gamepads[cmbDevices.ItemIndex].MapMatrix[cmbProfiles.Items.Count -
      1], @Gamepads[cmbDevices.ItemIndex].MapMatrix[cmbProfiles.ItemIndex], 24);
    cmbProfiles.ItemIndex := cmbProfiles.Items.Count - 1;
    cmbProfiles.OnChange(nil);
  end
  else
  begin
    MessageBox(MainForm.Handle, 'Maximum number of profiles is 8.',
      'Warning', MB_OK or MB_ICONEXCLAMATION);
  end;
end;

procedure TMainForm.mnuPRemoveClick(Sender: TObject);
var
  iCount: Integer;
begin
  if cmbProfiles.Items.Count > 1 then
  begin
    for iCount := cmbProfiles.ItemIndex to cmbProfiles.Items.Count - 2 do
    begin
      CopyMemory(@Gamepads[cmbDevices.ItemIndex].MapMatrix[iCount],
        @Gamepads[cmbDevices.ItemIndex].MapMatrix[iCount + 1], 24);
    end;

    Gamepads[cmbDevices.ItemIndex].iLayouts :=
      Gamepads[cmbDevices.ItemIndex].iLayouts - 1;

    cmbProfiles.Clear;

    for iCount := 1 to Gamepads[cmbDevices.ItemIndex].iLayouts do
    begin
      cmbProfiles.AddItem(IntToStr(iCount), nil);
    end;

    cmbProfiles.ItemIndex := 0;
    cmbProfiles.OnChange(nil);
  end
  else
  begin
    MessageBox(MainForm.Handle, 'Must have at least one profile.',
      'Warning', MB_OK or MB_ICONEXCLAMATION);
  end;
end;

procedure TMainForm.ckbAxesOnClick(Sender: TObject);
begin
  Gamepads[cmbDevices.ItemIndex].iAxesOn :=
    Gamepads[cmbDevices.ItemIndex].iAxesOn xor Round(Power(2, TCheckBox(Sender).Tag));
end;

procedure TMainForm.chkLFRangeClick(Sender: TObject);
begin
  Gamepads[cmbDevices.ItemIndex].bLStickFull := chkLFRange.Checked;
end;

procedure TMainForm.chkRFRangeClick(Sender: TObject);
begin
  Gamepads[cmbDevices.ItemIndex].bRStickFull := chkRFRange.Checked;
end;

procedure TMainForm.udNButtonsClick(Sender: TObject; Button: TUDBtnType);
begin
  txtNButtons.Caption := IntToStr(udNButtons.Position);

  if cmbDevices.ItemIndex >= 0 then
    Gamepads[cmbDevices.ItemIndex].iButtons := udNButtons.Position;
end;

procedure TMainForm.cmbDevTypeChange(Sender: TObject);
begin
  if cmbDevices.ItemIndex >= 0 then
    Gamepads[cmbDevices.ItemIndex].DevType :=
      cmbDevType.ItemIndex + HID_USAGE_JOYSTICK;
end;

end.
