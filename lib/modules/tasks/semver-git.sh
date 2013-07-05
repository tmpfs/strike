require git;

semver.git() {
  executable.validate git;
  local semver="$1";
  local version="$2";
  local tag="${semver}";
  local remote="origin";
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
    if [ "${tag}" != "${version}" ]; then
      local file="${target}/${version}-${tag}-commits.log";
      console info -- "commits %s..%s -> %s" "${version}" "${tag}" "${file}";
      git log "${version}".."${tag}" > "${file}";
    fi
    if git ls-remote --tags 2>/dev/null | grep "$tag" >/dev/null 2>&1; then
      console info -- "overwrite tag %s at %s" "${tag}" "${remote}";
    fi
    # TODO: confirm on tag overwrite remote
    console info -- "push %s to %s" "${tag}" "${remote}";
    git push -f "${remote}" "${tag}" > /dev/null 2>&1 \
      || console error -- "could not push tag %s" "${tag}";
  fi
}
