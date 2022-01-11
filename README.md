# How to setup this component
**You need to setup OAuth in order to use SearchLogs**
## Create a new Connected App: 
1. Setup -> App Manager
2. New Connected App
3. Filling in App Name and Contact email
4. Enable Oauth Settings
5. Callback URL (any): https://www.salesforce.com (if you want to)
6. Save
## Retrieve credentials
1. Setup -> App Manager -> Goto Connected App created above -> Click on dropdown -> Select View
2. Client ID -> Consumer Key -> Copy (for Client ID)
3. Client Secret -> Consumer Secre -> Click to Review -> Copy (for Client Secret)
## Get your security token
1. Your Password -> Your salesforce password + security token
2. My Profile -> Setting-> Reset My Security Token
3. Copy the resulting token (for password below)
## Add entry to Remote Site Setting
1. Setup -> Remote Site Setting -> New -> Add new entry for https://login.salesforce.com

# How to use Search Logs
1. Add the new component to your Org
2. Register your API user using OAuth credentials obtained from above steps
<img src="https://github.com/dalinwanglhtz/searchLogs/blob/master/force-app/main/default/staticresources/images/searchlog-register.JPG" width="400">
3. Start Searching - Quick Search
<img src="https://github.com/dalinwanglhtz/searchLogs/blob/master/force-app/main/default/staticresources/images/searchlog-ui.JPG" width="400">

# Quick Search vs Search All Logs
## Quick Search
The Quick Search button performs search of a given key in the most recent 100 logs. When results are found, the log contents are concatenated and displayed in the text area below.
<img src="https://github.com/dalinwanglhtz/searchLogs/blob/master/force-app/main/default/staticresources/images/searchlog-ui.JPG" width="400">

## Search All Logs
Search All Logs button performs comprehensive search across all the logs created in this org. When results are found, log contents are concatenated and emailed to Api User registered email as an attachment. 
<img src="https://github.com/dalinwanglhtz/searchLogs/blob/master/force-app/main/default/staticresources/images/search-all-logs-toast-message.JPG" width="400">
A custom notification will be created to notify user of this event.
<img src="https://github.com/dalinwanglhtz/searchLogs/blob/master/force-app/main/default/staticresources/images/search-all-logs-custom-notification.JPG" width="400">
<img src="https://github.com/dalinwanglhtz/searchLogs/blob/master/force-app/main/default/staticresources/images/search-all-logs-custom-notification-2.JPG" width="400">

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
