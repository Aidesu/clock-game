## Powershell GUI avec VS Community
## Interface graphique réalisée avec Visual Studio Community
$inputXML = @"
<Window x:Class="MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        mc:Ignorable="d"
        Title="AFPA " Height="700" Width="700" WindowStartupLocation="CenterScreen">
<Grid>
    <Label Content="The Clock Game" HorizontalAlignment="Center" Margin="0,71,0,0" VerticalAlignment="Top" FontSize="24" FontFamily="Rockwell" Height="36"/>

    <Grid x:Name="MainPage">
        <StackPanel HorizontalAlignment="Center" Height="131" Margin="0,175,0,0" VerticalAlignment="Top" Width="186">
            <Button x:Name="PlayBtn" Content="Play" Margin="0,0,0,5" FontFamily="Rockwell" Width="175" Height="25" Background="#FFF99CDC"/>
            <Button x:Name="ScoreboardBtn" Content="Scoreboard" Margin="0,0,0,5" FontFamily="Rockwell" Width="175" Height="25" Background="#FF8BE8DD"/>
            <Button x:Name="RulesBtn" Content="Rules" Margin="0,0,0,5" FontFamily="Rockwell" Width="175" Height="25" Background="#FFE2B779"/>
            <Button x:Name="ExitBtn" Content="Exit" FontFamily="Rockwell" Width="175" Height="25" Background="#FFFF6A6A"/>
        </StackPanel>
    </Grid>

    <Grid x:Name="LoginPage" Visibility="Collapsed">
        <StackPanel HorizontalAlignment="Center" Height="186" VerticalAlignment="Center" Width="202">
            <Label Content="Username" FontFamily="Rockwell"/>
            <TextBox x:Name="UsernameInput" Height="25" TextWrapping="Wrap" Text="" Width="180" FontFamily="Rockwell" VerticalContentAlignment="Center"/>
            <Label Content="Password" FontFamily="Rockwell"/>
            <PasswordBox x:Name="PasswordInput" Height="25" Width="180" Margin="0,0,0,10" FontFamily="Rockwell"/>
            <Label x:Name="LoginMessage" Content="" Visibility="Collapsed"/>
            <Button x:Name="LoginBtn" Content="Login" Background="#FF93E2F1" Margin="0,0,0,5" Width="150" Height="25" FontFamily="Rockwell"/>
            <Button x:Name="RegisterBtn" Content="Register" Background="#FFEC9F51" Width="150" Height="25" FontFamily="Rockwell"/>
        </StackPanel>
    </Grid>

    <Grid x:Name="ScoreboardPage" Visibility="Collapsed">
        <StackPanel HorizontalAlignment="Center" Height="223" VerticalAlignment="Top" Width="540" Margin="0,122,0,0">
            <Label Content="Scoreboard" HorizontalAlignment="Center" Margin="0,0,0,5" FontFamily="Rockwell" FontSize="16"/>
            <DataGrid x:Name="DataScore" Height="187" FontFamily="Rockwell" AutoGenerateColumns="True" IsReadOnly="True"/>
        </StackPanel>
        <Button x:Name="ScoreboardBackBtn" Content="Back" HorizontalAlignment="Left" Height="25" Margin="10,10,0,0" VerticalAlignment="Top" Width="95" Background="#FF880505" Foreground="White"/>
    </Grid>

    <Grid x:Name="DiffPage" Visibility="Collapsed">
        <StackPanel HorizontalAlignment="Center" Height="209" VerticalAlignment="Center" Width="202">
            <Label Content="Difficulty" HorizontalAlignment="Center" Margin="0,0,0,25" FontFamily="Rockwell" FontSize="16"/>
            <Button x:Name="EasyBtn" Content="Easy" Background="#FF58EC9E" Width="150" Height="25" Margin="0,0,0,5" FontFamily="Rockwell"/>
            <Button x:Name="MediumBtn" Content="Medium" Background="#FFECBE58" Width="150" Height="25" Margin="0,0,0,5" FontFamily="Rockwell"/>
            <Button x:Name="HardBtn" Content="Hardcore" Background="#FFEC7358" Width="150" Height="25" Margin="0,0,0,5" FontFamily="Rockwell"/>
            <Button x:Name="CustomBtn" Width="150" Height="25" Content="Custom" FontFamily="Rockwell" Margin="0,0,0,5">
                <Button.Background>
                    <LinearGradientBrush EndPoint="0.25,1" StartPoint="0.25,0" MappingMode="RelativeToBoundingBox">
                        <GradientStop Color="#FFEDA6E7" Offset="1"/>
                        <GradientStop Color="#FF66ECDC" Offset="0"/>
                    </LinearGradientBrush>
                </Button.Background>
            </Button>
            <Button x:Name="DiffBackBtn" Width="150" Height="25" Content="Back" Background="#FFCA7FCE" FontFamily="Rockwell"/>
        </StackPanel>
    </Grid>

    <Grid x:Name="InGamePage" Visibility="Collapsed">
        <StackPanel HorizontalAlignment="Center" Height="154" VerticalAlignment="Center" Width="294">
            <Label x:Name="InGameNmbLabel" Content="Enter a number between 0 - 50" HorizontalAlignment="Center" Margin="0,0,0,20" FontFamily="Rockwell" FontSize="16"/>
            <TextBox x:Name="GuessInput" TextWrapping="Wrap" Text="" Width="160" Height="30" Margin="0,0,0,5" FontFamily="Rockwell" VerticalContentAlignment="Center"/>
            <Label x:Name="InGameLabel" Content="" HorizontalAlignment="Center" Margin="0,0,0,5" FontFamily="Rockwell"/>
            <Button x:Name="InGameEnterBtn" Content="Enter" Width="150" Height="25" Background="#FFECA7DF" FontFamily="Rockwell"/>
        </StackPanel>
    </Grid>

    <Grid x:Name="RestartPage" Visibility="Collapsed">
        <StackPanel HorizontalAlignment="Center" Height="154" VerticalAlignment="Center" Width="294">
            <Label Content="Restart with same difficulty" HorizontalAlignment="Center" Margin="0,0,0,20" FontFamily="Rockwell" FontSize="16"/>
            <Button x:Name="RestartBtn" Content="Restart" Width="200" Height="25" Background="#FFB3A7EC" Margin="0,0,0,5" FontFamily="Rockwell"/>
            <Button x:Name="RestartMenuBtn" Content="Back to main menu" Width="200" Height="25" Background="#FFC35353" FontFamily="Rockwell"/>
        </StackPanel>
    </Grid>
