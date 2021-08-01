param location string 
param vnetNamePrefix string 
param vnetAddressSpacePrefix string 


var subnets = [
  {
    name: 'app'
    subnetSuffix: '10.0/24'
  }
  {
    name: 'db'
    subnetSuffix: '20.0/24'
  }
  {
    name: 'web'
    subnetSuffix: '30.0/24'
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: '${vnetNamePrefix}-vnet'
  location: location
  dependsOn: [
    vnetappnsg
  ]
  properties: {
    addressSpace: {
      addressPrefixes: [
        '${vnetAddressSpacePrefix}.0.0/16'
      ]
    }
    // subnets: [for subnet in subnets: {
    //   name: '${subnet.name}-subnet'
    //   properties: {
    //     addressPrefix: '${vnetAddressSpacePrefix}.${subnet.subnetSuffix}'
    //   }
    // }]

    subnets: [
      {
        name: 'app-subnet'
        properties: {
          addressPrefix: '${vnetAddressSpacePrefix}.20.0/24'
         
        }
      }
      {
        name: 'db-subnet'
        properties: {
          addressPrefix: '${vnetAddressSpacePrefix}.30.0/24'
        }
      } 
      {
        name: 'web-subnet'
        properties: {
          addressPrefix: '${vnetAddressSpacePrefix}.10.0/24'
          networkSecurityGroup: {
            id : vnetappnsg.id
          }
        }
      } 
    ]
  }
} 

resource vnetappnsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${vnetNamePrefix}-vnet-app-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '159.196.149.211/32'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges:  [
            '22'
            '80'
            '443'
            '3389'
          ]
        }
      }
    ]
  }
}

output vnetId string = vnet.id
