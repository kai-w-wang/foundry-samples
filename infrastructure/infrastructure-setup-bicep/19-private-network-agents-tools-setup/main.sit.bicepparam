// az deployment group create --location southeastasia --template-file main.bicepparam --parameters @main.bicepparam -g mbb-rg-aishared-sit-myw-01
using './main.bicep'

param location = 'southeastasia'
param aiServices = 'mbb-aif-aifoundry-sit-sea-01'
param modelName = 'gpt-4.1'
param modelFormat = 'OpenAI'
param modelVersion = '2025-04-14'
param modelSkuName = 'GlobalStandard'
param modelCapacity = 1
param firstProjectName = 'mbb-proj-espi-sit-sea-01'
param projectDescription = 'mbb-proj-espi-sit-sea-01'
param displayName = 'mbb-proj-espi-sit-sea-01'
param peSubnetName = 'mbb-snet-pe-aifoundry-sit-sea-01'

// Resource IDs for existing resources
// If you provide these, the deployment will use the existing resources instead of creating new ones
param existingVnetResourceId = '/subscriptions/de638d3e-027b-4581-8fa0-047b18e0c26d/resourceGroups/mbb-rg-aishared-sit-myw-01/providers/Microsoft.Network/virtualNetworks/mbb-vnet-aifoundry-sit-sea-01'
param vnetName = 'mbb-vnet-aifoundry-sit-sea-01'
param agentSubnetName = 'mbb-snet-agt-aifoundry-sit-sea-01'
param aiSearchResourceId = '/subscriptions/de638d3e-027b-4581-8fa0-047b18e0c26d/resourceGroups/mbb-rg-aishared-sit-myw-01/providers/Microsoft.Search/searchServices/mbb-srch-aiagent-sit-sea-01'
param azureStorageAccountResourceId = '/subscriptions/de638d3e-027b-4581-8fa0-047b18e0c26d/resourceGroups/mbb-rg-aishared-sit-myw-01/providers/Microsoft.Storage/storageAccounts/mbbsaaiagentsitsea01'
param azureCosmosDBAccountResourceId = '/subscriptions/de638d3e-027b-4581-8fa0-047b18e0c26d/resourceGroups/mbb-rg-aishared-sit-myw-01/providers/Microsoft.DocumentDB/databaseAccounts/mbb-cosmos-aiagent-sit-sea-01'
// Pass the DNS zone map here
// Leave empty to create new DNS zone, add the resource group of existing DNS zone to use it
param existingDnsZones = {
  'privatelink.services.ai.azure.com': ''
  'privatelink.openai.azure.com': ''
  'privatelink.cognitiveservices.azure.com': ''
  'privatelink.search.windows.net': ''
  'privatelink.blob.core.windows.net': ''
  'privatelink.documents.azure.com': ''
}

//DNSZones names for validating if they exist
param dnsZoneNames = [
  'privatelink.services.ai.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.search.windows.net'
  'privatelink.blob.core.windows.net'
  'privatelink.documents.azure.com'
]

// Network configuration (behavior depends on `existingVnetResourceId`)
//
// - NEW VNet (existingVnetResourceId is empty):
//     The values below are used to CREATE the VNet and the two subnets.
//     Provide explicit, non-overlapping CIDR ranges when creating a new VNet.
//
// - EXISTING VNet (existingVnetResourceId is provided):
//     The module will reference the existing VNet. Subnet handling depends on the
//     values you provide:
//       * If `agentSubnetPrefix` or `peSubnetPrefix` are empty, the module may
//         auto-derive subnet CIDRs from the existing VNet's address space
//         (using cidrSubnet). This can produce /24 (or configured) subnets
//         starting at index 0, 1, etc.
//       * If you provide explicit subnet prefixes, the module will attempt to
//         create or update subnets with those prefixes in the existing VNet.
//
// Important operational notes and risks (when existingVnetResourceId is provided):
// - Avoid CIDR overlaps with any existing subnets in the target VNet. Overlap
//   leads to `NetcfgSubnetRangesOverlap` and failed deployments.
// - For highest safety when using an existing VNet, supply the existing `agentSubnetPrefix` and `peSubnetPrefix`. 
param vnetAddressPrefix = [
  '172.21.40.0/25'
  '172.21.40.128/27'
]
param agentSubnetPrefix = '172.21.40.0/25'
param peSubnetPrefix = '172.21.40.128/27'
param mcpSubnetPrefix = ''
param mcpSubnetName = ''
