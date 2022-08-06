# Deployments Experiment

This is a little learning in public. I've been wanting to explore different ways to do Bicep deployments that allow a little more choice.

In this example, I'm working with a Synapse data platform deployment. This is minimal, but the goal is to make it secure and accessible from a vm workstation using Bastion.

I want to work this in stages. Here's the plan:

1. Deploy a Windows 10 VM from the portal and create a Bastion host for it. This will give me the basic starting place to deploy my resources to.
2. Extract the ARM template from the portal and drop it into an ARM folder.
3. Revise the ARM template into Bicep that uses the AzureResource repository (basically, we want to stick with focusing on configuration, not keeping copies of resource code) with a configuration file capable of handing additional environments, like dev, test, and prod.
4. Create a Deployment script scoped to the resource group that uses the Bicep template and a configuration file.
5. Delete the existing code in the resources group and test the deployment from Bicep.