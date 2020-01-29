#! /bin/bash
find /var/lib/jenkins/jobs/$1 -type d -name builds | while read jobs
do
cd "$jobs" ;
ls -d [[:digit:]]* &>/dev/null ;
exitcode=$? ;
if [[ $exitcode -eq 0 ]] ;
then
buildName=$(ls -d [[:digit:]]* | sort -n) ;
echo -e "build name:\n$buildName" &>/dev/null ;
latestBuild=$(echo $buildName | awk '{print $NF}') ;
oldestBuild=$(echo $buildName | awk '{print $1}') ;
amountOfBuilds=$(echo $buildName | wc -w ) ;
lastBuildToKeep=$(echo "$(($latestBuild-9))" );
echo "latest build: $latestBuild"
echo "oldest build: $oldestBuild"
echo "lastbuild to keep : $lastBuildToKeep"
if [ ${amountOfBuilds} -le 10 ] ;
then
echo "Skipping $(pwd) ";
else
for (( i=$oldestBuild; i<$lastBuildToKeep; i++))
do
echo "Deleting $(pwd)/${i} ..."
rm -r "$i" ;
done ;
fi ;
else
echo "Skipping $(pwd) --> Zero builds";
fi ;
done ;
