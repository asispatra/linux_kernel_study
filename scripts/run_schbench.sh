#!/bin/bash

#
# File Name: run_schbench.sh
#
# Date: April 09, 2020
# Author: Asis Kumar Patra
# Purpose: Make runs for schbench
#
#

# Write your shell script here.

# schbench usage:
#         -m (--message-threads): number of message threads (def: 2)
#         -t (--threads): worker threads per message thread (def: 16)
#         -r (--runtime): How long to run before exiting (seconds, def: 30)
#         -s (--sleeptime): Message thread latency (usec, def: 10000
#         -c (--cputime): How long to think during loop (usec, def: 10000
#         -a (--auto): grow thread count until latencies hurt (def: off)
#         -p (--pipe): transfer size bytes to simulate a pipe test (def: 0)
#         -R (--rps): requests per second mode (count, def: 0)

TEST=0 # 1: TRUE, 0: FALSE
SLEEP=5

function EXEC {
  COMMAND=$1
  echo "# ${COMMAND}"
  if [ ${TEST} -eq 0 ] ; then
    echo "### START: $(date)"
    eval "${COMMAND}" 2>&1
    echo "### END: $(date)"
    echo
  fi
}

BENCHMARK="${PWD}/schbench"
ext=$(date +%d%b%Y_%H%M%S) # Add timestamp extension to file name to identify uniqly
LOGDIR="logs/"
mkdir -p "${LOGDIR}"

# Here `s` in `<VAR>s` stand for plural
# ++++++++----------++++++++++----------#
                                        ########################################
SMTs="4 2 1"                            # System SMT

Ms="1 2 4 8 16 24"                      # message-threads
Ts="1 2 4 8 16 24"                      # threads
Rs="10 30 120"                          # runtime

iterations=10                           # Number of iterations for each run

# System LOOPs
for SMT in ${SMTs} ; do
  SYS_INFO="SMT${SMT}"
  if [ ${SMT} -ne $(echo "$(ppc64_cpu --smt | grep '=' || echo 'SMT=1')" | cut -d"=" -f2) ] ; then
    echo "Setting SMT=${SMT}..."
    CMD="ppc64_cpu --smt=${SMT}"
    EXEC "${CMD}"
    sleep ${SLEEP}
  else
    echo "SMT=${SMT} : unchanged!"
  fi
  CMD="ppc64_cpu --smt"
  EXEC "${CMD}"

  # Benchmark LOOPs
  for R in ${Rs} ; do
  for T in ${Ts} ; do
  for M in ${Ms} ; do

    # Multiple iterations LOOPs
    iter=0
    while [ ${iter} -lt ${iterations} ] ; do
      CMD="${BENCHMARK} -m ${M} -t ${T} -r ${R}"
      LOGFILE=$(echo "${CMD}" | tr -d ' ' | tr '-' '_' | tr -s '_' | sed 's/.*\///')
      LOGFILE="${LOGDIR}${LOGFILE}_${SYS_INFO}_${ext}_${iter}"
      SCHEDSTAT="${LOGFILE}_schedstat"
      LOGFILE="${LOGFILE}.log"
      #echo ${LOGFILE}
      cat /proc/schedstat 2>&1 >> ${SCHEDSTAT}.before
      EXEC "${CMD}" 2>&1 >> ${LOGFILE}
      cat /proc/schedstat 2>&1 >> ${SCHEDSTAT}.after
      cat ${LOGFILE}
      iter=$(expr ${iter} + 1)
      #exit
      sleep ${SLEEP}
    done
  done
  done
  done
done
