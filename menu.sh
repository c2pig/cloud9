#!/bin/bash
clear
region_opts=(
"US East (Ohio)"
"US East (N. Virginia)"
"US West (N. California"
"US West (Oregon)"
"Asia Pacific (Mumbai)"
"Asia Pacific (Seoul)"
"Asia Pacific (Singapore)"
"Asia Pacific (Sydney)"
"Asia Pacific (Tokyo)"
"Canada (Central)"
"EU (Frankfurt)"
"EU (Ireland)"
"EU (London)"
"South America (São Paulo)"
)

ttl_opts=(
"1 Hour"
"2 Hours"
"5 Hours"
"12 Hours"
"18 Hours"
"1 Day"
)

node_opts=(
"1 Node"
"3 Nodes"
"5 Nodes"
"7 Nodes"
"9 Nodes"
)

mtype_opts=(
"t2.small"
"t2.medium"
"t2.large"
"t2.xlarge"
)
PS3="* Select A Region To Launch Cloud9 Stack: "
select opt in "${region_opts[@]}"
do
  case $opt in
    "US East (Ohio)")
      region=us-east-2
      break;
      ;;
    "US East (N. Virginia)")
      region=us-east-1
      break;
      ;;
    "US West (N. California)")
      region=us-west-1
      break;
      ;;
    "US West (Oregon)")
      region=us-west-2
      break;
      ;;
    "Asia Pacific (Mumbai)")
      region=ap-south-1
      break;
      ;;
    "Asia Pacific (Seoul)")
      region=ap-northeast-2
      break;
      ;;
    "Asia Pacific (Singapore)")
      region=ap-southeast-1
      break;
      ;;
    "Asia Pacific (Sydney)")
      region=ap-southeast-2
      break;
      ;;
    "Asia Pacific (Tokyo)")
      region=ap-northeast-1
      break;
      ;;
    "Canada (Central)")
      region=ca-centra-1
      break;
      ;;
    "EU (Frankfurt)")
      region=eu-central-1
      break;
      ;;
    "EU (Ireland)")
      region=eu-west-1
      break;
      ;;
    "EU (London)")
      region=eu-west-2
      break;
      ;;
    "South America (São Paulo)")
      region=sa-east-1
      break;
      ;;
    *) echo invalid option; exit 1 ;;
 esac
done
###
echo
PS3="* Num of Performance Testing Node: "
select opt in "${node_opts[@]}"
do
  case $opt in
    "1 Node")
      nodes=1;
      break;
      ;;
    "3 Nodes")
      nodes=3;
      break;
      ;;
    "5 Nodes")
      nodes=5;
      break;
      ;;
    "7 Nodes")
      nodes=7;
      break;
      ;;
    "9 Nodes")
      nodes=9;
      break;
      ;;
  esac
done
###
echo
PS3="* Select A Machine Type: "
select opt in "${mtype_opts[@]}"
do
  case $opt in
    "t2.small")
      mtype=0.023;
      break;
      ;;
    "t2.medium")
      mtype=0.0464;
      break;
      ;;
    "t2.large")
      mtype=0.0928;
      break;
      ;;
    "t2.xlarge")
      mtype=0.1856;
      break;
      ;;
  esac
done
###
echo
PS3="* Stack Alive Duration: "
select opt in "${ttl_opts[@]}"
do
  case $opt in
    "1 Hour")
      hours=1;
      break;
      ;;
    "2 Hours")
      hours=2;
      break;
      ;;
    "5 Hours")
      hours=5;
      break;
      ;;
    "12 Hours")
      hours=12;
      break;
      ;;
    "18 Hours")
      hours=18;
      break;
      ;;
    "1 Day")
      hours=24;
      break;
      ;;
    *) echo invalid option; exit 1 ;;
  esac
done
export hours=$hours
export region=$region
export mtype=$mtype
export nodes=$nodes
####
export cost=`echo "scale=2; $hours * $mtype * $nodes" | bc`
echo
echo
echo -e "Stack Cost Estimation: \033[5m\$${cost}\033[0m"

read -p "* Do you want to launch Cloud9 Stack?[y/N]"
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
 ./progress.sh
fi
