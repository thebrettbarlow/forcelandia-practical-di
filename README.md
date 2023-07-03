# Practical Uses of Dependency Injection

Example project that was presented at [Forcelandia](https://forcelandia.com/) 2023.

---

This project has been organized to showcase everyday uses of Dependency Injection.

Check out the examples to learn more:

- [Apex Trigger](force-app/di-examples/apex-trigger)
- [Integration with a REST API](force-app/di-examples/rest-integration)
- [Lightning Component](force-app/di-examples/lightning-component)

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
