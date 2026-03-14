@echo off
setlocal enabledelayedexpansion

echo "Hello frp bat"

set WORK_PATH=%~dp0

echo %WORK_PATH%

set BUILD=build

if not exist %BUILD% (
    echo "Building the %BUILD% file..."
    md %BUILD%
    echo "Built the %BUILD% file..."
)

cd %BUILD%

set SRC_DIR=frp-0.52.1
set FRPS=frps.exe
set FRPC=frpc.exe

if not exist %FRPS% if not exist %FRPC% (
    echo "Ready to build the executable file of frpc and frps"
    cd ..
    if exist %SRC_DIR% (
        cd %SRC_DIR%

        echo "Current path : %cd%"

        go build -o ../build/frps.exe ./cmd/frps

        go build -o ../build/frpc.exe ./cmd/frpc

        cd %BUILD%
    ) else (
        echo "None of the file of %SRC_DIR%"
        exit
    )
) 

set CTOML=frpc.toml
set STOML=frps.toml

if exist !FRPS! if exist !FRPC! (
    echo "Exist the file of %FRPC% and %FRPS%"

    if not exist %CTOML% (
        md %CTOML%
    )

    if not exist %STOML% (
        md %STOML%
    )


    set /p mode="Enter number : 1 Config or 2 Run-only (All other inputs count as cancel) : "

    echo "Your input" : [!mode!]

    if "!mode!"=="1" (
        set /p choice="Enter number : 1 Server or 2 Customer (All other inputs count as cancel) : "
        
        echo "Your input" : [!choice!]
        
        if "!choice!"=="1" (
            @REM ------------------------------------------------------------------
            @REM Server------------------------------------------------------------
            set /p SERVERPORT="Enter the Server PORT : "
            echo bindPort = !SERVERPORT! > %STOML%

            set /p TOKEN="Enter the TOKEN : "
            echo token = "!TOKEN!" >> %STOML%

            set FRPLOG=frps.log

            if not exist !FRPLOG! (
                type nul > !FRPLOG!
            )

            (
            echo.
            echo logFile = "./!FRPLOG!"
            echo logLevel = "info"
            echo logMaxDays = 3
            ) >> %STOML%
            echo "Runing the Service...."
            @REM ------------------------------------------------------------------
            @REM ------------------------------------------------------------------


            @REM ------------------------------------------------------------------
            @REM Customer----------------------------------------------------------
            set /p SERVERAddR="Enter the Server IP : "
            echo serverAddr = "!SERVERAddR!" > %CTOML%

            set /p SERVERPORT="Enter the Server PORT : "
            echo serverPort = !SERVERPORT! >> %CTOML%

            set /p PASSWORD="Enter the Server PASSWORD : "
            echo token = "!PASSWORD!" >> %CTOML%

            (
            echo. 
            echo [[proxies]] 
            )>> %CTOML%

            set /p GAMENAME="Enter the Game name : "
            echo name = "!GAMENAME!" >> %CTOML%

            echo type = "tcp" >> %CTOML%

            set /p LOCALIP="Enter the Local ip : "
            echo localip = "!LOCALIP!" >> %CTOML%

            set /p LOCALPORT="Enter the Local port : "
            echo localport = !LOCALPORT! >> %CTOML%

            set /p REMOTEPORT="Enter the Server port : "
            echo remoteport = !REMOTEPORT! >> %CTOML%

            echo "Running the Customer...."
            @REM ------------------------------------------------------------------
            @REM ------------------------------------------------------------------

        ) else if "!choice!"=="2" (
            set /p SERVERAddR="Enter the Server IP : "
            echo serverAddr = "!SERVERAddR!" > %CTOML%

            set /p SERVERPORT="Enter the Server PORT : "
            echo serverPort = !SERVERPORT! >> %CTOML%

            set /p PASSWORD="Enter the Server PASSWORD : "
            echo token = "!PASSWORD!" >> %CTOML%

            (
            echo. 
            echo [[ 
            echo proxies 
            echo ]] 
            )>> %CTOML%

            set /p GAMENAME="Enter the Game name : "
            echo name = "!GAMENAME!" >> %CTOML%

            echo type = tcp >> %CTOML%

            set /p LOCALIP="Enter the Local ip : "
            echo localip = "!LOCALIP!" >> %CTOML%

            set /p LOCALPORT="Enter the Local port : "
            echo localport = !LOCALPORT! >> %CTOML%

            set /p REMOTEPORT="Enter the Server port : "
            echo remoteport = !REMOTEPORT! >> %CTOML%

            echo "Running the Customer...."
        ) else (
            echo "Wrong enter.... Cancel And Quit...."
        )

    ) else if "!mode!"=="2" (
        set /p choice="Enter number : 1 Server or 2 Customer (All other inputs count as cancel) : "
        
        echo "Your input" : [!choice!]

        if "!choice!"=="1" (
            set FRPLOG=frps.log

            if not exist !FRPLOG! (
                type nul > !FRPLOG!
            )

            start cmd /k "%WORK_PATH%\build\frps.exe -c %WORK_PATH%\build\frps.toml"
            start cmd /k "%WORK_PATH%\build\frpc.exe -c %WORK_PATH%\build\frpc.toml"

        )
    ) else (
        echo "Wrong enter.... Cancel And Quit...."
    )
)
