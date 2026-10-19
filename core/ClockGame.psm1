
function New-Game {
    param(
        [int]$max,
        [int]$min,
        [int]$try
    )
    [PSCustomObject]@{
        secret = Get-Random -Minimum $min -Maximum ($max + 1)
        min = $min
        max = $max
        attempts = 0
        MaxTries = $try
    }
}

function Save-Game {
    param(
        $game,
        [ValidateSet("Win", "Lose")]
        [string]$result,
        [string]$filePath = "$PSScriptRoot/../data/scores.csv"
    )

    if ($result -eq "Win") {
        $score = $game.MaxTries + 50 * ($game.MaxTries - $game.attempts)
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
    }
    $calculScore | Export-Csv $filePath -Append -NoTypeInformation -Encoding UTF8
    Write-Host "Game saved to $filePath"
}

function Submit-Guess {
    param(
        $game,
        [int]$guess
    )
    $game.attempts++
    if ($guess -eq $game.secret) { return "Win" }
    if ($game.attempts -ge $game.MaxTries) { return "Lose" }
    if ($guess -lt $game.secret) { return "Too Low" }
    else { return "Too High" }

    
}

function Start-ClockGame {
    param(
        [string]$username,
        [string]$difficulty
    )

    $difficultyData = Import-Csv "$PSScriptRoot/../data/difficulties.csv" | 
        Where-Object Name -eq $difficulty
    if (-not $difficultyData) { Throw "Difficulty not found" }

    $game = New-Game -max $difficultyData.max -min $difficultyData.min -try $difficultyData.tries
    $game | Add-Member -MemberType NoteProperty -Name "Username" -Value $username
    return $game
}