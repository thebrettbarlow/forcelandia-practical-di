# Forcelandia 2023: Practical Uses of Dependency Injection

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
  --alias="${alias}" \
  --definition-file=config/project-scratch-def.json \
  --duration-days=30 \
  --set-default

sf project deploy start \
  --source-dir=force-app \
  --wait=10 \
  --ignore-conflicts \
  --verbose
```
