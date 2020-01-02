
<#
.SYNOPSIS
Build script for the TimeFunctions module.

.DESCRIPTION
To run this build script, run the "Invoke-Build" command from a PowerShell prompt in the module's directory.

To install the build module, follow thsee instructions at https://github.com/nightroman/Invoke-Build as also copied below:

Install as module: Invoke-Build is distributed as the module InvokeBuild. In PowerShell 5.0 or with PowerShellGet you can install it by this command:

PS:\> Install-Module InvokeBuild

To install the module with Chocolatey, run the following command. NOTE: This package is maintained by its owner, see package info.

C:\> choco install invoke-build -y

Module commands: Invoke-Build, Build-Checkpoint, Build-Parallel. Import the module in order to make them available:

PS:\> Import-Module InvokeBuild

Go to the module's directory

PS:\> CD "$Home\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions"

Run the build command, "Invoke-Build"

PS:\> Invoke-Build

.LINK
https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/

.LINK
https://github.com/nightroman/Invoke-Build

.LINK
http://duffney.io/GettingStartedWithInvokeBuild#powershell-module-development-workflow
#>

#-----------------------------------------------------------------------------------------------------------------------
#=======================================================================================================================
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Clear-Host # CLS
Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.

#=======================================================================================================================

# Run chosen tasks for this build script

#task . InstallDependencies, Analyze, Test, UpdateVersion, Clean, Archive
#task . InstallDependencies, Test, IntegrateFunctions, BuildModule
#task . Test, IntegrateFunctions, BuildModule
task . IntegrateFunctions, BuildModule

#=======================================================================================================================

#-----------------------------------------------------------------------------------------------------------------------

# Install the dependencies required to perform the rest of this build script.

task InstallDependencies {
    Install-Module PSScriptAnalyzer  #-Force
    Install-Module Pester #-Force
}

#-----------------------------------------------------------------------------------------------------------------------

task Analyze {
    $scriptAnalyzerParams = @{
        Path = "$BuildRoot\DSCClassResources\TeamCityAgent\"
        Severity = @('Error', 'Warning')
        Recurse = $true
        Verbose = $false
        ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
    }
    
    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams
    
    if ($saResults) {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

#-----------------------------------------------------------------------------------------------------------------------

# Test our cmdlets/libraries

task Test {
    $invokePesterParams = @{
        Strict = $true
        PassThru = $true
        Verbose = $false
        EnableExit = $false
    }
    
    # Publish Test Results as NUnitXml
    $testResults = Invoke-Pester @invokePesterParams;
    
    $numberFails = $testResults.FailedCount
    assert($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)
}

#-----------------------------------------------------------------------------------------------------------------------

# Build a dot-source .ps1 function script by combining all the different function/library scripts saved individually into one script

task IntegrateFunctions {
    
    $ModuleFunctions = Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-AMPMhourTo24hour.ps1"
    
    $ModuleFunctions += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-TimeZones.ps1"
    
    $ModuleFunctions += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\PromptForChoice-DayDate.ps1"
    
    $ModuleFunctions += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\ReadPrompt-AMPM24.ps1"
    
    $ModuleFunctions += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Read-PromptTimeValues.ps1"
    
    Set-Content -Path "TimeFunctions.ps1" -Value $ModuleFunctions
    
}

#-----------------------------------------------------------------------------------------------------------------------

# Build the .psm1 module by 

task BuildModule {
    
    <#
    $ModuleContent = Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-AMPMhourTo24hour.ps1"
    
    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-TimeZones.ps1"
    
    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\PromptForChoice-DayDate.ps1"
    
    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\ReadPrompt-AMPM24.ps1"
    
    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Read-PromptTimeValues.ps1"
    #>
    
    $ModuleContent = Get-Content "TimeFunctions.ps1"
    
    Set-Content -Path "TimeFunctions.psm1" -Value $ModuleContent
    
}

#-----------------------------------------------------------------------------------------------------------------------


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#=======================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------
