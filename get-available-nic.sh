#!/usr/bin/env bash

available_nic=("")

get_available_nic()
{
	ALL_NIC=$(ip link show up | grep "^[0-9]" | cut -f2 -d":" | grep -Pv "lo|usb|sit|ib" | sed 's/ //g')

    count=0

	for i in $ALL_NIC
	do
		if $(echo $ALL_NIC | grep -q -v $i); then
			res=$(ifup $i)
			if [[ $res != 0 ]]; then
				echo "$i startup failed!"
				continue
			fi
		fi

		link=$(ethtool $i | grep "Link detected" | sed 's/.*: \(.*\)/\1/g')

		if [[ $link = "yes" ]]; then
			phc=$(ethtool -T $i | grep "PTP Hardware Clock" | sed 's/.*: \(.*\)/\1/g')
			driver=$(ethtool -i $i | grep driver | awk -F ' ' '{ print $2 }')
			ip4=$(ip addr show dev $i | grep -w inet | awk '{ print $2 }')
			ip6=$(ip addr show dev $i | grep inet6 | grep global | awk '{ print $2 }')

			if [[ -z $ip4 ]]; then
				echo "need setting $i ipv4 by manually."
			fi

			if [[ -z $ip6 ]]; then
				echo "need setting $i ipv6 by manually."
			fi

			# save this interface in available_nic
			echo "$i is available interface!"
            available_nic[count]=$driver
            ((count++))
		fi
	done
}

get_available_nic
for i in ${available_nic[@]}; do
    echo $i
done
