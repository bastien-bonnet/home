#!/bin/bash

function gitInfo() {
	# If git is installed && current directory is inside a git repo
	if [[ $(command -v git) != "" && ("$(git rev-parse --is-inside-work-tree 2>&1)" == "true") ]]; then
		local gitBranch="$(git branch --no-color | sed -n 's/* \(.*\)/\1/p')"
		local gitStatus="$(git status)"

		local unStagedWork="$([[ $(echo $gitStatus | grep 'Changes not staged for commit:') != '' ]] && echo '*')"
		local unCommitedWork="$([[ $(echo $gitStatus | grep 'Changes to be committed:') != '' ]] && echo c)"
		local unTrackedFiles="$([[ $(echo $gitStatus | grep 'Untracked files:') != '' ]] && echo …)"
		local dirty="$unCommitedWork$unStagedWork$unTrackedFiles"
		[[ -n $dirty ]] && dirtyColored="$red$dirty$default_text" || dirtyColored="✔"
		
		if [[ -d .git/svn ]]; then
			if [[ -f .git/refs/remotes/git-svn && -f .git/refs/heads/master ]]; then
				local diverged="$([[ $(git diff master git-svn) != '' ]] && echo '↓↑(git-svn)')"
			elif [[ -f .git/refs/remotes/trunk && -f .git/refs/heads/master ]]; then
				local diverged="$([[ $(git diff master trunk) != '' ]] && echo '↓↑(trunk)')"
			else
				local diverged="?"
			fi
		else
			local behind="$(echo $gitStatus | sed -n 's/.*Your branch is behind.*\([0-9]\+\).*\..*/↓\1/p')"
			local ahead="$(echo $gitStatus | sed -n 's/.*Your branch is ahead.*\([0-9]\+\).*\..*/↑\1/p')"
			local diverged="$(echo $gitStatus | sed -n 's/.*and have \([0-9]\+\) and \([0-9]\+\) different commit.*/↓\2↑\1/p')"
		fi
		local branchState="$yellow$bgColor$behind$ahead$diverged$default_text"
		
		[[ "$gitBranch" != master && "$gitBranch" != next ]] && gitBranch="$yellow$gitBranch$default_text"
		local gitInfo=" [git: $gitBranch $branchState|$dirtyColored]"
		echo -n "$gitInfo"
	fi
}
export gitInfo

function svnInfos() {
	if [[ $(command -v svn != "") ]]; then
		local svnStatus="$(svn status --xml 2>&1)"
		if [ -z "$(echo $svnStatus | grep 'is not a working copy')" ]; then
			[ -n "$(echo $svnStatus | grep 'item="modified"')" ] && local modifiedFiles="*"
			[ -n "$(echo $svnStatus | grep 'item="unversioned"')" ] && local newFiles="…"
			local dirty="$modifiedFiles$newFiles"
			[ -n "$dirty" ] && dirtyColored="$red$dirty$default_text" || dirtyColored="✔"
			echo -n " [svn: $dirtyColored]"
		fi
	fi
}
export svnInfos
