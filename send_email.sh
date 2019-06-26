#!/bin/zsh
# this program accepts arguments to formulate and send an email
# Usage:
# ./send_email.sh me@mydoma.in you@yourdoma.in my_domain_relay_serv.er

get_email_subject() {
# the subject of this email
	subject_content=$(fortune)
	echo $subject_content
}


get_email_body() {
# the body of this email
	body_content=$(fortune)
	echo $body_content
}


get_source_address() {
# email address sending this email
	source_address=$1
	echo $source_address
}


get_target_address() {
# email address receiving this email
	target_address=$1
	echo $target_address
}


get_relay_server() {
# SMTP server to send this mail through
	relay_server=$1
	echo $relay_server
}


get_relay_port() {
# TCP port of relay server
	relay_port=25
	echo $relay_port
}


get_source_domain() {
# domain sending this email
	source_domain=$1
	echo $source_domain
}


# data structure
typeset -A email_data
	email_data["subject_content"]="$(get_email_subject)"
	email_data["body_content"]="$(get_email_body)"
	email_data["source_address"]="$(get_source_address) $1"
	email_data["target_address"]="$(get_target_address) $2"
	email_data["relay_port"]="$(get_relay_port)"
	email_data["relay_server"]="$(get_relay_server) $3"
	email_data["source_domain"]="$(get_source_domain) $4"


	# debug
	#echo "${email_data["source_domain"]}"
	#echo "${email_data["source_address"]}"
	#echo "${email_data["subject_content"]}"
	#echo "${email_data["body_content"]}"
	#echo "${email_data["relay_server"]}"
	#echo "${email_data["relay_port"]}"
	#echo "${email_data["target_address"]}"
	#for key in ${!email_data[@]}; do echo $key; done
	#for value in ${email_data[@]}; do echo $value; done

get_email_socket_data() {
# line up data to send down the socket to relay
	echo "ehlo ${email_data["source_domain"]}
	mail from:${email_data["source_address"]}
	rcpt to:${email_data["source_address"]}
	data
	to:${email_data["target_address"]}
	subject:${email_data["subject_content"]}

	${email_data["body_content"]}
	."
}


set_email_socket_connection() {
# receive data and send it down named pipe to relay
	while read data; do
		echo $data
	done | nc ${email_data["relay_server"]} ${email_data["relay_port"]}
}


main() {
# run the program
	get_email_socket_data | set_email_socket_connection
}


main
