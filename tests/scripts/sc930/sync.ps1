$RocksLocation = "C:\inetpub\wwwroot\rocksTest930.local"
$RocksHost = "https://rockstest930.local"

Push-Location $PSScriptRoot\..\..\..

try {

    # & msbuild .\tests\code\instance\UnicornConfig.csproj /p:Configuration=Release /p:Platform=AnyCPU /p:DeployOnBuild=true /p:PublishProfile=FilesystemPublish /p:DebugType=None /p:publishUrl="$RocksLocation" /p:DeleteExistingFiles=False /restore /v:m

    Import-Module .\tests\scripts\unicorn\Unicorn.psm1
    $secret = ([xml](Get-Content -Raw .\tests\code\instance\App_Config\Include\zzz\RocksTestData.config)).configuration.sitecore.unicorn.authenticationProvider.SharedSecret

    # For reserializing test data
    Sync-Unicorn -ControlPanelUrl "$RocksHost/unicorn.aspx" -SharedSecret $secret -Verb 'Sync' -InformationAction Continue
    Remove-Item -r -Force .\tests\serialization\*
    Copy-Item -r -Force $RocksLocation\App_Data\unicorn\* .\tests\serialization
} finally {
    Pop-Location
}
