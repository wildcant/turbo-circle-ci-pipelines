#!/bin/bash

DIR="$(cd "$(dirname "$1")" && pwd)"
PROJECT="admin"
TURBO_RUN_FILTER=...[origin/main]

# Extract json from dry response from dry command.
json="$(echo `yarn build --filter=$TURBO_RUN_FILTER --dry-run=json` | grep -o '{.*}')"

# Extract the packages that changed.
packages=($(echo "$json" | grep -o '"packages": \[[^]]*\]' | sed 's/"packages": \[\([^]]*\)\]/\1/' | tr -d '",[]' | tr ' ' '\n'))
echo "Packages that require deployment: (${packages[@]})"

# Check if the given packages is in the list of packages that changed.
if [[ " ${packages[*]} " =~ " ${PROJECT} " ]]; then
  packageChanged=true
else
  packageChanged=false
fi

echo "Project \"${PROJECT}\" requires deployment? ${packageChanged}"
