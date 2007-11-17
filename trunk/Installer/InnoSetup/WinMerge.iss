; ID line follows -- this is updated by SVN
; $Id$
;
;           Programmed by:  Christian Blackburn, Christian List, Kimmo Varis,
;                 Purpose:  The is the Inno Setup installation script for distributing our WinmMerge application.
; Tools Needed To Compile:  Inno Setup 5.1.7+ (http://www.jrsoftware.org/isdl.php), Inno Setup QuickStart Pack 5.1.7+(http://www.jrsoftware.org/isdl.php)
;                           note: the versions of Inno Setup and the QuickStart Pack should be identical to ensure proper function
;Directly Dependant Files:  Because this is an installer. It would be difficult to list and maintain each of the files referenced
;                           throughout the script in the header.  If you search this plain text script for a particular file in our Subversio repository and it
;                           doesn't appear then this script is not directly dependant on that file.
;Compilation Instructions:  1.  Open this file in Inno Setup or ISTool
;                           2.  Make sure Compression=LZMA/Ultra, InternalCompressLevel=Ultra, and SolidCompression=True these values are lowered during
;                               development to speed up compilation, however at release we want the intaller to be as strong as possible.
;                           3. Check all files are present:
;                                   -From ISTool Click
;                           4.  Compile the script: "Project" --> "Verify Files..."
;                                   -From Inno Setup "Click "Build" --> "Compile"
;                                   -From ISTool Click "Project" --> "Compile Setup"
;                           5.  The compiled installer will appear in the \InnoSetup\Output\ directory at currently should be around 1.5MBs in size.
;
; Installer To Do List:
; #  We need to unregister, and delete the ShellExtension Dll if the user doesn't want it, during installation

; #  Display integration options in gray rather than hiding them if the user doesn't have the application in question installed
; #  We need to ask those that have the RCLLocalization.dll in their plugins folder if they actually want it, their answer will need to be stored in the registry
; #  Write code to detect "\Programs\WinMerge\WinMerge" type start menu installs
;
; Things that make the user's life easier:
; #  Create instructions and a sample language file using the Inno Setup Translator Tool (http://www2.arnes.si/~sopjsimo/translator.html)
; #  Add "WinMerge is running would you like to close it now?" support with programmatic termination
;     -Note: We'll need to add a declares statement to our ISX code so that we can use FindWindowEx directly or a mutex search or two
; #  Rather than requiring users to restart we could just kill all intances of Explorer.exe, but we'll need to prompt the user first and restart it
;    once the ShellExtension.dll file has been added or removed.
;
; Non-Essential Features:
; #  See about getting a higher resolution copy of the Users's Guide.ico source art from somebody (A 32x32, and or 48x48 would be nice)
; #  Using the registry set the order our icons appear within their group in the start menu.:
;      1.  WinMerge
;      2.  Read Me
;      3.  Users's Guide
;      4.  WinMerge on the Web
;      5.  Uninstall WinMerge
; #  Create the ability to install to two start menu groups simultaneously
;
; Not yet possible (Limited by Inno Setup):
; #  While uninstalling prompt the user as to whether or not they'd like to remove their WinMerge preferences too?

#define AppVersion GetFileVersion(SourcePath + "\..\..\Build\MergeUnicodeRelease\WinMergeU.exe")
#define FriendlyAppVersion Copy(GetFileVersion(SourcePath + "\..\..\Build\MergeUnicodeRelease\WinMergeU.exe"), 1, 5)


[Setup]
AppName=WinMerge
AppVerName=WinMerge {#AppVersion}
AppPublisher=Thingamahoochie Software
AppPublisherURL=http://WinMerge.org/
AppSupportURL=http://WinMerge.org/
AppUpdatesURL=http://WinMerge.org/

;This is in case an older version of the installer happened to be
DirExistsWarning=no

;This requires IS Pack 4.18(full install).
AppVersion={#AppVersion}

;Tells the installer to only display a select language dialog if the an exact match wasn't found
ShowLanguageDialog=auto

DefaultDirName={pf}\WinMerge
DefaultGroupName=WinMerge
DisableStartupPrompt=true
AllowNoIcons=true
InfoBeforeFile=..\..\Docs\users\GPL.rtf
InfoAfterFile=..\..\Docs\users\ReadMe.txt

OutputBaseFilename=WinMerge-{#AppVersion}-Setup

;This must be admin to install C++ Runtimes and shell extension
PrivilegesRequired=admin

UninstallDisplayIcon={app}\{code:ExeName}

;File Version Info
VersionInfoVersion={#AppVersion}

;Artwork References
WizardImageFile=Art\Large Logo.bmp
WizardSmallImageFile=Art\Small Logo.bmp
WizardImageStretch=false

;It is confusing, if Setup/Uninstall use the same icon like WinMerge!
;SetupIconFile=..\..\src\res\Merge.ico

;Compression Parameters
;Please note while Compression=lzma/ultra and InternalCompressLevel=Ultra are better than max
;they also require 320 MB of memory for compression. If you're system has at least 256MB RAM then by all
;means set it to ultra before compilation
Compression=lzma/ultra
InternalCompressLevel=ultra
SolidCompression=true

; Update file associations for shell (project files)
ChangesAssociations=true
OutputDir=..\..\Build
AlwaysShowComponentsList=true


[Languages]
;Inno Setup's Native Language
Name: English; MessagesFile: Languages\English.isl

;Localizations:
Name: Bulgarian; MessagesFile: Languages\Bulgarian.isl; InfoAfterFile: ..\..\Docs\Users\Languages\ReadMe-Bulgarian.txt
Name: Catalan; MessagesFile: Languages\Catalan.isl; InfoAfterFile: ..\..\Docs\Users\Languages\ReadMe-Catalan.txt
Name: Chinese_Simplified; MessagesFile: Languages\Chinese_Simplified.isl
Name: Chinese_Traditional; MessagesFile: Languages\Chinese_Traditional.isl
Name: Croatian; MessagesFile: Languages\Croatian.isl
Name: Czech; MessagesFile: Languages\Czech.isl
Name: Danish; MessagesFile: Languages\Danish.isl
Name: Dutch; MessagesFile: Languages\Dutch.isl
Name: French; MessagesFile: Languages\French.isl; InfoAfterFile: ..\..\Docs\Users\Languages\ReadMe-French.txt
Name: German; MessagesFile: Languages\German.isl
Name: Hungarian; MessagesFile: Languages\Hungarian.isl
Name: Italian; MessagesFile: Languages\Italian.isl
Name: Japanese; MessagesFile: Languages\Japanese.isl
Name: Korean; MessagesFile: Languages\Korean.isl
Name: Norwegian; MessagesFile: Languages\Norwegian.isl
Name: Polish; MessagesFile: Languages\Polish.isl
Name: Portuguese; MessagesFile: Languages\Portuguese.isl
Name: PortugueseBrazilian; MessagesFile: Languages\Brazilian_Portuguese.isl
Name: Russian; MessagesFile: Languages\Russian.isl
Name: Slovak; MessagesFile: Languages\Slovak.isl
Name: Spanish; MessagesFile: Languages\Spanish.isl; InfoAfterFile: ..\..\Docs\Users\Languages\ReadMe-Spanish.txt
Name: Swedish; MessagesFile: Languages\Swedish.isl; InfoAfterFile: ..\..\Docs\Users\Languages\ReadMe-Swedish.txt
Name: Turkish; MessagesFile: Languages\Turkish.isl


[Messages]
English.FinishedLabel=Setup has finished installing WinMerge on your computer.
English.SetupAppTitle=Setup - WinMerge {#AppVersion}
English.WizardInfoBefore=License Agreement
English.InfoBeforeLabel=GNU General Public License


[Types]
Name: typical; Description: {cm:TypicalInstallation}
Name: full; Description: {cm:FullInstallation}
Name: compact; Description: {cm:CompactInstallation}
Name: custom; Description: {cm:CustomInstallation}; Flags: iscustom


[Components]
; Executable and libraries
Name: Core; Description: {cm:AppCoreFiles}; Types: full custom typical compact; Flags: fixed

; User rmanual
Name: docs; Description: {cm:UsersGuide}; Flags: disablenouninstallwarning; Types: full typical
Name: filters; Description: {cm:Filters}; Flags: disablenouninstallwarning; Types: full typical
Name: Plugins; Description: {cm:Plugins}; Flags: disablenouninstallwarning; Types: full

;Language components
Name: Languages; Description: {cm:Languages}; Flags: disablenouninstallwarning
Name: Languages\Bulgarian; Description: {cm:BulgarianLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Bulgarian
Name: Languages\Bulgarian; Description: {cm:BulgarianLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Bulgarian

Name: Languages\Catalan; Description: {cm:CatalanLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Catalan
Name: Languages\Catalan; Description: {cm:CatalanLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Catalan

Name: Languages\Chinese_Simplified; Description: {cm:ChineseSimplifiedLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Chinese_Simplified
Name: Languages\Chinese_Simplified; Description: {cm:ChineseSimplifiedLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Chinese_Simplified

Name: Languages\Chinese_Traditional; Description: {cm:ChineseTraditionalLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Chinese_Traditional
Name: Languages\Chinese_Traditional; Description: {cm:ChineseTraditionalLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Chinese_Traditional

Name: Languages\Croatian; Description: {cm:CroatianLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Croatian
Name: Languages\Croatian; Description: {cm:CroatianLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Croatian

Name: Languages\Czech; Description: {cm:CzechLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Czech
Name: Languages\Czech; Description: {cm:CzechLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Czech

Name: Languages\Danish; Description: {cm:DanishLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Danish
Name: Languages\Danish; Description: {cm:DanishLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Danish

Name: Languages\Dutch; Description: {cm:DutchLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Dutch
Name: Languages\Dutch; Description: {cm:DutchLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Dutch

Name: Languages\French; Description: {cm:FrenchLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not French
Name: Languages\French; Description: {cm:FrenchLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: French

Name: Languages\German; Description: {cm:GermanLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not German
Name: Languages\German; Description: {cm:GermanLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: German

Name: Languages\Hungarian; Description: {cm:HungarianLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Hungarian
Name: Languages\Hungarian; Description: {cm:HungarianLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Hungarian

Name: Languages\Italian; Description: {cm:ItalianLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Italian
Name: Languages\Italian; Description: {cm:ItalianLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Italian

Name: Languages\Japanese; Description: {cm:JapaneseLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Japanese
Name: Languages\Japanese; Description: {cm:JapaneseLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Japanese

Name: Languages\Korean; Description: {cm:KoreanLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Korean
Name: Languages\Korean; Description: {cm:KoreanLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Korean

Name: Languages\Norwegian; Description: {cm:NorwegianLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Norwegian
Name: Languages\Norwegian; Description: {cm:NorwegianLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Norwegian

Name: Languages\Polish; Description: {cm:PolishLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Polish
Name: Languages\Polish; Description: {cm:PolishLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Polish

Name: Languages\Portuguese; Description: {cm:PortugueseLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Portuguese
Name: Languages\Portuguese; Description: {cm:PortugueseLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Portuguese

Name: Languages\PortugueseBrazilian; Description: {cm:PortugueseBrazilLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not PortugueseBrazilian
Name: Languages\PortugueseBrazilian; Description: {cm:PortugueseBrazilLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: PortugueseBrazilian

Name: Languages\Russian; Description: {cm:RussianLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Russian
Name: Languages\Russian; Description: {cm:RussianLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Russian

Name: Languages\Slovak; Description: {cm:SlovakLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Slovak
Name: Languages\Slovak; Description: {cm:SlovakLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Slovak

Name: Languages\Spanish; Description: {cm:SpanishLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Spanish
Name: Languages\Spanish; Description: {cm:SpanishLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Spanish

Name: Languages\Swedish; Description: {cm:SwedishLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Swedish
Name: Languages\Swedish; Description: {cm:SwedishLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Swedish

Name: Languages\Turkish; Description: {cm:TurkishLanguage}; Flags: disablenouninstallwarning; Types: full; Languages: not Turkish
Name: Languages\Turkish; Description: {cm:TurkishLanguage}; Flags: disablenouninstallwarning; Types: full typical compact; Languages: Turkish

[Tasks]
Name: ShellExtension; Description: {cm:ExplorerContextMenu}; GroupDescription: {cm:OptionalFeatures}
Name: TortoiseCVS; Description: {cm:IntegrateTortoiseCVS}; GroupDescription: {cm:OptionalFeatures}; Check: TortoiseCVSInstalled
Name: TortoiseSVN; Description: {cm:IntegrateTortoiseSVN}; GroupDescription: {cm:OptionalFeatures}; Check: TortoiseSVNInstalled; MinVersion: 0,5.0.2195sp3
Name: ClearCase; Description: {cm:IntegrateClearCase}; GroupDescription: {cm:OptionalFeatures}; Check: ClearCaseInstalled
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked
Name: quicklaunchicon; Description: {cm:CreateQuickLaunchIcon}; GroupDescription: {cm:AdditionalIcons}

[InstallDelete]
; Diff.txt is a file left over from previous versions of WinMerge (before version 2.0), we just delete it to be nice.
Type: files; Name: {app}\Diff.txt

;All of these files are removed so if the user upgrades their operating system or changes their language selections only the
;necessary files will be left in the installation folder
;Another reason these files might be strays is if a user extracted one of the experimental builds such as:
;WinMerge.{#AppVersion}-exe.7z.
Name: {app}\WinMerge.exe; Type: files
Name: {app}\WinMergeU.exe; Type: files; MinVersion: 0, 4

;Remove manifest files as we don't need them in 2.6.2 / 2.7.1.1 or later
Name: {app}\WinMerge.exe.manifest; Type: files
Name: {app}\WinMergeU.exe.manifest; Type: files

;This won't work, because the file has to be unregistered, and explorer closed, first.
;Name: {app}\ShellExtension.dll; Type: files; Check: TaskDisabled('ShellExtension')

; Remove existing .lang files - we don't need them anymore as we are
; using PO files now.
Name: {app}\Languages\MergeBrazilian.lang; Type: files; Check: not IsComponentSelected('PortugueseBrazilian')
Name: {app}\Languages\MergeBulgarian.lang; Type: files; Check: not IsComponentSelected('Bulgarian')
Name: {app}\Languages\MergeCatalan.lang; Type: files; Check: not IsComponentSelected('Catalan')
Name: {app}\Languages\MergeChineseSimplified.lang; Type: files; Check: not IsComponentSelected('Chinese_Simplified')
Name: {app}\Languages\MergeChineseTraditional.lang; Type: files; Check: not IsComponentSelected('Chinese_Traditional')
Name: {app}\Languages\MergeCzech.lang; Type: files; Check: not IsComponentSelected('Czech')
Name: {app}\Languages\MergeDanish.lang; Type: files; Check: not IsComponentSelected('Danish')
Name: {app}\Languages\MergeDutch.lang; Type: files; Check: not IsComponentSelected('Dutch')
Name: {app}\Languages\MergeFrench.lang; Type: files; Check: not IsComponentSelected('French')
Name: {app}\Languages\MergeGerman.lang; Type: files; Check: not IsComponentSelected('German')
Name: {app}\Languages\MergeHungarian.lang; Type: files; Check: not IsComponentSelected('Hungarian')
Name: {app}\Languages\MergeItalian.lang; Type: files; Check: not IsComponentSelected('Italian')
Name: {app}\Languages\MergeJapanese.lang; Type: files; Check: not IsComponentSelected('Japanese')
Name: {app}\Languages\MergeKorean.lang; Type: files; Check: not IsComponentSelected('Korean')
Name: {app}\Languages\MergeNorwegian.lang; Type: files; Check: not IsComponentSelected('Norwegian')
Name: {app}\Languages\MergePolish.lang; Type: files; Check: not IsComponentSelected('Polish')
Name: {app}\Languages\MergePortuguese.lang; Type: files; Check: not IsComponentSelected('Portuguese')
Name: {app}\Languages\MergeSlovak.lang; Type: files; Check: not IsComponentSelected('Slovak')
Name: {app}\Languages\MergeSpanish.lang; Type: files; Check: not IsComponentSelected('Spanish')
Name: {app}\Languages\MergeRussian.lang; Type: files; Check: not IsComponentSelected('Russian')
Name: {app}\Languages\MergeSwedish.lang; Type: files; Check: not IsComponentSelected('Swedish')
Name: {app}\Languages\MergeTurkish.lang; Type: files; Check: not IsComponentSelected('Turkish')
Name: {app}\MergePlugins\list.txt; Type: files; Check: not IsComponentSelected('Plugins')

;Removes the user's guide icon if the user deselects the user's guide component.
Name: {group}\{cm:UsersGuide}.lnk; Type: files; Check: not IsComponentSelected('Docs')

;This removes the quick launch icon in case the user chooses not to install it after previously having it installed
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\WinMerge.lnk; Type: files; Check: not IsTaskSelected('QuickLauchIcon')

;This removes the desktop icon in case the user chooses not to install it after previously having it installed
Name: {userdesktop}\WinMerge.lnk; Type: files; Check: not IsTaskSelected('DesktopIcon')

;Remove ANSI executable link from start menu for NT-based Windows versions
;This was installed earlier, but not anymore.
Name: {group}\WinMerge (ANSI).lnk; Type: files; MinVersion: 0,4
Name: {app}\Docs; Type: filesandordirs

Name: {app}\MergePlugins\editor addin.sct; Type: Files; Check: not IsComponentSelected('Plugins')
Name: {app}\MergePlugins\insert datetime.sct; Type: Files; Check: not IsComponentSelected('Plugins')
Name: {app}\MergePlugins; Type: DirIfEmpty; Check: not IsComponentSelected('Plugins')

Name: {app}\Filters\ADAMulti.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\ASPNET.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\CSharp_loose.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\Delphi.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\MASM.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\Merge_GnuC_loose.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\Merge_VC_loose.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\Merge_VB_loose.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\SourceControl.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\Symbian.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\XML_html.flt; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters\FileFilter.tmpl; Type: Files; Check: not IsComponentSelected('Filters')
Name: {app}\Filters; Type: DirIfEmpty; Check: not IsComponentSelected('Filters')



[Dirs]
;The always uninstall flag tells the uninstaller to remove the folder if it's empty regardless of whether or not it existed prior to the installation
Name: {app}; Flags: uninsalwaysuninstall


[Files]
; Select the proper executable for different Windows versions
; For Windows 05/98/ME ANSI executable is installed (WinMerge.exe)
; For Windows NT4/2000/XP/2003/Vista the Unicode executable is installed (WinMergeU.exe)
Source: ..\..\Build\MergeUnicodeRelease\WinMergeU.exe; DestDir: {app}; Flags: promptifolder; MinVersion: 0, 4; Components: Core
Source: ..\..\Build\MergeRelease\WinMerge.exe; DestDir: {app}; Flags: promptifolder; OnlyBelowVersion: 0, 4; Components: Core

; List of installed files
Source: ..\..\Docs\Users\Files.txt; DestDir: {app}; Flags: promptifolder; Components: Core

; Microsoft runtime libraries (C-runtime, MFC)
Source: ..\Runtimes\mfc71.dll; DestDir: {sys}; Flags: restartreplace uninsneveruninstall sharedfile; OnlyBelowVersion: 0, 4; Components: Core
Source: ..\Runtimes\mfc71u.dll; DestDir: {sys}; Flags: restartreplace uninsneveruninstall sharedfile; MinVersion: 0, 4; Components: Core
Source: ..\Runtimes\msvcr71.dll; DestDir: {sys}; Flags: restartreplace uninsneveruninstall sharedfile; Components: Core
Source: ..\Runtimes\msvcp71.dll; DestDir: {sys}; Flags: restartreplace uninsneveruninstall sharedfile; Components: Core

; Shell extension
Source: ..\..\Build\MergeRelease\ShellExtension.dll; DestDir: {app}; Flags: regserver uninsrestartdelete restartreplace promptifolder; MinVersion: 4, 0; Check: not IsWin64
Source: ..\..\Build\MergeUnicodeRelease\ShellExtensionU.dll; DestDir: {app}; Flags: regserver uninsrestartdelete restartreplace promptifolder; MinVersion: 0, 4; Check: not IsWin64
; 64-bit version of ShellExtension
Source: ..\..\Build\ShellExtensionX64\ShellExtensionX64.dll; DestDir: {app}; Flags: regserver uninsrestartdelete restartreplace promptifolder 64bit; MinVersion: 0,5.01.2600; Check: IsWin64

; Expat dll
Source: ..\..\Build\expat\libexpat.dll; DestDir: {app}; Flags: promptifolder; Components: Core

; PCRE dll
Source: ..\..\Build\pcre\pcre.dll; DestDir: {app}; Flags: promptifolder; Components: Core

; MergeLang.dll - translation helper dll
Source: ..\..\Build\MergeUnicodeRelease\MergeLang.dll; DestDir: {app}; Flags: promptifolder; Components: Core

; Language files
Source: ..\..\Src\Languages\Brazilian.po; DestDir: {app}\Languages; Components: Languages\PortugueseBrazilian; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Bulgarian.po; DestDir: {app}\Languages; Components: Languages\Bulgarian; Flags: ignoreversion comparetimestamp
Source: ..\..\Docs\Users\Languages\ReadMe-Bulgarian.txt; DestDir: {app}\Docs; Components: Languages\Bulgarian
Source: ..\..\Src\Languages\Catalan.po; DestDir: {app}\Languages; Components: Languages\Catalan; Flags: ignoreversion comparetimestamp
Source: ..\..\Docs\Users\Languages\ReadMe-Catalan.txt; DestDir: {app}\Docs; Components: Languages\Catalan
Source: ..\..\Src\Languages\ChineseSimplified.po; DestDir: {app}\Languages; Components: Languages\Chinese_Simplified; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\ChineseTraditional.po; DestDir: {app}\Languages; Components: Languages\Chinese_Traditional; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Croatian.po; DestDir: {app}\Languages; Components: Languages\Croatian; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Czech.po; DestDir: {app}\Languages; Components: Languages\Czech; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Danish.po; DestDir: {app}\Languages; Components: Languages\Danish; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Dutch.po; DestDir: {app}\Languages; Components: Languages\Dutch; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\French.po; DestDir: {app}\Languages; Components: Languages\French; Flags: ignoreversion comparetimestamp
Source: ..\..\Docs\Users\Languages\ReadMe-French.txt; DestDir: {app}\Docs; Components: Languages\French
Source: ..\..\Src\Languages\German.po; DestDir: {app}\Languages; Components: Languages\German; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Hungarian.po; DestDir: {app}\Languages; Components: Languages\Hungarian; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Italian.po; DestDir: {app}\Languages; Components: Languages\Italian; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Japanese.po; DestDir: {app}\Languages; Components: Languages\Japanese; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Korean.po; DestDir: {app}\Languages; Components: Languages\Korean; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Norwegian.po; DestDir: {app}\Languages; Components: Languages\Norwegian; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Polish.po; DestDir: {app}\Languages; Components: Languages\Polish; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Portuguese.po; DestDir: {app}\Languages; Components: Languages\Portuguese; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Russian.po; DestDir: {app}\Languages; Components: Languages\Russian; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Slovak.po; DestDir: {app}\Languages; Components: Languages\Slovak; Flags: ignoreversion comparetimestamp
Source: ..\..\Src\Languages\Spanish.po; DestDir: {app}\Languages; Components: Languages\Spanish; Flags: ignoreversion comparetimestamp
Source: ..\..\Docs\Users\Languages\ReadMe-Spanish.txt; DestDir: {app}\Docs; Components: Languages\Spanish
Source: ..\..\Src\Languages\Swedish.po; DestDir: {app}\Languages; Components: Languages\Swedish; Flags: ignoreversion comparetimestamp
Source: ..\..\Docs\Users\Languages\ReadMe-Swedish.txt; DestDir: {app}\Docs; Components: Languages\Swedish
Source: ..\..\Src\Languages\Turkish.po; DestDir: {app}\Languages; Components: Languages\Turkish; Flags: ignoreversion comparetimestamp

Source: ..\..\Filters\*.flt; DestDir: {app}\Filters; Flags: sortfilesbyextension comparetimestamp ignoreversion; Components: filters
Source: ..\..\Filters\FileFilter.tmpl; DestDir: {app}\Filters; Flags: sortfilesbyextension comparetimestamp ignoreversion; Components: filters

;Documentation
Source: ..\..\Docs\Users\ReadMe.txt; DestDir: {app}\Docs; Flags: comparetimestamp ignoreversion promptifolder; Components: Core
Source: ..\..\Docs\Users\Contributors.txt; DestDir: {app}; Flags: comparetimestamp ignoreversion promptifolder; Components: Core
Source: ..\..\Build\Manual\htmlhelp\WinMerge.chm; DestDir: {app}\Docs\; Flags: overwritereadonly uninsremovereadonly; Components: docs

;Plugins
;Please note IgnoreVersion and CompareTimeStamp are to instruct the installer to not not check for version info and go straight to comparing modification dates
Source: ..\..\Plugins\dlls\editor addin.sct; DestDir: {app}\MergePlugins; Flags: IgnoreVersion CompareTimeStamp; Components: Plugins
Source: ..\..\Plugins\dlls\insert datetime.sct; DestDir: {app}\MergePlugins; Flags: IgnoreVersion CompareTimeStamp; Components: Plugins
Source: ..\..\Plugins\dlls\*.dll; DestDir: {app}\MergePlugins; Flags: promptifolder; Components: Plugins

[INI]
Filename: {group}\{cm:ProgramOnTheWeb,WinMerge}.url; Section: InternetShortcut; Key: URL; String: http://WinMerge.org/; Check: GroupCreated


[Icons]
;Start Menu Icons
Name: {group}\WinMerge; Filename: {app}\{code:ExeName}
Name: {group}\{cm:ReadMe}; Filename: {app}\Docs\ReadMe.txt; IconFileName: {win}\NOTEPAD.EXE
Name: {group}\{cm:UsersGuide}; Filename: {app}\Docs\WinMerge.chm; Components: docs
Name: {group}\{cm:UninstallProgram,WinMerge}; Filename: {uninstallexe}

;Desktop Icon
Name: {userdesktop}\WinMerge; Filename: {app}\{code:ExeName}; Tasks: desktopicon

;Quick Launch Icon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\WinMerge; Filename: {app}\{code:ExeName}; Tasks: quicklaunchicon

[Registry]
Root: HKCU; Subkey: Software\Thingamahoochie; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: Software\Thingamahoochie\WinMerge; Flags: uninsdeletekey

;Add Project file extension (.WinMerge) to known extensions and
;set WinMerge to open those files
;set Notepad to edit project files
Root: HKCR; Subkey: .WinMerge; ValueType: String; ValueData: WinMerge.Project.File; Flags: uninsdeletekey
Root: HKCR; Subkey: WinMerge.Project.File; ValueType: String; ValueData: {cm:ProjectFileDesc}; Flags: uninsdeletekey
Root: HKCR; Subkey: WinMerge.Project.File\shell\open\command; ValueType: String; ValueData: """{app}\{code:ExeName}"" ""%1"""; Flags: uninsdeletekey
Root: HKCR; Subkey: WinMerge.Project.File\shell\edit\command; ValueType: String; ValueData: """NOTEPAD.EXE"" ""%1"""; Flags: uninsdeletekey
Root: HKCR; Subkey: WinMerge.Project.File\DefaultIcon; ValueType: String; ValueData: """{app}\{code:ExeName}"",1"; Flags: uninsdeletekey

; delete obsolete values
;In Inno Setup Version 4.18 ValueData couldn't be null and compile,
;if this is fixed in a later version feel free to remove the parameter
Root: HKCU; Subkey: Software\Thingamahoochie\WinMerge\Settings; ValueType: none; ValueName: LeftMax; Flags: deletevalue
Root: HKCU; Subkey: Software\Thingamahoochie\WinMerge\Settings; ValueType: none; ValueName: DirViewMax; Flags: deletevalue

;This removes the key that remembers which messageboxes to hide from the user, this is because the text of that message
;can change and make it more clear as to the user why they might want to pay attention to a particular dialog and also
;because a particular message might be added or removed and a new message might occupy a previous message's ID number
Root: HKLM; Subkey: Software\Thingamahoochie\WinMerge\MessageBoxes; ValueType: none; Flags: deletekey

Root: HKCR; SubKey: Directory\Shell\WinMerge\command; ValueType: none; Flags: deletekey noerror
Root: HKCR; SubKey: Directory\Shell\WinMerge; ValueType: none; Flags: deletekey noerror

;Adds "Start Menu" --> "Run" Support for WinMerge
Root: HKLM; Subkey: Software\Microsoft\Windows\CurrentVersion\App Paths\WinMerge.exe; ValueType: none; Flags: uninsdeletekey
Root: HKLM; Subkey: Software\Microsoft\Windows\CurrentVersion\App Paths\WinMergeU.exe; ValueType: none; Flags: uninsdeletekey
Root: HKLM; SubKey: SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinMerge.exe; ValueType: string; ValueName: ; ValueData: {app}\{code:ExeName}
Root: HKLM; SubKey: SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinMergeU.exe; ValueType: string; ValueName: ; ValueData: {app}\{code:ExeName}

;Registry Keys for use by ShellExtension.dll
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge; ValueType: string; ValueName: Executable; ValueData: {app}\{code:ExeName}

;Enables or disables the Context Menu preference based on what the user selects during install
;Initially the Context menu is explicitly disabled:
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge; ValueType: dword; ValueName: ContextMenuEnabled; ValueData: 0; Check: not IsTaskSelected('ShellExtension')

;If the user chose to use the context menu then we re-enable it.  This is necessary so it'll turn on and off not just on.
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge; ValueType: dword; ValueName: ContextMenuEnabled; ValueData: 1; Tasks: ShellExtension; Check: not ShellMenuEnabled()

;If WinMerge.exe is installed then we'll automatically configure WinMerge as the differencing application
Root: HKCU; SubKey: Software\TortoiseCVS; ValueType: string; ValueName: External Diff Application; ValueData: {app}\{code:ExeName}; Flags: uninsdeletevalue; Tasks: TortoiseCVS
Root: HKCU; SubKey: Software\TortoiseCVS; ValueType: dword; ValueName: DiffAsUnicode; ValueData: $00000001; Flags: uninsdeletevalue; Tasks: TortoiseCVS

;Tells TortoiseCVS to use WinMerge as its differencing application (this happens whether or not Tortoise is current installed, that way
;if it is installed at a later date this will automatically support it)
Root: HKCU; SubKey: Software\TortoiseCVS; ValueType: string; ValueName: External Merge Application; ValueData: {app}\{code:ExeName}; Flags: uninsdeletevalue; Tasks: TortoiseCVS
Root: HKCU; SubKey: Software\TortoiseCVS; ValueType: dword; ValueName: MergeAsUnicode; ValueData: $00000001; Flags: uninsdeletevalue; Tasks: TortoiseCVS

;Set WinMerge as TortoiseSVN diff tool
Root: HKCU; SubKey: Software\TortoiseSVN; ValueType: string; ValueName: Diff; ValueData: {app}\{code:ExeName} -e -x -ub -dl %bname -dr %yname %base %mine; Flags: uninsdeletevalue; Tasks: TortoiseSVN

;Whatever the user chooses at the [Select Setup Language] dialog should also determine what language WinMerge will start up in
;(unless the user already has a startup language specified)
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000402; Flags: deletevalue; Languages: Bulgarian
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000403; Flags: deletevalue; Languages: Catalan
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000804; Flags: deletevalue; Languages: Chinese_Simplified
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000404; Flags: deletevalue; Languages: Chinese_Traditional
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $0000041a; Flags: deletevalue; Languages: Croatian
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000405; Flags: deletevalue; Languages: Czech
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000406; Flags: deletevalue; Languages: Danish
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000413; Flags: deletevalue; Languages: Dutch
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000409; Flags: deletevalue; Languages: English
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $0000040c; Flags: deletevalue; Languages: French
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000407; Flags: deletevalue; Languages: German
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000410; Flags: deletevalue; Languages: Italian
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000411; Flags: deletevalue; Languages: Japanese
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000412; Flags: deletevalue; Languages: Korean
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000414; Flags: deletevalue; Languages: Norwegian
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000415; Flags: deletevalue; Languages: Polish
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000816; Flags: deletevalue; Languages: Portuguese
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000416; Flags: deletevalue; Languages: PortugueseBrazilian
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000419; Flags: deletevalue; Languages: Russian
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $0000041b; Flags: deletevalue; Languages: Slovak
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $00000c0a; Flags: deletevalue; Languages: Spanish
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $0000041D; Flags: deletevalue; Languages: Swedish
Root: HKCU; SubKey: Software\Thingamahoochie\WinMerge\Locale; ValueType: dword; ValueName: LanguageId; ValueData: $0000041f; Flags: deletevalue; Languages: Turkish
Root: HKCU; SubKey: Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu\Programs\{code:RelativeGroupPath}; ValueType: binary; ValueName: Order; ValueData: 08 00 00 00 02 00 00 00 a2 01 00 00 01 00 00 00 05 00 00 00 4c 00 00 00 01 00 00 00 3d 00 00 00 41 75 67 4d 01 00 00 00 01 00 00 00 00 00 00 00 27 00 32 00 2b 05 00 00 95 30 17 80 20 00 52 65 61 64 20 4d 65 2e 6c 6e 6b 00 52 45 41 44 4d 45 7e 31 2e 4c 4e 4b 00 00 00 00 00 00 05 00 00 00 56 00 00 00 04 00 00 00 48 00 00 00 41 75 67 4d 01 00 00 00 01 00 00 00 00 00 00 00 32 00 32 00 be 01 00 00 95 30 17 80 20 00 55 6e 69 6e 73 74 61 6c 6c 20 57 69 6e 4d 65 72 67 65 2e 6c 6e 6b 00 55 4e 49 4e 53 54 7e 31 2e 4c 4e 4b 00 00 00 00 00 05 00 00 00 50 00 00 00 02 00 00 00 42 00 00 00 41 75 67 4d 01 00 00 00 01 00 00 00 00 00 00 00 2c 00 32 00 c9 05 00 00 95 30 17 80 20 00 55 73 65 72 27 73 20 47 75 69 64 65 2e 6c 6e 6b 00 55 53 45 52 27 53 7e 31 2e 4c 4e 4b 00 00 00 00 00 05 00 00 00 58 00 00 00 03 00 00 00 49 00 00 00 41 75 67 4d 01 00 00 00 01 00 00 00 00 00 00 00 33 00 32 00 2e 00 00 00 95 30 17 80 20 00 57 69 6e 4d 65 72 67 65 20 6f 6e 20 74 68 65 20 57 65 62 2e 75 72 6c 00 57 49 4e 4d 45 52 7e 31 2e 55 52 4c 00 00 00 00 00 00 05 00 00 00 4c 00 00 00 00 00 00 00 3e 00 00 00 41 75 67 4d 01 00 00 00 01 00 00 00 00 00 00 00 28 00 32 00 ce 01 00 00 95 30 17 80 20 00 57 69 6e 4d 65 72 67 65 2e 6c 6e 6b 00 57 49 4e 4d 45 52 47 45 2e 4c 4e 4b 00 00 00 00 00 05 00 00 00


[Run]
;This will no longer appear unless the user chose to make a start menu group in the first place
Filename: {win}\Explorer.exe; Description: {cm:ViewStartMenuFolder}; Parameters: """{group}"""; Flags: waituntilidle postinstall skipifsilent unchecked; Check: GroupCreated

Filename: {app}\{code:ExeName}; Description: {cm:LaunchProgram, WinMerge}; Flags: nowait postinstall skipifsilent runmaximized


[UninstallDelete]
;Remove 7-zip integration dlls possibly installed (by hand or using separate installer)
Name: {app}\Merge7z*.dll; Type: files
Name: {app}\7zip_pad.xml; Type: files
Name: {app}\Codecs; Type: filesandordirs
Name: {app}\Formats; Type: filesandordirs
Name: {app}\Lang; Type: filesandordirs

Name: {group}\{cm:ProgramOnTheWeb,WinMerge}.url; Type: Files
Name: {group}; Type: dirifempty
Name: {app}; Type: dirifempty


[Code]
{Determines whether or not the user chose to create a start menu}
Function GroupCreated(): boolean;
Var
    {Stores the path of the start menu group Inno Setup may have created}
    strGroup_Path: string;
Begin
    {Saves the path that Inno Setup intended to create the start menu group at}
    strGroup_Path := ExpandConstant('{group}');

    {If the start menu path isn't blank then..}
    if strGroup_Path <> '' Then
        Begin
            {If the user choose to create the start menu then this folder will exist.
            If the folder exists then GroupCreated = True otherwise it does not.}
            Result := DirExists(strGroup_Path)
        end
    else
        {Since the start menu path is null, we know that the user chose not to create a
        start menu group (note in Inno Setup 4.18 this didn't yet work, but I'm sure it will in the future}
        Result := False;

     {Debug

    If DirExists(strGroup_Path) = True Then
        Msgbox('The group "' + ExpandConstant('group') + '" was found', mbInformation, mb_ok)
    Else
        Msgbox('The group "' + ExpandConstant('group') + '" doesn''t exist.', mbInformation, mb_ok); }
End;


{Returns the appropriate name of the .EXE being installed}
Function ExeName(Unused: string): string;
Begin

  If UsingWinNT() = True Then
	 Result := 'WinMergeU.exe'
  Else
    Result := 'WinMerge.exe';
End;

Function FixVersion(strInput: string): string;
{Returns a version with four segments A.B.C.D}
Var
  {Stores the number of periods found within the version string}
  intPeriods: integer;

  {Creates a counter}
  i: integer;

  {Generates the string to be returned to the user}
  strVersion: string;
Begin

  {Creates a copy of the input string before we tear it apart}
  strVersion := strInput;

  {Until strInput is empty do..}
  While Length(strInput) > 0 do
    Begin
      {if the first character of the input string is a period then}
      If Copy(strInput, 1, 1) = '.' Then

        {Incriment the number of periods found}
        intPeriods := intPeriods + 1;

      {Remove the first character from the Input string}
      strInput := Copy(strINput, 2, length(strINput));
    End;

  {For every period shy of 3 do..}
  For i := 1 to 3 - intperiods do

    {Add a '.0' to the version string}
    strVersion := strVersion + '.0';

  {Returns the Version string with the correct number of segments}
  Result := strVersion;

End;

Function RemoveLeadingZeros(strInput: string): string;
{Removes the leading zeros if any from a numeric string}
Begin

  {While the first character of the string is a zero}
  While Copy(strInput, 1, 1) = '0' Do
    begin

    {Removes one leading zero from the input string}
      strInput := Copy(strInput, 2, Length(strINput));
    end;

  {Returns the formatted string}
  Result := strInput;

End;


{Returns whether or not the version string detected is meets the version number requirement}
Function VersionAtLeast(strVersion_Installed: string; intMajor: integer; intMinor: integer; intRevision: integer; intBuild: integer): boolean;
Var

  {Stores the Major of the Version installed (X.0.0.0)}
  intMajor_Installed: Integer;

  {Stores the Minor of the Version installed (1.X.0.0)}
  intMinor_Installed: Integer;

  {Stores the Revision of the Version installed (1.0.X.0)}
  intRevision_Installed: Integer;

  {Stores the Revision of the Version installed (1.0.0.X)}
  intBuild_Installed: Integer;

  {Stores the last valid character of a particular segment (Major, Minor, Revision) of the Version string}
  intEnd_Pos: Integer;

begin
  {Debug
  Msgbox('The version installed is ' + strVersion_Installed + ' and the required version is ' + IntToStr(intMajor) + '.' + IntToStr(intMinor) + '.' + IntToStr(intRevision) + '.' + IntToStr(intBuild), mbINformation, mb_OK)
        }

  {Makes sure the version string contains four numberic segments 5.2 ---> 5.2.0.0}
  strVersion_Installed := FixVersion(strVersion_Installed);

  {If the version number is empty then quit the function}
  if strVersion_Installed = '' Then
    begin
      Result := False;

      {Stops analyzing the version installed and returns that the version installed was inadequate}
      exit;
    end;

  {Starts detecting the Major value of the Version Installed}

  {Sets the end position equal to one character before the first period in the version number}
  intEnd_Pos := Pos('.', strVersion_Installed) -1

  {Sets the major version equal to all character before the first period }
  intMajor_installed := StrToIntDef(RemoveLeadingZeros(Copy(strVersion_Installed, 1, intEnd_Pos)), 0);

  {Debug
  msgbox('The Major version installed is ' + IntToStr(intMajor_installed) + ' and the required Major is ' + IntToStr(intMajor) + '.', mbInformation, MB_OK)
        }

  {If the Major Version Installed is greater than the required value then...}
  if intMajor_Installed > intMajor Then
    begin
      {Returns that the version number was adequate, since it actually exceeded the requirement}
      Result := True;

        {Debug
        msgbox(IntToStr(intMajor_installed) + ' > ' +  IntToStr(intMajor), mbInformation, MB_OK)
        }

      {Stops analyzing the version number since we already know it met the requirement}
      exit;
    end;

  {If the Major version installed is less than the requirement then...}
  If intMajor_Installed < intMajor Then
    begin
      {Debug
       msgbox(IntToStr(intMajor_installed) + ' < ' +  IntToStr(intMajor), mbInformation, MB_OK)
       }

      Result := False;

      {Stops analyzing the version number since we already know it's inadequate and returns False (inadequate)}
      exit;
    end


  {Starts detecting the Minor version of the Version Installed}

  {Modifies strVersion_Installed removing the first period and everything prior to it (Removes the Major Version)}
  strVersion_Installed := Copy(strVersion_Installed, intEnd_Pos + 2, Length(strVersion_Installed));

  {Sets the end position equal to one character before the first period in the version number}
  intEnd_Pos := Pos('.', strVersion_Installed) -1

  {Sets the Minor version equal to all character before the first period }
	intMinor_installed := StrToIntDef(RemoveLeadingZeros(Copy(strVersion_Installed, 1, intEnd_Pos)), 0)

	{Debug
  msgbox('The Minor version installed is ' + IntToStr(intMinor_installed) + ' and the required Minor is ' + IntToStr(intMinor) + '.', mbInformation, MB_OK)
        }

	{If the Minor Version Installed is greater than the required value then...}
	If intMinor_Installed > intMinor Then
    begin
      {Returns that the version number was adequate}
      Result := True;

      {Stops further analyzation of the version number}
      exit
    end;

  {If the minor installed is less than what was required}
  If intMinor_Installed < intMinor Then
    Begin
      Result := False;

      {Returns that the version installed did not meet the required value and stops analyzing the version number}
      exit;
    end;


  {Starts Detecting the Revision of the Version Installed}

	{Modifies strVersion_Installed removing the first period and everything prior to it (Removes the Minor Version)}
	strVersion_Installed := Copy(strVersion_Installed, intEnd_Pos + 2, Length(strVersion_Installed));

	{Sets the last character of the Revision to last character before the first period}
	intEnd_Pos := Pos('.', strVersion_Installed) -1

	{Sets the Revision Installed equal to everything before the first period}
	intRevision_Installed := strToIntDef(RemoveLeadingZeros(Copy(strVersion_Installed, 1, intEnd_Pos)), 0);

	{Debug
  msgbox('The Revision version installed is ' + IntToStr(intRevision_installed) + ' and the required Revision is ' + IntToStr(intRevision) + '.', mbInformation, MB_OK)
        }

	{If the Revision Installed is greater than the required value then...}
  If intRevision_Installed > intRevision Then
    begin
      {Return that the version installed was adequate}
      Result := True;

      {Stops further analyzation of the version number}
      exit
    end;

  {If the revision installed did not meet the requirement then...}
  If intRevision_Installed < intRevision Then
    begin
      Result := False;

    {Return that the version number failed to meet the requirement and stops further analyzation of the version number}
      exit;
    end;

  {Start Detection the Build Installed}

	{Modifies strVersion_Installed removing the first period and everything prior to it (Removes the Revision) leaving behind only the build number}
	strVersion_Installed := Copy(strVersion_Installed, intEnd_Pos + 2, Length(strVersion_Installed));

	{Set the build installed = to what's left of the strVersion_Installed text}
	intBuild_installed := strToIntDef(RemoveLeadingZeros(strVersion_Installed), 0);

	{Debug
  msgbox('The Build version installed is ' + IntToStr(intBuild_installed) + ' and the required Build is ' + IntToStr(intBuild) + '.', mbInformation, MB_OK)
        }

	{If the build installed is greater than or equal to the requirement then...}
	if intBuild_installed >= intBuild Then

	 {Report that the version installed was adequate}
    Result := True
  else

    {Reports the inadequacy of the version installed and seases processing }
    Result := False;
end;

{Returns whether or not the version of particular file is at least equal to requested value}
Function FileVersionAtLeast(strFile_Path: string; intMajor: integer; intMinor: integer; intRevision: integer; intBuild: integer): boolean;
  Var
  {Stores the version of the file to be compared}
  strVersion: string;
Begin
  {Gets the version number of the specified file}
  GetVersionNumbersString(strFile_Path, strVersion)

  {File Version at least is the result of the VersionAtLeast Determination}
  Result := VersionAtLeast(strVersion, intMajor, intMinor, intRevision, intBuild);


  {Debug: If you'd like to debug with a messagebox then un rem this
	If Result = True then

	 Msgbox('The version of ' + strFile_path + ' required is "' + IntToStr(intMajor) + '.' + IntToStr(intMinor) + '.' + IntToStr(intRevision) + '.' + IntToStr(intBuild) + '". The version found was "'  + strVersion + '.  The version detected met the required value.', mbInformation, MB_OK)
	else
	 Msgbox('The version of ' + strFile_path + ' required is "' + IntToStr(intMajor) + '.' + IntToStr(intMinor) + '.' + IntToStr(intRevision) + '.' + IntToStr(intBuild) + '". The version found was "' + strVersion + '.  The version detected did not meet the required value.', mbInformation, MB_OK);
    }
end;

{Determines whether or not TortoiseCVS is installed}
Function TortoiseCVSInstalled(): boolean;
Begin
	{This absolutely must remain as \CustomIcons, because our application used to create some TortoiseCVS keys even if the application wasn't installed!}
    Result := RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\TortoiseCVS\CustomIcons');
End;

{Determines whether or not TortoiseSVN is installed}
Function TortoiseSVNInstalled(): boolean;
Begin
    Result := RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\TortoiseSVN');
End;

Function RelativeGroupPath(Unused: string): String;
Var
    strGroup: String;
Begin
    strGroup := ExpandConstant('{group}');
    StringChange(strGroup, ExpandConstant('{commonprograms}\'), '');
    Result := strGroup
End;

Function OldGroup(): string;
Begin
    {Stores where in \All Users\Programs\ our start menu used to be located}
     RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinMerge_is1', 'Inno Setup: Icon Group', Result)
End;

Procedure DeletePreviousStartMenu();
Var
        strOld: string;
        strNew: string;
        strMessage: string;
        strShortcut: string;
Begin
    {Detects the previous start menu group's path, if any}
    strOld := OldGroup();

    {Detects the current start menu group's path, if any (not creating a group is a valid option)}
    strNew := ExpandConstant('{group}');

    {removes the start menu portion of the path from the group path making it match the format of strOld}
    StringChange(strNew, ExpandConstant('{commonprograms}\'), '')

    {if the user does have a previous start menu location then..}
    If strOld <> '' THen
        Begin
            {If the current and previous start menu locations are different then...}
		    If Uppercase(strOld) <> UpperCase(strNew) Then
		        Begin
		            strMessage := ExpandConstant('{cm:DeletePreviousStartMenu}');
                    strMessage := Format(strMessage, [strOld, strNew]);

		              {Display a dialog asking the user if they'd like to delete the previous start menu group}
		            {If they'd like to delete the previous start menu group then...}
					If Msgbox(strMessage, mbConfirmation, mb_YesNo) = mrYes Then
						Begin
						    strOld := ExpandConstant('{commonprograms}\') + strOld;

                            {Removes each of the start menu icons to make the folder empty}
                            strShortcut := strOld + '\' + ExpandConstant('{cm:ReadMe}') + '.lnk';
			                DeleteFile(strShortcut)

			                strShortcut := strOld + '\Read Me.lnk';
			                DeleteFile(strShortcut)

			                strShortcut := strOld + '\' + ExpandConstant('{cm:UninstallProgram,WinMerge}') + '.lnk';
			                DeleteFile(strShortcut)

			                strShortcut := strOld + '\Uninstall WinMerge.lnk';
			                DeleteFile(strShortcut)

			                strShortcut := strOld + '\' + ExpandConstant('{cm:UsersGuide}') + '.lnk';
                            DeleteFile(strShortcut)

                            strShortcut := strOld + '\User''s Guide.lnk';
			                DeleteFile(strShortcut)

                            strShortcut := strOld + '\' + ExpandConstant('{cm:ProgramOnTheWeb,WinMerge}') + '.url';
			                DeleteFile(strShortcut)

			                strShortcut := strOld + '\Winmerge on the Web.lnk';
			                DeleteFile(strShortcut)

			                strShortcut := strOld + '\Winmerge on the Web.url';
			                DeleteFile(strShortcut)

			                strShortcut := strOld + '\WinMerge.lnk';
			                DeleteFile(strShortcut)

			                {Deletes the empty start menu directory (This has to already be empty in order for this to work, hence the
			                file deletions above)}
			                RemoveDir(strOld)
			            end;
		              {end; }
		        end;
        end;
End;

{This event procedure is queed each time the user changes pages within the installer}
Procedure CurPageChanged(CurPage: integer);
Begin
    {if the installer reaches the file copy page then...}
    If CurPage = wpInstalling Then
            {Delete the previous start menu group if the location has changed since the last install}
            DeletePreviousStartMenu;
End;

// Checks if context menu is already enabled for shell extension
// If so, we won't overwrite its existing value in [Registry] section
Function ShellMenuEnabled(): Boolean;
Begin
  If RegValueExists(HKCU, 'Software\Thingamahoochie\WinMerge', 'ContextMenuEnabled') Then
    result := True
  Else
    result := False;
End;

{Replace one occurrence of OldStr in Str with NewStr}
Function ReplaceSubString(Src: string; OldStr: string; NewStr: string) : string;
Var
    OldStrStartAt: Integer;

Begin
    OldStrStartAt := Pos(OldStr, Src);
    if OldStrStartAt > 0 then
    begin
        {Remove old string}
        Delete(Src, OldStrStartAt, Length(OldStr));
        {Insert new string}
        Insert(NewStr, Src, OldStrStartAt);
    end;
    Result := Src;
End;

{Returns WinMerge installed exeutable file name}
Function WinMergeExeName(): string;
Var
	Unused: String;

Begin
    Result := ExpandConstant('{app}\') + ExeName(Unused);
End;

{Returns ClearCase external tools configuration file name}
Function ClearCaseMapFile(): string;
Begin
    if not RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Rational Software\', 'RSINSTALLDIR', Result) then
    begin
        Result := {pf} + '\Rational\';
    end;
    Result := Result + 'ClearCase\lib\mgrs\map';
End;

{Determines whether or not Rational ClearCase is installed}
Function ClearCaseInstalled(): boolean;
Begin
    Result := FileExists(ClearCaseMapFile());
End;

{Intergrate WinMerge as ClearCase external diff tool}
Procedure IntegrateClearCase(OldExe: String; NewExe: String);
Var
    MapFile: TStringList;
    FileName: String;
    I: Integer;

Begin
    FileName := ClearCaseMapFile();
    MapFile := TStringList.Create();
    {Read the entire map file to a string list}
    MapFile.LoadFromFile(FileName);
    if MapFile.Count > 0 then
    begin
        for I := 0 to MapFile.Count do
        begin
            {Search for the 'text_file_delta xcompare ...' line}
			if (MapFile.Strings[I][1] <> ';') and (Pos('text_file_delta', MapFile.Strings[I]) > 0) and (Pos('xcompare', MapFile.Strings[I]) > 0) then
			begin
				{Replace old executable name with a new executable name}
				MapFile.Strings[I] := ReplaceSubString(MapFile.Strings[I], OldExe, NewExe);
			    break;
			end;
		end;
		{ Save the modified file. }
		MapFile.SaveToFile(FileName);
	end;
End;

procedure CurStepChanged(CurStep: TSetupStep);
Begin
    if CurStep = ssPostInstall then
    begin
        if IsTaskSelected('ClearCase') then
        begin
            IntegrateClearCase('..\..\bin\cleardiffmrg.exe', WinMergeExeName());
        end;
    end;
End;

Procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
Begin
    if CurUninstallStep = usPostUninstall then
    begin
      if ClearCaseInstalled() then
        IntegrateClearCase(WinMergeExeName(), '..\..\bin\cleardiffmrg.exe');
    end;
End;
