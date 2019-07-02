#Currently hardcoded later will be removed from the script and defined as env

GET_VARIABLES()
{
ServicePrincipalId="fb3fd119-f2bb-4316-b737-18af99a89185"
ServicePrincipalPass="RUStrnNHx0fZzvqjQBQWwHIfbQc/PLNhBiydJAQlqKQ="
ServicePrincipalTenant="81fa766e-a349-4867-8bf4-ab35e250a08f"
ACR_NAME="smcpacr"
REPO_NAME="dotnetapp"
RENTENTION_IMAGE=10
SubscriptionName="GCS_01"
}

#LOGOUT_AZURE

AUTHENTICATE_TO_AZURE()
{
echo "Establishing authentication with Azure..."
az login --service-principal -u $ServicePrincipalId -p $ServicePrincipalPass --tenant $ServicePrincipalTenant

echo "Setting subscription to: $SubscriptionName"
az account set --subscription $SubscriptionName

echo " Azure account used is..."
az account show
}

DELETE_ACR_IMAGES()
{
#GET all the tags for the given repository for the given ACR
getalltags()
{
 az acr repository show-tags -n $ACR_NAME --repository $REPO_NAME  --orderby time_desc -o tsv
}


#Get top ten images in the repository for the given ACR

gettoptentags()
{
az acr repository show-tags -n $ACR_NAME --repository $REPO_NAME --top $RENTENTION_IMAGE --orderby time_desc -o tsv 
}

declare -a All
declare -a Topten
All=$(getalltags)
Topten=$(gettoptentags)
#Display All the images in the repository

printf " All Images:  \n\n $All \n\n "

#Display only top ten images in the repository
printf " Top Ten Images:  \n\n $Topten \n\n"

#TotalcountofImages=$(echo "$All" | wc -l)

#echo TotalcountofImages "$TotalcountofImages"
# Display the difference between All tags and Top Ten tags ( B-A concept using comm operator)
declare -a C
C=($(comm -3 <(printf '%s\n' "${All[@]}" | LC_ALL=C sort) <(printf '%s\n' "${Topten[@]}" | LC_ALL=C sort)))
printf '%s\n' "${C[@]}"
: '
TobeDeletedListcount=$(echo "$C" | wc -l)
echo TotalcountofImages "$TobeDeletedListcount"
'

 for i in "${C[@]}"
 do 
 echo Deleting image $i 
 #az acr repository delete -n $ACR_NAME --image $REPO_NAME:$i --yes
 done

}

#To logout from azure subscription

AZ_LOGOUT()
{
echo " Logging out from the subscription "
az logout
#az accout show

}


GET_VARIABLES
AUTHENTICATE_TO_AZURE
DELETE_ACR_IMAGES
AZ_LOGOUT


































