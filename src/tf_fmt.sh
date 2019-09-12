#!/bin/sh

function terraformFmt {

  set -e
  if [ "${tfWorkingDir}" == "" ] || [ "${tfWorkingDir}" == "" ]; then
    cd ${GITHUB_WORKSPACE}
  else
    cd ${GITHUB_WORKSPACE}/${tfWorkingDir}
  fi

  set +e
  # OUTPUT=$(sh -c "terraform fmt -no-color -check -list -recursive $*" 2>&1)
  OUTPUT=$(terraform fmt -no-color -check -list -recursive)
  SUCCESS=${?}
  echo "${OUTPUT}"
  set -e

  if [ "${SUCCESS}" -eq 0 ]; then
      exit 0
  fi

  if [ "$TF_ACTION_COMMENT" = "1" ] || [ "$TF_ACTION_COMMENT" = "false" ]; then
      exit $SUCCESS
  fi

  if [ "${SUCCESS}" -eq 2 ]; then
    # If it exits with 2, then there was a parse error and the command won't have
    # printed out the files that have failed. In this case we comment back with the
    # whole parse error.
    COMMENT="\`\`\`
${OUTPUT}
\`\`\`
"
  else
    if [ "${GITHUB_EVENT_NAME}" == "pull_request" ]; then
      COMMENT=""
      for file in ${OUTPUT}; do
        FILE_DIFF=$(terraform fmt -no-color -write=false -diff "${file}" | sed -n '/@@.*/,//{/@@.*/d;p}')
        COMMENT="${COMMENT}
<details><summary><code>${file}</code></summary>
\`\`\`diff
${FILE_DIFF}
\`\`\`
</details>
"
      done

      COMMENT_WRAPPER="#### \`terraform fmt\` Failed
${COMMENT}
*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`*
"
      PAYLOAD=$(echo '{}' | jq --arg body "${COMMENT_WRAPPER}" '.body = $body')
      COMMENTS_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
      curl -s -S --header "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data "${PAYLOAD}" "${COMMENTS_URL}" > /dev/null

      exit ${SUCCESS}
    fi
  fi
}
