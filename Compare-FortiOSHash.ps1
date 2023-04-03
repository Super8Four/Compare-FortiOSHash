<#
.SYNOPSIS
    Compare the hash of a downloaded file with a hash provided by Fortinet.

.DESCRIPTION
    This script compares the hash of a downloaded file with a hash provided by Fortinet. It supports both MD5 and SHA512 hashes, and can check a TXT or XML file for the hash or take input from the command line. It also checks the name of the downloaded file to make sure it matches the provided name. The hashes are displayed side by side in all caps for easy comparison.

.PARAMETER FilePath
    The path to the downloaded file.

.PARAMETER Hash
    The hash provided by Fortinet. Can be provided via command line input or checked from a TXT or XML file.

.PARAMETER Algorithm
    The hash algorithm to use. Supports MD5, SHA512, or both.

.PARAMETER Name
    The expected name of the downloaded file.

.EXAMPLE
    Compare-FortiOSHash -FilePath C:\Downloads\file.out -Hash ABCDEF123456 -Algorithm SHA512 -Name file.out

.INPUTS
    None.

.OUTPUTS
    None.

.NOTES
    Version: 1.1
    Author: Gabriel Jensen
#>

function Compare-FortiOSHash {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [string]$Hash,

        [Parameter(Mandatory = $false)]
        [ValidateSet('MD5', 'SHA512', 'Both')]
        [string]$Algorithm = 'Both',

        [Parameter(Mandatory = $false)]
        [string]$Name
    )

    try {
        # If hash is not provided, check TXT and XML files
        if (-not $Hash) {
            $hashFile = Join-Path $PSScriptRoot 'hash.txt'
            if (Test-Path $hashFile) {
                $Hash = Get-Content $hashFile
            }
            else {
                $hashFile = Join-Path $PSScriptRoot 'hash.xml'
                if (Test-Path $hashFile) {
                    $Hash = Select-Xml -Path $hashFile -XPath "//hash" | Select-Object -ExpandProperty Node | Select-Object -ExpandProperty InnerText
                }
                else {
                    throw 'No hash provided and no hash.txt or hash.xml file found.'
                }
            }
        }

        # Check name of downloaded file
        if ($Name -and (Split-Path $FilePath -Leaf) -ne $Name) {
            throw "Downloaded file name doesn't match expected name."
        }

        # Check MD5 hash
        if ($Algorithm -in 'MD5', 'Both') {
            $md5 = Get-FileHash -Path $FilePath -Algorithm MD5 | Select-Object -ExpandProperty Hash
            Write-Host "MD5: $($md5.ToUpper())"
            if ($md5 -ne $Hash) {
                throw 'MD5 hash does not match provided hash.'
            }
        }

        # Check SHA512 hash
        if ($Algorithm -in 'SHA512', 'Both') {
            $sha512 = Get-FileHash -Path $FilePath -Algorithm SHA512 | Select-Object -ExpandProperty Hash
            Write-Host "SHA512: $($sha512.ToUpper())"
            if ($sha512 -ne $Hash) {
                throw 'SHA512 hash does not match provided hash.'
            }
        }
    }
    catch {
        Write-Error $_.Exception.Message
        return
    }
}
