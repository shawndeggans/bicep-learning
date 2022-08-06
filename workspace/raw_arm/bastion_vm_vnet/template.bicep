param virtualMachines_testdev_vm_name string = 'testdev-vm'
param virtualNetworks_testdev_vnet_name string = 'testdev-vnet'
param bastionHosts_testdev_vnet_bastion_name string = 'testdev-vnet-bastion'
param networkInterfaces_testdev_vm_nic1_name string = 'testdev-vm-nic1'
param publicIPAddresses_testdev_vnet_ip_name string = 'testdev-vnet-ip'
param publicIPAddresses_testdev_vm_pubip_name string = 'testdev-vm-pubip'
param storageAccounts_testdevr5hyia4npjghw_name string = 'testdevr5hyia4npjghw'

resource publicIPAddresses_testdev_vm_pubip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_testdev_vm_pubip_name
  location: 'centralus'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: 'testdev-vmr5hyi'
      fqdn: 'testdev-vmr5hyi.centralus.cloudapp.azure.com'
    }
    ipTags: []
  }
}

resource publicIPAddresses_testdev_vnet_ip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_testdev_vnet_ip_name
  location: 'centralus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.12.209.76'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_testdev_vnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_testdev_vnet_name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'sub'
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/26'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource storageAccounts_testdevr5hyia4npjghw_name_resource 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccounts_testdevr5hyia4npjghw_name
  location: 'centralus'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource virtualMachines_testdev_vm_name_enablevmaccess 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  parent: virtualMachines_testdev_vm_name_resource
  name: 'enablevmaccess'
  location: 'centralus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'VMAccessAgent'
    typeHandlerVersion: '2.0'
    settings: {
      UserName: 'devAdmin'
    }
    protectedSettings: {
    }
  }
}

resource virtualMachines_testdev_vm_name_SetupDevEnvironment 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  parent: virtualMachines_testdev_vm_name_resource
  name: 'SetupDevEnvironment'
  location: 'centralus'
  tags: {
    displayName: 'SetupDevEnvironment'
  }
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.8'
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/quisitive/ortad/main//code/infrastructure/arm/workstation/dev-vm/DSC/buildvm.ps1'
        'https://raw.githubusercontent.com/quisitive/ortad/main//code/infrastructure/arm/workstation/dev-vm/files/dpi30.ico'
      ]
      commandToExecute: 'powershell -ExecutionPolicy bypass -File buildvm.ps1 -rdpPort 3389'
    }
    protectedSettings: {
    }
  }
}

resource virtualNetworks_testdev_vnet_name_AzureBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_testdev_vnet_name_resource
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: '10.0.1.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_testdev_vnet_name_sub 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_testdev_vnet_name_resource
  name: 'sub'
  properties: {
    addressPrefix: '10.0.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource storageAccounts_testdevr5hyia4npjghw_name_default 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: storageAccounts_testdevr5hyia4npjghw_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_testdevr5hyia4npjghw_name_default 'Microsoft.Storage/storageAccounts/fileServices@2021-09-01' = {
  parent: storageAccounts_testdevr5hyia4npjghw_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_testdevr5hyia4npjghw_name_default 'Microsoft.Storage/storageAccounts/queueServices@2021-09-01' = {
  parent: storageAccounts_testdevr5hyia4npjghw_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_testdevr5hyia4npjghw_name_default 'Microsoft.Storage/storageAccounts/tableServices@2021-09-01' = {
  parent: storageAccounts_testdevr5hyia4npjghw_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource virtualMachines_testdev_vm_name_resource 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: virtualMachines_testdev_vm_name
  location: 'centralus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-10'
        sku: '19h2-pro'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_testdev_vm_name}_OsDisk_1_68e8ee4e06da49c3b85583a889618ea7'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_testdev_vm_name}_OsDisk_1_68e8ee4e06da49c3b85583a889618ea7')
        }
        deleteOption: 'Detach'
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_testdev_vm_name}_disk2_2f668f5af05d48a18b1e51df7cae01bc'
          createOption: 'Empty'
          caching: 'None'
          managedDisk: {
            id: resourceId('Microsoft.Compute/disks', '${virtualMachines_testdev_vm_name}_disk2_2f668f5af05d48a18b1e51df7cae01bc')
          }
          deleteOption: 'Detach'
          toBeDetached: false
        }
      ]
    }
    osProfile: {
      computerName: virtualMachines_testdev_vm_name
      adminUsername: 'devAdmin'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_testdev_vm_nic1_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://${storageAccounts_testdevr5hyia4npjghw_name}.blob.core.windows.net/'
      }
    }
  }
  dependsOn: [

    storageAccounts_testdevr5hyia4npjghw_name_resource
  ]
}

resource bastionHosts_testdev_vnet_bastion_name_resource 'Microsoft.Network/bastionHosts@2020-11-01' = {
  name: bastionHosts_testdev_vnet_bastion_name
  location: 'centralus'
  sku: {
    name: 'Basic'
  }
  properties: {
    dnsName: 'bst-63fcad3c-0fb8-4132-90d7-f939634dec4e.bastion.azure.com'
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_testdev_vnet_ip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_testdev_vnet_name_AzureBastionSubnet.id
          }
        }
      }
    ]
  }
}

resource networkInterfaces_testdev_vm_nic1_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_testdev_vm_nic1_name
  location: 'centralus'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_testdev_vm_pubip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_testdev_vnet_name_sub.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource storageAccounts_testdevr5hyia4npjghw_name_default_bootdiagnostics_testdevvm_0081f471_b9a0_470c_aeb7_1638d76da408 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: storageAccounts_testdevr5hyia4npjghw_name_default
  name: 'bootdiagnostics-testdevvm-0081f471-b9a0-470c-aeb7-1638d76da408'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_testdevr5hyia4npjghw_name_resource
  ]
}
