########################Variables#####################################
## !!!!!!!!   start with "az login"

$RG=                ""      #define RessourceGroup Name
$VNET=              ""        #define vnet name
$LOCATION=          "germanywestcentral"  #SHOW Location list: az account list-locations --output table   /

$VNET_Prefix=       "172.17.0.0/23" 
$APP_SUBNET=        "172.17.0.0/24"
$GATEWAY_SUBNET=    "172.17.1.0/25"
$BASTION_SUBNET=    "172.17.1.128/25"
$LOCAL_ADDRESSES=   "172.19.0.0/16 10.177.10.0/24 100.127.0.0/16  "  

$REMOTE_GW_IP=      ""

$PSK=               ""

$USER=              "x@networks.com"  #definte the user which will be used in the ressource tags

##########################Skript#########################################

$NDC=                  "no-delete-contact=$USER"
$NSC=                  "no-shut-contactt=$USER"
$TAGS=               @('provisioningState=DND','RunStatus=NOSTOP' ,$NSC, $NDC)
      

az group create --name $RG --location $LOCATION --tags $TAGS
az network vnet create --name $VNET --resource-group $RG --address-prefix $VNET_Prefix --location $LOCATION --subnet-name apps --subnet-prefix $APP_SUBNET --tags $TAGS
az network vnet subnet create --address-prefix $GATEWAY_SUBNET --name GatewaySubnet --resource-group $RG  --vnet-name $VNET 
az network vnet subnet create --address-prefix $BASTION_SUBNET --name AzureBastionSubnet --resource-group $RG  --vnet-name $VNET 
az network local-gateway create --gateway-ip-address $REMOTE_GW_IP --name azure-to-prisma --resource-group $RG --local-address-prefixes $LOCAL_ADDRESSES  --tags $TAGS
$P = az network public-ip create --name fbu-vpngw-pip --resource-group $RG --allocation-method Static --sku Standard --tags $TAGS
Write-output "The Public IP of the Azure VPN Gatway is:" $P
az network vnet-gateway create --name fbu-vpngw --public-ip-address fbu-vpngw-pip --resource-group $RG --vnet $VNET --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --no-wait --tags $TAGS
$K = az network vpn-connection create --name Azure2Prisma --resource-group $RG --vnet-gateway1 fbu-vpngw -l $LOCATION --shared-key $PSK --local-gateway2 azure-to-prisma 

Write-output "The Public IP of the Azure VPN Gatway is:" $K
