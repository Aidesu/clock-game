$savingPath = "$PSScriptRoot\..\data\scores.csv"
function New-Game {
    param(
        [string]$difficulty,
        [int]$max,
        [int]$min,
        [int]$try
    )
    [PSCustomObject]@{
        secret = Get-Random -Minimum $min -Maximum ($max + 1)
        min = $min
        max = $max
        Difficulty = $difficulty
        attempts = 0
        MaxTries = $try
    }
}

function Save-Game {
    param(
        $game,
        [ValidateSet("Win", "Lose")]
        [string]$result,
        [string]$filePath = $savingPath
    )

    if ($result -eq "Win") {
        $score = $game.max + 50 * ($game.MaxTries - $game.attempts)
    } else {
        $score = 0
    }

    $calculScore = [PSCustomObject]@{
        Username = $game.Username
        Result   = $result
        Secret   = $game.secret
        Attempts = $game.attempts
        MaxTries = $game.MaxTries
        Score    = $score
        Difficulty = $game.Difficulty
        Date     = Get-Date
    }
    $calculScore | Export-Csv $filePath -Append -NoTypeInformation -Encoding UTF8
    Write-Host "Game saved to $filePath"
}
function Read-AllScores {
    Import-Csv $savingPath | Sort-Object {[int]$_.Score} -Descending | Format-Table -Autosize
}
function Read-Scores ($username) {
    if (Import-Csv $savingPath | Where-Object Username -eq $username) {
        try {
            Import-Csv $savingPath | Where-Object Username -eq $username | Sort-Object {[int]$_.Score} -Descending | Format-Table -Autosize
        }
        catch {
            return "Error"
        }
    } else {
        return "User not found!"
    }
}

function Submit-Guess {
    param(
        $game,
        [int]$guess
    )
    if($guess -lt $game.min -or $guess -gt $game.max) {
        return "Outside range"
    } else {
        $game.attempts++
        if ($guess -eq $game.secret) { return "Win" }
        if ($game.attempts -ge $game.MaxTries) { return "Lose" }
        if ($guess -lt $game.secret) { return "Too Low" }
        else { return "Too High" }
    }
    
}

function Start-ClockGame {
    param(
        [string]$username,
        [string]$difficulty
    )

    $difficultyData = Import-Csv "$PSScriptRoot\..\data\difficulties.csv" | 
        Where-Object Name -eq $difficulty
    if (-not $difficultyData) { Throw "Difficulty not found" }

    $game = New-Game -max $difficultyData.max -min $difficultyData.min -try $difficultyData.tries -Difficulty $difficulty
    $game | Add-Member -MemberType NoteProperty -Name "Username" -Value $username
    return $game
}

function Get-Rules {
    $rules = "`nLorem ipsum, dolor sit amet consectetur adipisicing elit.`nAb voluptate corporis temporibus molestiae.`nPorro delectus reiciendis, debitis incidunt tempora quidem quibusdam `nnesciunt exercitationem, nisi amet eligendi. `nExplicabo quaerat autem illo!"
    return $rules
}