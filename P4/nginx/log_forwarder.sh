LOG_FILE="/var/log/nginx/access.log"
API_ENDPOINT="http://log_service:8001/nginx_log"

tail -F $LOG_FILE | while read -r log_entry; do
    curl -X POST -H "Content-Type: application/json" -d "$log_entry" $API_ENDPOINT
done
