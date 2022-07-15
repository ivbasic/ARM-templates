# Install-Module az
# Connect-AzAccount

# <----- user input start
    $RG_name = 'rg-tf2-is-not-dead'
    $RG_location = 'westeurope'
    New-AzResourceGroup -name $RG_name -location $RG_location -force | Out-Null
    Write-Host "$(Get-Date) $RG_name successfully created." -ForegroundColor Green
    $TemplateFile = "...\tf2.json" 
    $ContainerInstanceName = "tf2-instance" 
    $ContainerName = "tf2-container" 
    $ContainerImage = "melkortf/tf2-competitive" 
    $SERVER_HOSTNAME = "spejs.tf" 
    $SERVER_PASSWORD = "test" 
    $RCON_PASSWORD = "rcon" 
    #$LOGS_TF_APIKEY = "76561198000513793#9f770362cd920dd3"
    #$LOGS_TF_PREFIX = "testis" #$SERVER_HOSTNAME
    #$DEMOS_TF_APIKEY = "yHMHquTqnkCCLvzXqLNwtXKqddAppyCEEhKdJnEbHeMwNiJsgu7rbV94Ai3fwF77"
# user input end ----->


$AZ_deployment = (get-date -Format ddMMyyyyHHmmss).ToString()
$AZ_deployment_job = New-AzResourceGroupdeployment -name $AZ_deployment -resourcegroupname $RG_name `
    -templatefile $templatefile `
    -ContainerInstanceName $ContainerInstanceName `
    -ContainerName $ContainerName `
    -ContainerImage $ContainerImage `
    -SERVER_HOSTNAME $SERVER_HOSTNAME `
    -SERVER_PASSWORD $SERVER_PASSWORD `
    -RCON_PASSWORD $RCON_PASSWORD `
    -AsJob
    
    #-DEMOS_TF_APIKEY $DEMOS_TF_APIKEY `
    #-LOGS_TF_APIKEY $LOGS_TF_APIKEY `
    #-LOGS_TF_PREFIX $LOGS_TF_PREFIX `

    
# Container group deployment
    while ($AZ_deployment_job.statusmessage -ne "Completed"){
        Write-Progress "Creating $ContainerInstanceName, please wait..." 
        Start-Sleep 5
    }
    Write-Host  "$(Get-Date) $ContainerInstanceName successfully created." -ForegroundColor Green

# Container provisioning
    $ContainerStatus = Get-AzContainerGroup -ResourceGroupName $RG_name -ContainerGroupName $ContainerInstanceName 

    while ($ContainerStatus.ProvisioningState -ne "Succeeded"){
        Write-Progress "Provisioning $($ContainerStatus.Name), please wait..." 
        Start-Sleep 5
    }
    Write-Progress "Provisioning $($ContainerStatus.Name), please wait..." -Completed
    Write-Host "$(Get-Date) $ContainerName successfully created." -ForegroundColor Green
    
    $ConnectionString = "connect $($ContainerStatus.IPAddressIP):27015; password $SERVER_PASSWORD" 
    $ConnectionString | Set-Clipboard
    Write-Host "$(Get-Date) Connection string copied to your clipboard ($ConnectionString)" -ForegroundColor Green -NoNewline
    Write-Host " (note: please wait up to a few minutes before connecting, to allow TF2 server to fully start up)" -ForegroundColor Yellow
