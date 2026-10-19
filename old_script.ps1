#* ################################################## STEP 1 ###################################################
#* Generer chiffre aleatoire
#* Demande utilisateur un chiffre
#* Commparaison du chiffre donner par l'utilisatur 
#* jusqu'a ce que la bonne valeurs soit trouver
#* #############################################################################################################

#* ################################################## STEP 2 ###################################################
#* Afficher un menu au demarage du jeu ([1]NewGame, [2]Top score board, [3]User score, [4]Rules, Quit)
#* Demander le nickname du joueur au lancement de la partie 
#*  Attention nickname doit etre insensible a la casse (Sauvegarde des data, no space, between 3 - 20 char length, Nickname required)
#* 3 Niveau de difficulter (Facile {1 - 50 try: 10}, Medium {1 - 100 try: 7}, Hardcore {1 - 500 try: 8})
#* Deroulement de la partie...
#! Apres une partie choix (Restart, Return to main menu)
#* Calcul du score exemple (\[ Score = Base + 50 \times (T_{max}-T_{utilisées}) \])
#*  Sauvegarder les data dans un fichier CSV nommer scores.csv a utiliser (Import-Csv and Export-Csv)
#Todo Le score board doit permettre de consulter 2 types de classements 1 global par score decroissant et n\
#Todo 1 par joueur contenent (5 best results, Score moyen, best score, Win rate, Nombre de win/lose, Total game start) no user ? say no user
#Todo Aucune erreur attendue durant le gameplay
#Todo scores.csv doit etre stoquer dans un fichier data a coter du script
#* "############################################################################################################

#? ###########################################################################################
#? ##############################        Variables         ###################################
#? ###########################################################################################
[boolean]$isRunning = $true
[boolean]$script:game = $false
[int]$script:try = 0
[int]$script:maxTry = 0
[int]$script:maxNumber = 0
[int]$script:currTry = 0
[string]$welcome = "###############################################`n##        Welcome to the Clock Game!         ##`n###############################################"
[string]$rulesStr = "`nLorem ipsum dolor sit amet, consectetur adipiscing elit. `n`nSed do eiusmod tempor incididunt ut labore et dolore `n`nmagna aliqua. Ut enim ad minim veniam, quis nostrud `n`nexercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. `n`nDuis aute irure dolor in reprehenderit in voluptate `n`nvelit esse cillum dolore eu fugiat nulla pariatur. `n`nExcepteur sint occaecat cupidatat non proident, `nsunt in culpa qui officia deserunt mollit anim id est laborum.`n"
[string]$mainMenuStr = "################## Main Menu ##################`n[0] New Game`n[1] Score Board`n[2] User Score`n[3] Rules`n[4] Quit"
[string]$endMenuStr = "[1] Restart`n[2] Back to Main Menu"
[string]$exitStr = "###############################################`n##        Do you really want to quit ?       ##`n###############################################"
[string]$levelStr = "###############################################`n##              Level Selector               ##`n###############################################"
[string]$UiLine = "#######################################################################"
[string]$csvPath = "./data/scores.csv"
[string]$nickname = ""
[string]$currDiff = ""
# $script:notes = @("SS", "S", "A", "B", "C", "D")

#? ###########################################################################################
#? ################################        Class         #####################################
#? ###########################################################################################
# function New-User {
#     param (
#         [string]$username,
#         [datetime]$date,
#         [string]$difficulty,
#         [string]$result,
#         [int]$try,
#         [int]$score,
#         [int]$secret
#     )

#     $user = @{
#         username = $username
#         date = $date
#         difficulty = $difficulty
#         result = $result
#         try = $try
#         score = $score
#         secret = $secret
#     }

#     return New-Object PSObject -property $user
# }


#? ###########################################################################################
#? ###############################        Banner         #####################################
#? ###########################################################################################
function gameBanner() {
    Clear-Host
    $welcome | Write-Host -ForegroundColor Magenta
}

function userBanner($name) {
    Clear-Host
    Write-Host "###############################################" -ForegroundColor Blue
    Write-Host "PowerShell?, Let's go !" $name -ForegroundColor Blue
    Write-Host "###############################################" -ForegroundColor Blue
}

#? ###########################################################################################
#? #############################        Main Menu         ####################################
#? ###########################################################################################
function mainMenu(){
    gameBanner
    $mainMenuStr | Write-Host -ForegroundColor DarkGreen
    
    
    try {
        [int]$mainMenuAction = Read-Host "Enter your action"

    switch ($mainMenuAction) {
        1 {  }
        2 { getScoreboard }
        3 { rulesMenu }
        4 { exitGame }
        0 { levelMenu }
        Default {}
    }
    } catch {
        Write-Host "Error"
    }

}

#? ###########################################################################################
#? #############################        Level Menu         ###################################
#? ###########################################################################################
function levelMenu () {
    Clear-Host
    $levelStr | Write-Host -ForegroundColor Green
    Write-Host "[1] Easy" -ForegroundColor DarkGreen
    Write-Host "[2] Medium" -ForegroundColor DarkBlue
    Write-Host "[3] Hard" -ForegroundColor DarkRed
    $levelInput = Read-Host "Enter your action"
    levelSelector($levelInput)
}

function levelSelector($inputLevel) {
    switch ($inputLevel) {
        1 { game 50 10 "easy"}
        2 { game 100 7 "medium"}
        3 { game 500 8 "hard"}
        Default {}
    }
}


