```sh
git log --graph --oneline --all --simplify-by-decoration
```


# Move folders across repository while preserving the history
```sh
git subtree split -P services/connectors/custom-connectors/airbyte-cdk -b fix/move-airbyte-cdk
cd connector-cdk

git remote add services-core-local ~/test/services-core
git merge services-core-local/fix/move-airbyte-cdk --allow-unrelated-histories
```
