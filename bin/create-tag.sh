#!/usr/bin/env bash

echo -en "- Fetch tags...\n"
git fetch --tags

echo -en "- Creating git tag...\n"

current_branch=$(git branch | grep \* | cut -d ' ' -f2 | cut -d '=' -f1)
default_major_version=01
default_minor_version=0001
default_patch_version=0000

echo -en "Current branch is ${current_branch}\n"

if [[ "${current_branch}" = "master" ]]; then
    tag_prefix=prod

    last_tag=$(git ls-remote --tags | grep "refs/tags/$tag_prefix-" | sed -e "s|.*refs\/tags\/$tag_prefix-||" | sort | tail -n 1)

    last_tag_info=(${last_tag//./ })
    last_major_version=${last_tag_info[0]:-${default_major_version}}
    last_minor_version=${last_tag_info[1]:-${default_minor_version}}
    last_patch_version=${last_tag_info[2]:-${default_patch_version}}

    patch_version=$(printf "%04d" $((10#$last_patch_version + 1)))

    current_tag="$tag_prefix-$last_major_version.$last_minor_version.$patch_version"
else
    tag_prefix=branch

    last_patch_version=$(git ls-remote --tags | grep --regexp="refs/tags/$tag_prefix-$current_branch\.[0-9]*$" | sed -e "s|.*refs\/tags\/${tag_prefix}-${current_branch}.||" | sort | tail -n 1)

    current_patch_version=$(printf "%04d" $((10#$last_patch_version + 1)))

    current_tag="$tag_prefix-$current_branch.$current_patch_version"
fi

git tag ${current_tag}
git push --porcelain --progress --recurse-submodules=check origin refs/tags/${current_tag}:refs/tags/${current_tag}

if [[ $? -eq 0 ]]; then
    echo -en "Tag \"${current_tag}\" created and pushed\n"

    if [[ "${current_branch}" = "master" ]]; then
        echo -en "Visit https://gitlab.com/datsteam/mostbet/mostbet.com/-/pipelines?page=1&scope=tags&ref=${current_tag} to see your tag\n"
    else
        echo -en "Visit https://gitlab.com/datsteam/mostbet/mostbet.com/-/pipelines?page=1&scope=tags&ref=${current_tag} to see your tag\n"
    fi
else
    echo -en "Failed to push tag \"${current_tag}\"\n"
fi
