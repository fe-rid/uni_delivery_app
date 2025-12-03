import json
import os

with open('google-services.json', 'r') as f:
    data = json.load(f)

project_info = data['project_info']
client = data['client'][0]
client_info = client['client_info']
api_key = client['api_key'][0]['current_key']
oauth_client = client['oauth_client'][0]['client_id']

print('<?xml version="1.0" encoding="utf-8"?>')
print('<resources>')
print(f'    <string name="google_app_id" translatable="false">{client_info["mobilesdk_app_id"]}</string>')
print(f'    <string name="gcm_defaultSenderId" translatable="false">{client_info["android_client_info"]["package_name"]}</string>')
print(f'    <string name="default_web_client_id" translatable="false">{oauth_client}</string>')
print(f'    <string name="google_api_key" translatable="false">{api_key}</string>')
print(f'    <string name="google_crash_reporting_api_key" translatable="false">{api_key}</string>')
print(f'    <string name="project_id" translatable="false">{project_info["project_id"]}</string>')
print(f'    <string name="firebase_database_url" translatable="false">{project_info["firebase_url"]}</string>')
print(f'    <string name="ga_trackingId" translatable="false"></string>')
print('</resources>')
