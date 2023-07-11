# Practical Uses of Dependency Injection

Example project that was presented at [Forcelandia](https://forcelandia.com/) 2023
([slides](https://docs.google.com/presentation/d/1z9X-HAQVbAtuthoSS4uaYXLL4T-ZkbJx9OJ5g53basU/edit?usp=sharing)).

---

This project has been organized to showcase everyday uses of Dependency Injection.

Check out the examples to learn more:

- [Account Checker](force-app/main/account/classes/AccountChecker.cls)
- [Opportunity Checker](force-app/main/opportunity/classes/OpportunityChecker.cls)
- [Premium Opportunity Factory](force-app/premium-opportunity/service/classes/PremiumOpportunityFactory.cls)
- [Premium Opportunity Service](force-app/premium-opportunity/service/classes/PremiumOpportunityService.cls)
- [Apex Trigger](force-app/di-examples/apex-trigger)
- [Trigger Framework](force-app/main/trigger-framework)

A few static utilities are used throughout this project.
Find them in the [force-app/main/default](force-app/main/default) folder.

## Development

### Connect to the Dev Hub

```shell
org_alias="forcelandia-di"

sf org login web \
  --alias="${org_alias}" \
  --set-default-dev-hub
```

### Make a scratch org

```shell
org_alias="forcelandia-di-scratch"

sf org create scratch \
  --alias="${org_alias}" \
  --definition-file=config/project-scratch-def.json \
  --duration-days=30 \
  --set-default

sf project deploy start \
  --source-dir=force-app \
  --wait=10 \
  --ignore-conflicts \
  --verbose
```

### Run all tests

```shell
org_alias="forcelandia-di-scratch"

sf apex test run \
  --target-org="${org_alias}" \
  --wait=10 \
  --code-coverage
```