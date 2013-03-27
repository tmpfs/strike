# determine if a git repository has changes
# see: http://stackoverflow.com/questions/2657935/checking-for-a-dirty-index-or-untracked-files-with-git
git.clean?() {
  local output=$( git status --porcelain );
  if [ -z "$output" ]; then
    return 0;
  fi
  return 1;
}

# determine if a directory is a valid git repository
git.valid?() {
  local dir="${1:-}";
  # test current working directory
  # when no directory is specified
  if [ -z "$dir" ]; then
    dir="$PWD";
  fi
  if [ -d "$dir" ] && [ -d "${dir}/.git" ]; then
    return 0;
  fi
  return 1;
}

# determines if the git program is available
git.exists?() {
  local git="${executables[git]:-}";
  if [ -z "$git" ]; then
    executable.validate --test git;
    if [ -z "${executables[git]}" ]; then
      console warn "git is not available";
      return 1;
    fi
  fi
  return 0;
}

# retrieve an author/email string for a revision
git.show.author() {
  local revision="${1:-HEAD}";
  git --no-pager show -s --format='%an <%ae>' "$revision";
}

# git ls-files --others -i --exclude-from=.git/info/exclude
# git ls-files --others -i --exclude-standard
# git ls-files --others -i --exclude-from=.gitignore
# git ls-files --others
# git ls-files --others --directory
# list files ignored by a repository
git.others() {
  local dir="${1:-}";
  # git ls-files --others -i --exclude-standard
  if git.exists? && git.valid? "${dir:-}"; then
    ${executables[git]} ls-files --others
  fi
}

# get the current branch name
git.branch.current() {
  local varname="${1:-git_branch_current}";
  if git.exists?; then
    local branch=$( "${executables[git]}" rev-parse --abbrev-ref HEAD );
    eval "$varname=\"$branch\"";
  fi
}

# get the hash of the last commit in a branch
git.branch.hash() {
  local varname="${1:-git_branch_hash}";
  if git.exists?; then
    local git_branch="${1:-}";
    if [ -z "${git_branch}" ]; then
      git.branch.current "git_branch";
    fi
    local hash=$( "${executables[git]}" rev-parse "$git_branch" );
    eval "$varname=\"$hash\"";
  fi
}

# get the message of the last commit in a branch
git.branch.message() {
  local varname="${1:-git_branch_message}";
  if git.exists?; then
    local git_branch="${1:-}";    
    if [ -z "${git_branch}" ]; then
      git.branch.current "git_branch";
    fi
    local msg=$( "${executables[git]}" log -n 1 "$git_branch" --format=format:%s );
    eval "$varname=\"$msg\"";
  fi
}

# retrieve the remote url for <name> a git repository
# and assign to variable name defined by $2
git.remote.url() {
  local varname="${1:-git_remote_url}";
  local name="${2:-origin}";
  if git.exists?; then
    local url=$( "${executables[git]}" config --get "remote.${name}.url" );
    eval "$varname=\"$url\"";
  fi
}
