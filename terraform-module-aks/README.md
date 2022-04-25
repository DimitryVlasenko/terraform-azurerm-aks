## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| agent\_count | count of nodes in the AKS cluster, e.g. 2 | string | `"1"` | no |
| aks\_defaultuser | azure ad aks default user | string | `"mamelch"` | no |
| aks\_defaultuser\_ssh\_public\_key | the public key of the aks default user for ssh access to the nodes. | string | n/a | yes |
| aks\_node\_vm\_size |  | string | `"Standard_B2s"` | no |
| cluster\_name | Name of the AKS cluster | string | n/a | yes |
| create\_sql\_service\_endpoint | create a service endpoint for Microsoft.SQL? | string | `"false"` | no |
| dns\_prefix | DNS prefix for this AKS cluster | string | n/a | yes |
| environment | default tags applied to all resources | string | `"prod"` | no |
| kubernetes\_version |  | string | `"1.13.7"` | no |
| location |  | string | `"westeurope"` | no |
| resource\_group\_name | Resource Group Name for AKS | string | n/a | yes |
| route\_table\_name | Name of the route table that should be assigned to the aks subnet | string | n/a | yes |
| sleep\_command | use timeout command for Windows machines | string | `"sleep"` | no |
| subnet\_range | Subnet CIDR Range for AKS | string | n/a | yes |
| vnet\_name | VNET Name for AKS | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| azuread\_service\_principal |  |
| subnet\_id |  |

