# URL pour la page des dernières versions de PowerShell sur GitHub
$latestReleaseUrl = "https://github.com/PowerShell/PowerShell/releases/latest"

try {
    # Obtient la page de la dernière version
    $response = Invoke-WebRequest -Uri $latestReleaseUrl -UseBasicParsing
    $downloadUrl = ($response.Links | Where-Object { $_.href -match ".*win-x64\.msi" }).href

    if ($downloadUrl) {
        # Prépare le chemin pour le fichier MSI téléchargé
        $msiPath = "$env:TEMP\PowerShell-Latest.msi"

        # Télécharge le fichier MSI
        Write-Output "Téléchargement de la dernière version depuis : $downloadUrl"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $msiPath

        # Installe PowerShell
        Write-Output "Installation de la dernière version de PowerShell..."
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait

        # Supprime le fichier MSI
        Remove-Item -Path $msiPath

        Write-Output "Mise à jour de PowerShell terminée. Vous devrez peut-être redémarrer la session PowerShell."
    } else {
        Write-Output "Échec du téléchargement. L'URL de la dernière version n'a pas été trouvée."
    }
} catch {
    Write-Output "Une erreur s'est produite : $_"
}

Pause  # Garde la fenêtre ouverte pour vérifier les messages
