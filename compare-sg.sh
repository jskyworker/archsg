#!/bin/bash

# Variables
REPORT_DIR="/tmp/reports/"
CURRENT_REPORT="report-cron"
SAVED_REPORT="report-cron.saved"
CURRENT_DATE=$(date +"%M_%H_%m_%d_%Y")
OUT_DIR="/tmp/"
LOG="${OUT_DIR}changes-${CURRENT_DATE}.log"

cd ${REPORT_DIR}

# No report
if [ ! -f ${CURRENT_REPORT} ]; then
    echo "No report was generated. Exiting."
    exit 1
fi;

# First compare, no saved reports so far.
if [ ! -f ${SAVED_REPORT} ]; then
    echo "Previous report is not found."
    tar czf "${OUT_DIR}${CURRENT_REPORT}-$CURRENT_DATE".tar.gz ${CURRENT_REPORT}
    mv ${CURRENT_REPORT} ${SAVED_REPORT}
    exit 0
fi;

# Compare files
diff -u "${REPORT_DIR}${CURRENT_REPORT}" "${REPORT_DIR}${SAVED_REPORT}" >${LOG} 2>/dev/null

# Save report
if [ $? -ne 0 ]; then
    echo "There are some changes, saving report and log."
    tar czf "${OUT_DIR}${CURRENT_REPORT}-$CURRENT_DATE".tar.gz ${CURRENT_REPORT}
    mv ${CURRENT_REPORT} ${SAVED_REPORT}
else
    rm ${LOG}
fi;