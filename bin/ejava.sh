#! /bin/bash

# MAINTAINER Ma Qian<maqian258@gmail.com>

function get_value_as_mbytes() {
    key="$1"
    value="$2"

    if [ -z "$value" ]; then
        return 0
    fi
    num=`echo $value|sed 's/\([0-9]*\)[kKmMgG]*/\1/'`
    if [[ "$value" =~ [0-9]+$ ]]; then
        echo $((num / 1048576))
    elif [[ "$value" =~ [0-9]+[kK]$ ]]; then
        echo $((num / 1024))
    elif [[ "$value" =~ [0-9]+[mM]$ ]]; then
        echo $num
    elif [[ "$value" =~ [0-9]+[gG]$ ]]; then
        echo $((num * 1024))
    fi
    return 0
}

function get_java_opt() {
    local opts="$1"
    local key="$2"
    local value=""

    if [[ "$opts" =~ .*$key=?.* ]]; then
        value=`echo $opts|sed "s/.*$key=*\([^ =]*\).*/\1/"`
    fi

    if [ "$key" = "-Xss" ] || [ "$key" = "-XX:ThreadStackSize" ]; then
        echo $value
        return 0
    fi

    if [ -n "$value" ] && [[ ! "$value" =~ [0-9]+[kKmMgG]*$ ]]; then
        echo Invalid value $value for vm option $key
        return 1
    else
        echo $(get_value_as_mbytes "key" "$value")
        return 0
    fi
}

function get_env_as_mbytes() {
    local key="$1"
    local value="${!key}"

    if [ -n "$value" ] && [[ ! "$value" =~ [0-9]+[kKmMgG]*$ ]]; then
        echo Invalid value $value for environment variable $key
        return 1
    else
        echo $(get_value_as_mbytes "key" "$value")
        return 0
    fi
}

function get_env_as_switch() {
    local key="$1"
    local value="${!key}"
    local def="$2"
    [ -z "$def" ] && def="off"

    if [ "$value" = "ON" ] || [ "$value" = "on" ] || [ "$value" = "1" ];then
        value="on"
    else
        value="$def"
    fi
    echo $value
    return 0
}

function get_env_as_port() {
    local key="$1"
    local value="${!key}"

    [[ ! "$value" =~ ^[1-9][0-9]*$ ]] && value="${!value}"
    if [ -z "$value" ] || [[ ! "$value" =~ ^[1-9][0-9]*$ ]];then
        echo Cound not parse environment variable $key: ${!key}
        return 1
    else
        echo $value
        return 0
    fi
}

function get_env() {
    local key="$1"
    local value="${!key}"
    local def="$2"
    [ -z "$value" ] && value="$def"

    echo $value
    return 0
}

JAVACMD=`type java |awk '{print $(NF)}'`
$JAVACMD -version > /dev/null 2>&1
[ $? -ne 0 ] && echo Could not find java program in your system, please install a java package or set JAVA_HOME in PATH. && exit 1

service_name=$(get_env "SERVICE_NAME" "$SERVICE")
[ -z "$service_name" ] && service_name="java"
mesos_task_id=$(get_env "MESOS_TASK_ID" "apptask%p")
task_id=$(get_env "X_TASK_ID" "$mesos_task_id")
log_path=$(get_env "X_LOG_PATH" "/var/log/$service_name/$task_id"); mkdir -p $log_path
heap_ratio=$(get_env "X_HEAP_RATIO" "0.6")

verbose=$(get_env_as_switch "X_VERBOSE")
nmt=$(get_env_as_switch "X_NMT")
profile=$(get_env_as_switch "X_PROFILE")
gc_log=$(get_env_as_switch "X_GC_LOG")
oom_dump=$(get_env_as_switch "X_OOM_DUMP")
debug=$(get_env_as_switch "X_DEBUG")
jmx=$(get_env_as_switch "X_JMX")
interpret=$(get_env_as_switch "X_INT")
limit_in_mb=$(get_env_as_mbytes "X_MEM_LIMIT")

