html header:<meta charset="utf-8"/>
            <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate"/>
            <meta http-equiv="Pragma" content="no-cache"/>
            <meta http-equiv="Expires" content="0"/>
            <link type="text/css" rel="stylesheet" href="file:///O:/MyProfile/lua/lua/html/css/normalize.css"/>
            <link type="text/css" rel="stylesheet" href="file:///O:/MyProfile/lua/lua/html/css/MutliMarkdown2.css"/>
	        <script src="file:///O:/MyProfile/lua/lua/html/js/highlight.min.js"></script>
	        <script>hljs.initHighlightingOnLoad();</script>
html footer:<script>document.body.contentEditable="true";</script>





<title>Standard Keys</title>
# Universal Keyboard Shortcuts (UKS)
## Introduction

Instead of learning and re-learning keyboard shortcuts I am "_on an mission_" to force all my editors to respond to the same keystrokes.

This may sound a little limiting, and there are some actions I cannot achieve in some software. However, using some tricks most things are possible:

* Use Autohotkey to translate keyboard/mouse input for each target program.
* Use Reshacker to change PE executable keyboard accelerators.
* Use the scripting capabilities of each target program.
* Call external tools for some advanced actions (fzf, bat.exe, findstr, winGREP)

## Actions and Workflow

I don't hate the mouse, but lots of clicking makes my pisiform bone hurt!

There are several situations where a keyboard interface can avoid many clicks:

* Word focused actions
* Moving the cursor (shift to select)
* Move and act
* Searching / Navigating
* Jumping to next and previous
* Command alternatives to dialog boxes
* Activating options
* Selecting from a long list

In my trials of many editors, there are some editing actions I find so useful I have adopted them.

## Moving the cursor (shift to select)

| Actions______________ | Keys_________________ |
| :-------------------- | :-------------------- |
| Move Word Left        | Ctrl_Left             |
| Move Word Right       | Ctrl_Right            |
| Jump Brackets         | Ctrl_J                |
| BOL                   | Ctrl_B, Home          |
| EOL                   | Ctrl_E, End           |
| Up Line               | Up                    |
| Down Line             | Down                  |
| Up Full Page          | PgUp                  |
| Down Full Page        | PgDn                  |
| BOF                   | Ctrl_Home             |
| EOF                   | Ctrl_End              |

## Move and act

| Actions______________ | Keys_________________ |
| :-------------------- | :-----------------    |
| Select All            | Ctrl_A                |
| Select Word           | Ctrl_Space            |
| Select Word Backwards | Ctrl_Shift_Space      |
| Select Line           | Ctrl_L                |
| Select Line Backwards | Ctrl_Shift_L          |
| Select Inside Brackets| Ctrl_Shift_J          |
| Select All Occurrences| Ctrl_Shift_A          |
| Delete Word Left      | Ctrl_Bksp             |
| Delete Word Right     | Ctrl_Del              |
| Delete to EOL         | Ctrl_K                |
| Delete to BOL         | Ctrl_Shift_K          |
| Delete Line(s)        | Ctrl_Y                |
| Move Line(s) Up       | Ctrl_Shift_Up         |
| Move Line(s) Down     | Ctrl_Shift_Down       |
| Swap Anchor<>Caret    | Ctrl_Shift_T          |
| Duplicate Line(s)     | Ctrl_D                |
| Indent Line(s)        | Ctrl_Shift_>          |
| Outdent Line(s)       | Ctrl_Shift_<          |
| Comment               | Ctrl_Q                |
| UnComment             | Ctrl_Shift_Q          |
| Prefix                | Ctrl_[                |
| Postfix               | Ctrl_]                |
| Undo                  | Ctrl_Z                |
| Undoundo              | Ctrl_Shift_Z          |

## Clipboard Actions

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Cut                   | Ctrl_X                |
| CutAppend             | Ctrl_Shift_X          |
| Copy                  | Ctrl_C                |
| CopyAppend            | Ctrl_Shift_C          |
| Paste                 | Ctrl_V                |
| PastePlain            | Ctrl_Shift_V          |

