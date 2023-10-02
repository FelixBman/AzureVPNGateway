# AzureVPNGateway
Sets up an Azure VPN Gateway incl vNet, Subnets, as well as a vpn connection. 
There are also a few tags included.

You would have to define:
1. Resource group Name
2. VNET Name
3. Location
4. adjust you Vnet Prefix as well as the subnets (Bastion is optional)
5. Remote GW IP (e.g. Prisma Service Connection)
6. Local Addresses
7. PSK
8. The User which will be used in tagging
