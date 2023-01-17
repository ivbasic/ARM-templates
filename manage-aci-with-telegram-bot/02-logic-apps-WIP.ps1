# Install-Module az
# Connect-AzAccount

# 
    $RG_name = 'rg-tf2-is-not-dead'
    $RG_location = 'westeurope'
    #New-AzResourceGroup -name $RG_name -location $RG_location -force | Out-Null
    #Write-Host "$(Get-Date) $RG_name successfully created." -ForegroundColor Green
    $TemplateFile = "...\tf2-app.json
    $LogicAppNameStartStop = "LogicStartStop-tf2" 
    $LogicAppNameStatus = "LogicStatus-tf2" 
    $AppServicePlanName = "AppSVCPlanName-tf2" 
    $AppServicePHPName = "AppSVCPHPName-tf2" 
    $ContainerGroupName = "tf2-instance"

    #$SubscriptionID = (get-azsubscription).id
    #$roleAssignmentName = New-Guid
    $principalId = ""
    #$roleDefinitionID = (Get-AzRoleDefinition -name "Reader").id


$AZ_deployment = (get-date -Format ddMMyyyyHHmmss).ToString()
$AZ_deployment_job = New-AzResourceGroupdeployment -name $AZ_deployment -resourcegroupname $RG_name `
    -TemplateFile $TemplateFile `
    -LogicAppNameStartStop $LogicAppNameStartStop `
    -LogicAppNameStatus $LogicAppNameStatus `
    -AppServicePlanName $AppServicePlanName `
    -AppServicePHPName $AppServicePHPName `
    -ContainerGroupName $ContainerGroupName `
    -principalId $principalId `
    -AsJob

