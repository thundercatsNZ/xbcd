unit MixedColor;

interface

uses Graphics;

function GetMixedColor(const StartColor, EndColor: TColor; const MinPosition, Position, MaxPosition: Integer): TColor; forward;

implementation

uses SysUtils, Windows, Math;

//------------------------------------------------------------------------------
// Function for getting mixed color from two given colors, with a relative
// distance from two colors determined by Position value inside
// MinPosition..MaxPosition range
// Author: Dmitri Papichev (c) 2001
// License type: Freeware
//------------------------------------------------------------------------------
function GetMixedColor (const StartColor, EndColor: TColor; const MinPosition, Position, MaxPosition: Integer): TColor;
var
   Fraction: double;
   R, G, B,
   R0, G0, B0,
   R1, G1, B1: byte;
begin
   { process Position out of range situation }
   if (MaxPosition < MinPosition) then
      raise Exception.Create('GetMixedColor: MaxPosition is less then MinPosition');

   { if Position is outside MinPosition..MaxPosition range, the closest boundary
     is effectively substituted through the adjustment of Fraction }
   Fraction := Min(1, Max(0, (Position - MinPosition)/(MaxPosition - MinPosition)));

   { extract the intensity values }
   R0 := GetRValue(StartColor);
   G0 := GetGValue(StartColor);
   B0 := GetBValue(StartColor);
   R1 := GetRValue(EndColor);
   G1 := GetGValue(EndColor);
   B1 := GetBValue(EndColor);

   { calculate the resulting intensity values }
   R := R0 + Round((R1 - R0) * Fraction);
   G := G0 + Round((G1 - G0) * Fraction);
   B := B0 + Round((B1 - B0) * Fraction);

   { combine intensities in a resulting color }
   Result := RGB(R, G, B);
end;

end.
 