if [ "$debug" = "on" ]; then
    debug_port=$(get_env_as_port "X_DEBUG_PORT")
    [ $? -ne 0 ] && echo $debug_port && exit 1
    debug_param="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=$debug_port"
fi

if [ "$jmx" = "on" ];then
    jmx_port=$(get_env_as_port "X_JMX_PORT")
    [ $? -ne 0 ] && echo $jmx_port && exit 1
    jmx_param="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$jmx_port -Dcom.sun.management.jmxremote.rmi.port=$jmx_port -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=$(hostname)"
fi

if [ "$verbose" = "on" ];then
    echo Feature Flag:
    echo X_TASK_ID: $task_id
    echo X_LOG_PATH: $log_path
    echo X_VERBOSE: $verbose
    echo X_NMT: $nmt
    echo X_PROFILE: $profile
    echo X_GC_LOG: $gc_log
    echo X_OOM_DUMP: $oom_dump
    echo X_DEBUG: $debug
    echo X_DEBUG_PORT: $debug_port
    echo X_JMX: $jmx
    echo X_JMX_PORT: $jmx_port
    echo X_INT: $interpret
    echo X_HEAP_RATIO: $heap_ratio
fi

ext_params="-XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions"
[ "$verbose" = "on" ] && ext_params="$ext_params -XX:+PrintVMOptions -XX:+PrintCommandLineFlags"
[ "$gc_log" = "on" ] && ext_params="$ext_params -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Xloggc:${log_path}/gc.log"
[ "$oom_dump" = "on" ] && ext_params="$ext_params -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${log_path}/heapdump.hprof"
[ "$nmt" = "on" ] && ext_params="$ext_params -XX:NativeMemoryTracking=summary -XX:+PrintNMTStatistics"
[ "$profile" = "on" ] && ext_params="$ext_params -XX:+PreserveFramePointer"
[ "$debug" = "on" ] && ext_params="$ext_params $debug_param"
[ "$jmx" = "on" ] && ext_params="$ext_params $jmx_param"
[ "$interpret" = "on" ] && ext_params="$ext_params -Xint"

java_params="$*"; [[ ! $java_params == *$JAVA_OPTS* ]] && java_params="$JAVA_OPTS $java_params"
# apply memory limitation on when /sys/fs/cgroup/memory/memory.limit_in_bytes is set
if [ -z "$limit_in_mb" ] && [ -f "/sys/fs/cgroup/memory/memory.limit_in_bytes" ]; then
    limit_in_bytes=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
    limit_in_mb=$((limit_in_bytes / 1048576))
fi

if [ "$verbose" = "on" ];then
  echo X_MEM_LIMIT: ${limit_in_mb:--1}M
fi

if [ -z "$limit_in_mb" ] || [ "$limit_in_mb" -gt "1048576" ]; then
    [ "$verbose" = "on" ] && echo $JAVACMD $ext_params $java_params
    exec $JAVACMD $ext_params $java_params
