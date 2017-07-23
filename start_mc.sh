#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

VAR=$(cat <<'ENDCONFIG'
generator-settings=
op-permission-level=4
allow-nether=true
level-name=world
enable-query=false
allow-flight=false
announce-player-achievements=true
server-port=25565
level-type=DEFAULT
enable-rcon=true
rcon.port=25575
rcon.password=pass
level-seed=
force-gamemode=false
server-ip=
max-build-height=256
spawn-npcs=true
white-list=true
spawn-animals=true
snooper-enabled=true
online-mode=true
resource-pack=
pvp=true
difficulty=1
enable-command-block=false
gamemode=0
player-idle-timeout=0
max-players=60
spawn-monsters=true
generate-structures=true
view-distance=16
motd=Welcome to the Redwood Skyfactory3 Server
ENDCONFIG
)

function run_command()
{
    echo "$1"
    eval "$1"
}

run_command "addgroup -g $MCGID minecraft"
run_command "adduser -h /srv/minecraft -S -u $MCUID -G minecraft minecraft"
run_command "chown -R minecraft:minecraft /srv/minecraft"

set +e
run_command "cp -R /srv/minecraft/config.override/* /srv/minecraft/config/"
run_command "cp -R /srv/minecraft/mods.override/* /srv/minecraft/mods/"
set -e

run_command "echo "${VAR}" > /srv/minecraft/server.properties"

echo "Starting server"

cd /srv/minecraft/
run_command "su -s $(which bash) -c \"$(which java) -server -d64 -XX:NewRatio=1 -XX:UseSSE=4 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+UseCMSCompactAtFullCollection -XX:+CMSScavengeBeforeRemark -XX:+UseParNewGC -XX:SurvivorRatio=4 -XX:NewSize=128m -XX:MaxNewSize=128m -XX:+DisableExplicitGC -XX:+AggressiveOpts -XX:MaxGCPauseMillis=50 -XX:+UseLargePages -XX:LargePageSizeInBytes=2m -XX:+UseStringCache -XX:CompileThreshold=500 -XX:+UseFastAccessorMethods -XX:+UseBiasedLocking -XX:+OptimizeStringConcat -Dsun.net.client.defaultConnectTimeout=1000 -Xmx${MCMEM}M -Xms${MCMEM}M -jar $(find . -name '*.jar' -type f -maxdepth 1 | grep -i 'ftbserver') nogui\" minecraft"
