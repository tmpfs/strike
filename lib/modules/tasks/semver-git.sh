require git;

semver.git() {
  executable.validate git;
  local semver="$1";
  local version="$2";
  local tag="${semver}";
  local remote="origin";
  #echo "semver git $semver : $version"
  if git.valid? "${root}"; then
    cd "${root}";
    # TODO: confirm on tag overwrite
    if git tag | grep "${tag}" >/dev/null 2>&1; then
      console info -- "delete tag %s" "${tag}";
      git tag -d "${tag}" > /dev/null 2>&1 \
        || console error -- "could not delete tag %s" "${tag}";
    fi
    console info -- "tag %s" "${tag}";
    git tag "${tag}" \
      || console error -- "could not create tag %s" "${tag}";
    if [ "${semver}" != "${version}" ]; then
      echo "create commit diff of tags..."
    fi
    console info -- "push %s to %s" "${tag}" "${remote}";
    git push "${remote}" "${tag}" > /dev/null 2>&1 \
      || console error -- "could not push tag %s" "${tag}";
  fi
}
