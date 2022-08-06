# Revised Bastion, VM, and VNET

Now that I have a ARM template export from Azure, I want to create a more flexible Bicep deployment script. This is the first step in any deployment, because the goal moving forward is to create this as our initial starting place. Eventually, this VM will get configured with more stuff (Data Engineering Tools), but for now it's perfect.

Additionally, I want to make the most of the existing ResourceModules project, so I only want to reference the BICEP and not write it.

I'm also thinking it might not be a bad idea to play with some of the Bicep tool and try an automatic transformation of the RAW to BICEP

To do this, you need to make sure you have the latest version of Bicep installed.

For this, I'm going to use the `bicep decompile` and drop it directly into the raw folder with the ARM template.

The decompiled version is a bit of a mess, but it's a good place to start. I've also added a dev and prod versions of the parameter files. 

One of the first things I want to do is get a handle on these terrible names. The following is the parameters from the template:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "virtualMachines_testdev_vm_name": {
            "value": null
        },
        "virtualNetworks_testdev_vnet_name": {
            "value": null
        },
        "bastionHosts_testdev_vnet_bastion_name": {
            "value": null
        },
        "networkInterfaces_testdev_vm_nic1_name": {
            "value": null
        },
        "publicIPAddresses_testdev_vnet_ip_name": {
            "value": null
        },
        "publicIPAddresses_testdev_vm_pubip_name": {
            "value": null
        },
        "storageAccounts_testdevr5hyia4npjghw_name": {
            "value": null
        }
    }
}
```

Each of these parameters represents something in the Bicep file that's needed. Most of them are names, and I would like to make naming things as simple as possible. I want to see what I can find that is a good Bicep naming tool. Something that maybe I can feed a pattern to and it will spit out good names for me, but I need it to be flexible enough so that if I'm working in someone else's environment and they have some other way of naming things, that I'm covered.



