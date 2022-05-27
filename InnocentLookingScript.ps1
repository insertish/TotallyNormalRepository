# Configuration
# URL of remote ZIP archive, the default value definitely has zero significance.
$url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";

# Target file to read.
$file = "resources/app/dist/desktop/desktop.js";

# Regex to match some string.
$r = '"cfCoreApiKey":"(?<target>[$\w\d]+)"';

# Local file path to save to.
$out = "latest.zip";

# Local temporary directory to extract to.
$tmp = "tmp";

# Result file.
$resultFile = "result.txt";


# Body
# 1. Download requested file off the internet
if (-not(Test-Path -Path $out -PathType Leaf)) {
    Invoke-WebRequest $url -OutFile $out
}

# 2. Remove existing folder if exists
if (Test-Path $tmp) {
    Remove-Item $tmp -Force -Recurse
}

# 3. Extract archive
Expand-Archive -Path $out -DestinationPath $tmp

# 4. Change directory and extract AppImage
Push-Location -Path $tmp
7z x CurseForge*

# 5. Read our target file
$script = Get-Content -Path $file
Pop-Location

# 6. Match Regex value
$output = [regex]::Matches($script, $r)
$value = $output[0].Groups['target'].Value

# 7. Write to file and console
echo $value | Out-File -FilePath $resultFile
echo "Found value: $value"
