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

        set /p ASSIGN="Choice Type : 1.Rewrite , 2.Fixed : "
        set /p CONNECTTYPE="Choice TCP or UDP : 1.TCP , 2.UDP : "
        set /p CHOICE="Enter number : 1 Server or 2 Customer (All other inputs count as cancel) : "


        if "!ASSIGN!"=="1" (
            if "!CHOICE!"=="1" (
                @REM ------------------------------------------------------------------
                @REM Server------------------------------------------------------------
                set /p SERVERPORT="Enter the Server PORT : "
                echo bindPort = !SERVERPORT! > %STOML%

                set /p TOKEN="Enter the TOKEN : "
                echo token = "!TOKEN!" >> %STOML%

                if "!CONNECTTYPE!"=="2" (
                    set /p UDPPORT="Enter the UDPPORT : "
                    echo UDPport = !UDPPORT! >> %STOML%
                )

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

                @REM start /k %WORK_PATH%/build/frps.exe -c frps.toml

                @REM ------------------------------------------------------------------
                @REM ------------------------------------------------------------------

            ) else if "!CHOICE!"=="2" (
                set /p CHARACTER="As Host Or Vistor : 1.Host , 2.Vistor : "

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

                if "!CONNECTTYPE!"=="1" (
                    echo type = "tcp" >> %CTOML%
                ) else (
                    echo type = "xtcp" >> %CTOML%
                    set /p SK="Write The SK Password : "
                    echo sk = "!SK!" >> %CTOML%
                )

                if "!CHARACTER!"=="1" (
                    set /p LOCALIP="Enter the Local ip : "
                    echo localip = "!LOCALIP!" >> %CTOML%

                    set /p LOCALPORT="Enter the Local port : "
                    echo localport = !LOCALPORT! >> %CTOML%

                    if "!CONNECTTYPE!"=="1" (
                        set /p REMOTEPORT="Enter the Server port : "
                        echo remoteport = !REMOTEPORT! >> %CTOML%
                    )
                ) else (
                    echo role="vistor" >> %CTOML%

                    set /p BINDADDR="Enter the Bind ip : "
                    echo bindAddr = "!BINDADDR!" >> %CTOML%

                    set /p BINDPORT="Enter the Bind port : "
                    echo bindPort = !BINDPORT! >> %CTOML%
                )

                echo "Running the Customer...."
                @REM start cmd /k %WORK_PATH%/build/frpc.exe -c frpc.toml

            ) else (
                echo "Wrong enter.... Cancel And Quit...."
            )

        ) else (
            if "!CHOICE!"=="1" (
                @REM ------------------------------------------------------------------
                @REM Server------------------------------------------------------------
                echo bindPort = 7000 > %STOML%

                set /p TOKEN="Enter the TOKEN : "
                echo token = "!TOKEN!" >> %STOML%

                if "!CONNECTTYPE!"=="2" (
                    echo UDPport = 7001 >> %STOML%
                )

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

                @REM start /k %WORK_PATH%/build/frps.exe -c frps.toml

                @REM ------------------------------------------------------------------
                @REM ------------------------------------------------------------------

            ) else (
                set /p CHARACTER="As Host Or Vistor : 1.Host , 2.Vistor : "
                set /p GAME="Which game : 1.MC , 2.Terraria , 3...."
                if "!GAME!"=="1" (

                    set /p SERVERAddR="Enter the Server IP : "
                    echo serverAddr = "!SERVERAddR!" > %CTOML%

                    echo serverPort = 7000 >> %CTOML%

                    set /p PASSWORD="Enter the Server PASSWORD : "
                    echo token = "!PASSWORD!" >> %CTOML%

                    (
                    echo. 
                    echo [[proxies]] 
                    )>> %CTOML%

                    echo name="MC" >> %CTOML%

                    if "!CONNECTTYPE!"=="1" (
                        echo type = "tcp" >> %CTOML%
                    ) else (
                        echo type = "xtcp" >> %CTOML%
                        set /p SK="Write The SK Password : "
                        echo sk = "!SK!" >> %CTOML%
                    )

                    if "!CHARACTER!"=="1" (
                        echo localip = "127.0.0.1" >> %CTOML%

                        echo localport = 25535 >> %CTOML%

                        if "!CONNECTTYPE!"=="1" (
                            echo remoteport = 25535 >> %CTOML%
                        )
                    ) else (
                        echo role="vistor" >> %CTOML%

                        echo bindAddr = "127.0.0.1" >> %CTOML%

                        echo bindPort = 25535 >> %CTOML%
                    )
                )
            )
        )


    ) else if "!mode!"=="2" (
        set /p CHOICE="Enter number : 1 Server or 2 Customer (All other inputs count as cancel) : "
        
        echo "Your input" : [!CHOICE!]

        if "!CHOICE!"=="1" (
            set FRPLOG=frps.log

            if not exist !FRPLOG! (
                type nul > !FRPLOG!
            )

            start cmd /k "%WORK_PATH%\build\frps.exe -c %WORK_PATH%\build\frps.toml"

        ) else if "!CHOICE!"=="2" (
            start cmd /k "%WORK_PATH%\build\frpc.exe -c %WORK_PATH%\build\frpc.toml"
        )
    ) else (
        echo "Wrong enter.... Cancel And Quit...."
    )
)
