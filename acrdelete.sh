#Currently hardcoded later will be removed from the script and defined as env

GET_VARIABLES()
{
ServicePrincipalId="fb3fd119-f2bb-4316-b737-18af99a89185"
ServicePrincipalPass="RUStrnNHx0fZzvqjQBQWwHIfbQc/PLNhBiydJAQlqKQ="
ServicePrincipalTenant="81fa766e-a349-4867-8bf4-ab35e250a08f"
ACR_NAME="smcpacr"
RENTENTION_IMAGE=8
SubscriptionName="GCS_01"
}

#LOGOUT_AZURE

AUTHENTICATE_TO_AZURE()
{
echo "Establishing authentication with Azure..."
az login --service-principal -u $ServicePrincipalId -p $ServicePrincipalPass --tenant $ServicePrincipalTenant

echo "Setting subscription to: $SubscriptionName"
az account set --subscription $SubscriptionName

}

DELETE_ACR_IMAGES()
{

Starttime=$(date +"%m-%d-%Y-%T")
echo $Starttime "Start time"

# Number of newest images in repository that will not be deleted
declare -a REPOSITORIES
for ACR in $ACR_NAME; do
  REPOSITORIES=$(az acr repository list -n $ACR -o tsv)
  printf '%s\n' "${REPOSITORIES[@]}"
  for REPO in $REPOSITORIES; do
    echo "Old Images will be deleted form the repository:" "$REPO"
    OLD_IMAGES=$(az acr repository show-tags --name $ACR --repository $REPO --orderby time_asc -o tsv | head -n -$RENTENTION_IMAGE)

    for OLD_IMAGE in $OLD_IMAGES; do
	echo $OLD_IMAGE "deleting the image"
       az acr repository delete --name $ACR --image $REPO:$OLD_IMAGE --yes
	  
    done
  done
done
Endtime=$(date +"%m-%d-%Y-%T")
echo $Endtime "End time "
}

#To logout from azure subscription

AZ_LOGOUT()
{
echo " Logging out from the subscription "
az logout
}

GET_VARIABLES
AUTHENTICATE_TO_AZURE
DELETE_ACR_IMAGES
AZ_LOGOUT



















