#Requires AutoHotkey v2.0
#SingleInstance Force

; 作者：scifx
; 网站：https://scifx.github.io
; 社交媒体：https://space.bilibili.com/232679770

try{
    TraySetIcon("Linkit.ico")
}

if A_Args.Length=2
{
    src:=A_Args[1]

    if A_Args[2]=="-h"{
        dst:=FileSelect("S",A_Args[1],"硬链接")
        Run(A_ComSpec " /c mklink /h " dst " " src,,"Hide",)
        ; MsgBox("硬链接")
    }

    if A_Args[2]=="-s"{
        dst:=FileSelect("S",A_Args[1],"软链接")
        Run(A_ComSpec " /c mklink " dst " " src,,"Hide",)
        ; MsgBox("软链接")
    }

    if A_Args[2]=="-d"
    {
        dst:=FileSelect("S",A_Args[1],"链接文件夹")
        
        Run(A_ComSpec " /c mklink /D " dst " " src,,"Hide",)
        ; MsgBox("目录")
    }
}

if A_IsCompiled
{
    vf:=Format('"{}" "%1" ',A_ScriptFullPath)
}else{
    vf:=Format('"{}" {} "%1" ',A_AhkPath,A_ScriptFullPath)
}

if A_Args.Length<1
{
    if not A_IsAdmin
    {
        MsgBox("请以管理员身份运行！","LinkIt (由SciFX制作)",48)
        Exit()
    }

    hardlinkfile := "HKEY_CLASSES_ROOT\*\shell\硬链接\command"
    ; vhf:='"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" C:\Users\scifx\Desktop\LinkIt.ahk "%1" -h'
    vhf:=vf "-h"

    softlinkfile := "HKEY_CLASSES_ROOT\*\shell\软链接\command"
    ; vsf:='"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" C:\Users\scifx\Desktop\LinkIt.ahk "%1" -s'
    vsf:=vf "-s"

    linkDir := "HKEY_CLASSES_ROOT\Folder\shell\链接文件夹\command"
    ; vd:='"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" C:\Users\scifx\Desktop\LinkIt.ahk %1 -d'
    vd:=vf "-d"

    khf := "HKEY_CLASSES_ROOT\*\shell\硬链接"
    ksf := "HKEY_CLASSES_ROOT\*\shell\软链接"
    kd := "HKEY_CLASSES_ROOT\Folder\shell\链接文件夹"

    install:=false
    try
    {
        RegRead(hardlinkfile)=vhf
        RegRead(softlinkfile)=vsf
        RegRead(linkDir)=vd
    }catch OSError as err{
        install:=true
    }


    if install=true
    {
        RegWrite(vhf, "REG_SZ", hardlinkfile)
        RegWrite(vsf, "REG_SZ", softlinkfile)
        RegWrite(vd, "REG_SZ", linkDir)
        MsgBox("LinkIt 已安装","LinkIt (由SciFX制作)",64)
    }else{
        RegDeleteKey(khf)
        RegDeleteKey(ksf)
        RegDeleteKey(kd)
        MsgBox("LinkIt 已卸载","LinkIt (由SciFX制作)",64)
    }
}