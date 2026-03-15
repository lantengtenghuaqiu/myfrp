@echo off
setlocal enabledelayedexpansion

echo "Hello frp bat"

set WORK_PATH=%~dp0

set BUILD=build
set SRC_DIR=frp-0.52.1

set FRPS=frps.exe
set FRPC=frpc.exe

set STOML=frps.toml

set CTOML_HOSTER=frpc-hoster.toml
set CTOML_VISTOR=frpc-visitor.toml


echo "Work Space Path : %WORK_PATH%"


call :CheckIfNeedToBuild %BUILD% %FRPS% %FRPC%



if exist !FRPS! if exist !FRPC! (
    echo "Exist the file of %FRPC% and %FRPS%"

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
                echo bindPort=!SERVERPORT! > %STOML%

                set /p TOKEN="Enter the TOKEN : "
                echo token="!TOKEN!" >> %STOML%

                if "!CONNECTTYPE!"=="2" (
                    set /p bindUDPPORT="Enter the UDPPORT : "
                    echo bindUDPport=!bindUDPPORT! >> %STOML%
                )

                set FRPLOG=frps.log

                if not exist !FRPLOG! (
                    type nul > !FRPLOG!
                )

                (
                echo.
                echo logFile="./!FRPLOG!"
                echo logLevel="info"
                echo logMaxDays=3
                ) >> %STOML%
                echo "Runing the Service...."

                start cmd /k %WORK_PATH%/build/frps.exe -c frps.toml

                @REM ------------------------------------------------------------------
                @REM ------------------------------------------------------------------

            ) else if "!CHOICE!"=="2" (
                set /p CHARACTER="As Host Or Vistor : 1.Host , 2.Visitor : "

                if "!CHARACTER!"=="1" (
                    if not exist %CTOML_HOSTER% (
                        type nul> %CTOML_HOSTER%
                    )

                    set /p SERVERAddR="Enter the Server IP : "
                    echo serverAddr="!SERVERAddR!" > %CTOML_HOSTER%

                    set /p SERVERPORT="Enter the Server PORT : "
                    echo serverPort=!SERVERPORT! >> %CTOML_HOSTER%

                    set /p PASSWORD="Enter the Server PASSWORD : "
                    echo token="!PASSWORD!" >> %CTOML_HOSTER%

                    (
                    echo. 
                    echo [[proxies]] 
                    )>> %CTOML_HOSTER%

                    set /p GAMENAME="Enter the Game name : "
                    echo name="!GAMENAME!" >> %CTOML_HOSTER%

                    if "!CONNECTTYPE!"=="1" (
                        echo type="tcp" >> %CTOML_HOSTER%
                    ) else if "!CONNECTTYPE!"=="2" (
                        echo type="xtcp" >> %CTOML_HOSTER%
                        set /p SK="Write The SK Password : "
                        echo role="server" >> %CTOML_HOSTER%
                        echo sk="!SK!" >> %CTOML_HOSTER%
                    ) else (
                        echo type="xtcp" >> %CTOML_HOSTER%
                        set /p SK="Write The SK Password : "
                        echo role="server" >> %CTOML_HOSTER%
                        echo sk="!SK!" >> %CTOML_HOSTER%                        
                    )

                    set /p LOCALIP="Enter the Local IP(127.0.0.1) : "
                    echo localIP="!LOCALIP!" >> %CTOML_HOSTER%

                    set /p LOCALPORT="Enter the Local port : "
                    echo localPort=!LOCALPORT! >> %CTOML_HOSTER%

                    echo "Running the Customer...."
                    start cmd /k %WORK_PATH%/build/frpc.exe -c frpc-hoster.toml

                    if "!CONNECTTYPE!"=="1" (
                        set /p REMOTEPORT="Enter the Server port : "
                        echo remotePort=!REMOTEPORT! >> %CTOML_HOSTER%
                    )

                ) else if "!CHARACTER!"=="2" (
                    if not exist %CTOML_VISTOR% (
                        type nul> %CTOML_VISTOR%
                    )

                    set /p SERVERAddR="Enter the Server IP : "
                    echo serverAddr="!SERVERAddR!" > %CTOML_VISTOR%

                    set /p SERVERPORT="Enter the Server PORT : "
                    echo serverPort=!SERVERPORT! >> %CTOML_VISTOR%

                    set /p PASSWORD="Enter the Server PASSWORD : "
                    echo token="!PASSWORD!" >> %CTOML_VISTOR%

                    (
                    echo. 
                    echo [[proxies]] 
                    )>> %CTOML_VISTOR%

                    set /p GAMENAME="Enter the Game name : "
                    echo name="!GAMENAME!" >> %CTOML_VISTOR%

                    echo type="xtcp" >> %CTOML_VISTOR%
                    set /p SK="Write The SK Password : "
                    echo role="visitor" >> %CTOML_VISTOR%
                    echo sk="!SK!" >> %CTOML_VISTOR%
                    
                    set /p BINDADDR="Enter the Bind IP(127.0.0.1) : "
                    echo bindAddr="!BINDADDR!" >> %CTOML_VISTOR%

                    set /p BINDPORT="Enter the Bind port : "
                    echo bindPort=!BINDPORT! >> %CTOML_VISTOR%

                    echo "Running the Customer...."
                    start cmd /k %WORK_PATH%/build/frpc.exe -c frpc-server.toml

                ) else (
                    if not exist %CTOML_VISTOR% (
                        type nul> %CTOML_VISTOR%
                    )
                )


            ) else (
                echo "Wrong enter.... Cancel And Quit...."
            )

        ) else (
            if "!CHOICE!"=="1" (
                @REM ------------------------------------------------------------------
                @REM Server------------------------------------------------------------
                echo bindPort=7000 > %STOML%

                set /p TOKEN="Enter the TOKEN : "
                echo token="!TOKEN!" >> %STOML%

                if "!CONNECTTYPE!"=="2" (
                    echo bindUDPport=7001 >> %STOML%
                )

                set FRPLOG=frps.log

                if not exist !FRPLOG! (
                    type nul > !FRPLOG!
                )

                (
                echo.
                echo logFile="./!FRPLOG!"
                echo logLevel="info"
                echo logMaxDays=3
                ) >> %STOML%
                echo "Runing the Service...."

                start cmd /k %WORK_PATH%/build/frps.exe -c frps.toml

                @REM ------------------------------------------------------------------
                @REM ------------------------------------------------------------------

            ) else (
                set /p CHARACTER="As Host Or Vistor : 1.Host , 2.Vistor : "
                set /p GAME="Which game : 1.MC , 2.Terraria , 3...."
                if "!GAME!"=="1" (

                    set /p SERVERAddR="Enter the Server IP : "
                    echo serverAddr="!SERVERAddR!" > %CTOML_HOSTER%

                    echo serverPort=7000 >> %CTOML_HOSTER%

                    set /p PASSWORD="Enter the Server PASSWORD : "
                    echo token="!PASSWORD!" >> %CTOML_HOSTER%

                    (
                    echo. 
                    echo [[proxies]] 
                    )>> %CTOML_HOSTER%

                    echo name="MC" >> %CTOML_HOSTER%

                    if "!CONNECTTYPE!"=="1" (
                        echo type="tcp" >> %CTOML_HOSTER%
                    ) else (
                        echo type="xtcp" >> %CTOML_HOSTER%
                        set /p SK="Write The SK Password : "
                        echo sk="!SK!" >> %CTOML_HOSTER%
                    )

                    if "!CHARACTER!"=="1" (
                        echo localIp="127.0.0.1" >> %CTOML_HOSTER%

                        echo localPort=25535 >> %CTOML_HOSTER%

                        if "!CONNECTTYPE!"=="1" (
                            echo remoteport=25535 >> %CTOML_HOSTER%
                        )
                    ) else (
                        echo role="visitor" >> %CTOML_HOSTER%

                        echo bindAddr="127.0.0.1" >> %CTOML_HOSTER%

                        echo bindPort=25535 >> %CTOML_HOSTER%
                    )
                )
                start cmd /k "%WORK_PATH%\build\frpc.exe -c %WORK_PATH%\build\frpc.toml"
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




:CheckIfNeedToBuild
if not exist %BUILD% (
    echo "Building the %BUILD% file..."
    md %BUILD%
    echo "Built the %BUILD% file..."
)

cd %BUILD%

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
goto :eof