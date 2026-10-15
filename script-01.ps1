Clear-Host

#* ################################################## STEP 1 ###################################################
#* Generer chiffre aleatoire
#* Demande utilisateur un chiffre
#* Commparaison du chiffre donner par l'utilisatur 
#* jusqu'a ce que la bonne valeurs soit trouver
#* #############################################################################################################

#* ################################################## STEP 2 ###################################################
#Todo Afficher un menu au demarage du jeu ([1]NewGame, [2]Top score board, [3]User score, [4]Rules, Quit)
#Todo Demander le nickname du joueur au lancement de la partie 
#!  Attention nickname doit etre insensible a la casse (Sauvegarde des data, no space, between 3 - 20 char length, Nickname required)
#Todo 3 Niveau de difficulter (Facile {1 - 50 try: 10}, Medium {1 - 100 try: 7}, Hardcore {1 - 500 try: 8})
#Todo Deroulement de la partie...
#Todo Apres une partie choix (Restart, Return to main menu)
#Todo Calcul du score exemple (\[ Score = Base + 50 \times (T_{max}-T_{utilisées}) \])
#?  Sauvegarder les data dans un fichier CSV nommer scores.csv a utiliser (Import-Csv and Export-Csv)
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
[int]$script:try
[int]$script:maxTry
[int]$script:maxNumber
[string]$welcome = "###############################################`n##        Welcome to the Clock Game!         ##`n###############################################"
[string]$mainMenuStr = "################## Main Menu ##################`n[1] New Game`n[2] Score Board`n[3] User Score`n[4] Rules`n[0] Quit"
[string]$exitStr = "###############################################`n##        Do you really want to quit ?       ##`n###############################################"
[string]$levelStr = "###############################################`n##              Level Selector               ##`n###############################################"
[string]$csvPath = "C:\Users\Carla\Documents\PowerShell\data\scores.csv"
[string]$nickname = ""
$script:notes = @("SS", "S", "A", "B", "C", "D")



#? ###########################################################################################
#? ################################        Class         #####################################
#? ###########################################################################################
# class GameData{
#     [string]$dataNickname
#     [string]$dataDate
#     [string]$dataDifficulty
#     [string]$dataResultat
#     [int]$dataTry
#     [int]$dataScore
#     [int]$dataSecretNmb

#     GameData(
#     [string]$dataNickname,
#     [string]$dataDate,
#     [string]$dataDifficulty,
#     [string]$dataResultat,
#     [int]$dataTry,
#     [int]$dataScore,
#     [int]$dataSecretNmb
#     ) {
#     $this.dataNickname = $dataNickname
#     $this.dataDate = $dataDate
#     $this.dataDifficulty = $dataDifficulty
#     $this.dataResultat = $dataResultat
#     $this.dataTry = $dataTry
#     $this.dataScore = $dataScore
#     $this.dataSecretNmb = $dataSecretNmb
#     }
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
#? #############################        Main Menu         ####################################enterNmb
#? ###########################################################################################
function mainMenu(){
    gameBanner
    $mainMenuStr | Write-Host -ForegroundColor DarkGreen
    
    
    try {
        [int]$mainMenuAction = Read-Host "Enter your action"

    switch ($mainMenuAction) {
        1 { levelMenu }
        2 {  }
        3 {  }
        4 { rulesMenu }
        0 { exitGame }
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
    $levelInput = Read-Host "Action"
    levelSelector($levelInput)
}

function levelSelector($inputLevel) {
    switch ($inputLevel) {
        1 { game 50 10 }
        2 { game 100 7 }
        3 { game 500 8 }
        Default {}
    }
}


#? ###########################################################################################
#? ################################        Rules         #####################################
#? ###########################################################################################
function rulesMenu() {
    gameBanner
    Write-Host "This is the clock game !`n[1] Back to main menu" -ForegroundColor Cyan
    $rulesAction = Read-Host "Action"
    if ($rulesAction -eq 1 -or $rulesAction -eq "1") {
        mainMenu
    } else {
        Write-Host "Input not reconized"
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
    while ($true) {
        Clear-Host
        $exitStr | Write-Host -ForegroundColor Red
        Write-Host "[1] Back to main menu" -ForegroundColor Green
        Write-Host "[2] Let me leave" -ForegroundColor DarkRed
        $action = Read-Host "Action"

    switch ($action) {
        1 { mainMenu }
        2 { bye }
    Default {}
    }
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
#? ###########################################################################################

function gameResult($score, $maxNmb, $result) {
    
    if ($result -eq "W") {
        Clear-Host
        Write-Host "#######################################################################" -ForegroundColor DarkCyan
        Write-Host ""
        Write-Host $nickname "You won! with"$script:try "try remains, the number is" $number". Accuracy:" ("{0:N2}" -f ($finalScore))"%" -ForegroundColor Magenta
        Write-Host "Your note:" "N/A" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "#######################################################################" -ForegroundColor DarkCyan
        # $note = calculNote($score)
        saveGame
        
    } else {
        Write-Host "#######################################################################" -ForegroundColor DarkCyan
        Write-Host ""
        Write-Host $nickname "You lose! with"$script:try "try remains, the number is" $number". Accuracy:" ("{0:N2}" -f ($finalScore))"%" -ForegroundColor Magenta
        Write-Host "Your note:" "N/A" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "#######################################################################" -ForegroundColor DarkCyan
        saveGame
    }
}

function saveGame() {
    $date = Get-Date
        
        $userSave = [GameData]::new($nickname, $date, "", "", $try, ("{0:N2}" -f ($finalScore)), $nmb)
        $userSave
        
        $script:game = $false
}



function enterNmb ($numberInput, $nmb) {
    userBanner $nickname
    $script:try --
    if ($numberInput -lt $nmb){
        Write-Host "Try:" $script:try "Le chiffre est plus grand" -ForegroundColor Red
    }  elseif ($numberInput -gt $nmb) {
        Write-Host "Try:" $script:try "Le chiffre est plus petit"  -ForegroundColor Yellow
    } elseif ($numberInput -eq $nmb) {
        [float]$finalScore = 100/$script:try
        gameResult $finalScore $nmb "W"
    }

    if ($script:try -eq 0) {
        gameResult $finalScore $nmb "L"
    }
}


function game($nmb, $try) {
    gameStart
    $number = Get-Random -Maximum $nmb
    $script:try = $try
    while ($script:try -gt 0) {
        if (-not $nickname) {
            gameBanner
            [string]$usernameInput = Read-Host "Enter your username"
            $nickname = textFormalizer($usernameInput)
            userBanner $nickname
        } else {
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
