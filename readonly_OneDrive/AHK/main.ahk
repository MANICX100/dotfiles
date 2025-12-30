#Requires AutoHotkey v2.0

SendMode("Input")
SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(true)
SetTitleMatchMode(2)
#WinActivateForce
Persistent

;Hotkeys
;# win
;! alt
;^ ctrl

; --- Global Variable ---
; Declare and initialize the global variable to track the state.
global komorebi_is_running := false ; Assume Komorebi is stopped initially

; --- Hotkey Definition ---
; Win + Ctrl + K :: Toggle Komorebi Start/Stop
#^k::
{
    ; IMPORTANT: Variable declarations MUST come first in the block!
    global komorebi_is_running

    ; Now the rest of the code follows the declaration:
    if (komorebi_is_running) ; Check the global variable's value
    {
        Run("komorebic stop",, "Hide")
        ToolTip("Komorebi Stopping...")
        komorebi_is_running := false ; Update the global variable
    }
    else ; If we think it's stopped, start it
    {
        Run("komorebic start",, "Hide")
        ToolTip("Komorebi Starting...")
        komorebi_is_running := true ; Update the global variable
    }
    ; Remove the tooltip after 1.5 seconds
    SetTimer(() => ToolTip(), -1500)
}

#HotIf WinActive("ahk_class CabinetWClass")
`::
{
    explorerHwnd := WinActive("ahk_class CabinetWClass")
    if (explorerHwnd)
    {
        dir := ""
        for window in ComObject("Shell.Application").Windows
        {
            if (window.HWND == explorerHwnd)
            {
                dir := window.Document.Folder.Self.Path
                break
            }
        }

        if (dir != "")
        {
            ; Open Windows Terminal in the current folder using the default profile
            Run 'wt.exe -d "' dir '"'
            return
        }
    }

    ; Fallback: open Windows Terminal normally
    Run "wt.exe"
}
#HotIf

AppsKey::Run "https://t3.chat/"

Home::Reload()

Pause::Send("{Media_Play_Pause}")

; Alt + Pause  →  open *this* script in Notepad
!Pause::
{
    Run('notepad.exe "' A_ScriptFullPath '"')
}

^!W::ToggleChrome()

ToggleChrome() {
    local w, v := 0
    DetectHiddenWindows false
    for w in WinGetList("ahk_class Chrome_WidgetWin_1") {
        v := 1
    }
    DetectHiddenWindows true
    for w in WinGetList("ahk_class Chrome_WidgetWin_1") {
        if v
            WinHide(w)
        else
            WinShow(w)
    }
}

^!S::Shutdown(5)
^!R::Shutdown(6)
^!n::Run("notepad.exe")

#F5::Run("narrator.exe")
#F4::A_Clipboard := WinGetClass("A")

#e::
^!e::
{
USERPROFILE := EnvGet("USERPROFILE")
Run(USERPROFILE "\Documents")
return
}

^!l::
{
    DllCall("LockWorkStation")
    return
}

^!+t::
{
    WinSetAlwaysOnTop -1, "A"
}

; Map Ctrl+Alt+T to launch Windows Terminal (wt.exe)
^!t::
{
    Run("wt.exe")
    return
}
; Map Ctrl+Shift+Esc to launch Task Manager with the "-d" parameter
^+Esc::
 {
    Run("taskmgr.exe -d")
    return
 }
 
^!b::Run "http://"

^!i::Run "ms-settings:windowsupdate"

#PgUp::Send "{Volume_Up}"
#PgDn::Send "{Volume_Down}"
