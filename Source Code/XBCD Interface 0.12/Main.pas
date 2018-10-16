unit Main;

interface

uses
  Windows, SysUtils, Hid, SetupApi;

Type
  TReadConfig = packed record
    id: Byte;
    Signature: LongWord;
  end;

Type
  PXBCD_Device = ^TXBCD_Device;
  TXBCD_Device = packed record
    Index: Integer;
    HIDPath: PChar;
    USBPath: PChar;
  end;

Type
  PXBCD_Version = ^TXBCD_Version;
  TXBCD_Version = packed record
    Major: Byte;
    Minor: Byte;
    Release: Byte;
  end;

Type
  PFeatureGetVersion = ^TFeatureGetVersion;
  TFeatureGetVersion = packed record
    id: Byte;
    Signature: LongWord;
    Major: Byte;
    Minor: Byte;
    Release: Byte;
  end;

Type
  PEnumCallback = ^TEnumCallback;
  TEnumCallback = function(EnumDevice: PXBCD_Device): Integer;

const
  FEATURE_CODE_GET_VERSION = 4;

var
  iDevices: Integer;
  sHIDDevicePath: array of string;
  sUSBDevicePath: array of string;

  function XBCDEnumerate(EnumCallback: TEnumCallback; bUSBPathReq: Boolean): Integer; stdcall;
  function XBCDGetVersion(HIDPath: PChar; XBCDVersion: PXBCD_Version): Boolean; stdcall;

const
  XBCD_SIGNATURE = $58425355; //'XBSU'


implementation

function GetDevInterfaceDetail(DevInfoSet: HDEVINFO; DevInterfaceData: PSPDeviceInterfaceData; out DevInterfaceDetailData: PSPDeviceInterfaceDetailData; DevInfoData: PSPDevInfoData): Boolean;
var
   DetailData: Longint;
   Needed: DWORD;
begin
     Result := False;

     //******************************************************************************
     //SetupDiGetDeviceInterfaceDetail
     //Returns: an SP_DEVICE_INTERFACE_DETAIL_DATA structure
     //containing information about a device.
     //To retrieve the information, call this function twice.
     //The first time returns the size of the structure in Needed.
     //The second time returns a pointer to the data in DeviceInfoSet.
     //Requires:
     //A DeviceInfoSet returned by SetupDiGetClassDevs and
     //an SP_DEVICE_INTERFACE_DATA structure returned by SetupDiEnumDeviceInterfaces.
     //*******************************************************************************
     DevInfoData.cbSize := sizeof(TSPDevInfoData);
     SetupDiGetDeviceInterfaceDetail(DevInfoSet, DevInterfaceData, nil, 0, @Needed, DevInfoData);
     If GetLastError = 122 Then
     begin
          DetailData := Needed;

          //Store the structure's size.
          DevInterfaceDetailData := AllocMem(DetailData);
          DevInterfaceDetailData.cbSize := sizeof(TSPDeviceInterfaceDetailData);

          //Call SetupDiGetDeviceInterfaceDetail again.
          //This time, pass the address of the first element of DetailDataBuffer
          //and the returned required buffer size in DetailData.
          If SetupDiGetDeviceInterfaceDetail(DevInfoSet, DevInterfaceData, DevInterfaceDetailData, DetailData, @Needed, DevInfoData) Then
          begin
               Result := True;
          end
          else
          begin
               FreeMem(DevInterfaceDetailData);
          end;
     end;
end;

procedure FindTheHid;
var
   DevInfoSet: HDEVINFO;
   HIDDevInfoData: TSPDevInfoData;
   HIDDevInterfaceData: TSPDeviceInterfaceData;
   HIDDevInterfaceDetailData: PSPDeviceInterfaceDetailData;
   ParentDevInfoData: TSPDevInfoData;
   ParentDevInterfaceData: TSPDeviceInterfaceData;
   ParentDevInterfaceDetailData: PSPDeviceInterfaceDetailData;
   LastDevice: Boolean;
   HIDGuid: TGUID;
   USBGuid: TGUID;
   MemberIndex: Longint;
   bResult: LongBool;
   pDevInst: DWORD;
   sDeviceID: String;
   sDevProp: String;
   OSVer: TOSVersionInfoA;
   Win98Old: Boolean;
