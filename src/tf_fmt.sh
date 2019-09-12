#!/bin/sh

function terraformFmt {
  OUTPUT=$(terraform fmt -no-color -check -list -recursive 2>&1)
  SUCCESS=${?}
  echo "${OUTPUT}"
}
