@minLength(3)
@maxLength(24)
@description('Specify a storage account name.')
param storageAccountName string

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName // must be globally unique

  location: 'eastus'
  tags:{
    diplayName: storageAccountName
  }
  sku: {
      name: 'Standard_LRS'
      tier: 'Standard'
  }
  kind: 'Storage'
}

resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'test'
  location: 'eastus'
} 
