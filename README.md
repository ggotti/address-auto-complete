# address-auto-complete

This small application demonstrates an Australia address autocomplete AWS Lambda function, using the [G-NAF](https://data.gov.au/dataset/ds-dga-19432f89-dc3a-4ef3-b943-5326ef1dbecc/details?q=) dataset.


https://user-images.githubusercontent.com/1842134/117966230-057ccb00-b367-11eb-9698-798174a1b25b.mp4


It's deployable using the Serverless Application Model Command Line Interface (SAM CLI).

## Prequrisites
* Docker - [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)
* SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* Node.js 14 - [Install Node.js 14](https://nodejs.org/en/),

## How to Build & Deploy
```bash
sam build
sam deploy --guided
```
## Local Testing

```bash
address-auto-complete$ sam local invoke AddressLookupFunction --event events/event.json
```