</Grid>
</Window>
"@

## Nettoyage du XAML généré par Visual Studio
$inputXML = $inputXML `
    -replace 'mc:Ignorable="d"', '' `
    -replace '\s+d:\w+="[^"]*"', '' `
    -replace 'x:Name', 'Name' `
    -replace '^<Win.*', '<Window'

## Chargement des classes WPF
try {
    Add-Type -AssemblyName PresentationFramework
} catch {
    Write-Warning "Erreur lors du chargement de l'assembly WPF - Fin du script."
    exit 1
}

## Conversion en XML
[xml]$XAML = $inputXML

## Chargement de l'interface
$reader = New-Object System.Xml.XmlNodeReader $XAML
try {
    $Window = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    Write-Host "Erreur durant le chargement du code XAML :" -ForegroundColor Red
    Write-Host $_.Exception.InnerException.Message -ForegroundColor Red
    exit 1
}

#######################################################
##             Variables interface XAML              ##
#######################################################

## Une variable GUI_<Nom> par contrôle nommé
$XAML.SelectNodes("//*[@Name]") | ForEach-Object {
    Set-Variable -Name "GUI_$($_.Name)" -Value $Window.FindName($_.Name)
}

#######################################################
##                   Navigation                      ##
#######################################################

$pages = @($GUI_MainPage, $GUI_LoginPage, $GUI_ScoreboardPage, $GUI_DiffPage, $GUI_InGamePage, $GUI_RestartPage)

function Show-Page($page) {
    foreach ($p in $pages) { $p.Visibility = 'Collapsed' }
    $page.Visibility = 'Visible'
}

$GUI_PlayBtn.Add_Click({ Show-Page $GUI_LoginPage })
$GUI_ScoreboardBtn.Add_Click({
    $csv = "$PSScriptRoot/data/scores.csv"
    if (Test-Path $csv) { $GUI_DataScore.ItemsSource = @(Import-Csv $csv) }
    Show-Page $GUI_ScoreboardPage
})
$GUI_ScoreboardBackBtn.Add_Click({ Show-Page $GUI_MainPage })
$GUI_DiffBackBtn.Add_Click({ Show-Page $GUI_MainPage })
$GUI_RestartMenuBtn.Add_Click({ Show-Page $GUI_MainPage })
$GUI_ExitBtn.Add_Click({ $Window.Close() })

#######################################################
##                     Account                       ##
#######################################################



## Affichage de la fenêtre
$Window.ShowDialog() | Out-Null