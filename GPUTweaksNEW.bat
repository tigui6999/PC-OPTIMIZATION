rem ::: GPU Tweaks
rem ::: Plundered by NEKR1D
rem ::: Originally created by Shoober420
rem ::: https://github.com/shoober420/windows11-scripts

rem ::: Works for any graphics card [cite: 31]

rem ::: !!! WARNING !!!
rem ::: !!! DOES NOT SUPPORT DIGITAL STREAM COMPRESSION (DSC) !!! [cite: 2, 31]
rem ::: Black screen will occur if used with settings that activate DSC [cite: 3, 32]

rem ::: RECOMMENDED TO DISABLE ONBOARD INTEGRATED GPU IN BIOS AND DEVICE MANAGER AND USE DEDICATED GPU ONLY [cite: 4, 31]
rem ::: IMPROVES LATENCY AT THE COST OF A LITTLE FRAMERATE [cite: 5, 31]
rem ::: Timeout Detection and Recovery (TDR) [cite: 32]
rem ::: Deferred Procedure Call [cite: 32]

PAUSE

rem ::: Enable and start WMI [cite: 32]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t REG_DWORD /d "2" /f [cite: 32]
sc config winmgmt start= auto [cite: 33]
net start winmgmt [cite: 33]

if not exist C:\Windows\System32\wbem\WMIC.exe (
    echo Installing WMIC...
    DISM /Online /Add-Capability /CapabilityName:WMIC~~~~
    echo Done.
)

rem ::: MAY CAUSE CRASHES
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t REG_DWORD /d "0" /f

rem ::: Affinity tweak
rem ::: Use conditional logic from NEW file [cite: 34]
for /f "tokens=2 delims=^=" %%f in ('wmic cpu get NumberOfCores /value ^| find "="') do set Cores=%%f [cite: 34]

if %Cores% gtr 4 ( [cite: 34]
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f
)

rem ::: Enable MSI Mode for GPU
rem ::: Forces MSI Mode ON and sets Low Priority (0) from NEW file
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do ( [cite: 7]
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f 
)

rem ::: DirectDraw AGP Tweaks (Updated to 1 for DisableAGPSupport and applied to all hives) 
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "1" /f 

