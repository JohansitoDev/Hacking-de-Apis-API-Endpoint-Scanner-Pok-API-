# API Endpoint Scanner para PokéAPI
# Autor: JohansitoDev


param (
    [string]$WordlistPath
)


$ApiUrl = "https://pokeapi.co/api/v2/pokemon"


if ([string]::IsNullOrEmpty($WordlistPath)) {
    Write-Host "Uso: .\\api-scanner.ps1 -WordlistPath .\\pokemon.txt"
    exit
}


$pokemonList = Get-Content -Path $WordlistPath

Write-Host "Iniciando escaneo de Pokémon para la URL base: $ApiUrl"
Write-Host "---------------------------------------------------"

foreach ($pokemon in $pokemonList) {
    
    $url = "$ApiUrl/$pokemon"
    
    try {
       
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 10 -ErrorAction Stop

        Write-Host "[+] Pokémon encontrado: $pokemon (Código: 200 OK)" -ForegroundColor Green
    }
    catch {
        $errorCode = $_.Exception.Response.StatusCode.value__
        if ($errorCode -ne 404) {
            Write-Host "[!] Error inesperado al buscar $pokemon (Código: $errorCode)" -ForegroundColor Yellow
        }
        else {
            Write-Host "[-] Pokémon no encontrado: $pokemon (Código: 404 Not Found)" -ForegroundColor Red
        }
    }
}

Write-Host "---------------------------------------------------"
Write-Host "Escaneo completado."
