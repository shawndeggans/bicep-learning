# Azure Resource Naming Helper

I've been searching for a good ways to name Azure resources. This module attempts to take Azure's recommended best practices for naming resources. I'd like something that's flexible, but still opinionated.

**Here are some of our basics:**

* Use lowercase
  
* Use hypens where permitted

* Starts and ends with alpha

**Naming components:**

* Azure Region = region

* Environment - env

* Workload or Applicaiton Name = app

* Business unit = bunit

* Instance = instance

* Resource Type = resource

**Patterns:**

To make this is flexible as possible, I would like to be able to pass a type of pattern. Basically, I need to be able to pass an array of the different components n a specific order. We will use that to match to patterns.

I'm going to go ahead and create a resource type reference with its restricted naming convetions, as well.

I haven't found a way to use RegEx yet to enforce naming, so the option now is to try to be restrictive, but still somewhat flexible.

**Regions:**

I grabbed the latest list of regions from the command shell. `az account list-locations -o table`

```cmd
DisplayName               Name                 RegionalDisplayName
------------------------  -------------------  -------------------------------------
East US                   eastus               (US) East US
East US 2                 eastus2              (US) East US 2
South Central US          southcentralus       (US) South Central US
West US 2                 westus2              (US) West US 2
West US 3                 westus3              (US) West US 3
Australia East            australiaeast        (Asia Pacific) Australia East
Southeast Asia            southeastasia        (Asia Pacific) Southeast Asia
North Europe              northeurope          (Europe) North Europe
Sweden Central            swedencentral        (Europe) Sweden Central
UK South                  uksouth              (Europe) UK South
West Europe               westeurope           (Europe) West Europe
Central US                centralus            (US) Central US
South Africa North        southafricanorth     (Africa) South Africa North
Central India             centralindia         (Asia Pacific) Central India
East Asia                 eastasia             (Asia Pacific) East Asia
Japan East                japaneast            (Asia Pacific) Japan East
Korea Central             koreacentral         (Asia Pacific) Korea Central
Canada Central            canadacentral        (Canada) Canada Central
France Central            francecentral        (Europe) France Central
Germany West Central      germanywestcentral   (Europe) Germany West Central
Norway East               norwayeast           (Europe) Norway East
Switzerland North         switzerlandnorth     (Europe) Switzerland North
UAE North                 uaenorth             (Middle East) UAE North
Brazil South              brazilsouth          (South America) Brazil South
East US 2 EUAP            eastus2euap          (US) East US 2 EUAP
Qatar Central             qatarcentral         (Middle East) Qatar Central
Central US (Stage)        centralusstage       (US) Central US (Stage)
East US (Stage)           eastusstage          (US) East US (Stage)
East US 2 (Stage)         eastus2stage         (US) East US 2 (Stage)
North Central US (Stage)  northcentralusstage  (US) North Central US (Stage)
South Central US (Stage)  southcentralusstage  (US) South Central US (Stage)
West US (Stage)           westusstage          (US) West US (Stage)
West US 2 (Stage)         westus2stage         (US) West US 2 (Stage)
Asia                      asia                 Asia
Asia Pacific              asiapacific          Asia Pacific
Australia                 australia            Australia
Brazil                    brazil               Brazil
Canada                    canada               Canada
Europe                    europe               Europe
France                    france               France
Germany                   germany              Germany
Global                    global               Global
India                     india                India
Japan                     japan                Japan
Korea                     korea                Korea
Norway                    norway               Norway
Singapore                 singapore            Singapore
South Africa              southafrica          South Africa
Switzerland               switzerland          Switzerland
United Arab Emirates      uae                  United Arab Emirates
United Kingdom            uk                   United Kingdom
United States             unitedstates         United States
United States EUAP        unitedstateseuap     United States EUAP
East Asia (Stage)         eastasiastage        (Asia Pacific) East Asia (Stage)
Southeast Asia (Stage)    southeastasiastage   (Asia Pacific) Southeast Asia (Stage)
North Central US          northcentralus       (US) North Central US
West US                   westus               (US) West US
Jio India West            jioindiawest         (Asia Pacific) Jio India West
Central US EUAP           centraluseuap        (US) Central US EUAP
West Central US           westcentralus        (US) West Central US
South Africa West         southafricawest      (Africa) South Africa West
Australia Central         australiacentral     (Asia Pacific) Australia Central
Australia Central 2       australiacentral2    (Asia Pacific) Australia Central 2
Australia Southeast       australiasoutheast   (Asia Pacific) Australia Southeast
Japan West                japanwest            (Asia Pacific) Japan West
Jio India Central         jioindiacentral      (Asia Pacific) Jio India Central
Korea South               koreasouth           (Asia Pacific) Korea South
South India               southindia           (Asia Pacific) South India
West India                westindia            (Asia Pacific) West India
Canada East               canadaeast           (Canada) Canada East
France South              francesouth          (Europe) France South
Germany North             germanynorth         (Europe) Germany North
Norway West               norwaywest           (Europe) Norway West
Switzerland West          switzerlandwest      (Europe) Switzerland West
UK West                   ukwest               (Europe) UK West
UAE Central               uaecentral           (Middle East) UAE Central
Brazil Southeast          brazilsoutheast      (South America) Brazil Southeast
```

I'm only using the following, because these are the places I'm mostly likely to deploy to:

```json
    "locations": {
        "eastus": "eus",
        "eastus2": "eus2",
        "southcentralus": "scus",
        "westus": "wus",
        "westus2": "wus2",
        "centralus": "cus",
        "northcentralus": "ncus",
        "usdodcentral": "usdc",
        "usdodeast": "usde",
        "usgovarizona": "usga",
        "usgotexas": "usgt",
        "usgovvirginia": "usgv"
    }
```
