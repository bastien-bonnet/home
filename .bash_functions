#!/bin/bash

function define_colors {
	export red="\033[31m"
	export green="\033[32m"
	export yellow="\033[33m"
	export blue="\033[1;34m"
	export off="\033[00m"
	export default_text_color_and_intensity="\033[39m\033[22m"
}
define_colors

function gitInfo() {
	# If git is installed && current directory is inside a git repo
	if [[ $(command -v git) != "" && ("$(git rev-parse --is-inside-work-tree 2>&1)" == "true") ]]; then
		local gitStatus="$(git status)"

		local dirtyStatus="$(gitDirtyStatus)"
		[[ -n $dirtyStatus ]] && dirtyStatusColored="$red$dirtyStatus$default_text_color_and_intensity"
		
		local branchDivergence="$(gitBranchDivergence)"
		[[ -n $branchDivergence ]] && branchStateColored="$yellow$bgColor$branchDivergence$default_text_color_and_intensity"
		
		local localStatus="$branchStateColored $dirtyStatusColored"
		[[ -z $localStatus ]] && localStatus="✔"
		
		echo -n "[$(gitBranchColored) $localStatus]"
	fi
}

function gitBranchColored {
	local gitBranch="$(git branch --no-color | sed -n 's/* \(.*\)/\1/p')"
	[[ "$gitBranch" != master && "$gitBranch" != next ]] && gitBranch="$yellow$gitBranch$default_text_color_and_intensity"
	echo -n "$gitBranch"
}

function gitDirtyStatus {
	local unCommitedWork="$([[ $(echo $gitStatus | grep 'Changes to be committed:') != '' ]] && echo A)"
	local unMergedWork="$([[ $(echo $gitStatus | grep 'Unmerged paths:') != '' ]] && echo U)"
	local unStagedWork="$([[ $(echo $gitStatus | grep 'Changes not staged for commit:') != '' ]] && echo 'M')"
	local unTrackedFiles="$([[ $(echo $gitStatus | grep 'Untracked files:') != '' ]] && echo ?)"
	echo -n "$unCommitedWork$unMergedWork$unStagedWork$unTrackedFiles"
}

function gitBranchDivergence {
	if [[ -d .git/svn ]]; then
		if [[ -f .git/refs/remotes/git-svn && -f .git/refs/heads/master ]]; then
			local diverged="$([[ $(git diff master git-svn) != '' ]] && echo '↓↑(git-svn)')"
		elif [[ -f .git/refs/remotes/trunk && -f .git/refs/heads/master ]]; then
			local diverged="$([[ $(git diff master trunk) != '' ]] && echo '↓↑(trunk)')"
		else
			local diverged="?"
		fi
	else
		local behind="$(echo $gitStatus | sed -n 's/.*Your branch is behind.*by \([[:digit:]]\+\) commit.*/↓ \1/p')"
		local ahead="$(echo $gitStatus | sed -n 's/.*Your branch is ahead.*by \([[:digit:]]\+\) commit.*/↑ \1/p')"
		local diverged="$(echo $gitStatus | sed -n 's/.*and have \([[:digit:]]\+\) and \([[:digit:]]\+\) different commit.*/↓ \2↑ \1/p')"
	fi
	echo -n "$behind$ahead$diverged"
}

export gitInfo

function svnInfos() {
	if [[ $(command -v svn != "") ]]; then
		local svnStatus="$(svn status --xml 2>&1)"
		if [ -z "$(echo $svnStatus | grep 'is not a working copy')" ]; then
			[ -n "$(echo $svnStatus | grep 'item="modified"')" ] && local modifiedFiles="*"
			[ -n "$(echo $svnStatus | grep 'item="unversioned"')" ] && local newFiles="…"
			local dirtyStatus="$modifiedFiles$newFiles"
			[ -n "$dirtyStatus" ] && dirtyStatusColored="$red$dirtyStatus$default_text_color_and_intensity" || dirtyStatusColored="✔"
			echo -n " [svn: $dirtyStatusColored]"
		fi
	fi
}
export svnInfos
