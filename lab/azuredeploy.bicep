
/* =========================================
   NET
   ========================================= */
module hub './modules/vnet.bicep' = {
  name: 'hub'
  params: {
    location: resourceGroup().location
    vnetNamePrefix: 'hub'
    vnetAddressSpacePrefix: '10.99'
  }
}

module spoke './modules/vnet.bicep' = {
  name: 'spoke'
  params: {
    location: resourceGroup().location
    vnetNamePrefix: 'spoke'
    vnetAddressSpacePrefix: '10.88'
  }
}

output hubVnetId string = hub.outputs.vnetId
output spokeVnetId string = spoke.outputs.vnetId

/* =========================================
   VM
   ========================================= */
module ubuntuhub 'modules/ubuntu.bicep' = {
  name: 'ubuntu-hub'
  params: {
    adminUsername: getKeyVaultSecret(kv, 'adminPassword')
    adminPasswordOrKey: 'Password1234!'
    vnetName: 'hub-vnet'
    subnetName: 'web-subnet'
    vmName: 'ubuntuhub'
  }
}

module ubuntuspoke 'modules/ubuntu.bicep' = {
  name: 'ubuntu-spoke'
  params: {
    adminUsername: 'azureuser'
    adminPasswordOrKey: 'Password1234!'
    vnetName: 'spoke-vnet'
    subnetName: 'web-subnet'
    vmName: 'ubuntuspoke'
  }
}

output ubuntuHubAdminUsername string = ubuntuhub.outputs.adminUsername
output ubuntuHubHostname string = ubuntuhub.outputs.hostname
output ubuntuHubSshCommand string =  ubuntuhub.outputs.sshCommand

output ubuntuSpokeAdminUsername string = ubuntuspoke.outputs.adminUsername
output ubuntuSpokeHostname string = ubuntuspoke.outputs.hostname
output ubuntuSpokeSshCommand string =  ubuntuspoke.outputs.sshCommand

resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: 'vmCrendential'
} 
