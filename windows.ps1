Import-Module "./core/ClockGame.psm1"

## interface graphique réalisée avec visual studio-community
$inputXML = @"
<Window x:Class="MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:AFPA"
        mc:Ignorable="d"
        Title="AFPA " Height="700" Width="700" WindowStartupLocation="CenterScreen">
<Grid>
    <Label Content="The Clock Game" HorizontalAlignment="Center" Margin="0,79,0,0" VerticalAlignment="Top" FontSize="22" FontFamily="Rockwell"/>
    <Grid x:Name="menuPanel" Margin="316,178,316,96">
        <Grid.RowDefinitions>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <Button x:Name="playBtn" Content="Play" VerticalAlignment="Center" Height="32" FontFamily="Rockwell"/>
        <Button x:Name="scoreboardBtn" Content="Scoreboard" VerticalAlignment="Center" Height="32" Grid.Row="1" FontFamily="Rockwell"/>
        <Button x:Name="rulesBtn" Content="Rules" VerticalAlignment="Center" Height="32" Grid.Row="2" FontFamily="Rockwell"/>
        <Button x:Name="creditBtn" Content="Credit" VerticalAlignment="Center" Height="32" Grid.Row="3" FontFamily="Rockwell"/>
        <Button x:Name="quitBtn" Content="Quit Game" VerticalAlignment="Center" Height="32" Grid.Row="4" FontFamily="Rockwell"/>
    </Grid>
    <Grid x:Name="nicknamePanel" Margin="289,160,289,199" Visibility="Hidden">

        <Button x:Name="usernameBtn" Content="Done" HorizontalAlignment="Center" Margin="0,55,0,0" VerticalAlignment="Top" FontFamily="Rockwell"/>
        <Label Content="Nickname:" HorizontalAlignment="Left" VerticalAlignment="Top" Padding="0,5,5,0" FontFamily="Rockwell"/>
        <TextBox HorizontalAlignment="Center" Margin="0,21,0,0" TextWrapping="Wrap" Text="Enter your nickname here..." VerticalAlignment="Top" Width="222" TextChanged="TextBox_TextChanged" FontFamily="Rockwell"/>
        <Grid/>

    </Grid>
    <Grid x:Name="levelPanel" HorizontalAlignment="Center" Height="64" VerticalAlignment="Center" Width="222" Visibility="Hidden">
    <Grid.ColumnDefinitions>
        <ColumnDefinition/>
        <ColumnDefinition/>
        <ColumnDefinition/>
    </Grid.ColumnDefinitions>
    <Button x:Name="easyBtn" Content="Easy" Margin="10" Background="#FFC2F1CC" FontFamily="Rockwell"/>
    <Button x:Name="mediumBtn" Content="Medium" Margin="10" Grid.Column="1" Background="#FFA1D9E4" FontFamily="Rockwell"/>
    <Button x:Name="hardBtn" Content="Hard" Margin="10" Grid.Column="2" Background="#FFEAC6C6" FontFamily="Rockwell"/>
</Grid>
    <Grid HorizontalAlignment="Center" Height="193" VerticalAlignment="Center" Width="302" Visibility="Hidden">
        <Label Content="Enter a number between" HorizontalAlignment="Center" Margin="0,23,0,0" VerticalAlignment="Top" FontFamily="Rockwell"/>
        <Button x:Name="nmbInputBtn" Content="Done" HorizontalAlignment="Center" Margin="0,117,0,0" VerticalAlignment="Top" FontFamily="Rockwell"/>
        <TextBox HorizontalAlignment="Center" Margin="0,65,0,0" TextWrapping="Wrap" Text="Number here.." VerticalAlignment="Top" Width="126" Height="32" FontSize="16" FontFamily="Rockwell"/>
    </Grid>
</Grid>
</Window>
"@

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'

## chargement des classes WPF
try { Add-Type -AssemblyName PresentationFramework}
      catch { Write-Warning "Erreur lors du chargement de l'assembly WPF - Fin du script.";
Exit $LASTEXITCODE}
 
## Assignement d'une nouvelle variable de type XML à partir de la chaine inputXML
[xml]$XAML = $inputXML

## interprétation du code XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml)

##  traitement d’erreur afin d’intercepter d’éventuelles erreurs d’interprétation ou de chargement du code de l’interface
Try { $Window =[Windows.Markup.XamlReader]::Load( $reader ) }
  Catch { Write-Host "Erreur durant le chargement du code XAML."
          Write-Host $_
    }
 
#######################################################
#######################################################
##             variables interface xaml              ##
#######################################################
#######################################################
 
## déclaration des variables pour chaque objet de l’interface graphique, à partir de son nom, pour les exploiter simplement au sein du script
## Pour identifier plus facilement ces variables propres à l’interface graphique, elles sont préfixées par 'GUI'
$xaml.SelectNodes("//*[@Name]") | % { Set-Variable -Name "GUI_$($_.Name)" -Value $Window.FindName($_.Name) }
#affichage de la fenetre
$Window.ShowDialog() | out-null

$GUI_playBtn.Add_Click({
    $GUI_menuPanel.Visibility = 'Collapsed'
    $GUI_nicknamePanel.Visibility = 'Visible'
})

New-User -username "Carla"

$GUI_quitBtn.Add_Click({$Window.Close()})
