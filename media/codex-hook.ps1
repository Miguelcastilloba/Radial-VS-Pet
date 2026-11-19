param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('working', 'idle')]
  [string]$State
)

$ErrorActionPreference = 'Stop'

try {
  $hookInput = [Console]::In.ReadToEnd()
  if ([string]::IsNullOrWhiteSpace($hookInput)) {
    exit 0
  }

  $event = $hookInput | ConvertFrom-Json
  $sessionId = [string]$event.session_id
  if ([string]::IsNullOrWhiteSpace($sessionId)) {
    exit 0
  }

  $safeSessionId = [regex]::Replace($sessionId, '[^A-Za-z0-9._-]', '_')
  if ([string]::IsNullOrWhiteSpace($safeSessionId)) {
    exit 0
  }

  if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
    $codexHome = Join-Path $env:USERPROFILE '.codex'
  } else {
    $codexHome = [System.IO.Path]::GetFullPath($env:CODEX_HOME)
  }

  $stateDirectory = Join-Path $codexHome 'radial-mascot\state'
  [System.IO.Directory]::CreateDirectory($stateDirectory) | Out-Null

  $status = [ordered]@{
    sessionId = $sessionId
    state = $State
    updatedAt = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
    event = [string]$event.hook_event_name
  }

  $targetPath = Join-Path $stateDirectory ($safeSessionId + '.json')
  $temporaryPath = Join-Path $stateDirectory ($safeSessionId + '.' + $PID + '.tmp')
  $json = $status | ConvertTo-Json -Compress
  $encoding = [System.Text.UTF8Encoding]::new($false)
  [System.IO.File]::WriteAllText($temporaryPath, $json, $encoding)
  Move-Item -LiteralPath $temporaryPath -Destination $targetPath -Force

  if ([string]$event.hook_event_name -eq 'SessionEnd') {
    $staleBefore = [DateTime]::UtcNow.AddDays(-30)
    Get-ChildItem -LiteralPath $stateDirectory -Filter '*.json' -File -ErrorAction SilentlyContinue |
      Where-Object { $_.LastWriteTimeUtc -lt $staleBefore } |
      Remove-Item -Force -ErrorAction SilentlyContinue
  }
} catch {
  # The mascot is optional; a local status-write problem must never block Codex.
}

exit 0
