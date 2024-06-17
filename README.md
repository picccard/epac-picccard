# epac-picccard
## Resources
- [Reasons to use EPAC](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/policy-management/enterprise-policy-as-code#reasons-to-use-epac)
  > *You have a team that's not responsible for infrastructure deployment, for example a security team that might want to deploy and manage policies.*
- [What does policy-driven governance mean, and how does it work?](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/faq#what-does-policy-driven-governance-mean-and-how-does-it-work)
- [Advanced Azure Policy management](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/policy-management/enterprise-policy-as-code)
- [Testing approach for Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/testing-approach)

## Getting started with Enterprise Policy as Code
### Create an initial repo structure

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
```


### Adding custom modifications

Copy an existing policy definition and policy assignment to get start with.
```pwsh
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

Now open and update the content in

| FilePath | Docs |
|---|---|
|`Definitions\global-settings.jsonc`| [*global-settings docs*](https://azure.github.io/enterprise-azure-policy-as-code/settings-global-setting-file/) |
| `Definitions\policyAssignments\<orgShortName>\IntermediateRoot.jsonc` | [*policy-assignments docs*](https://azure.github.io/enterprise-azure-policy-as-code/policy-assignments/) |


### Publish to github
Initiate the repo and push it wherever you'd like!
```pwsh
git init -b main
git add .
git commit -m 'batman' # batman got no parents, just like this commit
git remote add origin https://github.com/<GithubAccountNameHere>/<RepoNameHere>
git push origin main
```

## Updating - Keeping in sync with ALZ policies
Policies for ALZ gets updated regulary with bugfixes and improvements.
With [policy refresh H2 FY2024](https://github.com/Azure/Enterprise-Scale/wiki/Whats-new#-policy-refresh-h2-fy24) introduced (among other changes) new built-in policies for diagnostic setting and deprecated custom ones, 53 policies and 1 initiative was deprecated.

```pwsh
git clone https://github.com/<GithubAccountNameHere>/<RepoNameHere>
cd <RepoNameHere>

$branchName = 'syncAlzPolicyes-{0}' -f (Get-Date -Format 'yyyyMMddTHHMMssffffZ')
git checkout -b $branchName

Install-Module EnterprisePolicyAsCode
Update-Module EnterprisePolicyAsCode
Import-Module EnterprisePolicyAsCode

Sync-ALZPolicies -DefinitionsRootFolder .\Definitions

git add Definitions/policySetDefinitions/*
git commit -m 'added policySetDefinitions from ALZ policy release xyz'

git add Definitions/policyDefinitions/*
git commit -m 'added policyDefinitions from ALZ policy release xyz'

# review any new / modified policyAssignments from ALZ
# scope will change to tenant1 on sync, change back to your epac env name if the assignment is wanted
# if assignment is new, deside if it is wanted and set scope to your epac env name
git add ./Definitions/policyAssignments/ALZ/*
git commit -m 'added policyAssignments from ALZ policy release xyz'

git push --set-upstream origin "$branchName"

gh pr create --title "ALZ Policy sync xyz" --body "PR includes the files from ALZ policy release xyz"


# helpers
# git status -s
# git add $(git ls-files -o --exclude-standard) # stage new files, I'm only worried about modified assignments
```