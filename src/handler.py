import boto3
import os
import json
import logging

import urllib3
http = urllib3.PoolManager()

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def parse_event(event):
    logger.info(json.dumps(event))

    accountId = event['account']
    detail = event['detail']

    project_name = detail['project-name']
    build_status = detail['build-status']
    color = 0
    if build_status == "SUCCEEDED":
        color = 2752256 # Green
    if build_status == "FAILED":
        color = 16711680 # Red

    info = detail['additional-information']
    source_version = info['source-version']
    build_number = "N/A"
    if 'build-number' in info:
        build_number = info['build-number']

    embeds = [
      {
        "description": f"Ref: {source_version} | Status: **{build_status}**",
        "color": color
      },
    ]

    # Find error details if unsuccessful
    error = None
    if 'phases' in info:
        for phase in info['phases']:
            if 'phase-status' in phase and phase['phase-status'] == 'FAILED':
                build_status = phase['phase-status']
                error = "\n".join(phase['phase-context'])
    if error is not None:
        embeds.append({
            "description": f"Error: `{error}`",
            "color": 16711680
        })

    return {
      "content": f"`{project_name}` (build: {build_number})",
      "embeds": embeds
    }

def notify_via_discord(content):
    url = os.environ['DISCORD_URL']
    r = http.request('POST', url,
        body=json.dumps(content).encode('utf-8'),
        headers={
            'Content-Type': 'application/json',
            'User-Agent': 'Mozilla/5.0 (X11; U; Linux i686) Gecko/20071127 Firefox/2.0.0.11'
        },
        timeout=10)
    if r.status != 204:
        logger.error(f"Unexpected response from Discord ({r.status}): {r.data}")
        return False

    logger.info(f"Message sent to Discord (status: {r.status})")
    return True


def lambda_handler(event, context):
    logger.info(json.dumps(event))

    records = event['Records']
    for record in records:
        discord_content = parse_event(json.loads(record['Sns']['Message']))
        logger.info(json.dumps(discord_content))
        notify_via_discord(discord_content)
