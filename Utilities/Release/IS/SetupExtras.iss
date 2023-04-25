; Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
; file Copyright.txt or https://cmake.org/licensing for details.

[Registry]
Root: HKLM; Subkey: "Software\Kitware"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Kitware\CMake"; ValueType: string; ValueName: "InstallDir"; ValueData: "{app}\"; Flags: uninsdeletekey

; The following lines change the system PATH
Root: HKCU; Subkey: "Environment"; ValueType: string; ValueName: "Path"; ValueData: "{olddata};{app}\bin"; Check: CMakeNeedsAddPathCurrentUser('{app}\bin'); Tasks: pathcurrentuser
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}\bin"; Check: CMakeNeedsAddPathAllUsers('{app}\bin'); Tasks: pathallusers

[CustomMessages]
ChangeEnvironment=Change environment variables:
DontAddToPath=Do not add CMake to the system PATH
AddToAllUsersPath=Add CMake to the system PATH for all users
AddToCurrentUsersPath=Add CMake to the system PATH for current user

[Tasks]
Name: "nopath"; Description: "{cm:DontAddToPath}"; GroupDescription: "{cm:ChangeEnvironment}"; Flags: exclusive
Name: "pathallusers"; Description: "{cm:AddToAllUsersPath}"; GroupDescription: "{cm:ChangeEnvironment}"; Flags: exclusive unchecked checkedonce
Name: "pathcurrentuser"; Description: "{cm:AddToCurrentUsersPath}"; GroupDescription: "{cm:ChangeEnvironment}"; Flags: exclusive unchecked checkedonce

[Code]
function CMakeNeedsAddPathCurrentUser(Param: String): Boolean;
var
  OrigPath: String;
begin
  if not RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', OrigPath) then
  begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + ExpandConstant(Param) + ';', ';' + OrigPath + ';') = 0;
end;

function CMakeNeedsAddPathAllUsers(Param: String): Boolean;
var
  OrigPath: String;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath) then
  begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + ExpandConstant(Param) + ';', ';' + OrigPath + ';') = 0;
end;
