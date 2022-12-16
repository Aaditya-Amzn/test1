#!/bin/sh

set -ue
echo "Here"

RepositoryName="${INPUT_REPOSITORY_NAME}"
AwsRegion="${INPUT_AWS_REGION}"
SourceBranch="${INPUT_SOURCE_BRANCH}"
DestinationBranch="${INPUT_DESTINATION_BRANCH}"
FoldersToCopy="${INPUT_FOLDERS_TO_COPY}"
CodeCommitUrl="https://git-codecommit.${AwsRegion}.amazonaws.com/v1/repos/${RepositoryName}"
github_after="${INPUT_GITHUB_AFTER}" 
github_before="${INPUT_GITHUB_BEFORE}" 
echo $CodeCommitUrl
echo "github ---- "
echo $github_after
echo $github_before
echo "----"
CommitMessage="syncing commits for range ${github_before} to ${github_after}"
echo $CommitMessage
git config --global --add safe.directory /github/workspace
git config --global credential.'https://git-codecommit.*.amazonaws.com'.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

cd /
git clone "$CodeCommitUrl"
cd "$RepositoryName"
git checkout "$DestinationBranch"

if [$FoldersToCopy != ""]
then
    for folder in $FoldersToCopy
    do
        echo $folder
        echo "/github/workspace/$folder"
        cp -r "/github/workspace/$folder" .
    done
else
    cp -r "/github/workspace/" .  
fi
echo $(ls)
# git remote add sync ${CodeCommitUrl}
# git add .
# git commit -m "${CommitMessage}"
# git push sync ${DestinationBranch}
