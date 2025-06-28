#SingleInstance Force
#Persistent

; 创建一个命令行窗口
Run, cmd.exe  /k "ollama serve",, , PID
WinWait, ahk_pid %PID%

; 获取命令行窗口的句柄
WinGet, HWND, ID, ahk_pid %PID%

; 定义一个函数用于将窗口最小化到托盘
MinimizeToTray(hWnd)
{
    ; 创建托盘图标
    Menu, Tray, Icon, shell32.dll, 10
    Menu, Tray, Add, 显示命令行窗口, ShowCmdWindow
    Menu, Tray, Default, 显示命令行窗口
    Menu, Tray, Add
    Menu, Tray, Add, 退出, ExitScript

    ; 最小化窗口
    PostMessage, 0x112, 0xF060,,, ahk_id %hWnd%
}

ShowCmdWindow:
; 显示命令行窗口
WinActivate, ahk_pid %PID%
return

ExitScript:
ExitApp

; 当窗口最小化时触发
OnMessage(0x112, "WmSystray")
WmSystray(wParam, lParam) {
    global HWND
    if (lParam = 0xF010) ; 检测到最小化消息
    {
        MinimizeToTray(HWND)
        return 0
    }
}
return