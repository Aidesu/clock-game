$script:userFile = "$PSScriptRoot/../data/users.csv"
$script:user = $null
 
function usernameFormalizer([string]$username) {
    $username = $username.Replace(" ", "")
    $textInfo = (Get-Culture).TextInfo
    return $textInfo.ToTitleCase($username.ToLower())
}
 
function usernameChecker([string]$username) {
    if ($username.Length -lt 3)  { throw "Username minimum characters 3" }
    if ($username.Length -gt 20) { throw "Username maximum characters 20" }
 
    if (Test-Path $script:userFile) {
        $users = Import-Csv $script:userFile
        if ($users.Username -contains $username) { throw "Username already exists" }
    }
}
 
function passwordChecker {
    param([securestring]$password)
    if ($password.Length -lt 3) { throw "Password minimum characters 3" }
}
 
function ConvertPlainText([securestring]$secure) {
    [pscredential]::new("x", $secure).GetNetworkCredential().Password
}
 
function Connect-User {
    param (
        [string]$username,
        [securestring]$password
    )
 
    $username = usernameFormalizer $username
 
    if (-not (Test-Path $script:userFile)) { throw "Unknown user" }
 
    $user = Import-Csv $script:userFile |
            Where-Object Username -eq $username |
            Select-Object -First 1
    if (-not $user) { throw "Unknown user" }
 
    $stored = ConvertPlainText ($user.Password | ConvertTo-SecureString)
    if ($stored -cne (ConvertPlainText $password)) { throw "Wrong password" }
 
    $script:user = $user.Username
    return $user.Username
}
 
function New-User {
    param (
        [string]$username,
        [securestring]$password
    )
 
    $usernameFormalized = usernameFormalizer $username
 
    usernameChecker -username $usernameFormalized
    passwordChecker -password $password
 
    New-Item -ItemType Directory -Force -Path (Split-Path $script:userFile) | Out-Null
 
    [PSCustomObject]@{
        Username = $usernameFormalized
        Password = $password | ConvertFrom-SecureString
    } | Export-Csv $script:userFile -Append -NoTypeInformation -Encoding UTF8
 
    return "User $usernameFormalized created"
}
