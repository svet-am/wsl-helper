# wsl-helper.ps1
# a helper script for installing and maintaining WSLv2 deployments
# SPDX-License-Identifier: MIT
# original author Tony McDowell <svet.am@gmail.com>

# Get System Meta-data
$debugMode		= 1
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force;

function InstallIfNotInstalled {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=$true)] [string]$FeatureName 
    )  
  if((Get-WindowsOptionalFeature -FeatureName $FeatureName -Online).State -eq "Enabled") {
        # $FeatureName is Installed
        # (simplified function to paste here)
    } else {
        # Install $FeatureName 
    }
}

# Check if winget is installed
# This code snippet courtesy of https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/winutil.ps1
Write-Host "Checking if Winget is Installed..."
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe) {
	#Checks if winget executable exists and if the Windows Version is 1809 or higher
	Write-Host "Winget Already Installed"
} else {
		#Gets the computer's information
		$ComputerInfo = Get-ComputerInfo
		#Gets the Windows Edition
		if ($ComputerInfo.OSName) {
			$OSName = $ComputerInfo.OSName
		} else {
			$OSName = $ComputerInfo.WindowsProductName
		}
		if (((($OSName.IndexOf("LTSC")) -ne -1) -or ($OSName.IndexOf("Server") -ne -1)) -and (($ComputerInfo.WindowsVersion) -ge "1809")) {
						
			Write-Host "Running Alternative Installer for LTSC/Server Editions"

			# Switching to winget-install from PSGallery from asheroto
			# Source: https://github.com/asheroto/winget-installer
						
			Start-Process powershell.exe -Verb RunAs -ArgumentList "-command irm https://raw.githubusercontent.com/ChrisTitusTech/winutil/$BranchToUse/winget.ps1 | iex | Out-Host" -WindowStyle Normal
						
		} elseif (((Get-ComputerInfo).WindowsVersion) -lt "1809") {
			#Checks if Windows Version is too old for winget
			Write-Host "Winget is not supported on this version of Windows (Pre-1809)"
		} else {
			#Installing Winget from the Microsoft Store
			Write-Host "Winget not found, installing it now."
			Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
			$nid = (Get-Process AppInstaller).Id
			Wait-Process -Id $nid
			Write-Host "Winget Installed"
		}
	
}