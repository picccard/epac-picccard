
$commonSplat = @{
    DefinitionsRootFolder = './Definitions'
    OutputFolder          = './Output'
    InformationAction     = 'Continue'
}
Build-DeploymentPlans @commonSplat -PacEnvironmentSelector 'tenant'
# Build-DeploymentPlans @commonSplat -PacEnvironmentSelector 'epac-dev'



$commonSplat = @{
    DefinitionsRootFolder = './Definitions'
    InputFolder           = './Output'
    InformationAction     = 'Continue'
}
Deploy-PolicyPlan @commonSplat -PacEnvironmentSelector 'tenant'
# Deploy-PolicyPlan @commonSplat -PacEnvironmentSelector 'epac-dev'