begin
     Win98Old := False;
     OSVer.dwOSVersionInfoSize := sizeof(OSVer);
     If GetVersionEx(OSVer) Then
     begin
          If ((OSVer.dwMajorVersion = 4) And (OSVer.dwMinorVersion = 10) And (OSVer.dwBuildNumber And $FFFF < 2183)) Then
          begin
               Win98Old := True;
          end;
     end;

     HidD_GetHidGuid(HIDGuid);
     USBGuid := StringToGUID('{A5DCBF10-6530-11D2-901F-00C04FB951ED}');

     If Win98Old Then
     begin
          DevInfoSet := SetupDiGetClassDevs(nil,
                                            nil,
                                            0,
                                            DIGCF_DEVICEINTERFACE or DIGCF_ALLCLASSES);
     end
     else
     begin
          DevInfoSet := SetupDiGetClassDevs(nil,
                                            nil,
                                            0,
                                            DIGCF_PRESENT or DIGCF_DEVICEINTERFACE or DIGCF_ALLCLASSES);
     end;



     iDevices := 0;
     MemberIndex := 0;
     LastDevice := False;

     while LastDevice <> True Do
     begin
          HIDDevInterfaceData.cbSize := sizeof(HIDDevInterfaceData);
          bResult := SetupDiEnumDeviceInterfaces(DevInfoSet,
                                                 nil,
                                                 HIDGuid,
                                                 MemberIndex,
                                                 HIDDevInterfaceData);

          If bResult = False Then LastDevice := True;

          If Win98Old And (HIDDevInterfaceData.Flags And SPINT_ACTIVE <> SPINT_ACTIVE) Then
          begin
               bResult := False;
          end;

          //If a device exists, display the information returned.
          If (bResult <> False) Then
          begin
               If GetDevInterfaceDetail(DevInfoSet, @HIDDevInterfaceData, HIDDevInterfaceDetailData, @HIDDevInfoData) Then
               begin
                    If CM_Get_Parent(Addr(pDevInst), HIDDevInfoData.DevInst, 0) = 0 Then
                    begin
                         sDeviceID := StringOfChar(#0, 255);
                         If CM_Get_Device_IDA(pDevInst, PChar(sDeviceID), Length(sDeviceID), 0) = 0 Then
                         begin
                              sDeviceID := Trim(sDeviceID);

                              ParentDevInfoData.cbSize := sizeof(ParentDevInfoData);
                              SetupDiOpenDeviceInfo(DevInfoSet,
                                                    PChar(sDeviceID),
                                                    0,
                                                    DIOD_INHERIT_CLASSDRVS,
                                                    @ParentDevInfoData);

                              sDevProp := StringOfChar(#0, 255);

                              If SetupDiGetDeviceRegistryProperty(DevInfoSet,
                                                                  @ParentDevInfoData,
                                                                  SPDRP_SERVICE,
                                                                  nil,
                                                                  PByte(sDevProp),
                                                                  Length(sDevProp),
                                                                  nil) Then
                              begin
                                   sDevProp := Trim(sDevProp);
                                   If UpperCase(sDevProp) = 'XBCD' Then
                                   begin
                                        ParentDevInterfaceData.cbSize := sizeof(ParentDevInterfaceData);
                                        If SetupDiEnumDeviceInterfaces(DevInfoSet, @ParentDevInfoData, USBGuid, 0, ParentDevInterfaceData) Then
                                        begin
                                             If GetDevInterfaceDetail(DevInfoSet, @ParentDevInterfaceData, ParentDevInterfaceDetailData, @ParentDevInfoData) Then
                                             begin
                                                  SetLength(sHIDDevicePath, iDevices+1);
                                                  SetString(sHIDDevicePath[iDevices], PChar(@HIDDevInterfaceDetailData.DevicePath), Length(PChar(@HIDDevInterfaceDetailData.DevicePath)));
                                                  SetLength(sUSBDevicePath, iDevices+1);
                                                  SetString(sUSBDevicePath[iDevices], PChar(@ParentDevInterfaceDetailData.DevicePath), Length(PChar(@ParentDevInterfaceDetailData.DevicePath)));

                                                  Inc(iDevices);

                                                  FreeMem(ParentDevInterfaceDetailData);
                                             end;
                                        end;
                                   end;
                              end;
                         end;
                    end;
                    FreeMem(HIDDevInterfaceDetailData);
               end;
          end;
          //Keep looking until we find the device or there are no more left to examine.
          Inc(MemberIndex);
     end;
     //Free the memory reserved for the DeviceInfoSet returned by SetupDiGetClassDevs.
     SetupDiDestroyDeviceInfoList(DevInfoSet);
end;

function XBCDEnumerate(EnumCallback: TEnumCallback; bUSBPathReq: Boolean): Integer;
var
   iCount: Integer;
   EnumDevice: TXBCD_Device;
   iRet: Integer;
begin
     Result := 0;

     FindTheHid;

     For iCount := 0 To iDevices-1 Do
     begin
          EnumDevice.Index := iCount;
          EnumDevice.HIDPath := PChar(sHIDDevicePath[iCount]);

          If bUSBPathReq Then EnumDevice.USBPath := PChar(sUSBDevicePath[iCount]);

          iRet := EnumCallback(@EnumDevice);

          Result := iCount + 1;

          If iRet = -1 Then
          begin
               Break
          end;
     end;

     SetLength(sUSBDevicePath, 0);
     SetLength(sHIDDevicePath, 0);
     iDevices := 0;
end;

function XBCDGetVersion(HIDPath: PChar; XBCDVersion: PXBCD_Version): Boolean;
var
   //HIDCaps: THIDPCaps;
   FGVer: TFeatureGetVersion;
   HIDHandle: DWORD;
   HIDPPData: PHIDPPreparsedData;
   HIDCaps: THIDPCaps;
begin
     Result := False;

     HIDHandle := CreateFile(HIDPath,
                             GENERIC_READ Or GENERIC_WRITE,
                             FILE_SHARE_READ Or FILE_SHARE_WRITE,
                             nil,
                             OPEN_EXISTING,
                             0,
                             0);

     If HIDHandle <> INVALID_HANDLE_VALUE Then
     begin
          FGVer.id := FEATURE_CODE_GET_VERSION;
          FGVer.Signature := XBCD_SIGNATURE;
          
          If HidD_GetFeature(HIDHandle, FGVer, sizeof(FGVer)) Then
          begin
               XBCDVersion.Major := FGVer.Major;
               XBCDVersion.Minor := FGVer.Minor;
               XBCDVersion.Release := FGVer.Release;
               Result := True;
          end
          else
          begin
               //See what the driver supports and compare to what
               //each version supports
               If HidD_GetPreparsedData(HIDHandle, HIDPPData) Then
               begin
                    If HidP_GetCaps(HIDPPData, HIDCaps) = HIDP_STATUS_SUCCESS Then
                    begin
                         //Result := True;
                    end;
                    HidD_FreePreparsedData(HIDPPData);
               end;
          end;
          CloseHandle(HIDHandle);
     end;
end;

end.
