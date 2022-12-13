#!/bin/sh

set -ue

RepositoryName="${INPUT_REPOSITORY_NAME}"
AwsRegion="${INPUT_AWS_REGION}"
SourceBranch="${INPUT_SOURCE_BRANCH}"
DestinationBranch="${INPUT_DESTINATION_BRANCH}"
FoldersToCopy="${INPUT_FOLDERS_TO_COPY}"
CodeCommitUrl="https://git-codecommit.${AwsRegion}.amazonaws.com/v1/repos/${RepositoryName}"
CommitMessage = "syncing commits for range ${github.event.before} to ${github.event.after}"

git config --global --add safe.directory /github/workspace
git config --global credential.'https://git-codecommit.*.amazonaws.com'.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

ActionEvent = "${github.event}"

git clone "$CodeCommitUrl"
git checkout "$DestinationBranch"

cd "$RepositoryName"

if [$FoldersToCopy]
then
    for folder in $FoldersToCopy
    do
        echo $folder
        cp -r "/github/workspace/$folder" .
    done
else
    cp -r "/github/workspace" .  
fi

echo $CommitMessage
    
# git remote add sync ${CodeCommitUrl}
# git add .
# git commit -m "${CommitMessage}"
# git push sync ${DestinationBranch}