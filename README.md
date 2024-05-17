# Resources
- [Reasons to use EPAC](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/policy-management/enterprise-policy-as-code#reasons-to-use-epac)
  > *You have a team that's not responsible for infrastructure deployment, for example a security team that might want to deploy and manage policies.*
- [What does policy-driven governance mean, and how does it work?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/faq#what-does-policy-driven-governance-mean-and-how-does-it-work)
- [Advanced Azure Policy management](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/policy-management/enterprise-policy-as-code)
- [Testing approach for Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/testing-approach)

# How this repo was constructed

```pwsh
cd /git
git clone https://github.com/Azure/enterprise-azure-policy-as-code


Install-Module Az
Install-Module EnterprisePolicyAsCode


$orgShortName = 'Uhlv'
$repoName = 'epac-picccard'

mkdir $repoName
cd $repoName


New-HydrationDefinitionFolder -DefinitionsRootFolder Definitions
mkdir '.\Definitions\policyExemptions'


$PipelinesFromStarterKitSplat = @{
   StarterKitFolder = '..\enterprise-azure-policy-as-code\StarterKit'
   PipelinesFolder = '.\.github\workflows'
   PipelineType = 'GitHubActions'
   BranchingFlow = 'GitHub'
   ScriptType = 'module'
}
New-PipelinesFromStarterKit @PipelinesFromStarterKitSplat


Sync-ALZPolicies -DefinitionsRootFolder .\Definitions

mkdir ".\Definitions\policyAssignments\$orgShortName\"
mkdir ".\Definitions\policyDefinitions\$orgShortName\"
mkdir ".\Definitions\policySetDefinitions\$orgShortName\"
mkdir ".\Definitions\policyExemptions\$orgShortName\"
New-Item -Path ".\Definitions\policyAssignments\$orgShortName\.gitkeep" -ItemType File
New-Item -Path ".\Definitions\policyDefinitions\$orgShortName\.gitkeep" -ItemType File
New-Item -Path ".\Definitions\policySetDefinitions\$orgShortName\.gitkeep" -ItemType File
New-Item -Path ".\Definitions\policyExemptions\$orgShortName\.gitkeep" -ItemType File


$copySplat1 = @{
  Path = ".\Definitions\policyDefinitions\ALZ\Network\Deny-Subnet-Without-Nsg.json"
  Destination = ".\Definitions\policyDefinitions\$orgShortName\Deny-Subnet-Without-Nsg-duplicate.json"
}
$copySplat2 = @{
  Path = ".\Definitions\policyAssignments\ALZ\ALZ-Sandbox-Default.jsonc"
  Destination = ".\Definitions\policyAssignments\$orgShortName\IntermediateRoot.jsonc"
}
Copy-Item @copySplat1
Copy-Item @copySplat2
```

## Next steps

Now open and update the content in

|   |   |
|---|---|
|`Definitions\global-settings.jsonc`| [*global-settings docs*](https://azure.github.io/enterprise-azure-policy-as-code/settings-global-setting-file/) |
| `Definitions\policyAssignments\<orgShortName>\IntermediateRoot.jsonc` | [*policy-assignments docs*](https://azure.github.io/enterprise-azure-policy-as-code/policy-assignments/) |


### Initiate the repo and push it wherever you'd like!
- `git init -b main`
- `git add .`
- `git commit -m 'batman'` (batman got no parents, just like this commit)
- `git remote add origin https://github.com/<GithubAccountName>/<RepoName>` (replace \<GithubAccountName\> and \<RepoName\>)
- `git push origin main`