else

    min_heap_free_ratio=$(get_java_opt "$java_params" "-XX:MinHeapFreeRatio")
    [ $? -ne 0 ] && echo $min_heap_free_ratio && exit 1
    if [ -z "$min_heap_free_ratio" ]; then
        has_min_heap_free_ratio=0
        min_heap_free_ratio=20
    fi

    max_heap_free_ratio=$(get_java_opt "$java_params" "-XX:MaxHeapFreeRatio")
    [ $? -ne 0 ] && echo $max_heap_free_ratio && exit 1
    if [ -z "$max_heap_free_ratio" ]; then
        has_max_heap_free_ratio=0
        max_heap_free_ratio=40
    fi

    gc_time_ratio=$(get_java_opt "$java_params" "-XX:GCTimeRatio")
    [ $? -ne 0 ] && echo $gc_time_ratio && exit 1
    if [ -z "$gc_time_ratio" ]; then
        has_gc_time_ratio=0
        gc_time_ratio=4
    fi

    adaptive_size_policy_weight=$(get_java_opt "$java_params" "-XX:AdaptiveSizePolicyWeight")
    [ $? -ne 0 ] && echo $adaptive_size_policy_weight && exit 1
    if [ -z "$adaptive_size_policy_weight" ]; then
        has_adaptive_size_policy_weight=0
        adaptive_size_policy_weight=90
    fi

    max_heap_size=$(get_java_opt "$java_params" "-XX:MaxHeapSize")
    [ $? -ne 0 ] && echo $max_heap_size && exit 1
    if [ -z "$max_heap_size" ]; then
        max_heap_size=$(get_java_opt "$java_params" "-Xmx")
    fi
    if [ -z "$max_heap_size" ]; then
        has_max_heap_size=0
        max_heap_size=`echo $heap_ratio $limit_in_mb|awk '{print int($1 * $2)}'`
        [ "$verbose" = "on" ] && echo the jvm option -Xmx is not set, so we figure out the value ${max_heap_size}m
    fi
    if [ $max_heap_size -gt $limit_in_mb ]; then
        echo memory required exceed the limitation ${limit_in_mb}m && exit 1
    fi

    min_heap_size=$(get_java_opt "$java_params" "-Xms")
    [ $? -ne 0 ] && echo $min_heap_size && exit 1
    if [ -z "$min_heap_size" ]; then
        has_min_heap_size=0
        min_heap_size=$((max_heap_size/2))
        [ "$verbose" = "on" ] && echo the jvm option -Xms is not set, so we figure out the value ${min_heap_size}m
    fi

    thread_stack_size=$(get_java_opt "$java_params" "-Xss")
    [ $? -ne 0 ] && echo $thread_stack_size && exit 1
    if [ -z "$thread_stack_size" ]; then
        thread_stack_size=$(get_java_opt "$java_params" "-XX:ThreadStackSize")
    fi
    if [ -z "$thread_stack_size" ]; then
        has_thread_stack_size=0
        thread_stack_size=512k
    fi

    parallel_gc_threads=$(get_java_opt "$java_params" "-XX:ParallelGCThreads")
    [ $? -ne 0 ] && echo $parallel_gc_threads && exit 1
    if [ -z "$parallel_gc_threads" ]; then
        has_parallel_gc_threads=0
        parallel_gc_threads=2
    fi

    ext_params="$ext_params -XX:MaxRAM=${limit_in_mb}m"
    JAVA_VERSION=`$JAVACMD -version  2>&1 |head -n1|sed 's/"//g'|awk '{print $3}'`
    [[ ! "$JAVA_VERSION" < "1.8.0_131" ]] && ext_params="$ext_params -XX:+UseCGroupMemoryLimitForHeap"
    [ "$has_max_heap_size" = "0" ] && ext_params="$ext_params -Xmx${max_heap_size}m"
    [ "$has_min_heap_size" = "0" ] && ext_params="$ext_params -Xms${min_heap_size}m"
    [ "$has_thread_stack_size" = "0" ] && ext_params="$ext_params -Xss${thread_stack_size}"
    [ "$has_parallel_gc_threads" = "0" ] && ext_params="$ext_params -XX:ParallelGCThreads=$parallel_gc_threads"
    [ "$has_min_heap_free_ratio" = "0" ] && ext_params="$ext_params -XX:MinHeapFreeRatio=$min_heap_free_ratio"
    [ "$has_max_heap_free_ratio" = "0" ] && ext_params="$ext_params -XX:MaxHeapFreeRatio=$max_heap_free_ratio"
    [ "$has_gc_time_ratio" = "0" ] && ext_params="$ext_params -XX:GCTimeRatio=$gc_time_ratio"
    [ "$has_adaptive_size_policy_weight" = "0" ] && ext_params="$ext_params -XX:AdaptiveSizePolicyWeight=$adaptive_size_policy_weight"
    [ "$verbose" = "on" ] && echo $JAVACMD $ext_params $java_params
    exec $JAVACMD $ext_params $java_params
fi