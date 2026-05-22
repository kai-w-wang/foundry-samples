@echo
setlocal
pushd %~dp0
az deployment group create --name main-uat --parameters main.uat.bicepparam -g mbb-rg-aishared-uat-myw-01 --subscription e7616c81-ff17-4d0e-8b76-b69ccf27d000 --debug
popd
endlocal