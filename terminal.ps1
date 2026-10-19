Import-Module "$PSScriptRoot/core/Account.psm1" -Force
Import-Module "$PSScriptRoot/core/ClockGame.psm1" -Force

[string]$script:currAccount = $null
$game = $null
function Start-Game {
    Write-Host "Starting the game..."
    # Game logic goes here
}

function Show-Difficulty {
    $difficulties = Import-Csv "$PSScriptRoot/data/difficulties.csv"   # -Delimiter ';' si besoin

    while ($true) {
        Write-Host "Select a difficulty level:"
        foreach ($d in $difficulties) {
            Write-Host "[$($d.Name)] - Min: $($d.min), Max: $($d.max), Tries: $($d.tries)"
        }
        $selected = (Read-Host "Enter the difficulty name").Trim('[', ']', ' ')
        $difficultyData = $difficulties | Where-Object Name -eq $selected
        if ($difficultyData) { break }
        Write-Host "Difficulty not found." -ForegroundColor Red
    }
    Start-GameWithDifficulty -username $script:currAccount -difficulty $difficultyData.Name
}

function Start-GameWithDifficulty {
    param(
        [string]$username,
        [string]$difficulty
    )

    $game = Start-ClockGame -username $username -difficulty $difficulty
    Write-Host "Game started for user $username with difficulty $difficulty."
    while ($game.attempts -lt $game.MaxTries) {
        $guess = Read-Host "Enter your guess (between $($game.min) and $($game.max))"
        if (-not [int]::TryParse($guess, [ref]$null)) {
            Write-Host "Please enter a valid integer." -ForegroundColor Red
            continue
        }
        $result = Submit-Guess -game $game -guess $guess
        Write-Host $result
        if ($result -eq "Win" -or $result -eq "Lose") {
            if ($result -eq "Lose") {
                Write-Host "The number was $($game.secret)."
            }
            Save-Game -game $game -result $result
            break
        }
    }
}
function Show-LoginRegister {
    Write-Host "[1] Login, [2] Register"
    $choice = Read-Host "Select an option"

    switch ($choice) {
        1 {
            if (-not $script:currAccount) {
                $username = Read-Host "Enter your username"
                $password = Read-Host "Enter your password" -AsSecureString
                try {
                    $script:currAccount = Connect-User -username $username -password $password
                    Write-Host "Login successful! Welcome, $($script:currAccount)."
                    Show-Difficulty
                } catch {
                    Write-Host $_.Exception.Message -ForegroundColor Red
                }
            } else {
                Write-Host "You are already logged in as $($script:currAccount)."
                Show-Difficulty
            }
        }
        2 {
            $username = Read-Host "Enter a new username"
            $password = Read-Host "Enter a new password" -AsSecureString
            try {
                New-User -username $username -password $password | Out-Null
                Write-Host "Registration successful! You can now log in."
            } catch {
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
        }
        Default {
            Write-Host "Invalid option. Please select a valid option."
        }
    }
}

Clear-Host
Write-Host "Welcome to ClockGame"

:mainLoop while ($true) {
    Write-Host "[1] Play, [2] Scoreboard, [3] Rules, [4] Exit"
    $choice = Read-Host "Select an option"

    switch ($choice) {
        1 { Show-LoginRegister }
        2 { Write-Host "Scoreboard feature is not implemented yet." }
        3 { Write-Host "Rules feature is not implemented yet." }
        4 {
            Write-Host "Exiting the game. Goodbye!"
            break mainLoop
        }
        Default { Write-Host "Invalid option. Please select a valid option." }
    }
}