rem ::: Tell Windows to stop tolerating high DPC/ISR latencies
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f [cite: 8, 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f [cite: 8, 36]

rem ::: Latency tweaks duplicated to GraphicsDrivers control set (from NEW file) 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ExitLatency" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "Latency" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f [cite: 36]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f [cite: 37]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f [cite: 37]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f [cite: 37]

rem ::: GraphicsDrivers\Power D3/Latency Tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f [cite: 8]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f [cite: 8, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemoryNoContext" /t REG_DWORD /d 1 /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f [cite: 9, 38]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f [cite: 9, 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f [cite: 10, 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MiracastPerfTrackGraphicsLatency" /t REG_DWORD /d "1" /f [cite: 10, 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 10, 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 10, 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f [cite: 10, 39]

rem ::: DPC ISP Latency tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "1" /f [cite: 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f [cite: 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceIdleResiliency" /t REG_DWORD /d "1" /f [cite: 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MfBufferingThreshold" /t REG_DWORD /d "0" /f [cite: 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f [cite: 39]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f [cite: 11, 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f [cite: 11, 40]

rem ::: GPU Power Options
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "PowerSavingTweaks" /t REG_DWORD /d "0" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "EnableRuntimePowerManagement" /t REG_DWORD /d "0" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "PrimaryPushBufferSize" /t REG_DWORD /d "1" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "FlTransitionLatency" /t REG_DWORD /d "1" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "D3PCLatency" /t REG_DWORD /d "1" /f [cite: 40]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RMDeepLlEntryLatencyUsec" /t REG_DWORD /d "1" /f [cite: 40]

rem ::: PciLatencyTimerControl (using new file's explicit hex value) [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "PciLatencyTimerControl" /t REG_DWORD /d "0x00000020" /f [cite: 41]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "LOWLATENCY" /t REG_DWORD /d "1" /f [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmDisableRegistryCaching" /t REG_DWORD /d "1" /f [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RMDisablePostL2Compression" /t REG_DWORD /d "1" /f [cite: 41]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "UseGpuTimer" /t REG_DWORD /d "1" /f [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f [cite: 41]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MSDisabled" /t REG_DWORD /d "1" /f [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "FxAccountingTelemetryDisabled" /t REG_DWORD /d "1" /f [cite: 41]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableIdleStatesAtBoot" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepstudyAccountingEnabled" /t REG_DWORD /d "0" /f [cite: 13, 42]

rem ::: GraphicsDrivers\Power D3/Latency Tweaks (Duplicated from above, from NEW file) [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f [cite: 42]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f [cite: 42]

rem ::: DirectX Driver Service Tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 13, 43]

rem ::: alufena = 0 (overwritten from 1) [cite: 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "CreateGdiPrimaryOnSlaveGPU" /t REG_DWORD /d "0" /f [cite: 43]

reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DriverSupportsCddDwmInterop" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncDxAccess" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncGPUAccess" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCreateSwapChain" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkFreeGpuVirtualAddress" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkOpenSwapChain" /t REG_DWORD /d "1" /f [cite: 13, 43]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkShareSwapChainObject" /t REG_DWORD /d "1" /f [cite: 14, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f [cite: 14, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent2" /t REG_DWORD /d "1" /f [cite: 14, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "SwapChainBackBuffer" /t REG_DWORD /d "1" /f [cite: 14, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "TdrResetFromTimeoutAsync" /t REG_DWORD /d "1" /f [cite: 14, 44]

rem ::: alufena = DELETED 
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "EnableVariableRefresh" /f 

rem ::: NEW DXGKrnl Settings [cite: 86, 87]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "EnableFlipEx" /t REG_DWORD /d "1" /f [cite: 86]
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "EnableFramePacing" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "EnableHDASurfaces" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "EnableIndependentFlip" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "EnableSoftwarePaging" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "EnableTiledResources" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "ReduceStalls" /t REG_DWORD /d "1" /f 


rem ::: TDR Settings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f [cite: 15, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d "0" /f [cite: 15, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDebugMode" /t REG_DWORD /d "0" /f [cite: 15, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d "0" /f [cite: 15, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDodPresentDelay" /t REG_DWORD /d "0" /f [cite: 15, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDodVSyncDelay" /t REG_DWORD /d "0" /f [cite: 15, 44]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLimitCount" /t REG_DWORD /d "0" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLimitTime" /t REG_DWORD /d "0" /f [cite: 15, 45]

rem ::: GraphicsDrivers Power / Low Latency Settings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "UseGpuTimer" /t REG_DWORD /d "1" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PowerSavingTweaks" /t REG_DWORD /d "0" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableRuntimePowerManagement" /t REG_DWORD /d "0" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PrimaryPushBufferSize" /t REG_DWORD /d "1" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "FlTransitionLatency" /t REG_DWORD /d "1" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "D3PCLatency" /t REG_DWORD /d "1" /f [cite: 15, 45]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RMDeepLlEntryLatencyUsec" /t REG_DWORD /d "1" /f [cite: 15, 45]

rem ::: PciLatencyTimerControl (using new file's explicit hex value) [cite: 46]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PciLatencyTimerControl" /t REG_DWORD /d "0x00000020" /f [cite: 46]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f [cite: 16, 46]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LOWLATENCY" /t REG_DWORD /d "1" /f [cite: 16, 46]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmDisableRegistryCaching" /t REG_DWORD /d "1" /f [cite: 16, 46]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RMDisablePostL2Compression" /t REG_DWORD /d "1" /f [cite: 16, 46]

rem ::: HwSchMode and HwSchedMode removed from NEW file
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f [cite: 16]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchedMode" /t REG_DWORD /d "2" /f [cite: 16]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f [cite: 16, 46]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f [cite: 16, 46]

rem ::: Direct3D Tweaks

reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d "0" /f [cite: 17, 46]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d "0" /f [cite: 17, 46]
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d "0" /f [cite: 46]

rem ::: FlipNoVsync value changed from 0 to 1 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f [cite: 17, 47]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f [cite: 17, 47]
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f 

reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f [cite: 17, 47]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f [cite: 17, 47]

reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d "0" /f [cite: 17, 47]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d "0" /f [cite: 17, 47]

reg add "HKLM\SOFTWARE\Microsoft\Direct3D\ReferenceDevice" /v "AllowAsync" /t REG_DWORD /d "1" /f [cite: 17, 47]

rem ::: GraphicsDrivers general settings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "AllowDeepCStates" /t REG_DWORD /d "0" /f [cite: 17, 47]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "AdaptiveVsyncEnable" /t REG_DWORD /d "0" /f [cite: 17, 48]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "BuffersInFlight" /t REG_DWORD /d "4096" /f [cite: 17, 48]

rem ::: Removed settings from OLD file based on NEW file exclusions [cite: 18, 19, 20]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ComputePreemption" /t REG_DWORD /d "0" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ComputePreemptionLevel" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "Disable_OverlayDSQualityEnhancement" /t REG_DWORD /d "1" /f [cite: 18, 48]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableAsyncPstates" /t REG_DWORD /d "1" /f [cite: 18, 48]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableCudaContextPreemption" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f [cite: 18, 48]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableGDIAcceleration" /t REG_DWORD /d "0" /f [cite: 18, 48]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableKmRender" /t REG_DWORD /d "0" /f [cite: 18, 48]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableKmRenderBoost" /t REG_DWORD /d "0" /f [cite: 18, 48]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableOverclockedPstates" /t REG_DWORD /d "1" /f [cite: 18, 48]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisablePFonDP" /t REG_DWORD /d "1" /f [cite: 18, 48]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisablePreemption" /t REG_DWORD /d "1" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableAggressivePStateBoost" /t REG_DWORD /d "1" /f [cite: 19, 48]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableAggressivePStateOnly" /t REG_DWORD /d "1" /f [cite: 19, 49]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableAsyncMidBufferPreemption" /t REG_DWORD /d "0" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableCEPreemption" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableDirectFlip" /t REG_DWORD /d "1" /f [cite: 19, 49]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableIndependentFlip" /t REG_DWORD /d "1" /f [cite: 19, 49]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableMidBufferPreemption" /t REG_DWORD /d "0" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableMidBufferPreemptionForHighTdrTimeout" /t REG_DWORD /d "0" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableMidGfxPreemption" /t REG_DWORD /d "0" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableMidGfxPreemptionVGPU" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnablePerformanceMode" /t REG_DWORD /d "1" /f [cite: 20, 49]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableSCGMidBufferPreemption" /t REG_DWORD /d "0" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "GPUPreemptionLevel" /t REG_DWORD /d "0" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PerfAnalyzeMidBufferPreemption" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d "1" /f [cite: 20, 49]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmClkPowerOffDramPllWhenUnused" /t REG_DWORD /d "0" /f [cite: 20, 49]

rem ::: RmFbsrPagedDMA changed from 0 to 1 [cite: 20, 49]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmFbsrPagedDMA" /t REG_DWORD /d "1" /f [cite: 49]

rem ::: EnableWDDM23Synchronization changed from 1 to 0 [cite: 20, 49]
rem ::: WDDM2.3 IS DEPRECATED [cite: 49]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableWDDM23Synchronization" /t REG_DWORD /d "0" /f [cite: 49]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceDirectFlip" /t REG_DWORD /d "1" /f [cite: 20, 83]

rem ::: UnsupportedMonitorModesAllowed changed from 1 to 0 [cite: 20, 49]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "UnsupportedMonitorModesAllowed" /t REG_DWORD /d "0" /f [cite: 49]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "UseXPModel" /t REG_DWORD /d "0" /f [cite: 20, 49]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableVersionMismatchCheck" /t REG_DWORD /d "1" /f [cite: 21, 50]

rem ::: EnableIgnoreWin32ProcessStatus changed from 1 to 0 [cite: 21, 50]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableIgnoreWin32ProcessStatus" /t REG_DWORD /d "0" /f [cite: 50]

rem ::: HwSchTreatExperimentalAsStable removed
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchTreatExperimentalAsStable" /t REG_DWORD /d "1" /f [cite: 21]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableBadDriverCheckForHwProtection" /t REG_DWORD /d "1" /f [cite: 21, 50]

rem ::: Removed settings from OLD file based on NEW file exclusions [cite: 21, 50]
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableBoostedVSyncVirtualization" /t REG_DWORD /d "1" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableIndependentVidPnVSync" /t REG_DWORD /d "1" /f
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableMultiSourceMPOCheck" /t REG_DWORD /d "1" /f

rem ::: EnableFbrValidation changed from 0 to 1 [cite: 21, 50]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableFbrValidation" /t REG_DWORD /d "1" /f [cite: 50]

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "KnownProcessBoostMode" /t REG_DWORD /d "0" /f [cite: 21, 50]

rem ::: NEW GraphicsDrivers Settings (part of a large block in NEW file) [cite: 50, 51, 52, 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f [cite: 50]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableCABC" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableGpuTimeoutDetection" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableVerticalBlankInterrupt" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DriverProtection" /t REG_DWORD /d "0" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DxgkWaitForIdle" /t REG_DWORD /d "0" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableAdvancedMemoryTimings" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableGpuMemoryOvercommitment" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableOptimizedFlipQueue" /t REG_DWORD /d "1" /f [cite: 51]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceLowLatencyDisplayMode" /t REG_DWORD /d "1" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceOffScreenTimeout" /t REG_DWORD /d "0" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "lowdebounce" /t REG_DWORD /d "1" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MaxPreRenderedFrames" /t REG_DWORD /d "1" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "NumberOfIdleStates" /t REG_DWORD /d "0" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "OPMSetProtectionLevel" /t REG_DWORD /d "0" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PanelSelfRefresh" /t REG_DWORD /d "0" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PoFxPowerControl" /t REG_DWORD /d "0" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PoFxStartDevicePowerManagement" /t REG_DWORD /d "0" /f [cite: 52]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PowerSavingModeEnabled" /t REG_DWORD /d "0" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "Protection" /t REG_DWORD /d "0" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ProtectionLevel" /t REG_DWORD /d "0" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ReduceFrameLatency" /t REG_DWORD /d "1" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "SchedulingDelay" /t REG_DWORD /d "0" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "SupportRuntimePowerManagement" /t REG_DWORD /d "0" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PMMEnable" /t REG_DWORD /d "0" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "FlipModel" /t REG_DWORD /d "1" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableFlipDiscard" /t REG_DWORD /d "1" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableDwmVSync" /t REG_DWORD /d "1" /f [cite: 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceSecondaryIFlipSupport" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceSecondaryMPOSupport" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IoMmuFlags" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "SmallQuantumMode" /t REG_DWORD /d "1" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "WDDM2LockManagement" /t REG_DWORD /d "1" /f [cite: 86]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "CrtcPhaseFrames" /t REG_DWORD /d "1" /f [cite: 80]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableAsyncShaderCompile" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableGdiContextGpuVa" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableMonitoredFenceGpuVa" /t REG_DWORD /d "1" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisablePagingContextGpuVa" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableSecondaryIFlipSupport" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableVaBackedVm" /t REG_DWORD /d "1" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableVerticalBlankInterrupts" /t REG_DWORD /d "1" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DriverManagesResidencyOverride" /t REG_DWORD /d "1" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DRTTestEnable" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableAcmSupportDeveloperPreview" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableBasicRenderGpuPv" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableDecodeMPO" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableFuzzing" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableHMDTestMode" /t REG_DWORD /d "0" /f [cite: 81]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableIntegratedPanelAcmByault" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableIntegratedPanelAcmByDefault" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableOfferReclaimOnDriver" /t REG_DWORD /d "1" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnablePanelFitterSupport" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableTimedCalls" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ExternalDiagnosticsBufferMultiplier" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ExternalDiagnosticsBufferSize" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "Force32BitFences" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceAccessedPhysically" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceBddFallbackOnly" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceEnableDWMClone" /t REG_DWORD /d "0" /f [cite: 82]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceEnableDxgMms2" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceExplicitResidencyNotification" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceInitPagingProcessVaSpace" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceReplicateGdiContent" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceSurpriseRemovalSupport" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceToMapGpuVa" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceUsb4MonitorSupport" /t REG_DWORD /d "0" /f [cite: 83]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ForceVariableRefresh" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HighPriorityCompletionMode" /t REG_DWORD /d "1" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "InternalDiagnosticsBufferMultiplier" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "InternalDiagnosticsBufferSize" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "InvestigationDebugParameter" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IsInternalRelease" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LimitNumberOfVfs" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MultiMonSupport" /t REG_DWORD /d "0" /f [cite: 84]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "NumVirtualFunctions" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "OutputDuplicationSessionApplicationLimit" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PageFaultDebugMode" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PreserveFirmwareMode" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PreventFullscreenWireFormatChange" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RapidHPDThresholdCount" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "SupportMultipleIntegratedDisplays" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TreatUsb4MonitorAsNormal" /t REG_DWORD /d "0" /f [cite: 85]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "Usb4MonitorPowerOnDelayInSeconds" /t REG_DWORD /d "0" /f [cite: 86]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "ValidateWDDMCaps" /t REG_DWORD /d "0" /f [cite: 86]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "VirtualGpuOnly" /t REG_DWORD /d "0" /f [cite: 86]


rem ::: GPU Scheduler Tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "AdjustWorkerThreadPriority" /t REG_DWORD /d "0" /f [cite: 21, 53]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "AudioDgAutoBoostPriority" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "AutoSyncToCPUPriority" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "DebugLargeSmoothenedDuration" /t REG_DWORD /d "0" /f 

rem ::: ForegroundPriorityBoost removed 
rem ::: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "ForegroundPriorityBoost" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "FrameServerAutoBoostPriority" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "QueuedPresentLimit" /t REG_DWORD /d "1" /f 

rem ::: NEW Scheduler Settings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "MaximumAllowedPreemptionDelay" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnableFlipOnVSyncHwFlipQueue" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnableFlipOnVSyncSwFlipQueue" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnableFlipImmediateHwFlipQueue" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnableFlipImmediateSwFlipQueue" /t REG_DWORD /d "1" /f 

rem ::: Deleted from NEW file
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnableDirectSubmission" /f 
rem ::: Removed setting from old file
rem ::: reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "HwQueuedRenderPacketGroupLimit" /f [cite: 69]
rem ::: reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "HwQueuedRenderPacketGroupLimitPerNode" /f [cite: 69]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "HwQueuedRenderPacketGroupLimit" /t REG_DWORD /d "2" /f [cite: 69]


rem ::: DirectX Tweaks
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_ENABLE_UNSAFE_COMMAND_BUFFER_REUSE" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_ENABLE_RUNTIME_DRIVER_OPTIMIZATIONS" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_RESOURCE_ALIGNMENT" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_MULTITHREADED" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_MULTITHREADED" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_DEFERRED_CONTEXTS" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_DEFERRED_CONTEXTS" /t REG_DWORD /d "1" /f [cite: 23, 55]
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_ALLOW_TILING" /t REG_DWORD /d "1" /f [cite: 23, 55]
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_ENABLE_DYNAMIC_CODEGEN" /t REG_DWORD /d "1" /f [cite: 23, 55]
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_ALLOW_TILING" /t REG_DWORD /d "1" /f [cite: 23, 55]
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_CPU_PAGE_TABLE_ENABLED" /t REG_DWORD /d "1" /f [cite: 23, 55]
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_HEAP_SERIALIZATION_ENABLED" /t REG_DWORD /d "1" /f [cite: 23, 55]
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_MAP_HEAP_ALLOCATIONS" /t REG_DWORD /d "1" /f [cite: 23, 55]
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_RESIDENCY_MANAGEMENT_ENABLED" /t REG_DWORD /d "1" /f [cite: 23, 55]

rem ::: NEW DirectX setting from NEW file
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "DisableHWOverlay" /t REG_DWORD /d "1" /f [cite: 72]

rem ::: Force contiguous memory allocation in the DirectX Graphics Kernel
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f [cite: 24, 55]

rem ::: Disable VSync control
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f [cite: 24, 55]

rem ::: DXGI Tweaks (CurrentVersion\Windows)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "AllowDelayedFlips" /t REG_DWORD /d "0" /f [cite: 24, 56]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "UseDx" /t REG_DWORD /d "1" /f [cite: 24, 56]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "UseGpuForRender" /t REG_DWORD /d "1" /f [cite: 24, 56]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "UseTdx" /t REG_DWORD /d "1" /f [cite: 24, 56]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "UseThreadedOptimization" /t REG_DWORD /d "1" /f [cite: 24, 56]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "UseWddmForFullscreenVideo" /t REG_DWORD /d "1" /f [cite: 24, 56]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "UseSoftwareRender" /t REG_DWORD /d "0" /f [cite: 24, 56]

rem ::: NEW CurrentVersion\Windows Tweaks [cite: 79, 80]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "DCEInUseTelemetryDisabled" /t REG_DWORD /d "1" /f [cite: 79]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "EnableRIMPnpThreadDelayBugcheck" /t REG_DWORD /d "0" /f [cite: 79]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "RITdemonTimerPowerSaveCoalescing" /t REG_DWORD /d "0" /f [cite: 79]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "RITdemonTimerPowerSaveElapse" /t REG_DWORD /d "0" /f [cite: 80]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v "TimerCoalescing" /t REG_BINARY /d "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f [cite: 80]


rem ::: ControlSet001 (Redundant, but kept from OLD/NEW)
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "SchedulingDelay" /t REG_DWORD /d "0" /f [cite: 25, 56]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "SupportRuntimePowerManagement" /t REG_DWORD /d "0" /f [cite: 25, 56]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "RuntimePowerManagement" /t REG_DWORD /d "0" /f [cite: 25, 56]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "Protection" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "ProtectionLevel" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "OPMSetProtectionLevel" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "NumberOfIdleStates" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "EnableRuntimePowerManagement" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "DriverProtection" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "PoFxStartDevicePowerManagement" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "PoFxPowerControl" /t REG_DWORD /d "0" /f [cite: 25, 57]
reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers" /v "DxgkWaitForIdle" /t REG_DWORD /d "0" /f [cite: 25, 57]

rem ::: Direct3D MMX Fast Path
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t REG_DWORD /d "1" /f [cite: 26, 57]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t REG_DWORD /d "1" /f [cite: 57]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "MMX Fast Path" /t REG_DWORD /d "1" /f [cite: 29, 58]


rem ::: DirectDraw/Direct3D General Tweaks
rem ::: DisableAGPSupport has already been handled and set to 1 globally earlier
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f [cite: 26, 58]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f [cite: 58]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f [cite: 26, 58]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f [cite: 26, 58]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f [cite: 58]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f [cite: 26, 58]
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableDDSCAPSInDDSD" /t REG_DWORD /d "0" /f [cite: 26, 58]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "DisableDDSCAPSInDDSD" /t REG_DWORD /d "0" /f [cite: 58]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "DisableDDSCAPSInDDSD" /t REG_DWORD /d "0" /f [cite: 26, 58]
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulatePointSprites" /t REG_DWORD /d "0" /f [cite: 26, 59]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "EmulatePointSprites" /t REG_DWORD /d "0" /f [cite: 59]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "EmulatePointSprites" /t REG_DWORD /d "0" /f [cite: 27, 59]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "ForceRgbRasterizer" /t REG_DWORD /d "0" /f [cite: 27, 59]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "ForceRgbRasterizer" /t REG_DWORD /d "0" /f [cite: 59]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "ForceRgbRasterizer" /t REG_DWORD /d "0" /f [cite: 27, 59]
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulateStateBlocks" /t REG_DWORD /d "0" /f [cite: 27, 59]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "EmulateStateBlocks" /t REG_DWORD /d "0" /f [cite: 59]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "EmulateStateBlocks" /t REG_DWORD /d "0" /f [cite: 27, 59]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableDebugging" /t REG_DWORD /d "0" /f [cite: 27, 59]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "EnableDebugging" /t REG_DWORD /d "0" /f [cite: 59]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "EnableDebugging" /t REG_DWORD /d "0" /f [cite: 59]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FullDebug" /t REG_DWORD /d "0" /f [cite: 27, 60]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "FullDebug" /t REG_DWORD /d "0" /f [cite: 60]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "FullDebug" /t REG_DWORD /d "0" /f [cite: 60]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableDM" /t REG_DWORD /d "1" /f [cite: 27, 60]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "DisableDM" /t REG_DWORD /d "1" /f [cite: 60]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "DisableDM" /t REG_DWORD /d "1" /f [cite: 60]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableMultimonDebugging" /t REG_DWORD /d "0" /f [cite: 27, 60]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "EnableMultimonDebugging" /t REG_DWORD /d "0" /f [cite: 60]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "EnableMultimonDebugging" /t REG_DWORD /d "0" /f [cite: 60]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t REG_DWORD /d "0" /f [cite: 27, 60]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t REG_DWORD /d "0" /f [cite: 60]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "LoadDebugRuntime" /t REG_DWORD /d "0" /f [cite: 61]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumReference" /t REG_DWORD /d "1" /f [cite: 27, 61]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumReference" /t REG_DWORD /d "1" /f [cite: 61]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "EnumReference" /t REG_DWORD /d "1" /f [cite: 27, 61]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t REG_DWORD /d "1" /f [cite: 27, 61]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t REG_DWORD /d "1" /f [cite: 61]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t REG_DWORD /d "1" /f [cite: 27, 61]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumRamp" /t REG_DWORD /d "1" /f [cite: 28, 61]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumRamp" /t REG_DWORD /d "1" /f [cite: 61]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "EnumRamp" /t REG_DWORD /d "1" /f [cite: 28, 61]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumNullDevice" /t REG_DWORD /d "1" /f [cite: 28, 61]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumNullDevice" /t REG_DWORD /d "1" /f [cite: 62]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "EnumNullDevice" /t REG_DWORD /d "1" /f [cite: 28, 62]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FewVertices" /t REG_DWORD /d "1" /f [cite: 28, 62]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "FewVertices" /t REG_DWORD /d "1" /f [cite: 62]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "FewVertices" /t REG_DWORD /d "1" /f [cite: 28, 62]
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableMMX" /t REG_DWORD /d "0" /f [cite: 28, 62]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "DisableMMX" /t REG_DWORD /d "0" /f [cite: 62]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "DisableMMX" /t REG_DWORD /d "0" /f [cite: 28, 62]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableMMX" /t REG_DWORD /d "0" /f [cite: 28, 62]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "DisableMMX" /t REG_DWORD /d "0" /f [cite: 62]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "DisableMMX" /t REG_DWORD /d "0" /f [cite: 28, 62]
rem ::: MMX Fast Path Hives are already set above
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMXFastPath" /t REG_DWORD /d "1" /f [cite: 29, 63]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "MMXFastPath" /t REG_DWORD /d "1" /f [cite: 63]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "MMXFastPath" /t REG_DWORD /d "1" /f [cite: 29, 63]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseMMXForRGB" /t REG_DWORD /d "1" /f [cite: 29, 63]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "UseMMXForRGB" /t REG_DWORD /d "1" /f [cite: 63]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "UseMMXForRGB" /t REG_DWORD /d "1" /f [cite: 29, 63]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "UseMMXForRGB" /t REG_DWORD /d "1" /f [cite: 29, 63]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "UseMMXForRGB" /t REG_DWORD /d "1" /f [cite: 63]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "UseMMXForRGB" /t REG_DWORD /d "1" /f [cite: 29, 63]
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t REG_DWORD /d "1" /f [cite: 29, 64]
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t REG_DWORD /d "1" /f [cite: 64]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "EnumSeparateMMX" /t REG_DWORD /d "1" /f [cite: 29, 64]
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "ForceNoSysLock" /t REG_DWORD /d "0" /f [cite: 29, 64]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "ForceNoSysLock" /t REG_DWORD /d "0" /f [cite: 64]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "ForceNoSysLock" /t REG_DWORD /d "0" /f [cite: 29, 64]

rem ::: NEW DirectDraw Tweaks [cite: 64, 65]
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableInactivate" /t REG_DWORD /d "1" /f [cite: 64]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "DisableInactivate" /t REG_DWORD /d "1" /f [cite: 64]
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectDraw" /v "DisableInactivate" /t REG_DWORD /d "1" /f [cite: 64]
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableNoSysLock" /t REG_DWORD /d "1" /f [cite: 64]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "DisableNoSysLock" /t REG_DWORD /d "1" /f [cite: 65]
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectDraw" /v "DisableNoSysLock" /t REG_DWORD /d "1" /f [cite: 65]

rem ::: Disable Multi-GPU Selection [cite: 65]
reg add "HKLM\Software\Microsoft\DirectX\GraphicsSettings" /v "SpecificGPUOptionApplicable" /t REG_DWORD /d "0" /f [cite: 65]
reg add "HKCU\Software\Microsoft\DirectX\GraphicsSettings" /v "SpecificGPUOptionApplicable" /t REG_DWORD /d "0" /f [cite: 65]

rem ::: NEW Direct3D Tweaks 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "AsyncFlip" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisablePresentationInterval" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableFramePacing" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnableWARP" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "ForceWARP" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "RenderAheadLimit" /t REG_DWORD /d "1" /f 
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Direct3D" /v "EnableWARP" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnableWARP" /t REG_DWORD /d "1" /f 
reg add "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EnableWARP" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D\Drivers" /v "EnableWARP" /t REG_DWORD /d "1" /f 

rem ::: NEW DirectDraw Tweaks [cite: 88, 89]
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "EnableWARP" /t REG_DWORD /d "1" /f [cite: 88]
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "EnableWARP" /t REG_DWORD /d "1" /f 

rem ::: NEW Direct2D Tweaks 
reg add "HKLM\SOFTWARE\Microsoft\Direct2D" /v "EnableRect" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct2D" /v "Sharpness" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct2D" /v "DisableGammaCorrection" /t REG_DWORD /d "1" /f 
reg add "HKLM\SOFTWARE\Microsoft\Direct2D" /v "DisableClearType" /t REG_DWORD /d "1" /f 

rem ::: NEW Multimedia System Profile Tweaks [cite: 76]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysUseDirectFlip" /t REG_DWORD /d "1" /f [cite: 76]
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AllowTearing" /t REG_DWORD /d "1" /f [cite: 76]


rem ::: NEW PnP PCI Tweaks [cite: 87, 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "AffinitizeAllInterrupts" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "EnableMSI" /t REG_DWORD /d "1" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "ForceMSI" /t REG_DWORD /d "1" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "InterruptSteeringEnabled" /t REG_DWORD /d "0" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "LowLatencyMode" /t REG_DWORD /d "1" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "MSIEnable" /t REG_DWORD /d "1" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "PCIDelayTransaction" /t REG_DWORD /d "0" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "PCIPrefetchEnable" /t REG_DWORD /d "1" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "UseMPSCap" /t REG_DWORD /d "1" /f [cite: 88]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f [cite: 88]

rem ::: NEW PolicyManager Tweaks [cite: 88]
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\DisableDirectXDatabaseUpdate" /v "value" /t REG_DWORD /d "0" /f [cite: 88]

rem ::: NEW Power Control Tweaks [cite: 76, 77, 78, 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "AwayModeEnabled" /t REG_DWORD /d "0" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceMemoryNoContext" /t REG_DWORD /d 1 /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f [cite: 77]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableThrottlingDuringGaming" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EcoMode" /t REG_DWORD /d "0" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnableIdleStates" /t REG_DWORD /d "0" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ForceMaxPerformance" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "FxVsyncEnabled" /t REG_DWORD /d "0" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HighestPerformance" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HighPerformance" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "IdleDisable" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "IgnoreCsComplianceCheck" /t REG_DWORD /d "1" /f [cite: 78]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f [cite: 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f [cite: 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "OverrideMaxPerformance" /t REG_DWORD /d "1" /f [cite: 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PowerThrottling" /t REG_DWORD /d "0" /f [cite: 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ProcessorIdleDisable" /t REG_DWORD /d "1" /f [cite: 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f [cite: 79]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "VideoIdleTimeout" /t REG_DWORD /d "0" /f [cite: 79]

rem ::: Environment Variables (using `reg add` to HKLM for permanence) 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "ANGLE_DISABLE_D3D11" /t REG_SZ /d "0" /f [cite: 65]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "ANGLE_DISABLE_VULKAN" /t REG_SZ /d "0" /f [cite: 65]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "CEF_DISABLE_GPU" /t REG_SZ /d "0" /f [cite: 65]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "DISABLEDXMAXIMIZEDWINDOWEDMODE DISABLEFADEANIMATIONS NOSHADOW NOPADDEDBORDER NOGHOST DISABLEANIMATION DISABLETHEMES DISABLETHEMEMENUS DISABLEDWM PERPROCESSSYSTEMDPIFORCEOFF" /f [cite: 65]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DISABLE_DYNAMIC_FPS" /t REG_SZ /d "1" /f [cite: 65]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DisableGPUTimeout" /t REG_SZ /d "1" /f [cite: 65]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX_ENABLE_HIGH_SPEED_PRESENT" /t REG_SZ /d "1" /f [cite: 65]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGIFlipModel" /t REG_SZ /d "1" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGI_FLIP_SEQUENTIAL" /t REG_SZ /d "1" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGI_MAX_FRAME_LATENCY" /t REG_SZ /d "1" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX_LOW_LATENCY_MODE" /t REG_SZ /d "1" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX_MaxFramesToRenderAhead" /t REG_SZ /d "1" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX_MaxLatency" /t REG_DWORD /d "0" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "EnableAdaptiveSync" /t REG_SZ /d "0" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "EnableExclusiveFullScreen" /t REG_SZ /d "1" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "EnableGameMode" /t REG_SZ /d "0" /f [cite: 66]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "FlipEx" /t REG_DWORD /d "1" /f [cite: 66, 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "FORCE_GPU_TIMINGS" /t REG_SZ /d "1" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "ForceThreadedRendering" /t REG_SZ /d "1" /f [cite: 67, 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "HWACCEL" /t REG_SZ /d "1" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "LatencyReductionMode" /t REG_SZ /d "1" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "MaxFPS" /t REG_SZ /d "999" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "MaxPendingFrames" /t REG_DWORD /d "1" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "UseFastWindowFlip" /t REG_SZ /d "1" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "UseLowLatencyInputDriver" /t REG_SZ /d "1" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "UseNewScheduler" /t REG_SZ /d "1" /f [cite: 67]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "CLOUDSDK_CORE_DISABLE_PROMPTS" /t REG_SZ /d "1" /f [cite: 69]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "CONFIG_HZ" /t REG_SZ /d "FFFFFFFFFFFFFFFF" /f [cite: 69]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DIRECT_CPU" /t REG_SZ /d "1" /f [cite: 69]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DIRECT_GPU" /t REG_SZ /d "1" /f [cite: 69]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DOCKER_CLI_TELEMETRY_OPTOUT" /t REG_SZ /d "1" /f [cite: 69]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DOTNET_CLI_TELEMETRY_OPTOUT" /t REG_SZ /d "1" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DOTNET_TRY_CLI_TELEMETRY_OPTOUT" /t REG_SZ /d "1" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "ELECTRON_DISABLE_GPU" /t REG_SZ /d "0" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "ELECTRON_ENABLE_CPU_RENDERING" /t REG_SZ /d "0" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "HZ" /t REG_SZ /d "FFFFFFFFFFFFFFFF" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "KERNEL_HZ" /t REG_SZ /d "FFFFFFFFFFFFFFFF" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "MOZ_OMTC_ENABLED" /t REG_SZ /d "0" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "MOZ_USE_OMTC" /t REG_SZ /d "0" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VS_TELEMETRY_OPT_OUT" /t REG_SZ /d "1" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGL_FRAME_LATENCY_WAITABLE_OBJECT" /t REG_SZ /d "1" /f [cite: 70]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGI_FRAME_LATENCY_WAITABLE_OBJECT" /t REG_SZ /d "1" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGI_SWAPCHAIN_FLUSH" /t REG_SZ /d "1" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_MAX_ALLOC_PERCENT" /t REG_SZ /d "100" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_SINGLE_ALLOC_PERCENT" /t REG_SZ /d "100" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX12_AGGRESSIVE_PIPELINE" /t REG_SZ /d "1" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX12_FORCE_WARP" /t REG_SZ /d "0" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_SYNC_OBJECTS" /t REG_SZ /d "1" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_MAX_HEAP_SIZE" /t REG_SZ /d "100" /f [cite: 71]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_FORCE_64BIT_PTR" /t REG_SZ /d "0" /f [cite: 72]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGI_ALLOW_TEARING" /t REG_SZ /d "1" /f [cite: 72]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGI_PRESENT_ALLOW_TEARING" /t REG_SZ /d "1" /f [cite: 72]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING" /t REG_SZ /d "1" /f [cite: 72]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "CHROME_HEADLESS" /t REG_SZ /d "1" /f [cite: 72]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "AMD_ASYNC_SHADERS" /t REG_SZ /d "1" /f [cite: 72]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "AMD_FORCE_LOW_LATENCY_MODE" /t REG_SZ /d "1" /f [cite: 72]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX_ENABLE_MULTITHREADED_OPTIMIZATIONS" /t REG_SZ /d "1" /f [cite: 72, 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX_MaxFrameBufferSize" /t REG_DWORD /d "0x00000080" /f [cite: 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DX_USE_DXGI_FLIP_MODE" /t REG_SZ /d "1" /f [cite: 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "ENABLE_LOW_LATENCY_MODE" /t REG_SZ /d "1" /f [cite: 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "ENABLE_MEMORY_PREFETCH" /t REG_SZ /d "1" /f [cite: 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "FAST_RESPONSE_MODE" /t REG_SZ /d "1" /f [cite: 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "FORCE_HIGH_PRIORITY_THREAD_SCHEDULING" /t REG_SZ /d "1" /f [cite: 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__GL_MAX_FRAMES_ALLOWED" /t REG_SZ /d "1" /f [cite: 73]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__GL_NO_SWAPLIMIT" /t REG_SZ /d "1" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__GL_SYNC_TO_VBLANK" /t REG_SZ /d "0" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_ALLOW_HIGH_PRIORITY_TASKS" /t REG_SZ /d "1" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_ASYNC_COMPUTE" /t REG_SZ /d "1" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_DEFERRED_RENDERING" /t REG_SZ /d "1" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_DISCARD_PENDING_WORK" /t REG_SZ /d "1" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_DYNAMIC_PRIORITY" /t REG_SZ /d "1" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_ENABLE_ASYNC_COMPUTE" /t REG_SZ /d "1" /f [cite: 74]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_FRAME_TIME_LIMIT" /t REG_SZ /d "1" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_MAX_FRAMERATE" /t REG_SZ /d "999" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_MAX_TASK_PRIORITY" /t REG_SZ /d "0" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_MAX_WORKGROUP_SIZE" /t REG_SZ /d "512" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_MINIMUM_BATCH_SIZE" /t REG_SZ /d "64" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_USE_DEDICATED_MEMORY" /t REG_SZ /d "1" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_USE_SHARED_MEMORY" /t REG_SZ /d "1" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_WAIT_FOR_FLIP" /t REG_SZ /d "0" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "GPU_WAIT_ON_SWAPCHAIN" /t REG_SZ /d "0" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "npm_config_loglevel" /t REG_SZ /d "silent" /f [cite: 75]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "NVIDIA_MULTI_DISPLAY_POWER_SAVER" /t REG_SZ /d "0" /f [cite: 76]
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "NVIDIA_SINGLE_DISP_MEM_OPTIMIZATION" /t REG_SZ /d "1" /f [cite: 76]

rem ::: Disable GpuEnergyDrv
echo Disabling GPU Energy Driver
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t REG_DWORD /d "4" /f 

PAUSE