## Searching / Navigating

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Find Forward          | Ctrl_F, Alt_/         |
| Find Regex            | Ctrl_/                |
| Find Word             | Ctrl_*                |
| Mark all              | Ctrl_M                |
| UnMark all            | Ctrl_U                |
| SelSearch             | Ctrl_Shift_F          |
| Find in files FZF     | Ctrl_Alt_F            |
| Goto Line             | Ctrl_G                |
| Goto with Filter FZF  | Ctrl_Shift_G          |
| Goto Stack FZF        | Ctrl_Alt_G            |
| Find TAGS             | Ctrl_T                |
| Make TAGS             | Ctrl_Shift_T          |
| Window Peek Up        | Ctrl_Shift_U          |
| Window Peek Down      | Ctrl_Shift_D          |

## Spliting Screens - TODO

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Current Split Below   | F8                    |
| Current Split Right   | F7                    |
| New Split Below       | Alt_F8                |
| New Split Right       | Alt_F7                |
| Move to Split Down    | Alt_Down              |
| Move to split Up      | Alt_Up                |
| Move to split Left    | Alt_Left              |
| Move to split Right   | Alt_Right             |

## Jumping to next and previous

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| List Buffers          | Alt_W                 |
| Next File             | Ctrl_Tab              |
| Prev File             | Ctrl_Shift_Tab        |
| Next Find             | Ctrl_Down             |
| Prev Find             | Ctrl_Up               |

## Command alternatives to dialog boxes

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Open File DLG         | Ctrl_O                |
| Open File FZF         | Ctrl_Alt_O            |
| Replace               | Ctrl_H                |
| Replace All           | Ctrl_Shift_H                |
| Insert Completion     | Alt_I                 |
| Edit  Completion      | Alt_Shift_I           |
| Insert File DLG       | Ctrl_I                |
| Insert File FZF       | Ctrl_Alt_I            |
| Insert Snippet FZF    | Ctrl_Alt_S            |
| Insert Template FZF   | Ctrl_Alt_T            |

## Activating menu options

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| File Open Selection   | Ctrl_Shift_O          |
| File New              | Ctrl_N                |
| File Save             | Ctrl_S                |
| File Save As          | Ctrl_Shift_S          |
| File Revert           | Ctrl_R                |
| File Print            | Ctrl_P                |
| File Close            | Ctrl_W                |
| File Backup           | Ctrl_Alt_B            |
| File Versions         | Ctrl_Alt_V            |
| File Diff             | Ctrl_Alt_D            |
| File Run              | Ctrl_Alt_R            |
| Toggle WordWrap       | Ctrl_Shift_W          |
| Toggle Fold Section   | Alt_Z                 |
| Toggle Fold Children  | Alt_Shift_Z           |
| Toggle Fold All       | Ctrl_Alt_Z            |
| Tools Shell Cmd       | Ctrl_#                |
| Tools Shell Pipe      | Ctrl_Shift_#          |
| Tools COMSPEC         | Ctrl_Alt_#            |

## Some special actions

| Actions______________ | Keys_________________ |
| :---                  | :---                  |
| Tools Command Line    | Ctrl_:                |
| Tools FZF command     | F9                    |
| Tools Repeat Last     | Ctrl_.                |
| Spell Check Dialog    | Ctrl_F7               |

##  Actions without shortcuts

These functions are less often used (by me), clash with more popular actions, or are only possible with specific editors:

| Actions______________ |
| :---                  |
| Exit                  |
| Abandon               |
| ToggleCase            |
| JoinAll               |
| ShowWhiteSpace        |
| ExecuteSelection      |

## Summary

