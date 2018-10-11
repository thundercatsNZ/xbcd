/*	
    Copyright 2005 Helder Acevedo

    This file is part of XBCD.

    XBCD is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    XBCD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with XBCD; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include "effdrv.h"

void WriteReport(HANDLE hDevice, BYTE lVal, BYTE rVal)
{
	//Send a report to the device.

	DWORD	BytesWritten = 0;
	CHAR	OutputReport[3];
	ULONG	Result;

	//The first byte is the report number.
	OutputReport[0]=2;
	OutputReport[1]=lVal;
	OutputReport[2]=rVal;

	if(hDevice != INVALID_HANDLE_VALUE)
	{
		Result = WriteFile(	hDevice, 
							OutputReport, 
							sizeof(OutputReport), 
							&BytesWritten, 
							NULL);
	}

	return;
}

BOOL ReadAxes(CDevice *pDev, PCHAR cX, PCHAR cY)
{
	//Read the values of the X and Y axes

	*cX = 0;
	*cY = 0;

	if(pDev->bDIReady)
	{
		HRESULT hres;

		hres = pDev->diHandle->Poll();

		if((hres == DI_OK) || (hres == DI_NOEFFECT))
		{
			DIJOYSTATE diJS;

			hres = pDev->diHandle->GetDeviceState(sizeof(diJS), &diJS);
			if(hres == DI_OK)
			{
				//Range for axes is -127 to 127
				*cX = (CHAR)diJS.lX;
				*cY = (CHAR)diJS.lY;

				return TRUE;
			}
		}
	}

	return FALSE;
}

int ftoi(double f)
{
	int result;
    
	return result;
}

double sine(double x)
{
	double result;

	return result;
}

double absd(double x)
{
#ifdef _MSC_VER
	if(x < 0)
		x = x * -1;
#else
	x = fabs(x);
#endif
	return x;
}

DWORD WINAPI TimeProc(LPVOID lpParam)
{
	//Timer Function
	//Runs as long as there is an effect that needs to be played

	bTimerOn = TRUE;
	do
	{
		BOOLEAN bKillTimer = TRUE;

		DevMap::iterator di;
		for(di = Devices.begin(); di != Devices.end(); di++)
		{
			BYTE LVal = 0;
			BYTE RVal = 0;
			CHAR AxisVal[2];
			BOOLEAN bHasEffect = FALSE;
			BOOLEAN bStopDevice = TRUE;
			BOOLEAN bAxesRead = FALSE;

      bAxesRead = di->second->bDevWheel ? ReadAxes(di->second, &AxisVal[0], &AxisVal[1]) : FALSE;

			EffMap::iterator ei;
			for(ei = di->second->Effects.begin(); ei != di->second->Effects.end(); ei++)
			{
				bHasEffect = TRUE;
				if(ei->second->bPlay)
				{
					DWORD dwCurrentTime;
					bStopDevice = FALSE;
					dwCurrentTime = timeGetTime();
					if(dwCurrentTime >= ei->second->dwStartTime)
					{
						if(((ei->second->dwStartTime + (ei->second->effect.dwDuration/1000)) > dwCurrentTime) || (ei->second->effect.dwDuration == INFINITE))
						{
							switch(ei->second->dwType)
							{
							case EFFECT_CONSTANT:
								{
									DebugPrint("Constant");

									if(abs(ei->second->fconstant.lMagnitude) > LVal)
										LVal = (BYTE)abs(ei->second->fconstant.lMagnitude);

									if(abs(ei->second->fconstant.lMagnitude) > RVal)
										RVal = (BYTE)abs(ei->second->fconstant.lMagnitude);

									break;
								}
							case EFFECT_SINE:
								{
									double bVal2;
									DebugPrint("Sine");

									bVal2 = timeGetTime() - ei->second->dwStartTime;
									bVal2 = bVal2/ei->second->fperiodic.dwPeriod;
									bVal2 = 360000 * bVal2;
									bVal2 = bVal2 * M_PI/180;
									bVal2 = sine(bVal2);
									bVal2 = ei->second->fperiodic.dwMagnitude * bVal2;

									if(bVal2 > 0)
									{
										bVal2 = absd(bVal2);
										if(bVal2 > RVal)
										{
											RVal = ftoi(bVal2);
										}
									}
									else
									{
										bVal2 = absd(bVal2);
										if(bVal2 > LVal)
										{
											LVal = ftoi(bVal2);
										}
									}
									break;
								}
							case EFFECT_RAMP:
								{
									LONG diffForce;
									LONG diffTime;
									double bVal2;
									DebugPrint("Ramp");

									diffTime = ei->second->effect.dwDuration/1000;

									if(ei->second->framp.lEnd > ei->second->framp.lStart)
									{
										if(ei->second->framp.lStart < 0)
										{
											diffForce = abs(ei->second->framp.lEnd) + abs(ei->second->framp.lStart);
											bVal2 = diffForce * (timeGetTime() - ei->second->dwStartTime)/diffTime;
											if(bVal2 < abs(ei->second->framp.lStart))
											{
												bVal2 = abs(ei->second->framp.lStart) - bVal2;
												if(bVal2 > LVal)
													LVal = ftoi(bVal2);
											}
											else
											{
												bVal2 = bVal2 - abs(ei->second->framp.lStart);
												if(bVal2 > RVal)
													RVal = ftoi(bVal2);
											}
										}
										else
										{
											diffForce = abs(ei->second->framp.lEnd) - abs(ei->second->framp.lStart);
											bVal2 = diffForce * (timeGetTime() - ei->second->dwStartTime)/diffTime;

											bVal2 = bVal2 + abs(ei->second->framp.lStart);
											if(bVal2 > RVal)
												RVal = ftoi(bVal2);
										}
									}
									else
									{
										if(ei->second->framp.lEnd < ei->second->framp.lStart)
										{
											if(ei->second->framp.lStart < 0)
											{
												diffForce = abs(ei->second->framp.lStart) - abs(ei->second->framp.lEnd);
												bVal2 = diffForce * (timeGetTime() - ei->second->dwStartTime)/diffTime;

												bVal2 = abs(ei->second->framp.lStart) + bVal2;
												if(bVal2 > LVal)
													LVal = ftoi(bVal2);
											}
											else
											{
												diffForce = abs(ei->second->framp.lEnd) + abs(ei->second->framp.lStart);
												bVal2 = diffForce * (timeGetTime() - ei->second->dwStartTime)/diffTime;
												if(bVal2 < abs(ei->second->framp.lStart))
												{
													bVal2 = abs(ei->second->framp.lStart) - bVal2;
													if(bVal2 > RVal)
														RVal = ftoi(bVal2);
												}
												else
												{
													bVal2 = bVal2 - abs(ei->second->framp.lStart);
													if(bVal2 > LVal)
														LVal = ftoi(bVal2);
												}
											}
										}
										else
										{
											if(ei->second->framp.lStart < 0)
											{
												if(abs(ei->second->framp.lStart) > LVal)
													LVal = (BYTE)abs(ei->second->framp.lStart);
											}
											else
											{
												if(abs(ei->second->framp.lStart) > RVal)
													RVal = (BYTE)abs(ei->second->framp.lStart);
											}
										}
									}
									break;
								}
							case EFFECT_SQUARE:
								{
									double bVal2;
									DebugPrint("Square");

									bVal2 = timeGetTime() - ei->second->dwStartTime;
									bVal2 = 1000 * bVal2/ei->second->fperiodic.dwPeriod;
									bVal2 = bVal2 - (int)bVal2;

									if(bVal2 < 0.5)
									{
										if(ei->second->fperiodic.dwMagnitude > RVal)
											RVal = (BYTE)ei->second->fperiodic.dwMagnitude;
									}
									else
									{
										if(ei->second->fperiodic.dwMagnitude > LVal)
											LVal = (BYTE)ei->second->fperiodic.dwMagnitude;
									}
									break;
								}
							case EFFECT_TRIANGLE:
								{
									double bVal2;
									DebugPrint("Triangle");

									bVal2 = timeGetTime() - ei->second->dwStartTime;
									bVal2 = bVal2/ei->second->fperiodic.dwPeriod;
									bVal2 = 360000 * bVal2;
									bVal2 = bVal2 * M_PI/180;
									bVal2 = sine(bVal2);
									bVal2 = ei->second->fperiodic.dwMagnitude * bVal2;

									if(bVal2 > 0)
									{
										bVal2 = absd(bVal2);
										if(bVal2 > RVal)
										{
											RVal = ftoi(bVal2);
										}
									}
									else
									{
										bVal2 = absd(bVal2);
										if(bVal2 > LVal)
										{
											LVal = ftoi(bVal2);
										}
									}
									break;
								}
							case EFFECT_SAWTOOTHUP:
								{
									double bVal2;
									DebugPrint("Sawtooth Up");

									bVal2 = timeGetTime() - ei->second->dwStartTime;
									bVal2 = 1000 * bVal2/ei->second->fperiodic.dwPeriod;
									bVal2 = bVal2 - (int)bVal2;

									if(bVal2 < 0.5)
									{
										bVal2 = (double)ei->second->fperiodic.dwMagnitude * (0.5 - bVal2)/0.5;
										if(bVal2 > LVal)
											LVal = (BYTE)ftoi(bVal2);
									}
									else
									{
										bVal2 = (double)ei->second->fperiodic.dwMagnitude * (bVal2 - 0.5)/0.5;
										if(bVal2 > RVal)
											RVal = (BYTE)ftoi(bVal2);
									}
									break;
								}
							case EFFECT_SAWTOOTHDOWN:
								{
									double bVal2;
									DebugPrint("Sawtooth Down");

									bVal2 = timeGetTime() - ei->second->dwStartTime;
									bVal2 = 1000 * bVal2/ei->second->fperiodic.dwPeriod;
									bVal2 = bVal2 - (int)bVal2;

									if(bVal2 < 0.5)
									{
										bVal2 = (double)ei->second->fperiodic.dwMagnitude * (0.5 - bVal2)/0.5;
										if(bVal2 > RVal)
											RVal = (BYTE)ftoi(bVal2);
									}
									else
									{
										bVal2 = (double)ei->second->fperiodic.dwMagnitude * (bVal2 - 0.5)/0.5;
										if(bVal2 > LVal)
											LVal = (BYTE)ftoi(bVal2);
									}
									break;
								}
							}

							if(bAxesRead)
							{
								switch(ei->second->dwType)
								{
								case CONDITION_SPRING:
									{
										double fVal;
										DWORD dwAxis;

										DebugPrint("Spring");

										DebugPrintP(__FUNCTION__, "Axis 0 = %d, Axis 1 = %d", AxisVal[0], AxisVal[1]);

										for(dwAxis = 0; dwAxis < ei->second->effect.cAxes; dwAxis++)
										{
											if(ei->second->fcondition[dwAxis].lOffset > AxisVal[ei->second->dwAxes[dwAxis]])
											{
												fVal = -1 * abs(ei->second->fcondition[dwAxis].lOffset - AxisVal[ei->second->dwAxes[dwAxis]]);

												fVal = (float)(fVal/(ei->second->fcondition[dwAxis].lOffset + 127));
											}
											else
											{
												fVal = abs(AxisVal[ei->second->dwAxes[dwAxis]] - ei->second->fcondition[dwAxis].lOffset);

												fVal = fVal/(127 - ei->second->fcondition[dwAxis].lOffset);
											}

											if(fVal >= 0)
											{
												fVal = fVal * ei->second->fcondition[dwAxis].lPositiveCoefficient;
											}
											else
											{
												fVal = fVal * ei->second->fcondition[dwAxis].lNegativeCoefficient;
											}

											fVal = absd(fVal);
											if(fVal > RVal)
												RVal = ftoi(fVal);
											if(fVal > LVal)
												LVal = ftoi(fVal);
										}

										break;
									}
								case CONDITION_FRICTION:
									{
										double fVal;
										DWORD dwAxis;

										DebugPrint("Friction");

										for(dwAxis = 0; dwAxis < ei->second->effect.cAxes; dwAxis++)
										{
											if(di->second->LastAxisVal[ei->second->dwAxes[dwAxis]] != AxisVal[ei->second->dwAxes[dwAxis]])
											{
												if(AxisVal[ei->second->dwAxes[dwAxis]] > di->second->LastAxisVal[ei->second->dwAxes[dwAxis]])
												{
													fVal = ei->second->fcondition[dwAxis].lPositiveCoefficient;
												}
												else
												{
													fVal = -1 * (float)ei->second->fcondition[dwAxis].lNegativeCoefficient;
												}

												fVal = absd(fVal);
												if(fVal > RVal)
													RVal = ftoi(fVal);
												//if(fVal > LVal)
													//LVal = ftoi(fVal);
											}
										}
										break;
									}
								case CONDITION_DAMPER:
									{
										DebugPrint("Damper");
										break;
									}
								case CONDITION_INERTIA:
									{
										DebugPrint("Inertia");
										break;
									}
								case EFFECT_CUSTOM:
									{
										DebugPrint("Custom");
										break;
									}
								}
							}
						}
						else
						{
							ei->second->bPlay = FALSE;
						}
					}
				}
			}

			if(bHasEffect)
			{
				if(bStopDevice || bStopAllDevices)
				{
					di->second->LastLVal = 0;
					di->second->LastRVal = 0;
					WriteReport(di->second->rwHandle, 0, 0);

					di->second->LastAxisVal[0] = AxisVal[0];
					di->second->LastAxisVal[1] = AxisVal[1];
				}
				else
				{
					bKillTimer = FALSE;

					if((LVal != di->second->LastLVal) || (RVal != di->second->LastRVal))
					{
						di->second->LastLVal = LVal;
						di->second->LastRVal = RVal;

						DebugPrintP(__FUNCTION__, "LVal = %d, RVal = %d", di->second->LastLVal, di->second->LastRVal);

						DebugPrint("Sending");
						WriteReport(di->second->rwHandle, LVal, RVal);
					}

					di->second->LastAxisVal[0] = AxisVal[0];
					di->second->LastAxisVal[1] = AxisVal[1];
				}
			}
		}

		if(bKillTimer)
		{
			DebugPrint("Finished");
			bTimerOn = FALSE;
		}

		//Allow 10 milliseconds between executions of the loop
		//Let the system do some other work
		Sleep(10);
	}
	while(bTimerOn);

	return 0;
}
