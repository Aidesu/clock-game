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
[int]$script:try = 0
[int]$number = Get-Random -Maximum 100
[string]$welcome = "###############################################`n##        Welcome to the Clock Game!         ##`n###############################################"
[string]$mainMenuStr = "################## Main Menu ##################`n[1] New Game`n[2] Score Board`n[3] User Score`n[4] Rules`n[0] Quit"
[string]$exitStr = "###############################################`n##        Do you really want to quit ?       ##`n###############################################"
[string]$csvPath = "C:\Users\Carla\Documents\PowerShell\data\scores.csv"
[string]$nickname = ""
$script:notes = @("SS", "S", "A", "B", "C", "D")

#? ###########################################################################################
#? ################################        Class         #####################################
#? ###########################################################################################
class GameData{
    [string]$dataNickname
    [string]$dataDate
    [string]$dataDifficulty
    [string]$dataResultat
    [int]$dataTry
    [int]$dataScore
    [int]$dataSecretNmb

    GameData(
    [string]$dataNickname,
    [string]$dataDate,
    [string]$dataDifficulty,
    [string]$dataResultat,
    [int]$dataTry,
    [int]$dataScore,
    [int]$dataSecretNmb
    ) {
    $this.dataNickname = $dataNickname
    $this.dataDate = $dataDate
    $this.dataDifficulty = $dataDifficulty
    $this.dataResultat = $dataResultat
    $this.dataTry = $dataTry
    $this.dataScore = $dataScore
    $this.dataSecretNmb = $dataSecretNmb
    }
}

#? ###########################################################################################
#? ###############################        Banner         #####################################
#? ###########################################################################################
function gameBanner() {
    Clear-Host
    $welcome | Write-Host -ForegroundColor Magenta
}
function userBanner($name) {
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
    $mainMenuAction = Read-Host "Enter your action"

    switch ($mainMenuAction) {
        1 { gameStart }
        2 {  }
        3 {  }
        4 { rulesMenu }
        0 { exitGame }
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

#? ###########################################################################################
#? #############################        Formalizer         ###################################
#? ###########################################################################################
function textFormalizer($text) {
    $text.replace(' ', '')
    $textInfo = (Get-Culture).TextInfo
    $textInfo.ToTitleCase($text)
    return $text
}

#? ###########################################################################################
#? ###########################################################################################
function calculNote([float]$currNote) {
    #* Write-Host $currNote
        switch ($currNote) {
            {$_ -ge 85} { $note = $script:notes[0] }
            {$_ -ge 70} { $note = $script:notes[1] }
            {$_ -ge 50} { $note = $script:notes[2] }
            {$_ -ge 40} { $note = $script:notes[3] }
            {$_ -ge 20} { $note = $script:notes[4] }
            {$_ -lt 20} { $note = $script:notes[5] }
            Default { $note = "test"}
        }
    return $note
}

function gameWon($name, $score, $try, $nmb) {
    Clear-Host
    $note = calculNote($score)
    Write-Host "#######################################################################" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host $nickname "You won! with"$try"try, the number is" $number". Accuracy:" ("{0:N2}" -f ($finalScore))"%" -ForegroundColor Magenta
    Write-Host "Your note:" $note -ForegroundColor Magenta
    Write-Host ""
    Write-Host "#######################################################################" -ForegroundColor DarkCyan
    
    $date = Get-Date

    $userSave = [GameData]::new($nickname, $date, "", "", $try, ("{0:N2}" -f ($finalScore)), $nmb)

    $userSave.dataUsername | Write-Host

    $script:game = $false
}
function enterNmb ($numberInput) {
    Clear-Host
    userBanner($nickname)
    $script:try += 1
    if ($numberInput -lt $number){
        Write-Host "Try:" $try "Le chiffre est plus grand"-ForegroundColor Red
    }  
    if ($numberInput -gt $number) {
        Write-Host "Try:" $try "Le chiffre est plus petit"  -ForegroundColor Yellow
    }
    if ($numberInput -eq $number) {
        [float]$finalScore = 100/$try
        gameWon($nickname, $finalScore, $try, $number)
    }
}

mainMenu

while ($isRunning) {
    while ($script:game) {
        if (-not $nickname) {
            $usernameInput = Read-Host "Enter your username"
            $nickname = textFormalizer($usernameInput)
        } else {
            try {
                [int]$response = Read-Host "Enter a nummber between 1 to 100"
                if($response -le 100 -and $response -ge 0) {
                    enterNmb($response)
                } else {
                    Write-Host "Error number need to be between 1 to 100"
                }
            } catch {
                Write-Host "Error invalid type"
            }
        }
    }
}