| Keys_________________ | Actions______________ |
| :-------------------- | :-------------------- |
| ^ A                   | SelectAll             |
| ^ B                   | Home                  |
| ^ C                   | Copy                  |
| ^ D                   | Duplicate             |
| ^ E                   | End                   |
| ^ F                   | Find                  |
| ^ G                   | Goto                  |
| ^ H                   | Replace               |
| ^ I                   | Insertor              |
| ^ J                   | Jump Brace            |
| ^ K                   | Kill to EOL           |
| ^ L                   | SelectLine            |
| ^ M                   | MarkAll               |
| ^ N                   | New                   |
| ^ O                   | Open                  |
| ^ P                   | Print                 |
| ^ Q                   | Comment               |
| ^ R                   | Revert                |
| ^ S                   | Save                  |
| ^ T                   | FindTAGS              |
| ^ U                   | UnmarkAll             |
| ^ V                   | Paste                 |
| ^ W                   | Close                 |
| ^ X                   | Cut                   |
| ^ Y                   | Yank                  |
| ^ Z                   | Undo                  |
| ^+A                   | AllOccurances         |
| ^+B                   | SelectToBOL           |
| ^+C                   | CopyAppend            |
| ^+D                   |                       |
| ^+E                   | SelectToEOL           |
| ^+F                   | FindRegex             |
| ^+G                   | FilterGoto            |
| ^+H                   | ReplaceAll            |
| ^+I                   | EditInsertions        |
| ^+J                   | SelectBrace           |
| ^+K                   | Kill to BOL           |
| ^+L                   |                       |
| ^+M                   | Indent                |
| ^+N                   | Outdent               |
| ^+O                   | OpenSelection         |
| ^+P                   |                       |
| ^+Q                   | Uncomment             |
| ^+R                   |                       |
| ^+S                   | FileSaveAs            |
| ^+T                   | SwapAnchor            |
| ^+U                   | UnselectLine          |
| ^+V                   | PastePlainText        |
| ^+W                   | ToggleWordWrap        |
| ^+X                   | CutAppend             |
| ^+Y                   |                       |
| ^+Z                   | UndoUndo              |
| ^!A                   |                       |
| ^!B                   | MakeBackup            |
| ^!C                   |                       |
| ^!D                   |                       |
| ^!E                   |                       |
| ^!F                   |                       |
| ^!G                   |                       |
| ^!H                   |                       |
| ^!I                   | InsertFileFzF         |
| ^!J                   |                       |
| ^!K                   |                       |
| ^!L                   |                       |
| ^!M                   |                       |
| ^!N                   |                       |
| ^!O                   | OpenFzF               |
| ^!P                   |                       |
| ^!Q                   |                       |
| ^!R                   | RunFile               |
| ^!S                   | InsertSnippetFzf      |
| ^!T                   | InsertTemplateFzf     |
| ^!U                   |                       |
| ^!V                   | OpenBackupFzf         |
| ^!W                   |                       |
| ^!X                   |                       |
| ^!Y                   |                       |
| ^!Z                   |                       |
| ^\                    |                       |
| ^-                    |                       |
| ^=                    | LuaEval               |
| ^[                    | MulticursorPrefix     |
| ^]                    | MulticursorPostfix    |
| ^;                    |                       |
| ^'                    |                       |
| ^#                    |                       |
| ^,                    |                       |
| ^.                    |                       |
| ^/                    | FindLiteral           |
| ^+\                   |                       |
| ^+-                   |                       |
| ^+=                   | LuaCommand            |
| ^+[                   |                       |
| ^+]                   |                       |
| ^+;                   |                       |
| ^+'                   |                       |
| ^+#                   | TextFilter            |
| ^+,                   |                       |
| ^+.                   |                       |
| ^+/                   |                       |
| ^!-                   |                       |
| ^!=                   |                       |
| ^![                   |                       |
| ^!]                   |                       |
| ^!;                   |                       |
| ^!'                   |                       |
| ^!#                   |                       |
| ^!,                   |                       |
| ^!.                   |                       |
| ^!/                   |                       |
| {Esc}                 |                       |
| {Tab}                 | Indent                |
| {Space}               |                       |
| {Delete}              |                       |
| {BackSp}              |                       |
| {Enter}               |                       |
| {Tab}                 | Indent                |
| ^{Esc}                | StartMenu             |
| ^{Tab}                | SwitchWindow          |
| ^{Space}              | SelectWord            |
| ^+{Space}             | SelectWordBack        |
| ^{Delete}             | DeleteWordRight       |
| ^{BackSp}             | DeleteWordLeft        |
| ^{Enter}              | CompleteWord          |
| ^*                    | WordSearch            |
| !{Esc}                | SwitchApp             |
| !{Tab}                | SwitchApp             |
| !{Space}              | ControlMenu           |
| !{Delete}             |                       |
| !{BackSp}             |                       |
| !{Enter}              | FullScreen            |
| ^!{Esc}               |                       |
| ^!{Tab}               |                       |
| ^!{Space}             |                       |
| ^!{Delete}            |                       |
| ^!{BackSp}            |                       |
| ^!{Enter}             |                       |
| F1                    | Built-in Help         |
| + F1                  | Load keysheet         |
| ^ F1                  | Load helpsheet        |
| # F1                  | Run help app          |
| ^ F7                  | Spellcheck            |