#? ###########################################################################################
#? ################################        Rules         #####################################
#? ###########################################################################################
function rulesMenu() {
    gameBanner
    Write-Host "#################### Rules ####################" -ForegroundColor Yellow
    $rulesStr | Write-Host -ForegroundColor Green
    $rulesAction = Read-Host "Press any key return to main menu"
    if ($rulesAction) {
        mainMenu
    }
}

function gameStart() {
    Clear-Host
    $script:game = $true
    
}

#? ###########################################################################################
#? ################################        Exit         ######################################
#? ###########################################################################################
function bye() {
    Write-Host "See you soon!" -ForegroundColor Magenta
    exit 1
} 

function exitGame() {

    Clear-Host
        $exitStr | Write-Host -ForegroundColor Red
        Write-Host "[1] Back to main menu" -ForegroundColor Green
        Write-Host "[2] Let me leave" -ForegroundColor DarkRed
        $action = Read-Host "Enter your action"

    switch ($action) {
        1 { mainMenu }
        2 { bye }
    }
}

#? ###########################################################################################
#? #############################        Formalizer         ###################################
#? ###########################################################################################
function textFormalizer($text) {
    $text = $text.replace(' ', '')
    $textInfo = (Get-Culture).TextInfo
    $text = $textInfo.ToTitleCase($text.ToLower())
    return $text
}

#? ###########################################################################################
#? ###########################        OLD note calculator         ############################
#? ###########################################################################################
# function calculNote([float]$currNote) {
#     #* Write-Host $currNote
#         switch ($currNote) {
#             {$_ -ge 85} { $note = $script:notes[0] }
#             {$_ -ge 70} { $note = $script:notes[1] }
#             {$_ -ge 50} { $note = $script:notes[2] }
#             {$_ -ge 40} { $note = $script:notes[3] }
#             {$_ -ge 20} { $note = $script:notes[4] }
#             {$_ -lt 20} { $note = $script:notes[5] }
#             Default { $note = "test"}
#         }
#     return $note
# }

#? ###########################################################################################
#? ##############################        Gameplay        #####################################
#? ###########################################################################################
function enterNmb ($numberInput, $nmb) {
    userBanner $nickname
    $script:currTry ++
    $script:try --
    
    if ($numberInput -lt $nmb){
        Write-Host "Try:" $script:try "Le chiffre est plus grand" -ForegroundColor Red
    }  elseif ($numberInput -gt $nmb) {
        Write-Host "Try:" $script:try "Le chiffre est plus petit"  -ForegroundColor Yellow
    } elseif ($numberInput -eq $nmb) {
        [float]$finalScore = 100/$script:try
        endGame $finalScore $nmb "W"
    }

    if ($script:try -eq 0) {
        endGame $finalScore $nmb "L"
    }
}

#? ###########################################################################################
#? #############################        Game core         ####################################
#? ###########################################################################################

function endGameChoice($nmb, $diff) {
    $endMenuStr | Write-Host -ForegroundColor Green
    $inputEnd = Read-Host "Enter your action"
    switch ($inputEnd) {
        1 { game $nmb $script:maxTry $diff}
        2 { mainMenu }
    Default {  }
    }
}

function endGame($score, $maxNmb, $result) {
    $script:game = $false
    $winLose = $result ? "win" : "lose"
    Clear-Host
    $UiLine | Write-Host -ForegroundColor DarkCyan
    Write-Host $nickname "You $($winLose)! with"$script:try "try remains, the number is" $number". Accuracy:" ("{0:N2}" -f ($finalScore))"%" -ForegroundColor Magenta
    Write-Host "Your note:" $result -ForegroundColor Magenta
    $UiLine | Write-Host -ForegroundColor DarkCyan
    # $note = calculNote($score)
    # $note = ($result -eq "W" ) ? ($maxNmb + 50 * ($try / $script:currTry)) : 0
    # $saveUser = New-User $nickname (Get-Date) $currDiff $result $script:currTry $note $number
    # $saveUser | Export-Csv -Path $csvPath -Delimiter ";" -Append
    # saveGame
    endGameChoice $nmb $currDiff
    
}

function game($nmb, $try, $diff) {
    gameStart
    $script:maxTry = $try
    $currDiff = $diff
    $number = Get-Random -Maximum $nmb
    $script:try = $try
    while ($script:try -gt 0) {
        if (-not $nickname) {
            gameBanner
            [string]$usernameInput = Read-Host "Enter your username"
            $nickname = textFormalizer($usernameInput)
            userBanner $nickname
        } elseif ($script:game) {
            try {
                [int]$response = Read-Host "Enter a nummber between 1 to" $nmb
                if($response -le $nmb -and $response -ge 0) {
                    enterNmb $response $number
                } else {
                    Write-Host "Error number need to be between 1 to 100"
                }
            } catch {
                Write-Host "Error invalid type"
            }
        }
    }
}

while ($isRunning) {
    mainMenu
}

#? ###########################################################################################
#? ##############################        Scorebords         ##################################
#? ###########################################################################################
function getCsv() {
    return Import-Csv -Path $csvPath -Encoding utf8
}

function getScoreboard() {
    getCsv | Format-Table -AutoSize
}

function scoreBoardMenu() {
    function rulesMenu() {
    gameBanner
    Write-Host "#################### Rules ####################" -ForegroundColor Yellow
    $rulesStr | Write-Host -ForegroundColor Green
    $rulesAction = Read-Host "Press any key return to main menu"
    if ($rulesAction) {
        mainMenu
    }
}
}


    