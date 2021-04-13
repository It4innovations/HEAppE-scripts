#!/bin/bash
cat "${PBS_NODEFILE}" > nodes
echo "IPS:" > AllocationNodeInfo
cat nodes >> AllocationNodeInfo
while read -r temp; do
  #echo ${temp}
  TMP="$(dig +short "${temp}")"
  sed -i "s/${temp}/$TMP/g" AllocationNodeInfo
done <nodes
rm nodes
#cat nodefile